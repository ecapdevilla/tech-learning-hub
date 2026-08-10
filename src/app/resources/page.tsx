import Image from "next/image";
import Link from "next/link";
import { lessons } from "@/content/catalog/lessons";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function ResourcesPage() {
  return (
    <SiteLayout>
      <section className="page-shell simple-page">
        <span className="section-kicker">Resources</span>
        <h1>Learning Resources</h1>
        <p className="resource-intro">
          Review current class guides and connect technology projects
          with the Sustainable Development Goals.
        </p>

        <section className="resources-layout">
          <article className="ods-panel">
            <div>
              <span className="section-kicker">Global Goals</span>
              <h2>Sustainable Development Goals</h2>
              <p>
                Use the SDGs as inspiration for technology projects
                that respond to real-world challenges.
              </p>
            </div>

            <Image
              src="/images/ods/sustainable-development-goals.png"
              alt="Sustainable Development Goals"
              width={1024}
              height={1024}
              className="ods-image"
              priority
            />
          </article>

          <div>
            <div className="section-heading compact">
              <div>
                <span className="section-kicker">Available now</span>
                <h2>Class Guides</h2>
              </div>
            </div>

            <div className="resource-guide-grid">
              {lessons.map((lesson) => (
                <article key={lesson.id} className="resource-guide-card">
                  <span className="cycle-badge">
                    Grade {lesson.grade} · Cycle {lesson.cycle}
                  </span>

                  <h3>{lesson.title.en}</h3>
                  <p>{lesson.objective.en}</p>

                  {lesson.guidePath && (
                    <a
                      className="primary-button resource-open"
                      href={lesson.guidePath}
                    >
                      Open guide
                    </a>
                  )}
                </article>
              ))}
            </div>

            <Link href="/" className="back-link resource-home">
              ← Back home
            </Link>
          </div>
        </section>
      </section>
    </SiteLayout>
  );
}