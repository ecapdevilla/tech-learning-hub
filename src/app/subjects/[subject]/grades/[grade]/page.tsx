import Link from "next/link";
import { notFound } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { createLessonService } from "@/modules/lessons/services";
import { lessonRepositoryLocal } from "@/infrastructure/repositories";
import { isGradeId } from "@/modules/grades/types/grade";
import { grades } from "@/content/grades/grades";
import { mathGrades } from "@/content/math/grades";

type Props = {
  params: Promise<{ subject: string; grade: string }>;
};

const lessonService = createLessonService(lessonRepositoryLocal);

const subjectCatalog: Record<string, { grades: typeof grades; label: string }> = {
  technology: { grades, label: "Technology" },
  math: { grades: mathGrades, label: "Mathematics" },
};

export default async function SubjectGradePage({ params }: Props) {
  const { subject, grade } = await params;

  const catalog = subjectCatalog[subject];
  if (!catalog) notFound();

  const gradeNumber = Number(grade);
  if (!isGradeId(gradeNumber)) notFound();

  const gradeData = catalog.grades.find((g) => g.id === gradeNumber);
  if (!gradeData) notFound();

  const gradeLessons =
    subject === "technology" ? lessonService.getLessonsByGrade(gradeNumber) : [];

  const isGrade10 = gradeNumber === 10;

  return (
    <SiteLayout>
      <section className="page-shell grade-page">
        <Link href={subject === "math" ? "/math" : "/"} className="back-link">
          ← Back to {catalog.label}
        </Link>

        <div className="grade-page-header">
          <div className="grade-big-number">{gradeData.id}</div>

          <div>
            <span className="section-kicker">{catalog.label}</span>
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
                    <span className="cycle-badge">Cycle {lesson.cycle}</span>
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
                    <a href={lesson.guidePath} className="primary-button lesson-button">
                      Open guide
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