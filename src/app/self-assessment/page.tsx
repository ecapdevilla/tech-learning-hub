import Link from "next/link";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { classroomsByGrade, gradeLabels } from "@/modules/student-projects/data/classrooms";

const GRADES = [6, 7, 8, 9, 10, 11];

export default function SelfAssessmentHomePage() {
  return (
    <SiteLayout>
      <main className="page-shell self-assessment-page">
        <section className="self-assessment-hero">
          <span className="student-projects-kicker">CICLO 6 · AUTOEVALUACIÓN</span>
          <h1>Autoevaluación</h1>
          <p>
            Responde las 11 preguntas calificándote de 1 a 4. Elige tu grado para comenzar.
          </p>
        </section>

        <section className="self-assessment-intro">
          <p>
            <strong>¿Cómo se calcula tu nota?</strong> Sumas tus respuestas (de 11 a 44) y ese total
            se convierte en tu nota y nivel. Al terminar, tu evaluación se guarda en tu salón.
          </p>
        </section>

        <h2 className="self-step-title">Elige tu grado</h2>
        <div className="self-grade-grid">
          {GRADES.map((grade) => (
            <Link
              key={grade}
              href={`/self-assessment/${grade}`}
              className="self-grade-card"
            >
              <span className="self-grade-number">{grade}</span>
              <strong>{gradeLabels[grade]}</strong>
              <small>{classroomsByGrade[grade]?.length ?? 0} salones</small>
            </Link>
          ))}
        </div>
      </main>
    </SiteLayout>
  );
}