import Link from "next/link";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function GamificationPage() {
  return (
    <SiteLayout>
      <main className="gamification-zone page-shell">
        <Link href="/" className="back-link">← Back to Tech Learning Hub</Link>
        <section className="game-hero">
          <span className="game-kicker">🎮 GAMIFICATION ZONE · GRADES 9–11</span>
          <h1>Play. Think. Build. Level Up.</h1>
          <p>A challenge arena where technology becomes strategy: computational thinking, debugging, data, web development, digital citizenship and IoT.</p>
          <div className="game-pill-row"><span>🇺🇸 English</span><span>🇨🇴 Español</span><span>🇫🇷 Immersion française</span><span>🏆 XP & Mastery</span></div>
        </section>
        <section className="game-intro">
          <div><b>MISSION</b><h2>Learning has a purpose.</h2><p>Every game includes a learning objective, progressive challenges, immediate feedback and a reflection checkpoint. Scores reward reasoning—not random clicking.</p></div>
          <div className="game-principles"><span>🎯 Objective</span><span>🧩 Challenge</span><span>🔁 Retry</span><span>💡 Feedback</span><span>🏅 Mastery</span></div>
        </section>
        <section className="game-grid">
        <a className="game-card" href="/gamification/logic.html">
          <span className="game-level">9–11</span><span className="game-icon">🧠</span>
          <small>Computational Thinking</small><h3>Logic Reactor</h3><p>Strengthen algorithmic reasoning by solving increasingly complex sequence, conditional and loop challenges.</p><b>PLAY / JUGAR / JOUER →</b>
        </a>
        <a className="game-card" href="/gamification/debug.html">
          <span className="game-level">9–11</span><span className="game-icon">🐞</span>
          <small>Debugging</small><h3>Bug Hunter Arena</h3><p>Identify, explain and repair logical errors in code and pseudocode using evidence.</p><b>PLAY / JUGAR / JOUER →</b>
        </a>
        <a className="game-card" href="/gamification/cyber.html">
          <span className="game-level">9–11</span><span className="game-icon">🛡️</span>
          <small>Digital Citizenship</small><h3>Cyber Defense Lab</h3><p>Recognize safe digital practices, social-engineering warning signs and responsible responses to common online scenarios.</p><b>PLAY / JUGAR / JOUER →</b>
        </a>
        <a className="game-card" href="/gamification/data.html">
          <span className="game-level">9–11</span><span className="game-icon">📊</span>
          <small>Data Literacy</small><h3>Data Detective</h3><p>Interpret datasets, distinguish useful evidence from misleading conclusions and make data-informed decisions.</p><b>PLAY / JUGAR / JOUER →</b>
        </a>
        <a className="game-card" href="/gamification/web.html">
          <span className="game-level">9–11</span><span className="game-icon">🌐</span>
          <small>Web Development</small><h3>Web Architect Challenge</h3><p>Connect HTML structure, CSS presentation and JavaScript behavior to design accessible interactive interfaces.</p><b>PLAY / JUGAR / JOUER →</b>
        </a>
        <a className="game-card" href="/gamification/iot.html">
          <span className="game-level">10–11</span><span className="game-icon">📡</span>
          <small>IoT & Systems</small><h3>IoT Mission Control</h3><p>Model input-process-output systems and reason about sensors, controllers, connectivity and automation.</p><b>PLAY / JUGAR / JOUER →</b>
        </a>
        </section>
        <section className="french-lab"><div><span className="game-kicker">🇫🇷 MINI IMMERSION</span><h2>French Tech Passport</h2><p>Each arena introduces useful French technology vocabulary without making French knowledge a barrier to play.</p></div><div className="french-words"><span>algorithme · algorithm</span><span>boucle · loop</span><span>données · data</span><span>capteur · sensor</span><span>déboguer · debug</span><span>réseau · network</span></div></section>
      </main>
    </SiteLayout>
  );
}
