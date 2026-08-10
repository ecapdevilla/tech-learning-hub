import Link from "next/link";
import {
  primaryGrades,
  secondaryGrades,
} from "@/content/grades/grades";
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

        <HomeFeatures />
      </section>

      <footer className="site-footer">
        <div className="page-shell">
          Tech Learning Hub · Learn · Practice · Create
        </div>
      </footer>
    </SiteLayout>
  );
}