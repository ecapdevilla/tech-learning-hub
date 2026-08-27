import { cookies } from "next/headers";
import { notFound, redirect } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { TeacherGate } from "@/modules/self-assessment/components/TeacherGate";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";
import { gradingRepository, computeStudent } from "@/modules/grading/data/gradingRepository";
import { isGradeId } from "@/modules/grades/types/grade";
import { isValidClassroom } from "@/modules/student-projects/services/studentProjectService";
import { gradeLabels } from "@/modules/student-projects/data/classrooms";
import { GradingEntry } from "@/modules/grading/components/GradingEntry";

export const dynamic = "force-dynamic";

export default async function GradingEntryPage({
  searchParams,
}: {
  searchParams: Promise<{ subject?: string; period?: string; grade?: string; classroom?: string }>;
}) {
  const cookieStore = await cookies();
  const isTeacher = cookieStore.get(TEACHER_COOKIE)?.value === "authorized";
  const sp = await searchParams;

  if (!isTeacher) {
    return (
      <SiteLayout>
        <main className="page-shell self-assessment-page">
          <TeacherGate />
        </main>
      </SiteLayout>
    );
  }

  const subjectId = sp.subject ?? "";
  const periodId = sp.period ?? "";
  const grade = Number(sp.grade);
  const classroom = sp.classroom ?? "";
  if (!isGradeId(grade) || !isValidClassroom(grade, classroom) || !subjectId || !periodId) {
    redirect("/grading");
  }

  await gradingRepository.ensureDimensions(subjectId, periodId);
  const dimensions = (await gradingRepository.getDimensions()).filter(
    (d) => d.subject_id === subjectId && d.period_id === periodId
  );
  const students = await gradingRepository.getStudents(grade, classroom);
  const gradeRows = await gradingRepository.getGrades(dimensions.map((d) => d.id));
  const computed = students.map((s) => computeStudent(s, dimensions, gradeRows));

  return (
    <SiteLayout>
      <main className="page-shell self-assessment-page">
        <section className="student-projects-intro">
          <div>
            <span className="section-kicker">MÓDULO DOCENTE · NOTAS</span>
            <h2>
              {gradeLabels[grade]} · {classroom.toUpperCase()} · {subjectId.slice(0, 8)}
            </h2>
          </div>
          <p>Digita las notas (1..5) o deja en blanco. Parciales y final se calculan automáticamente.</p>
        </section>

        {computed.length === 0 ? (
          <div className="empty-card">
            <span>👥</span>
            <h3>No hay estudiantes cargados</h3>
            <p>Carga el listado de estudiantes (Excel) en la tabla <code>grading_students</code> por grado y salón.</p>
          </div>
        ) : (
          <GradingEntry
            subjectId={subjectId}
            periodId={periodId}
            grade={grade}
            classroom={classroom}
            initial={computed.map((c) => ({
              studentId: c.student.id,
              fullName: `${c.student.last_name} ${c.student.first_name}`,
              saber: c.valores.saber,
              hacer: c.valores.hacer,
              ser: c.valores.ser,
            }))}
          />
        )}
      </main>
    </SiteLayout>
  );
}