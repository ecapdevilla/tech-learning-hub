import Link from "next/link";
import { notFound } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { classroomsByGrade, gradeLabels } from "@/modules/student-projects/data/classrooms";

const CLEAN_LABEL: Record<string, string> = {
  blue: "Blue",
  white: "White",
  red: "Red",
};

type Props = {
  params: Promise<{ grade: string }>;
};

export default async function SelfAssessmentGradePage({ params }: Props) {
  const { grade } = await params;
  const gradeNumber = Number(grade);
  if (gradeNumber < 6 || gradeNumber > 11) notFound();

  const classrooms = classroomsByGrade[gradeNumber];
  if (!classrooms) notFound();

  return (
    <SiteLayout>
      <main className="page-shell self-assessment-page">
        <Link href="/self-assessment" className="back-link">
          ← Autoevaluación
        </Link>

        <section className="student-projects-intro">
          <div>
            <span className="section-kicker">Ciclo 6 · Autoevaluación</span>
            <h2>{gradeLabels[gradeNumber]}</h2>
          </div>
          <p>Elige tu salón para comenzar la autoevaluación.</p>
        </section>

        <h2 className="self-step-title">Elige tu salón</h2>
        <div className="self-classroom-grid">
          {classrooms.map((classroom) => (
            <Link
              key={classroom}
              href={`/self-assessment/${gradeNumber}/${classroom}`}
              className={`self-classroom-card classroom-${classroom}`}
            >
              <strong>{CLEAN_LABEL[classroom]} Classroom</strong>
              <small>Ingresar ›</small>
            </Link>
          ))}
        </div>
      </main>
    </SiteLayout>
  );
}