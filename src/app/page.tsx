import Link from "next/link";
import { grades } from "@/content/grades/grades";
import { GradeCard } from "@/modules/grades/components/GradeCard";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function Home() {
  return (
    <SiteLayout>
      <section className="hero-section">
        <div className="page-shell hero-grid">
          <div>
            <span className="eyebrow">Technology · Programming · Innovation</span>

            <h1>
              Learn.
              <br />
              Practice.
              <br />
              <span>Create.</span>
            </h1>

            <p className="hero-copy">
              A learning space for guides, interactive activities,
              programming challenges and digital resources.
            </p>

            <div className="hero-actions">
              <a href="#grades" className="primary-button">
                Choose your grade
              </a>

              <Link href="/explore" className="secondary-button">
                Explore resources
              </Link>
            </div>
          </div>

          <div className="hero-visual">
            <div className="visual-card visual-one">💻</div>
            <div className="visual-card visual-two">🤖</div>
            <div className="visual-card visual-three">🌐</div>
            <div className="visual-card visual-four">📡</div>
          </div>
        </div>
      </section>

      <section id="grades" className="page-shell section-block">
        <div className="section-heading">
          <div>
            <span className="section-kicker">Learning paths</span>
            <h2>Select your grade</h2>
          </div>

          <p>
            Review your current lessons or explore another grade to reinforce
            concepts and discover new topics.
          </p>
        </div>

        <div className="grades-grid">
          {grades.map((grade) => (
            <GradeCard key={grade.id} grade={grade} />
          ))}
        </div>
      </section>

      <section className="page-shell feature-grid">
        <Link href="/explore" className="feature-card">
          <span className="feature-icon">🔎</span>
          <div>
            <span className="section-kicker">Explore</span>
            <h3>Learn beyond your grade</h3>
            <p>
              Search lessons, labs and concepts from different grade levels.
            </p>
          </div>
        </Link>

        <Link href="/resources" className="feature-card">
          <span className="feature-icon">📚</span>
          <div>
            <span className="section-kicker">Resources</span>
            <h3>Guides and materials</h3>
            <p>
              Access class guides, downloadable resources and support material.
            </p>
          </div>
        </Link>

        <div className="feature-card sdg-card">
          <span className="feature-icon">🌎</span>
          <div>
            <span className="section-kicker">Global Goals</span>
            <h3>Sustainable Development Goals</h3>
            <p>
              Connect technology projects with real-world challenges.
            </p>
          </div>
        </div>
      </section>

      <footer className="site-footer">
        <div className="page-shell">
          Tech Learning Hub · Technology & Programming
        </div>
      </footer>
    </SiteLayout>
  );
}