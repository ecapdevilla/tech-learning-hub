import Link from "next/link";
import { notFound } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { createGradeService } from "@/modules/grades/services";
import { createLessonService } from "@/modules/lessons/services";
import { gradeRepositoryLocal, lessonRepositoryLocal } from "@/infrastructure/repositories";
import { isGradeId } from "@/modules/grades/types/grade";

type Props = {
  params: Promise<{ grade: string }>;
};

const gradeService = createGradeService(gradeRepositoryLocal);
const lessonService = createLessonService(lessonRepositoryLocal);

export default async function GradePage({ params }: Props) {
  const { grade } = await params;
  const gradeNumber = Number(grade);

  if (!isGradeId(gradeNumber)) notFound();

  const gradeData = gradeService.getGradeById(gradeNumber);

  if (!gradeData) notFound();

  const gradeLessons = lessonService.getLessonsByGrade(gradeNumber);
  const isGrade10 = gradeNumber === 10;

  return (
    <SiteLayout>
      <section className="page-shell grade-page">
        <Link href="/" className="back-link">
          ← Back to grades
        </Link>

        <div className="grade-page-header">
          <div className="grade-big-number">{gradeData.id}</div>

          <div>
            <span className="section-kicker">Grade</span>
            <h1>{gradeData.label}</h1>
            <p>{gradeData.description}</p>
          </div>
        </div>

        <section className="lesson-list">
          <div className="section-heading compact">
            <div>
              <span className="section-kicker">
                {isGrade10 ? "Grade 10 sequences" : "Current content"}
              </span>
              <h2>{isGrade10 ? "Didactic sequences" : "Lessons & guides"}</h2>
            </div>
          </div>

          {gradeLessons.length === 0 ? (
            <div className="empty-card">
              <span>🚧</span>
              <h3>Content coming soon</h3>
              <p>This grade is ready to receive new guides and activities.</p>
            </div>
          ) : (
            <div className="lesson-grid">
              {gradeLessons.map((lesson) => (
                <article key={lesson.id} className="lesson-card">
                  <div className="lesson-top">
                    <span className="cycle-badge">
                      Cycle {lesson.cycle}
                    </span>
                    <span>{lesson.durationMinutes} min</span>
                  </div>

                  <h3>{lesson.title.en}</h3>
                  <p>{lesson.objective.en}</p>

                  <div className="tags">
                    {lesson.tags.map((tag) => (
                      <span key={tag}>{tag}</span>
                    ))}
                  </div>

                  {lesson.guidePath && (
                    <a
                      href={lesson.guidePath}
                      className="primary-button lesson-button"
                    >
                      Open guide
                    </a>
                  )}
                  {/* Add Grade 6 Scratch classroom quick link */}
                  {gradeData.id === 6 && (
                    <a
                      href="/guides/grade-06/scratch-classroom.html"
                      className="secondary-button lesson-button"
                      style={{ marginLeft: 8 }}
                    >
                      Scratch classroom
                    </a>
                  )}
                </article>
              ))}
            </div>
          )}
        </section>
      </section>
    </SiteLayout>
  );
}