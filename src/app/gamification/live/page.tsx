import Link from "next/link";

export default function LiveGameLanding() {
  return (
    <main className="live-shell">
      <section className="live-hero">
        <span className="live-kicker">6TH GRADE · LIVE CLASSROOM</span>
        <h1>Code Battle Live</h1>
        <p>
          A real-time programming challenge for variables, conditionals, loops,
          algorithms, debugging and ODS thinking.
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

      <section className="live-grid live-info-grid">
        <article className="live-panel">
          <span className="live-icon">⚡</span>
          <h2>Real time</h2>
          <p>Players, answers and leaderboard update live through Supabase Realtime.</p>
        </article>
        <article className="live-panel">
          <span className="live-icon">📷</span>
          <h2>QR + PIN</h2>
          <p>Students can scan the room QR or enter the six-digit classroom PIN.</p>
        </article>
        <article className="live-panel">
          <span className="live-icon">🔊</span>
          <h2>Sound feedback</h2>
          <p>Generated classroom sounds for joins, answers, reveals and winners.</p>
        </article>
      </section>
    </main>
  );
}
