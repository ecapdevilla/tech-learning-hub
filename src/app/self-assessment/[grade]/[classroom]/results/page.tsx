import Link from "next/link";
import { notFound } from "next/navigation";
import { cookies } from "next/headers";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { selfAssessmentRepository } from "@/modules/self-assessment/data/selfAssessmentRepository";
import { TeacherGate } from "@/modules/self-assessment/components/TeacherGate";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";
import { classroomsByGrade, gradeLabels } from "@/modules/student-projects/data/classrooms";

const CLEAN_LABEL: Record<string, string> = {
  blue: "Blue",
  white: "White",
  red: "Red",
};

type Props = {
  params: Promise<{ grade: string; classroom: string }>;
};

export default async function SelfAssessmentResultsPage({ params }: Props) {
  const { grade, classroom } = await params;
  const gradeNumber = Number(grade);
  if (gradeNumber < 6 || gradeNumber > 11) notFound();

  const classrooms = classroomsByGrade[gradeNumber];
  if (!classrooms || !classrooms.includes(classroom as "blue" | "white" | "red")) notFound();

  const cookieStore = await cookies();
  const isTeacher = cookieStore.get(TEACHER_COOKIE)?.value === "authorized";
  const label = gradeLabels[gradeNumber] ?? `${gradeNumber}th Grade`;

  let submissions: {
    firstName: string;
    lastName: string;
    total: number;
    nota: number;
    nivel: string;
  }[] = [];
  let configured = true;
  let avg = 0;

  if (isTeacher) {
    configured = selfAssessmentRepository.isConfigured();
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
      avg =
        submissions.length > 0
          ? submissions.reduce((acc, s) => acc + s.nota, 0) / submissions.length
          : 0;
    }
  }

  return (
    <SiteLayout>
      <main className="page-shell self-assessment-page">
        <Link href={`/self-assessment/${gradeNumber}/${classroom}`} className="back-link">
          ← {label} · {CLEAN_LABEL[classroom]}
        </Link>

        <section className="student-projects-intro">
          <div>
            <span className="section-kicker">Ciclo 6 · Resultados</span>
            <h2>
              {label} · {CLEAN_LABEL[classroom]} Classroom
            </h2>
          </div>
          <p>Resultados guardados, ordenados alfabéticamente por apellido. Acceso restringido.</p>
        </section>

        {!isTeacher ? (
          <TeacherGate />
        ) : !configured ? (
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
            <div className="results-toolbar">
              <div className="results-summary">
                <p>
                  <strong>Estudiantes:</strong> {submissions.length} ·{" "}
                  <strong>Promedio del salón:</strong> {avg.toFixed(2)}
                </p>
              </div>
              <a
                className="primary-button download-csv"
                href={`/api/self-assessment/export?grade=${gradeNumber}&classroom=${classroom}`}
                download
              >
                ⬇️ Descargar CSV
              </a>
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