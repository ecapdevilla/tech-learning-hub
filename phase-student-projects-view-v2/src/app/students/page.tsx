import Link from "next/link";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { classroomsByGrade, gradeLabels } from "@/modules/student-projects/data/classrooms";
import { getProjectsByGrade } from "@/modules/student-projects/services/studentProjectService";
import { StudentProjectsHero } from "@/shared/components/student-projects/StudentProjectsHero";
import { GradeProjectCard } from "@/shared/components/student-projects/GradeProjectCard";

export default function StudentProjectsPage() {
  return <SiteLayout><main className="page-shell student-projects-page">
    <Link href="/" className="back-link">← Back to Tech Learning Hub</Link><StudentProjectsHero />
    <section className="student-projects-intro"><div><b>EXPLORE</b><h2>Choose a grade.</h2></div>
      <p>Each grade is organized by classroom so students and families can find their projects quickly.</p></section>
    <section className="student-grade-grid">{Object.keys(classroomsByGrade).map((value) => {
      const grade = Number(value);
      return <GradeProjectCard key={grade} grade={grade} label={gradeLabels[grade]}
        classrooms={classroomsByGrade[grade]} projectCount={getProjectsByGrade(grade).length} />;
    })}</section>
  </main></SiteLayout>;
}
