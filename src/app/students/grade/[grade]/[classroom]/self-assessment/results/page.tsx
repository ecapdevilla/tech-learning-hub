import Link from "next/link";
import { notFound } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { selfAssessmentRepository } from "@/modules/self-assessment/data/selfAssessmentRepository";
import { isValidClassroom } from "@/modules/student-projects/services/studentProjectService";
import { isGradeId } from "@/modules/grades/types/grade";
import { gradeLabels } from "@/modules/student-projects/data/classrooms";

const CLEAN_LABEL: Record<string, string> = {
  blue: "Blue",
  white: "White",
  red: "Red",
};

type Props = {
  params: Promise<{ grade: string; classroom: string; results?: string }>;
};

export default async function SelfAssessmentResultsPage({ params }: Props) {
  const { grade, classroom } = await params;
  const gradeNumber = Number(grade);

  if (!isGradeId(gradeNumber) || gradeNumber < 6 || gradeNumber > 11) notFound();
  if (!isValidClassroom(gradeNumber, classroom)) notFound();

  const configured = selfAssessmentRepository.isConfigured();

  let submissions: {
    firstName: string;
    lastName: string;
    total: number;
    nota: number;
    nivel: string;
  }[] = [];

  if (configured) {
    const rows = await selfAssessmentRepository.getSubmissions(gradeNumber, classroom);
    submissions = rows
      .map((r) => ({
        firstName: r.first_name,
        lastName: r.last_name,
        total: r.total,
        nota: Number(r.nota),
        nivel: r.nivel,
      }))
      .sort((a, b) => a.lastName.localeCompare(b.lastName, "es", { sensitivity: "base" }));
  }

  const label = gradeLabels[gradeNumber] ?? `${gradeNumber}th Grade`;

  const avg =
    submissions.length > 0
      ? submissions.reduce((acc, s) => acc + s.nota, 0) / submissions.length
      : 0;

  return (
    <SiteLayout>
      <main className="page-shell self-assessment-page">
        <Link href="/students" className="back-link">
          ← Back to student projects
        </Link>

        <section className="student-projects-intro">
          <div>
            <span className="section-kicker">Ciclo 6 · Resultados</span>
            <h2>
              {label} · {CLEAN_LABEL[classroom]} Classroom
            </h2>
          </div>
          <p>Resultados guardados, ordenados alfabéticamente por apellido.</p>
        </section>

        {!configured ? (
          <div className="empty-card">
            <span>⚠️</span>
            <h3>Supabase no está configurado</h3>
            <p>Agrega las variables de entorno para consultar los resultados.</p>
          </div>
        ) : submissions.length === 0 ? (
          <div className="empty-card">
            <span>📋</span>
            <h3>Aún no hay autoevaluaciones</h3>
            <p>Cuando los estudiantes respondan, aparecerán aquí ordenadas por apellido.</p>
          </div>
        ) : (
          <>
            <div className="results-summary">
              <p>
                <strong>Estudiantes:</strong> {submissions.length} · <strong>Promedio del salón:</strong>{" "}
                {avg.toFixed(2)}
              </p>
            </div>
            <table className="results-table">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Apellido</th>
                  <th>Nombre</th>
                  <th>Total</th>
                  <th>Nota</th>
                  <th>Nivel</th>
                </tr>
              </thead>
              <tbody>
                {submissions.map((s, i) => (
                  <tr key={`${s.lastName}-${s.firstName}-${i}`}>
                    <td>{i + 1}</td>
                    <td>{s.lastName}</td>
                    <td>{s.firstName}</td>
                    <td>{s.total}</td>
                    <td>{s.nota.toFixed(1)}</td>
                    <td>
                      <span className={`level-badge level-${s.nivel.toLowerCase()}`}>{s.nivel}</span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        )}
      </main>
    </SiteLayout>
  );
}