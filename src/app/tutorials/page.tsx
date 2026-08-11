import Link from "next/link";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function TutorialsPage() {
  return (
    <SiteLayout>
      <section className="page-shell simple-page">
        <span className="section-kicker">Tutoriales</span>
        <h1>Jitsi Meet para docentes</h1>
        <p className="tutorial-intro">
          Una guía paso a paso para que el docente cree, comparta y dirija
          clases virtuales usando Jitsi Meet con confianza y claridad.
        </p>

        <div className="tutorial-summary-card">
          <div>
            <strong>Guía para el docente</strong>
            <p>
              Sigue el flujo ilustrado y los consejos pedagógicos. Cada paso está
              pensado para que sea fácil de aplicar en la clase real.
            </p>
          </div>
          <span className="tutorial-icon">👩‍🏫</span>
        </div>

        <div className="tutorial-grid">
          <article className="tutorial-step-card">
            <span className="tutorial-step-number">Paso 1</span>
            <h2>🌐 Abrir Jitsi Meet</h2>
            <p>
              Abra el navegador y vaya a <strong>meet.jit.si</strong>. Si ve el
              botón verde <strong>Comenzar</strong>, ya está lista para seguir.
            </p>
            <ul>
              <li>Use Chrome, Edge o Firefox para mejor compatibilidad.</li>
              <li>
                Si aparece un aviso, simplemente confirme que desea continuar.
              </li>
            </ul>
          </article>

          <article className="tutorial-step-card">
            <span className="tutorial-step-number">Paso 2</span>
            <h2>🔑 Crear la sala de clase</h2>
            <p>
              Escriba un nombre fácil de reconocer y haga clic en
              <strong> Comenzar</strong>.
            </p>
            <p className="tutorial-example">
              Ejemplo: <strong>Clase-Lenguaje-ProfeAna</strong>
            </p>
            <p className="tutorial-tip">
              Tip pedagógico: use el nombre de la materia y su nombre para que
              los estudiantes identifiquen la sala sin dudas.
            </p>
          </article>

          <article className="tutorial-step-card">
            <span className="tutorial-step-number">Paso 3</span>
            <h2>👤 Iniciar sesión una sola vez</h2>
            <p>
              Jitsi puede pedirle que se identifique. Seleccione su cuenta y
              continúe. No debe repetirlo cada clase.
            </p>
            <p className="tutorial-tip">
              Si ya inició sesión antes, la plataforma recordará su cuenta.
            </p>
          </article>

          <article className="tutorial-step-card">
            <span className="tutorial-step-number">Paso 4</span>
            <h2>📨 Compartir el enlace con los estudiantes</h2>
            <p>
              Copie la dirección completa de la sala y envíela por el canal de
              comunicación que usa con su grupo.
            </p>
            <p className="tutorial-example">
              Ejemplo: <strong>https://meet.jit.si/Clase-Lenguaje-ProfeAna</strong>
            </p>
            <p className="tutorial-tip">
              Los estudiantes no necesitan iniciar sesión. Solo deben ingresar su
              nombre y entrar.
            </p>
          </article>

          <article className="tutorial-step-card">
            <span className="tutorial-step-number">Paso 5</span>
            <h2>💬 Usar el chat y facilitar la clase</h2>
            <p>
              Durante la sesión, use el chat para enviar mensajes, enlaces y
              recordatorios rápidos.
            </p>
            <ul>
              <li>Haga clic en el ícono de chat 💬.</li>
              <li>Escriba su mensaje y presione Enter.</li>
              <li>
                Si algún estudiante tiene problemas, recomiende auriculares y
                recargar el navegador.
              </li>
            </ul>
          </article>
        </div>

        <div className="tutorial-footer-card">
          <div>
            <strong>¿Listo para enseñar?</strong>
            <p>
              Ahora puede abrir Jitsi Meet y crear su primera sala. Esta guía le
              ayuda a avanzar paso a paso con un enfoque claro y sencillo.
            </p>
          </div>
          <div className="tutorial-actions">
            <Link href="/" className="secondary-button">
              Volver al inicio
            </Link>
            <a
              href="https://meet.jit.si/"
              target="_blank"
              rel="noreferrer"
              className="primary-button"
            >
              Abrir Jitsi Meet
            </a>
          </div>
        </div>
      </section>
    </SiteLayout>
  );
}
