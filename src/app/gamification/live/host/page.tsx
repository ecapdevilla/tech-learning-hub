"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { RoomQr } from "@/modules/live-game/components/RoomQr";
import {
  getQuestionBank,
  liveGradeMeta,
  supportedLiveGrades,
  type SupportedLiveGrade,
} from "@/modules/live-game/data/questionBanks";
import {
  isLiveGameConfigured,
  liveSupabase,
} from "@/modules/live-game/lib/supabaseClient";
import { playGameSound } from "@/modules/live-game/lib/sounds";
import type {
  LiveAnswer,
  LiveGame,
  LivePlayer,
} from "@/modules/live-game/types/liveGame";

function makePin() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

export default function LiveHostPage() {
  const [selectedGrade, setSelectedGrade] = useState<SupportedLiveGrade>(6);
  const [game, setGame] = useState<LiveGame | null>(null);
  const [players, setPlayers] = useState<LivePlayer[]>([]);
  const [answers, setAnswers] = useState<LiveAnswer[]>([]);
  const [sound, setSound] = useState(true);
  const [message, setMessage] = useState("");
  const [origin, setOrigin] = useState("");

  useEffect(() => {
    const value = window.location.origin;
    queueMicrotask(() => setOrigin(value));
  }, []);

  const loadPlayers = useCallback(async (gameId: string) => {
    if (!liveSupabase) return;
    const { data } = await liveSupabase
      .from("live_players")
      .select("*")
      .eq("game_id", gameId)
      .order("score", { ascending: false });
    setPlayers((data ?? []) as LivePlayer[]);
  }, []);

  const loadAnswers = useCallback(async (gameId: string, qIndex: number) => {
    if (!liveSupabase) return;
    const { data } = await liveSupabase
      .from("live_answers")
      .select("*")
      .eq("game_id", gameId)
      .eq("question_index", qIndex);
    setAnswers((data ?? []) as LiveAnswer[]);
  }, []);

  const gameId = game?.id ?? "";
  const questionIndex = game?.current_question_index ?? 0;

  useEffect(() => {
    if (!gameId || !liveSupabase) return;

    const supabase = liveSupabase;

    const initialLoadTimer = window.setTimeout(() => {
      void loadPlayers(gameId);
      void loadAnswers(gameId, questionIndex);
    }, 0);

    const channel = supabase
      .channel(`host-${gameId}`)
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "live_players",
          filter: `game_id=eq.${gameId}`,
        },
        () => {
          void loadPlayers(gameId);
          if (sound) playGameSound("join");
        },
      )
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "live_answers",
          filter: `game_id=eq.${gameId}`,
        },
        () => void loadAnswers(gameId, questionIndex),
      )
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "live_games",
          filter: `id=eq.${gameId}`,
        },
        (payload) => setGame(payload.new as LiveGame),
      )
      .subscribe();

    return () => {
      window.clearTimeout(initialLoadTimer);
      void supabase.removeChannel(channel);
    };
  }, [gameId, questionIndex, loadAnswers, loadPlayers, sound]);

  const createGame = async () => {
    if (!liveSupabase) {
      setMessage("Supabase is not configured.");
      return;
    }

    const pin = makePin();
    const meta = liveGradeMeta[selectedGrade];

    const { data, error } = await liveSupabase
      .from("live_games")
      .insert({
        pin,
        grade: selectedGrade,
        title: `${selectedGrade}th Grade · ${meta.title}`,
        status: "lobby",
        current_question_index: 0,
      })
      .select()
      .single();

    if (error) {
      setMessage(error.message);
      return;
    }

    setGame(data as LiveGame);
    setMessage("");
  };

  const updateGame = async (patch: Partial<LiveGame>) => {
    if (!game || !liveSupabase) return null;

    const { data, error } = await liveSupabase
      .from("live_games")
      .update(patch)
      .eq("id", game.id)
      .select()
      .single();

    if (error) {
      setMessage(error.message);
      return null;
    }

    const updated = data as LiveGame;
    setGame(updated);
    return updated;
  };

  const bank = getQuestionBank(game?.grade ?? selectedGrade);
  const meta = liveGradeMeta[(game?.grade ?? selectedGrade) as SupportedLiveGrade];

  const startQuestion = async (index: number) => {
    setAnswers([]);
    if (sound) playGameSound("start");

    await updateGame({
      status: "question",
      current_question_index: index,
      question_started_at: new Date().toISOString(),
    });
  };

  const reveal = async () => {
    if (!game) return;
    if (sound) playGameSound("reveal");
    await updateGame({ status: "reveal" });
    await loadPlayers(game.id);
  };

  const next = async () => {
    if (!game) return;

    const nextIndex = game.current_question_index + 1;
    if (nextIndex >= bank.length) {
      if (sound) playGameSound("winner");
      await updateGame({ status: "finished" });
      return;
    }

    await startQuestion(nextIndex);
  };

  const current = game ? bank[game.current_question_index] : null;
  const joinUrl =
    game && origin ? `${origin}/gamification/live/play/${game.pin}` : "";

  const distribution = useMemo(
    () =>
      [0, 1, 2, 3].map(
        (choice) => answers.filter((a) => a.answer_index === choice).length,
      ),
    [answers],
  );

  if (!isLiveGameConfigured) {
    return (
      <main className="live-shell">
        <section className="live-panel live-setup">
          <span className="live-kicker">SETUP REQUIRED</span>
          <h1>Connect Supabase first</h1>
        </section>
      </main>
    );
  }

  return (
    <main className="live-shell">
      {!game ? (
        <>
          <section className="live-hero">
            <span className="live-kicker">TEACHER CONTROL · 6TH–11TH</span>
            <h1>Launch Code Battle Live</h1>
            <p>
              Select the grade. The battle engine stays the same while the
              curriculum bank changes automatically.
            </p>
          </section>

          <section className="live-grade-selector">
            {supportedLiveGrades.map((grade) => {
              const gradeMeta = liveGradeMeta[grade];
              return (
                <button
                  key={grade}
                  className={
                    selectedGrade === grade
                      ? "live-grade-card live-grade-card-active"
                      : "live-grade-card"
                  }
                  onClick={() => setSelectedGrade(grade)}
                >
                  <span>{grade}TH</span>
                  <strong>{gradeMeta.title}</strong>
                  <small>{gradeMeta.subtitle}</small>
                </button>
              );
            })}
          </section>

          <section className="live-panel live-launch-panel">
            <div>
              <span className="live-kicker">SELECTED BATTLE</span>
              <h2>
                {selectedGrade}th Grade · {liveGradeMeta[selectedGrade].title}
              </h2>
              <p>{liveGradeMeta[selectedGrade].subtitle}</p>
              <div className="live-topic-cloud">
                {liveGradeMeta[selectedGrade].topics.map((topic) => (
                  <span key={topic}>{topic}</span>
                ))}
              </div>
            </div>
            <button className="live-btn live-btn-primary" onClick={createGame}>
              ⚡ Create Live Room
            </button>
            {message && <p className="live-error">{message}</p>}
          </section>
        </>
      ) : (
        <>
          <section className="live-host-top">
            <div>
              <span className="live-kicker">
                {game.grade}TH · {meta?.title ?? "CODE BATTLE"}
              </span>
              <div className="live-pin">{game.pin}</div>
              <p>{players.length} players connected</p>
            </div>
            {joinUrl && <RoomQr value={joinUrl} />}
            <button className="live-sound" onClick={() => setSound((x) => !x)}>
              {sound ? "🔊 Sound ON" : "🔇 Sound OFF"}
            </button>
          </section>

          {game.status === "lobby" && (
            <section className="live-panel">
              <h2>Lobby · {game.grade}th Grade</h2>
              <div className="live-player-cloud">
                {players.map((p) => (
                  <span key={p.id}>👾 {p.name}</span>
                ))}
              </div>
              <button
                className="live-btn live-btn-primary"
                disabled={!players.length}
                onClick={() => startQuestion(0)}
              >
                ▶ Start Battle
              </button>
            </section>
          )}

          {(game.status === "question" || game.status === "reveal") &&
            current && (
              <>
                <section className="live-question-card">
                  <div className="live-question-head">
                    <span>
                      QUESTION {game.current_question_index + 1} / {bank.length}
                    </span>
                    <b>{current.topic}</b>
                  </div>
                  <h2>{current.prompt}</h2>
                  <p>{current.promptEs}</p>

                  <div className="live-host-choices">
                    {current.choices.map((choice, i) => (
                      <div
                        className={
                          game.status === "reveal" &&
                          i === current.correctIndex
                            ? "live-choice live-choice-correct"
                            : "live-choice"
                        }
                        key={choice}
                      >
                        <b>{String.fromCharCode(65 + i)}</b>
                        <span>{choice}</span>
                        <strong>{distribution[i]}</strong>
                      </div>
                    ))}
                  </div>

                  <div className="live-answer-progress">
                    {answers.length} / {players.length} answered
                  </div>

                  {game.status === "question" ? (
                    <button className="live-btn live-btn-primary" onClick={reveal}>
                      👀 Reveal Answer
                    </button>
                  ) : (
                    <div className="live-reveal-actions">
                      <p className="live-explanation">
                        ✅ {current.explanation}
                        <br />
                        <span>{current.explanationEs}</span>
                      </p>
                      <button className="live-btn live-btn-primary" onClick={next}>
                        {game.current_question_index + 1 >= bank.length
                          ? "🏆 Final Leaderboard"
                          : "Next Question →"}
                      </button>
                    </div>
                  )}
                </section>

                <section className="live-panel">
                  <h2>Live Leaderboard</h2>
                  <div className="live-leaderboard">
                    {players.slice(0, 10).map((p, i) => (
                      <div key={p.id}>
                        <span>{i + 1}</span>
                        <b>{p.name}</b>
                        <strong>{p.score.toLocaleString()}</strong>
                      </div>
                    ))}
                  </div>
                </section>
              </>
            )}

          {game.status === "finished" && (
            <section className="live-podium">
              <span className="live-kicker">
                {game.grade}TH GRADE · BATTLE COMPLETE
              </span>
              <h1>🏆 Final Podium</h1>
              <div className="live-podium-grid">
                {players.slice(0, 3).map((p, i) => (
                  <article key={p.id}>
                    <span>{["🥇", "🥈", "🥉"][i]}</span>
                    <h2>{p.name}</h2>
                    <b>{p.score.toLocaleString()} pts</b>
                  </article>
                ))}
              </div>
            </section>
          )}
        </>
      )}
    </main>
  );
}
