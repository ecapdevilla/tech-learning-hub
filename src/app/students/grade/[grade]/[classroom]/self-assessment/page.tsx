import Link from "next/link";
import { notFound } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { SelfAssessmentForm } from "@/modules/self-assessment/components/SelfAssessmentForm";
import { isValidClassroom } from "@/modules/student-projects/services/studentProjectService";
import { isGradeId } from "@/modules/grades/types/grade";
import { gradeLabels, classroomsByGrade } from "@/modules/student-projects/data/classrooms";

const CLEAN_LABEL: Record<string, string> = {
  blue: "Blue",
  white: "White",
  red: "Red",
};

type Props = {
  params: Promise<{ grade: string; classroom: string }>;
};

export default async function SelfAssessmentPage({ params }: Props) {
  const { grade, classroom } = await params;
  const gradeNumber = Number(grade);

  if (!isGradeId(gradeNumber) || gradeNumber < 6 || gradeNumber > 11) notFound();
  if (!isValidClassroom(gradeNumber, classroom)) notFound();

  const label = gradeLabels[gradeNumber] ?? `${grade}th Grade`;

  return (
    <SiteLayout>
      <main className="page-shell self-assessment-page">
        <Link href="/students" className="back-link">
          ← Back to student projects
        </Link>

        <section className="student-projects-intro">
          <div>
            <span className="section-kicker">Ciclo 6 · Autoevaluación</span>
            <h2>
              {label} · {CLEAN_LABEL[classroom]} Classroom
            </h2>
          </div>
          <p>
            Respondé las 11 preguntas calificándote de 1 a 4. Tu nota se calcula con la suma de
            todas tus respuestas y se guarda en su salón, ordenada por apellido.
          </p>
          <div className="hero-actions" style={{ marginTop: 16 }}>
            <Link
              href={`/students/grade/${gradeNumber}/${classroom}/self-assessment/results`}
              className="secondary-button"
            >
              Ver resultados del salón
            </Link>
          </div>
          {classroomsByGrade[gradeNumber] && (
            <div className="classroom-links">
              {classroomsByGrade[gradeNumber].map((c) => (
                <Link
                  key={c}
                  href={`/students/grade/${gradeNumber}/${c}/self-assessment`}
                  className={c === classroom ? "classroom-link active" : "classroom-link"}
                >
                  {CLEAN_LABEL[c]}
                </Link>
              ))}
            </div>
          )}
        </section>

        <SelfAssessmentForm grade={gradeNumber} classroom={classroom} />
      </main>
    </SiteLayout>
  );
}