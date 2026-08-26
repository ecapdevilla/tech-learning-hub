import Link from "next/link";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { GradeSection } from "@/modules/grades/components/GradeSection";
import {
  mathPrimaryGrades,
  mathSecondaryGrades,
} from "@/content/math/grades";

export default function MathHomePage() {
  return (
    <SiteLayout>
      <section className="hero-section">
        <div className="page-shell hero-grid">
          <div>
            <span className="section-kicker">Mathematics · Thinking · Problem Solving</span>
            <h1 className="hero-title">Math.</h1>
            <p className="hero-subtitle">
              A place to explore numbers, patterns and logic through hands-on
              challenges across every grade from first to eleventh.
            </p>

            <div className="hero-actions">
              <a href="#math-levels" className="primary-button">
                Start exploring
              </a>
              <Link href="/resources" className="secondary-button">
                Open resource library
              </Link>
            </div>
          </div>
          <div className="hero-visual">
            <div className="math-big-number">∑</div>
          </div>
        </div>
      </section>

      <section id="math-levels" className="page-shell learning-levels">
        <div className="welcome-strip">
          <span>🔢</span>
          <div>
            <strong>Choose your path</strong>
            <p>
              Start with your grade or explore another level to reinforce
              previous topics and see what comes next.
            </p>
          </div>
        </div>

        <GradeSection
          subject="math"
          kicker="Primary School"
          title="Learn by playing and creating"
          description="Visual, interactive and age-appropriate experiences that build number sense and reasoning."
          grades={mathPrimaryGrades}
        />

        <GradeSection
          subject="math"
          kicker="Secondary School"
          title="Think, solve and model"
          description="Progressive paths in algebra, geometry, statistics and calculus foundations."
          grades={mathSecondaryGrades}
        />
      </section>

      <footer className="site-footer">
        <div className="page-shell">
          Tech Learning Hub · Mathematics · Explore · Create
        </div>
      </footer>
    </SiteLayout>
  );
}