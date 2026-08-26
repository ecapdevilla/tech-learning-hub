import Link from "next/link";
import type { Grade } from "@/modules/grades/types/grade";

type Props = {
  grade: Grade;
  subject?: string;
};

export function GradeCard({ grade, subject }: Props) {
  const href = subject ? `/subjects/${subject}/grades/${grade.id}` : `/grades/${grade.id}`;
  return (
    <Link href={href} className="grade-card">
      <div className="grade-number">{grade.id}</div>
      <div>
        <p className="grade-label">{grade.label}</p>
        <p className="grade-description">{grade.description}</p>
      </div>
      <span className="grade-arrow">→</span>
    </Link>
  );
}