import Link from "next/link";
import { notFound } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { gradeLabels } from "@/modules/student-projects/data/classrooms";
import { getProjectsByClassroom, isValidClassroom } from "@/modules/student-projects/services/studentProjectService";
import { ProjectCard } from "@/shared/components/student-projects/ProjectCard";
import { EmptyGallery } from "@/shared/components/student-projects/EmptyGallery";
type Props = { params: Promise<{ grade: string; classroom: string }> };
export default async function ClassroomGalleryPage({ params }: Props) {
  const values = await params; const grade = Number(values.grade);
  if (!isValidClassroom(grade, values.classroom)) notFound();
  const projects = getProjectsByClassroom(grade, values.classroom);
  return <SiteLayout><main className="page-shell student-projects-page">
    <Link href={`/students/grade/${grade}`} className="back-link">← {gradeLabels[grade]}</Link>
    <section className={`classroom-gallery-hero classroom-${values.classroom}`}><span>STUDENT PROJECT GALLERY</span>
      <h1>{gradeLabels[grade]} · {values.classroom.toUpperCase()}</h1><p>Digital projects, learning sequences and evidence created by our students.</p>
      {/* Hidden: Self-assessment moved to /self-assessment. Re-enable feature by uncommenting.
      <div className="hero-actions" style={{ marginTop: 16 }}>
        <Link href={`/students/grade/${grade}/${values.classroom}/self-assessment`} className="primary-button">
          📝 Autoevaluación Ciclo 6
        </Link>
        <Link href={`/students/grade/${grade}/${values.classroom}/self-assessment/results`} className="secondary-button">
          Ver resultados
        </Link>
      </div>
      */}
      </section>
    {projects.length === 0 ? <EmptyGallery /> : <section className="student-project-grid">{projects.map((p) => <ProjectCard key={p.id} project={p} />)}</section>}
  </main></SiteLayout>;
}
