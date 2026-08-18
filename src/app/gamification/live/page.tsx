import Link from "next/link";
import { liveGradeMeta, supportedLiveGrades } from "@/modules/live-game/data/questionBanks";

export default function LiveGameLanding() {
  return (
    <main className="live-shell">
      <section className="live-hero">
        <span className="live-kicker">LIVE CLASSROOM · 6TH–11TH</span>
        <h1>Code Battle Live</h1>
        <p>
          One real-time classroom engine. Six curriculum-aligned battles.
          Scan, join, answer, debug, compete and learn together.
        </p>
        <div className="live-hero-actions">
          <Link className="live-btn live-btn-primary" href="/gamification/live/host">
            🎙 Host Game
          </Link>
          <Link className="live-btn" href="/gamification/live/join">
            📱 Join Game
          </Link>
        </div>
      </section>

      <section className="live-grade-selector live-public-grades">
        {supportedLiveGrades.map((grade) => (
          <article className="live-grade-card" key={grade}>
            <span>{grade}TH</span>
            <strong>{liveGradeMeta[grade].title}</strong>
            <small>{liveGradeMeta[grade].subtitle}</small>
          </article>
        ))}
      </section>
    </main>
  );
}
