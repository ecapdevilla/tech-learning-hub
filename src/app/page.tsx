import Link from "next/link";
import {
  primaryGrades,
  secondaryGrades,
} from "@/content/grades/grades";
import {
  mathPrimaryGrades,
  mathSecondaryGrades,
} from "@/content/math/grades";
import { GradeSection } from "@/modules/grades/components/GradeSection";
import { HeroCopy } from "@/modules/grades/components/HeroCopy";
import { HeroVisual } from "@/modules/grades/components/HeroVisual";
import { HomeFeatures } from "@/shared/components/layout/HomeFeatures";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function Home() {
  return (
    <SiteLayout>
      <section className="hero-section">
        <div className="page-shell hero-grid">
          <div>
            <HeroCopy
              eyebrow="Technology · Programming · Innovation"
              title="Create."
              description="A digital learning space where students can explore, build, practice and connect technology with real-world challenges."
            />

            <div className="hero-actions">
              <a href="#learning-levels" className="primary-button">
                Start learning
              </a>
              <Link href="/resources" className="secondary-button">
                Open resource library
              </Link>
            </div>
          </div>

          <HeroVisual />
        </div>
      </section>

      <section
        id="learning-levels"
        className="page-shell learning-levels"
      >
        <div className="welcome-strip">
          <span>🚀</span>
          <div>
            <strong>Choose your path</strong>
            <p>
              Start with your grade or explore another level to reinforce
              previous concepts and discover what comes next.
            </p>
          </div>
        </div>

        <GradeSection
          kicker="Primary School"
          title="Learn by playing and creating"
          description="Visual, interactive and age-appropriate experiences that introduce computational thinking."
          grades={primaryGrades}
        />

        <GradeSection
          kicker="Secondary School"
          title="Build, code and solve"
          description="Progressive learning paths in programming, web development, digital systems and IoT."
          grades={secondaryGrades}
        />

        <section className="math-home-entry">
          <a href="/math" className="feature-card" style={{ display: "block" }}>
            <span className="feature-icon">🔢</span>
            <div>
              <span className="section-kicker">Mathematics · Grades 1–11</span>
              <h3>Math Learning Hub</h3>
              <p>Explore numbers, patterns and problem solving across every grade, from primary to secondary.</p>
            </div>
          </a>
        </section>

        <GradeSection
          subject="math"
          kicker="Mathematics"
          title="Learn by numbers and patterns"
          description="Hands-on math paths that build number sense, reasoning and problem-solving skills."
          grades={mathPrimaryGrades}
        />

        <GradeSection
          subject="math"
          kicker="Mathematics"
          title="Think, solve and model"
          description="Progressive levels from algebra to calculus foundations, reusing the same learning structure."
          grades={mathSecondaryGrades}
        />

        <HomeFeatures />
      </section>

                      <section className="student-projects-home-entry" style={{ marginTop: "28px", marginBottom: "28px" }}>
          <a href="/students" className="feature-card" style={{ display: "block" }}>
            <span className="feature-icon">🌟</span>
            <div>
              <span className="section-kicker">Grades 6–11 · Student Portfolio</span>
              <h3>Student Projects & Learning Sequences</h3>
              <p>Created by our students. Shared with our families and community. Explore projects by grade and classroom.</p>
            </div>
          </a>
        </section><section className="gamification-home-entry">
          <a href="/gamification" className="feature-card">
            <span className="feature-icon">🎮</span>
            <div>
              <span className="section-kicker">Grades 9–11 · Gamification</span>
              <h3>Gamification Zone</h3>
              <p>
                Logic, debugging, data, web, cybersecurity, databases,
                AI and IoT. English · Español · French immersion.
              </p>
            </div>
          </a>
        </section><footer className="site-footer">
        <div className="page-shell">
          Tech Learning Hub · Learn · Practice · Create
        </div>
      </footer>
    </SiteLayout>
  );
}