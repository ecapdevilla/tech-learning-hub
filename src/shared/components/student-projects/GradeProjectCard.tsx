import Link from "next/link";
type Props = { grade: number; label: string; classrooms: string[]; projectCount: number };
export function GradeProjectCard({ grade, label, classrooms, projectCount }: Props) {
  return (
    <Link href={`/students/grade/${grade}`} className="student-grade-card">
      <span className="student-grade-number">{grade}</span><small>STUDENT PORTFOLIO</small><h3>{label}</h3>
      <p>{classrooms.map((item) => item.toUpperCase()).join(" · ")}</p>
      <span>{projectCount} published project{projectCount === 1 ? "" : "s"}</span><b>EXPLORE GRADE →</b>
    </Link>
  );
}
