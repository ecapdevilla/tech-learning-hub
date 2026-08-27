import Link from "next/link";
import { notFound } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { SelfAssessmentForm } from "@/modules/self-assessment/components/SelfAssessmentForm";
import { classroomsByGrade, gradeLabels } from "@/modules/student-projects/data/classrooms";

const CLEAN_LABEL: Record<string, string> = {
  blue: "Blue",
  white: "White",
  red: "Red",
};

type Props = {
  params: Promise<{ grade: string; classroom: string }>;
};

export default async function SelfAssessmentFormPage({ params }: Props) {
  const { grade, classroom } = await params;
  const gradeNumber = Number(grade);
  if (gradeNumber < 6 || gradeNumber > 11) notFound();

  const classrooms = classroomsByGrade[gradeNumber];
  if (!classrooms || !classrooms.includes(classroom as "blue" | "white" | "red")) notFound();

  const label = gradeLabels[gradeNumber] ?? `${gradeNumber}th Grade`;

  return (
    <SiteLayout>
      <main className="page-shell self-assessment-page">
        <Link href={`/self-assessment/${gradeNumber}`} className="back-link">
          ← {label}
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
            tus respuestas y se guarda en tu salón.
          </p>
          <div className="classroom-links" style={{ marginTop: 12 }}>
            {classrooms.map((c) => (
              <Link
                key={c}
                href={`/self-assessment/${gradeNumber}/${c}`}
                className={c === classroom ? "classroom-link active" : "classroom-link"}
              >
                {CLEAN_LABEL[c]}
              </Link>
            ))}
          </div>
        </section>

        <SelfAssessmentForm grade={gradeNumber} classroom={classroom} />
      </main>
    </SiteLayout>
  );
}