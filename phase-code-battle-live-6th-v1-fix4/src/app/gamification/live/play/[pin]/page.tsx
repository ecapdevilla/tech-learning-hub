"use client";

import { FormEvent, use, useCallback, useEffect, useMemo, useState } from "react";
import { grade6Questions } from "@/modules/live-game/data/grade6Questions";
import { calculatePoints } from "@/modules/live-game/lib/scoring";
import {
  isLiveGameConfigured,
  liveSupabase,
} from "@/modules/live-game/lib/supabaseClient";
import { playGameSound } from "@/modules/live-game/lib/sounds";
import type { LiveGame, LivePlayer } from "@/modules/live-game/types/liveGame";

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

  const fetchGame = useCallback(async () => {
    if (!liveSupabase) return;

    const { data, error } = await liveSupabase
      .from("live_games")
      .select("*")
      .eq("pin", pin)
      .single();

    if (error || !data) {
      setMessage("Room not found.");
      return;
    }

    setGame(data as LiveGame);
    setMessage("");
  }, [pin]);

  useEffect(() => {
    const timeoutId = window.setTimeout(() => {
      void fetchGame();
    }, 0);

    return () => window.clearTimeout(timeoutId);
  }, [fetchGame]);

  const gameId = game?.id ?? "";

  useEffect(() => {
    if (!gameId || !liveSupabase) return;

    const supabase = liveSupabase;

    const channel = supabase
      .channel(`player-game-${gameId}`)
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "live_games",
          filter: `id=eq.${gameId}`,
        },
        (payload) => {
          const nextGame = payload.new as LiveGame;

          setGame(nextGame);
          setSelected(null);
          setSubmitted(false);

          if (nextGame.status === "question") playGameSound("start");
          if (nextGame.status === "reveal") playGameSound("reveal");
          if (nextGame.status === "finished") playGameSound("winner");
        },
      )
      .subscribe();

    return () => {
      void supabase.removeChannel(channel);
    };
  }, [gameId]);

  const gameStatus = game?.status ?? "";
  const questionStartedAt = game?.question_started_at ?? null;
  const questionIndex = game?.current_question_index ?? 0;

  useEffect(() => {
    if (gameStatus !== "question" || !questionStartedAt) return;

    const question = grade6Questions[questionIndex];

    const timerId = window.setInterval(() => {
      const startedAtMs = Date.parse(questionStartedAt);
      const elapsedMs = new Date().getTime() - startedAtMs;
      const left = Math.max(
        0,
        question.seconds - Math.floor(elapsedMs / 1000),
      );

      setRemaining(left);

      if (left > 0 && left <= 3) {
        playGameSound("tick");
      }
    }, 500);

    return () => window.clearInterval(timerId);
  }, [gameStatus, questionIndex, questionStartedAt]);

  const join = async (event: FormEvent) => {
    event.preventDefault();

    if (!game || !liveSupabase) return;

    const cleanName = name.trim().replace(/\s+/g, " ").slice(0, 24);

    if (cleanName.length < 2) {
      setMessage("Enter your first name.");
      return;
    }

    const { data, error } = await liveSupabase
      .from("live_players")
      .insert({
        game_id: game.id,
        name: cleanName,
      })
      .select()
      .single();

    if (error) {
      setMessage(error.message);
      return;
    }

    setPlayer(data as LivePlayer);
    setMessage("");
    playGameSound("join");
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

    const question = grade6Questions[game.current_question_index];
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
      setSubmitted(false);
      setMessage(answerError.message);
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

    if (playerError) {
      setMessage(playerError.message);
      return;
    }

    if (updatedPlayer) {
      setPlayer(updatedPlayer as LivePlayer);
    }
  };

  const currentQuestion = game
    ? grade6Questions[game.current_question_index]
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
          <h1>{message || "Loading room…"}</h1>
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
              placeholder="First name"
              value={name}
              onChange={(event) => setName(event.target.value)}
            />
            <button className="live-btn live-btn-primary">
              Enter Lobby
            </button>
          </form>

          {message && <p className="live-error">{message}</p>}
        </section>
      </main>
    );
  }

  if (game.status === "lobby") {
    return (
      <main className="live-shell">
        <section className="live-player-wait">
          <span className="live-kicker">YOU&apos;RE IN</span>
          <h1>👾 {player.name}</h1>
          <p>Look at the classroom screen. The battle will start soon.</p>
          <div className="live-wait-orb">⚡</div>
        </section>
      </main>
    );
  }

  if (game.status === "finished") {
    return (
      <main className="live-shell">
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
    </main>
  );
}
