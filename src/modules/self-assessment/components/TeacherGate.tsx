"use client";

import { useState } from "react";

export function TeacherGate() {
  const [password, setPassword] = useState("");
  const [error, setError] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(false);
    setLoading(true);
    try {
      const res = await fetch("/api/self-assessment/teacher-login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ password }),
      });
      if (!res.ok) {
        setError(true);
        return;
      }
      window.location.reload();
    } catch {
      setError(true);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="results-gate">
      <div className="empty-card">
        <span>🔒</span>
        <h3>Acceso restringido</h3>
        <p>Ingresa la clave de docente para ver los resultados del salón.</p>
        <form onSubmit={handleSubmit} className="teacher-gate-form">
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Clave de acceso"
            autoFocus
            disabled={loading}
          />
          <button className="primary-button" type="submit" disabled={loading}>
            {loading ? "Verificando…" : "Ingresar"}
          </button>
        </form>
        {error && <p className="self-assessment-message">Clave incorrecta.</p>}
      </div>
    </div>
  );
}