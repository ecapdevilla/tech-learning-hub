"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

export default function Grade8SequenceLink() {
  const pathname = usePathname();

  if (pathname !== "/grades/8" && pathname !== "/grades/8/") {
    return null;
  }

  return (
    <section
      aria-label="Secuencia didáctica de 8th"
      style={{
        maxWidth: "1180px",
        margin: "28px auto 40px",
        padding: "0 20px",
      }}
    >
      <div
        style={{
          background: "linear-gradient(135deg, #eef4ff 0%, #ffffff 100%)",
          border: "1px solid #d7e1f2",
          borderRadius: "20px",
          padding: "22px 24px",
          display: "flex",
          gap: "18px",
          justifyContent: "space-between",
          alignItems: "center",
          flexWrap: "wrap",
          boxShadow: "0 8px 24px rgba(30, 41, 70, 0.06)",
        }}
      >
        <div style={{ minWidth: 0, flex: "1 1 460px" }}>
          <div
            style={{
              fontSize: "0.76rem",
              fontWeight: 900,
              letterSpacing: "0.08em",
              color: "#315c9b",
              marginBottom: "6px",
            }}
          >
            8TH GRADE · TECNOLOGÍA Y PROGRAMACIÓN
          </div>

          <h2
            style={{
              margin: "0 0 7px",
              fontSize: "1.45rem",
              lineHeight: 1.2,
              color: "#18213a",
            }}
          >
            Secuencia Didáctica 8th
          </h2>

          <p
            style={{
              margin: 0,
              color: "#5d687c",
              lineHeight: 1.55,
            }}
          >
            Consulta las secuencias de clase, proyectos finales,
            retroalimentación, calificaciones y archivos HTML de 8th.
          </p>
        </div>

        <Link
          href="/guides/grade-08/updated-class-sequences.html"
          style={{
            display: "inline-flex",
            minHeight: "44px",
            alignItems: "center",
            justifyContent: "center",
            textDecoration: "none",
            background: "#292451",
            color: "#ffffff",
            padding: "11px 16px",
            borderRadius: "12px",
            fontWeight: 900,
            whiteSpace: "nowrap",
          }}
        >
          Ver secuencia y proyectos →
        </Link>
      </div>
    </section>
  );
}
