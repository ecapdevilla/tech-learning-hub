import { cookies } from "next/headers";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { TeacherGate } from "@/modules/self-assessment/components/TeacherGate";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";
import { GradingSelector } from "@/modules/grading/components/GradingSelector";

export default async function GradingHomePage() {
  const cookieStore = await cookies();
  const isTeacher = cookieStore.get(TEACHER_COOKIE)?.value === "authorized";

  return (
    <SiteLayout>
      <main className="page-shell self-assessment-page">
        <section className="student-projects-intro">
          <div>
            <span className="section-kicker">MÓDULO DOCENTE · NOTAS</span>
            <h2>Calificaciones · Saber / Hacer / Ser</h2>
          </div>
          <p>
            Carga las notas de las entregas (Saber, Hacer, Ser) por estudiante y exporta el Excel
            en formato institucional. Acceso restringido al docente.
          </p>
        </section>

        {!isTeacher ? (
          <TeacherGate />
        ) : (
          <GradingSelector />
        )}
      </main>
    </SiteLayout>
  );
}