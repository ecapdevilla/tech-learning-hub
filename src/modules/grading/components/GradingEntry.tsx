"use client";

import { useMemo, useState } from "react";

type Init = {
  studentId: string;
  fullName: string;
  saber: (number | null)[];
  hacer: (number | null)[];
  ser: (number | null)[];
};

type Props = {
  subjectId: string;
  periodId: string;
  grade: number;
  classroom: string;
  initial: Init[];
};

const SABER_COUNT = 4;
const HACER_COUNT = 4;
const SER_COUNT = 3;
const WEIGHTS = { saber: 0.33, hacer: 0.33, ser: 0.34 };

const parseVal = (s: string): number | null => {
  const n = Number(s.replace(",", "."));
  if (s.trim() === "" || Number.isNaN(n)) return null;
  if (n < 0 || n > 5) return null;
  return Math.round(n * 10) / 10;
};

export function GradingEntry({ subjectId, periodId, grade, classroom, initial }: Props) {
  const [rows, setRows] = useState(initial);
  const [saving, setSaving] = useState(false);
  const [msg, setMsg] = useState("");

  const setVal = (idx: number, dim: "saber" | "hacer" | "ser", entrega: number, value: string) => {
    setRows((prev) =>
      prev.map((r, i) =>
        i === idx ? { ...r, [dim]: r[dim].map((v, k) => (k === entrega ? parseVal(value) : v)) } : r
      )
    );
  };

  const avg = (arr: (number | null)[]) => {
    const filled = arr.filter((v): v is number => v !== null);
    if (filled.length === 0) return null;
    return filled.reduce((a, b) => a + b, 0) / filled.length;
  };

  const formatted = useMemo(
    () =>
      rows.map((r) => {
        const parSab = avg(r.saber);
        const parHac = avg(r.hacer);
        const parSer = avg(r.ser);
        const final = parSab !== null && parHac !== null && parSer !== null ? parSab * WEIGHTS.saber + parHac * WEIGHTS.hacer + parSer * WEIGHTS.ser : null;
        return { ...r, parSab, parHac, parSer, final };
      }),
    [rows]
  );

  const save = async () => {
    setSaving(true);
    setMsg("");
    const dims: ("saber" | "hacer" | "ser")[] = ["saber", "hacer", "ser"];
    const payload: { student_id: string; dimension: string; entrega_index: number; value: number | null }[] = [];
    for (const r of rows) {
      for (const d of dims) {
        r[d].forEach((v, i) => {
          payload.push({ student_id: r.studentId, dimension: d, entrega_index: i + 1, value: v });
        });
      }
    }
    const res = await fetch("/api/grading/save", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ subject_id: subjectId, period_id: periodId, rows: payload }),
    });
    setSaving(false);
    if (res.ok) setMsg("Notas guardadas correctamente.");
    else setMsg("Error al guardar. Revisa conectividad.");
  };

  const exportUrl = `/api/grading/export?subject=${subjectId}&period=${periodId}&grade=${grade}&classroom=${classroom}`;

  const cell = (idx: number, dim: "saber" | "hacer" | "ser", entrega: number, value: number | null) => (
    <input
      className="grading-input"
      type="number"
      min={0}
      max={5}
      step={0.1}
      value={value ?? ""}
      onChange={(e) => setVal(idx, dim, entrega, e.target.value)}
    />
  );

  return (
    <div>
      <div className="grading-toolbar">
        <button className="primary-button" onClick={save} disabled={saving}>
          {saving ? "Guardando…" : "💾 Guardar notas"}
        </button>
        <a className="secondary-button" download href={exportUrl}>
          ⬇️ Exportar Excel
        </a>
      </div>
      {msg && <p className="grading-save-msg">{msg}</p>}

      <table className="grading-table">
        <thead>
          <tr>
            <th>N°</th>
            <th>Nombre completo</th>
            {Array.from({ length: SABER_COUNT }, (_, i) => (
              <th key={`s${i}`}>S n{i + 1}</th>
            ))}
            <th>Saber</th>
            {Array.from({ length: HACER_COUNT }, (_, i) => (
              <th key={`h${i}`}>H n{i + 1}</th>
            ))}
            <th>Hacer</th>
            {Array.from({ length: SER_COUNT }, (_, i) => (
              <th key={`e${i}`}>Ser n{i + 1}</th>
            ))}
            <th>Ser</th>
            <th>Final</th>
          </tr>
        </thead>
        <tbody>
          {formatted.map((r, idx) => (
            <tr key={r.studentId}>
              <td>{idx + 1}</td>
              <td>{r.fullName}</td>
              {r.saber.map((v, i) => (
                <td key={`s${idx}-${i}`}>{cell(idx, "saber", i, v)}</td>
              ))}
              <td className="grading-cell">{r.parSab === null ? "—" : r.parSab.toFixed(1)}</td>
              {r.hacer.map((v, i) => (
                <td key={`h${idx}-${i}`}>{cell(idx, "hacer", i, v)}</td>
              ))}
              <td className="grading-cell">{r.parHac === null ? "—" : r.parHac.toFixed(1)}</td>
              {r.ser.map((v, i) => (
                <td key={`e${idx}-${i}`}>{cell(idx, "ser", i, v)}</td>
              ))}
              <td className="grading-cell">{r.parSer === null ? "—" : r.parSer.toFixed(1)}</td>
              <td className="grading-final">{r.final === null ? "—" : r.final.toFixed(1)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}