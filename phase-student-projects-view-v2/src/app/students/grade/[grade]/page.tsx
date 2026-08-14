import Link from "next/link";
import { notFound } from "next/navigation";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { classroomsByGrade, gradeLabels } from "@/modules/student-projects/data/classrooms";
import { getProjectsByClassroom } from "@/modules/student-projects/services/studentProjectService";
import { ClassroomCard } from "@/shared/components/student-projects/ClassroomCard";
type Props = { params: Promise<{ grade: string }> };
export default async function StudentGradePage({ params }: Props) {
  const { grade: value } = await params; const grade = Number(value); const classrooms = classroomsByGrade[grade];
  if (!classrooms) notFound();
  return <SiteLayout><main className="page-shell student-projects-page">
    <Link href="/students" className="back-link">← Student Projects</Link>
    <section className="student-grade-hero"><span>🌟 STUDENT PORTFOLIO</span><h1>{gradeLabels[grade]}</h1><p>Choose a classroom to explore published projects and learning sequences.</p></section>
    <section className="classroom-grid">{classrooms.map((classroom) => <ClassroomCard key={classroom} grade={grade} classroom={classroom} count={getProjectsByClassroom(grade, classroom).length} />)}</section>
  </main></SiteLayout>;
}
