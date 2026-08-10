import { GradeCard } from "@/modules/grades/components/GradeCard";
import type { Grade } from "@/modules/grades/types/grade";

type Props = {
  title: string;
  kicker: string;
  description: string;
  grades: Grade[];
};

export function GradeSection({
  title,
  kicker,
  description,
  grades,
}: Props) {
  return (
    <section className="school-section">
      <div className="school-heading">
        <div>
          <span className="section-kicker">{kicker}</span>
          <h2>{title}</h2>
        </div>
        <p>{description}</p>
      </div>

      <div className="grades-grid">
        {grades.map((grade) => (
          <GradeCard key={grade.id} grade={grade} />
        ))}
      </div>
    </section>
  );
}