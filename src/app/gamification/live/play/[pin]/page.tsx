"use client";

import {
  FormEvent,
  use,
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";
import { getQuestionBank } from "@/modules/live-game/data/questionBanks";
import { calculatePoints } from "@/modules/live-game/lib/scoring";
import {
  isLiveGameConfigured,
  liveSupabase,
} from "@/modules/live-game/lib/supabaseClient";
import { safePlayGameSound } from "@/modules/live-game/lib/safeSounds";
import type { LiveGame, LivePlayer } from "@/modules/live-game/types/liveGame";

type ConnectionState =
  | "connecting"
  | "connected"
  | "reconnecting"
  | "offline"
  | "error";

type StoredPlayerSession = {
  pin: string;
  gameId: string;
  playerId: string;
  name: string;
};

const PLAYER_SESSION_PREFIX = "tlh-live-player:";
const FALLBACK_POLL_MS = 2500;

function storageKey(pin: string) {
  return `${PLAYER_SESSION_PREFIX}${pin}`;
}

function readStoredSession(pin: string): StoredPlayerSession | null {
  try {
    const raw = window.localStorage.getItem(storageKey(pin));
    if (!raw) return null;

    const parsed = JSON.parse(raw) as StoredPlayerSession;
    if (
      parsed.pin !== pin ||
      !parsed.gameId ||
      !parsed.playerId ||
      !parsed.name
    ) {
      return null;
    }

    return parsed;
  } catch {
    return null;
  }
}

function saveStoredSession(session: StoredPlayerSession) {
  try {
    window.localStorage.setItem(storageKey(session.pin), JSON.stringify(session));
  } catch {
    // Storage can be blocked by privacy settings. The game still continues
    // without persistent recovery.
  }
}

function clearStoredSession(pin: string) {
  try {
    window.localStorage.removeItem(storageKey(pin));
  } catch {
    // Ignore storage restrictions.
  }
}

export default function PlayerRoom({
  params,
}: {
  params: Promise<{ pin: string }>;
}) {
  const { pin } = use(params);

  const [game, setGame] = useState<LiveGame | null>(null);
  const [player, setPlayer] = useState<LivePlayer | null>(null);
  const [name, setName] = useState("");
  const [selected, setSelected] = useState<number | null>(null);
  const [submitted, setSubmitted] = useState(false);
  const [message, setMessage] = useState("Looking for room…");
  const [remaining, setRemaining] = useState(0);
  const [connection, setConnection] =
    useState<ConnectionState>("connecting");

  const gameRef = useRef<LiveGame | null>(null);
  const playerRef = useRef<LivePlayer | null>(null);
  const connectionRef = useRef<ConnectionState>("connecting");

  useEffect(() => {
    gameRef.current = game;
  }, [game]);

  useEffect(() => {
    playerRef.current = player;
  }, [player]);

  useEffect(() => {
    connectionRef.current = connection;
  }, [connection]);

  const syncGame = useCallback(
    async (options?: { quiet?: boolean }) => {
      if (!liveSupabase) return null;

      try {
        const { data, error } = await liveSupabase
          .from("live_games")
          .select("*")
          .eq("pin", pin)
          .maybeSingle();

        if (error || !data) {
          if (!options?.quiet) {
            setMessage("Room not found or no longer available.");
          }
          return null;
        }

        const nextGame = data as LiveGame;
        setGame(nextGame);

        if (!options?.quiet) {
          setMessage("");
        }

        return nextGame;
      } catch {
        if (!options?.quiet) {
          setMessage("Unable to reach the classroom room. Retrying…");
        }
        return null;
      }
    },
    [pin],
  );

  const syncPlayer = useCallback(
    async (gameId: string, playerId: string) => {
      if (!liveSupabase) return null;

      try {
        const { data, error } = await liveSupabase
          .from("live_players")
          .select("*")
          .eq("id", playerId)
          .eq("game_id", gameId)
          .maybeSingle();

        if (error || !data) return null;

        const nextPlayer = data as LivePlayer;
        setPlayer(nextPlayer);
        return nextPlayer;
      } catch {
        return null;
      }
    },
    [],
  );

  const restorePlayerSession = useCallback(
    async (currentGame: LiveGame) => {
      const stored = readStoredSession(pin);
      if (!stored || stored.gameId !== currentGame.id) return false;

      const recovered = await syncPlayer(stored.gameId, stored.playerId);
      if (!recovered) {
        clearStoredSession(pin);
        return false;
      }

      setName(recovered.name);
      return true;
    },
    [pin, syncPlayer],
  );

  useEffect(() => {
    const bootTimer = window.setTimeout(() => {
      void (async () => {
        const initialGame = await syncGame();
        if (initialGame) {
          await restorePlayerSession(initialGame);
        }
      })();
    }, 0);

    return () => window.clearTimeout(bootTimer);
  }, [restorePlayerSession, syncGame]);

  const gameId = game?.id ?? "";

  useEffect(() => {
    if (!gameId || !liveSupabase) return;

    const supabase = liveSupabase;
    let cancelled = false;

    const channel = supabase
      .channel(`player-game-${gameId}-${Math.random().toString(36).slice(2)}`)
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "live_games",
          filter: `id=eq.${gameId}`,
        },
        (payload) => {
          if (cancelled) return;

          const nextGame = payload.new as LiveGame;
          const previousStatus = gameRef.current?.status;

          setGame(nextGame);
          setSelected(null);
          setSubmitted(false);

          if (previousStatus !== nextGame.status) {
            if (nextGame.status === "question") {
              safePlayGameSound("start");
            } else if (nextGame.status === "reveal") {
              safePlayGameSound("reveal");
            } else if (nextGame.status === "finished") {
              safePlayGameSound("winner");
            }
          }
        },
      )
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "live_players",
          filter: `game_id=eq.${gameId}`,
        },
        (payload) => {
          if (cancelled) return;
          const currentPlayer = playerRef.current;
          const updatedPlayer = payload.new as LivePlayer;

          if (currentPlayer && updatedPlayer.id === currentPlayer.id) {
            setPlayer(updatedPlayer);
          }
        },
      )
      .subscribe((status) => {
        if (cancelled) return;

        if (status === "SUBSCRIBED") {
          setConnection("connected");
          void syncGame({ quiet: true });

          const currentPlayer = playerRef.current;
          if (currentPlayer) {
            void syncPlayer(gameId, currentPlayer.id);
          }
          return;
        }

        if (status === "CHANNEL_ERROR" || status === "TIMED_OUT") {
          setConnection("reconnecting");
          return;
        }

        if (status === "CLOSED") {
          setConnection(navigator.onLine ? "reconnecting" : "offline");
        }
      });

    return () => {
      cancelled = true;
      void supabase.removeChannel(channel);
    };
  }, [gameId, syncGame, syncPlayer]);

  useEffect(() => {
    if (!gameId) return;

    const pollTimer = window.setInterval(() => {
      if (
        connectionRef.current === "connected" &&
        document.visibilityState === "visible"
      ) {
        return;
      }

      void syncGame({ quiet: true });

      const currentPlayer = playerRef.current;
      if (currentPlayer) {
        void syncPlayer(gameId, currentPlayer.id);
      }
    }, FALLBACK_POLL_MS);

    return () => window.clearInterval(pollTimer);
  }, [gameId, syncGame, syncPlayer]);

  useEffect(() => {
    const handleOnline = () => {
      setConnection("reconnecting");
      void syncGame({ quiet: true });

      const currentPlayer = playerRef.current;
      const currentGame = gameRef.current;

      if (currentPlayer && currentGame) {
        void syncPlayer(currentGame.id, currentPlayer.id);
      }
    };

    const handleOffline = () => setConnection("offline");

    const handleVisibility = () => {
      if (document.visibilityState !== "visible") return;

      void syncGame({ quiet: true });

      const currentPlayer = playerRef.current;
      const currentGame = gameRef.current;

      if (currentPlayer && currentGame) {
        void syncPlayer(currentGame.id, currentPlayer.id);
      }
    };

    window.addEventListener("online", handleOnline);
    window.addEventListener("offline", handleOffline);
    document.addEventListener("visibilitychange", handleVisibility);

    return () => {
      window.removeEventListener("online", handleOnline);
      window.removeEventListener("offline", handleOffline);
      document.removeEventListener("visibilitychange", handleVisibility);
    };
  }, [syncGame, syncPlayer]);

  const gameStatus = game?.status ?? "";
  const questionStartedAt = game?.question_started_at ?? null;
  const questionIndex = game?.current_question_index ?? 0;
  const questionBank = getQuestionBank(game?.grade ?? 6);

  useEffect(() => {
    if (gameStatus !== "question" || !questionStartedAt) return;

    const question = questionBank[questionIndex];

    const updateRemaining = () => {
      const startedAtMs = Date.parse(questionStartedAt);
      const elapsedMs = new Date().getTime() - startedAtMs;
      const left = Math.max(
        0,
        question.seconds - Math.floor(elapsedMs / 1000),
      );
      setRemaining(left);
    };

    updateRemaining();
    const timerId = window.setInterval(updateRemaining, 500);

    return () => window.clearInterval(timerId);
  }, [gameStatus, questionIndex, questionStartedAt, questionBank]);

  const join = async (event: FormEvent) => {
    event.preventDefault();

    if (!game || !liveSupabase) return;

    const cleanName = name.trim().replace(/\s+/g, " ").slice(0, 24);

    if (cleanName.length < 2) {
      setMessage("Enter your first name.");
      return;
    }

    setMessage("Joining room…");

    try {
      const { data, error } = await liveSupabase
        .from("live_players")
        .insert({
          game_id: game.id,
          name: cleanName,
        })
        .select()
        .single();

      if (error || !data) {
        setMessage(error?.message ?? "Unable to join the room.");
        return;
      }

      const joinedPlayer = data as LivePlayer;

      saveStoredSession({
        pin,
        gameId: game.id,
        playerId: joinedPlayer.id,
        name: joinedPlayer.name,
      });

      setPlayer(joinedPlayer);
      setName(joinedPlayer.name);
      setMessage("");
      setConnection((current) =>
        current === "offline" ? "offline" : "connecting",
      );

      // Intentionally do not start WebAudio here.
      // Some mobile browsers are unstable when audio initialization and
      // a large state transition happen in the same join interaction.
    } catch {
      setMessage(
        "Your player was not confirmed. Check the connection and try again.",
      );
    }
  };

  const answer = async (choice: number) => {
    if (
      !game ||
      !player ||
      !liveSupabase ||
      submitted ||
      game.status !== "question"
    ) {
      return;
    }

    const question = questionBank[game.current_question_index];
    const elapsedSeconds = Math.max(0, question.seconds - remaining);
    const responseMs = elapsedSeconds * 1000;
    const isCorrect = choice === question.correctIndex;
    const nextStreak = isCorrect ? player.streak + 1 : 0;

    const points = calculatePoints(
      isCorrect,
      responseMs,
      question.seconds,
      nextStreak,
    );

    setSelected(choice);
    setSubmitted(true);

    try {
      const { error: answerError } = await liveSupabase
        .from("live_answers")
        .insert({
          game_id: game.id,
          player_id: player.id,
          question_index: game.current_question_index,
          answer_index: choice,
          is_correct: isCorrect,
          response_ms: responseMs,
          points,
        });

      if (answerError) {
        if (answerError.code === "23505") {
          // The answer was already stored. Keep the UI stable instead of
          // treating a retry/double tap as a fatal error.
          setMessage("Answer already received.");
          return;
        }

        setSubmitted(false);
        setMessage("Answer could not be sent. Try once more.");
        return;
      }

      const { data: updatedPlayer, error: playerError } = await liveSupabase
        .from("live_players")
        .update({
          score: player.score + points,
          streak: nextStreak,
        })
        .eq("id", player.id)
        .select()
        .single();

      if (!playerError && updatedPlayer) {
        setPlayer(updatedPlayer as LivePlayer);
      }

      setMessage("");
    } catch {
      setSubmitted(false);
      setMessage("Connection interrupted. Your game will resync automatically.");
      setConnection("reconnecting");
    }
  };

  const manualReconnect = async () => {
    setConnection("reconnecting");
    const nextGame = await syncGame();

    const currentPlayer = playerRef.current;
    if (nextGame && currentPlayer) {
      await syncPlayer(nextGame.id, currentPlayer.id);
    }
  };

  const currentQuestion = game
    ? questionBank[game.current_question_index]
    : null;

  const resultCorrect =
    game?.status === "reveal" &&
    selected !== null &&
    currentQuestion !== null &&
    selected === currentQuestion.correctIndex;

  const scoreLabel = useMemo(() => {
    if (!player) return "";
    return `${player.score.toLocaleString()} pts · 🔥 ${player.streak} streak`;
  }, [player]);

  const connectionLabel = {
    connecting: "SYNCING",
    connected: "CONNECTED",
    reconnecting: "RECONNECTING",
    offline: "OFFLINE",
    error: "CONNECTION ISSUE",
  }[connection];

  if (!isLiveGameConfigured) {
    return (
      <main className="live-shell">
        <section className="live-join-card">
          <h1>Live engine not configured.</h1>
        </section>
      </main>
    );
  }

  if (!game) {
    return (
      <main className="live-shell">
        <section className="live-join-card">
          <span className="live-kicker">CODE BATTLE LIVE</span>
          <h1>{message || "Loading room…"}</h1>
          <button className="live-btn" onClick={manualReconnect}>
            Retry connection
          </button>
        </section>
      </main>
    );
  }

  if (!player) {
    return (
      <main className="live-shell">
        <section className="live-join-card">
          <span className="live-kicker">ROOM {pin}</span>
          <h1>Choose your player name</h1>
          <p>Use your first name only.</p>

          <form onSubmit={join}>
            <input
              className="live-name-input"
              maxLength={24}
              autoComplete="off"
              placeholder="First name"
              value={name}
              onChange={(event) => setName(event.target.value)}
            />
            <button className="live-btn live-btn-primary">
              Enter Lobby
            </button>
          </form>

          {message && <p className="live-status-message">{message}</p>}
        </section>
      </main>
    );
  }

  const connectionBar = (
    <div className={`live-connection live-connection-${connection}`}>
      <span>
        {connection === "connected" ? "●" : "◌"} {connectionLabel}
      </span>
      {connection !== "connected" && (
        <button type="button" onClick={manualReconnect}>
          Resync
        </button>
      )}
    </div>
  );

  if (game.status === "lobby") {
    return (
      <main className="live-shell">
        {connectionBar}
        <section className="live-player-wait">
          <span className="live-kicker">YOU&apos;RE IN</span>
          <h1>👾 {player.name}</h1>
          <p>Look at the classroom screen. The battle will start soon.</p>
          <div className="live-wait-orb">⚡</div>
          <div className="live-player-score">{scoreLabel}</div>
          {message && <p className="live-status-message">{message}</p>}
        </section>
      </main>
    );
  }

  if (game.status === "finished") {
    return (
      <main className="live-shell">
        {connectionBar}
        <section className="live-player-wait">
          <span className="live-kicker">BATTLE COMPLETE</span>
          <h1>🏆 {player.name}</h1>
          <div className="live-player-score">{scoreLabel}</div>
          <p>Great work. Check the classroom screen for the final podium.</p>
        </section>
      </main>
    );
  }

  if (!currentQuestion) return null;

  return (
    <main className="live-shell live-player-shell">
      {connectionBar}

      <section className="live-player-header">
        <div>
          <span>Q {game.current_question_index + 1}</span>
          <b>{currentQuestion.topic}</b>
        </div>
        <strong>{remaining}s</strong>
      </section>

      <section className="live-player-question">
        <h1>{currentQuestion.prompt}</h1>
        <p>{currentQuestion.promptEs}</p>
      </section>

      {game.status === "question" && (
        <section className="live-mobile-choices">
          {currentQuestion.choices.map((choice, index) => (
            <button
              key={choice}
              disabled={submitted}
              className={`live-mobile-choice live-mobile-choice-${index} ${
                selected === index ? "selected" : ""
              }`}
              onClick={() => answer(index)}
            >
              <b>{String.fromCharCode(65 + index)}</b>
              <span>{choice}</span>
            </button>
          ))}
        </section>
      )}

      {game.status === "reveal" && (
        <section
          className={
            resultCorrect
              ? "live-result live-result-ok"
              : "live-result live-result-no"
          }
        >
          <span>{resultCorrect ? "✅ CORRECT" : "💡 LEARN & DEBUG"}</span>
          <h2>
            {resultCorrect ? "Nice work!" : currentQuestion.explanation}
          </h2>
          <p>{currentQuestion.explanationEs}</p>
          <strong>{scoreLabel}</strong>
        </section>
      )}

      {submitted && game.status === "question" && (
        <div className="live-answer-received">✓ ANSWER RECEIVED</div>
      )}

      {message && <div className="live-status-message">{message}</div>}
    </main>
  );
}
