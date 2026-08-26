"use client";

import { useCallback, useEffect, useState } from "react";
import { selfAssessmentRepository } from "@/modules/self-assessment/data/selfAssessmentRepository";
import { sumAnswers, toResult } from "@/modules/self-assessment/services/selfAssessmentService";
import type {
  SelfAssessmentQuestion,
  SelfAssessmentResult,
  SelfAssessmentScaleRow,
} from "@/modules/self-assessment/types/selfAssessment";

type Props = {
  grade: number;
  classroom: string;
};

const SCALE_LABELS = [
  { value: 1, label: "Nunca / Casi nunca" },
  { value: 2, label: "A veces" },
  { value: 3, label: "Casi siempre" },
  { value: 4, label: "Siempre" },
];

export function SelfAssessmentForm({ grade, classroom }: Props) {
  const [questions, setQuestions] = useState<SelfAssessmentQuestion[]>([]);
  const [scale, setScale] = useState<SelfAssessmentScaleRow[]>([]);
  const [answers, setAnswers] = useState<Record<number, number>>({});
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState("");
  const [result, setResult] = useState<SelfAssessmentResult | null>(null);
  const [configured, setConfigured] = useState<boolean>(true);

  useEffect(() => {
    if (!selfAssessmentRepository.isConfigured()) {
      setConfigured(false);
      return;
    }
    let active = true;
    Promise.all([
      selfAssessmentRepository.getQuestions(),
      selfAssessmentRepository.getScale(),
    ]).then(([q, s]) => {
      if (!active) return;
      setQuestions(q);
      setScale(s);
    });
    return () => {
      active = false;
    };
  }, []);

  const handleSubmit = useCallback(async () => {
    setMessage("");
    if (!firstName.trim() || !lastName.trim()) {
      setMessage("Escribe tu nombre y tu apellido para guardar la evaluación.");
      return;
    }
    if (Object.keys(answers).length !== questions.length) {
      setMessage("Respondé las 11 preguntas para calcular la nota.");
      return;
    }

    const values = questions.map((q) => answers[q.id]);
    if (values.some((v) => v === undefined)) {
      setMessage("Respondé todas las preguntas, cada una entre 1 y 4.");
      return;
    }

    const total = sumAnswers(values);
    const computed = toResult(total, scale);
    if (!computed) {
      setMessage("No se pudo calcular la nota (total fuera de rango).");
      return;
    }

    setSubmitting(true);
    const ok = await selfAssessmentRepository.saveSubmission({
      grade,
      classroom: classroom as "blue" | "white" | "red",
      first_name: firstName.trim(),
      last_name: lastName.trim(),
      p1: answers[1],
      p2: answers[2],
      p3: answers[3],
      p4: answers[4],
      p5: answers[5],
      p6: answers[6],
      p7: answers[7],
      p8: answers[8],
      p9: answers[9],
      p10: answers[10],
      p11: answers[11],
      total: computed.total,
      nota: computed.nota,
      nivel: computed.nivel,
    });
    setSubmitting(false);

    if (ok) {
      setResult(computed);
      setMessage("Evaluación guardada correctamente.");
    } else {
      setMessage("No se pudo guardar. Verificá la conexión a Supabase e intentá de nuevo.");
    }
  }, [answers, firstName, lastName, grade, classroom, questions, scale]);

  if (!configured) {
    return (
      <div className="empty-card">
        <span>⚠️</span>
        <h3>Supabase no está configurado</h3>
        <p>
          Agregá <code>NEXT_PUBLIC_SUPABASE_URL</code> y{" "}
          <code>NEXT_PUBLIC_SUPABASE_ANON_KEY</code> a un archivo .env.local para habilitar la
          autoevaluación.
        </p>
      </div>
    );
  }

  return (
    <div className="self-assessment-form">
      <div className="student-fields">
        <label>
          <span>Nombre</span>
          <input
            value={firstName}
            onChange={(e) => setFirstName(e.target.value)}
            placeholder="Nombre"
            disabled={!!result}
          />
        </label>
        <label>
          <span>Apellido</span>
          <input
            value={lastName}
            onChange={(e) => setLastName(e.target.value)}
            placeholder="Apellido"
            disabled={!!result}
          />
        </label>
      </div>

      <p className="self-assessment-scale-hint">
        Calificá cada enunciado de 1 a 4: {SCALE_LABELS.map((s) => `${s.value} = ${s.label}`).join(" · ")}
      </p>

      {questions.map((q, index) => (
        <fieldset key={q.id} className="self-question">
          <legend>
            {index + 1}. {q.question}
          </legend>
          <div className="self-question-options">
            {SCALE_LABELS.map((s) => (
              <label key={s.value} className="self-option">
                <input
                  type="radio"
                  name={`q-${q.id}`}
                  value={s.value}
                  checked={answers[q.id] === s.value}
                  onChange={() => setAnswers((prev) => ({ ...prev, [q.id]: s.value }))}
                  disabled={!!result}
                />
                <span>{s.value}</span>
              </label>
            ))}
          </div>
        </fieldset>
      ))}

      {!result ? (
        <button className="primary-button" onClick={handleSubmit} disabled={submitting}>
          {submitting ? "Guardando…" : "Calcular mi nota"}
        </button>
      ) : (
        <div className="self-assessment-result">
          <span className="section-kicker">Tu autoevaluación · Ciclo 6</span>
          <h3>Puntaje total: {result.total} / 44</h3>
          <div className="self-result-score">
            <strong>Nota: {result.nota.toFixed(1)}</strong>
            <span className={`level-badge level-${result.nivel.toLowerCase()}`}>{result.nivel}</span>
          </div>
          <button
            className="secondary-button"
            onClick={() => {
              setResult(null);
              setAnswers({});
              setMessage("");
            }}
            style={{ marginTop: 12 }}
          >
            Volver a evaluarme
          </button>
        </div>
      )}

      {message && <p className="self-assessment-message">{message}</p>}
    </div>
  );
}