import Link from "next/link";
const icons = { blue: "🔵", white: "⚪", red: "🔴" };
type Props = { grade: number; classroom: "blue" | "white" | "red"; count: number };
export function ClassroomCard({ grade, classroom, count }: Props) {
  return (
    <Link href={`/students/grade/${grade}/${classroom}`} className="classroom-card">
      <span className="classroom-icon">{icons[classroom]}</span><small>{grade}TH GRADE</small>
      <h3>{classroom.toUpperCase()}</h3><p>Student projects and learning sequences</p>
      <span>{count} published</span><b>OPEN GALLERY →</b>
    </Link>
  );
}
