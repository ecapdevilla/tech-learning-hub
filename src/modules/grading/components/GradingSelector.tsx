"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { classroomsByGrade, gradeLabels } from "@/modules/student-projects/data/classrooms";

const GRADES = [6, 7, 8, 9, 10, 11];
const CLEAN_LABEL: Record<string, string> = { blue: "Blue", white: "White", red: "Red" };

type Subject = { id: string; name: string; teacher: string };
type Period = { id: string; academic_year: number; period: number };

export function GradingSelector() {
  const router = useRouter();
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [periods, setPeriods] = useState<Period[]>([]);
  const [subjectId, setSubjectId] = useState("");
  const [periodId, setPeriodId] = useState("");
  const [grade, setGrade] = useState(6);
  const [classroom, setClassroom] = useState("blue");
  const [msg, setMsg] = useState("");

  useEffect(() => {
    fetch("/api/grading/context")
      .then((r) => r.json())
      .then((data) => {
        setSubjects(data.subjects ?? []);
        setPeriods(data.periods ?? []);
        if (data.subjects?.[0]) setSubjectId(data.subjects[0].id);
        if (data.periods?.[0]) setPeriodId(data.periods[0].id);
        if (data.msg) setMsg(data.msg);
      })
      .catch(() => setMsg("No se pudo conectar con el servidor de notas."));
  }, []);

  const go = (e: React.FormEvent) => {
    e.preventDefault();
    router.push(`/grading/entry?subject=${subjectId}&period=${periodId}&grade=${grade}&classroom=${classroom}`);
  };

  return (
    <div className="self-assessment-form grading-selector-form">
      {msg && <p className="self-assessment-message">{msg}</p>}
      <form onSubmit={go} className="grading-selector-grid">
        <label>
          <span>Materia</span>
          <select value={subjectId} onChange={(e) => setSubjectId(e.target.value)}>
            {subjects.length === 0 && <option value="">Sin materias (configura en Supabase)</option>}
            {subjects.map((s) => (
              <option key={s.id} value={s.id}>
                {s.name}
              </option>
            ))}
          </select>
        </label>

        <label>
          <span>Periodo</span>
          <select value={periodId} onChange={(e) => setPeriodId(e.target.value)}>
            {periods.length === 0 && <option value="">Sin periodos</option>}
            {periods.map((p) => (
              <option key={p.id} value={p.id}>
                {p.academic_year} · periodo {p.period}
              </option>
            ))}
          </select>
        </label>

        <label>
          <span>Grado</span>
          <select value={grade} onChange={(e) => setGrade(Number(e.target.value))}>
            {GRADES.map((g) => (
              <option key={g} value={g}>
                {gradeLabels[g]}
              </option>
            ))}
          </select>
        </label>

        <label>
          <span>Salón</span>
          <select value={classroom} onChange={(e) => setClassroom(e.target.value)}>
            {(classroomsByGrade[grade] ?? []).map((c) => (
              <option key={c} value={c}>
                {CLEAN_LABEL[c]}
              </option>
            ))}
          </select>
        </label>

        <button className="primary-button" type="submit" style={{ gridColumn: "1 / -1", justifySelf: "start" }}>
          Ir a cargar notas →
        </button>
      </form>
    </div>
  );
}