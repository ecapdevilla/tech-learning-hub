import Link from "next/link";

export function HomeFeatures() {
  return (
    <section className="feature-grid">
      <Link href="/explore" className="feature-card">
        <span className="feature-icon">🔎</span>
        <div>
          <span className="section-kicker">Explore</span>
          <h3>Learn beyond your grade</h3>
          <p>Review concepts from different learning levels.</p>
        </div>
      </Link>

      <Link href="/resources" className="feature-card">
        <span className="feature-icon">📚</span>
        <div>
          <span className="section-kicker">Library</span>
          <h3>Guides & resources</h3>
          <p>Access materials, activities and class support.</p>
        </div>
      </Link>

      <Link href="/resources" className="feature-card sdg-card">
        <span className="feature-icon">🌎</span>
        <div>
          <span className="section-kicker">Global Goals</span>
          <h3>Technology with purpose</h3>
          <p>Connect projects with Sustainable Development Goals.</p>
        </div>
      </Link>
    </section>
  );
}