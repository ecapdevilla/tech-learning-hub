import Link from "next/link";
import type { Grade } from "@/modules/grades/types/grade";

type Props = {
  grade: Grade;
};

export function GradeCard({ grade }: Props) {
  return (
    <Link href={`/grades/${grade.id}`} className="grade-card">
      <div className="grade-number">{grade.id}</div>
      <div>
        <p className="grade-label">{grade.label}</p>
        <p className="grade-description">{grade.description}</p>
      </div>
      <span className="grade-arrow">→</span>
    </Link>
  );
}