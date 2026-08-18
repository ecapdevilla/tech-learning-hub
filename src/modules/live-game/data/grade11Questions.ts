import type { LiveQuestion } from "../types/liveGame";

export const grade11Questions: LiveQuestion[] = [
  {
    "id": "g11-esp32-01",
    "grade": 11,
    "topic": "ESP32",
    "prompt": "What is the ESP32 in an IoT solution?",
    "promptEs": "¿Qué es el ESP32 en una solución IoT?",
    "choices": [
      "A microcontroller that processes inputs and controls outputs",
      "Only a chart",
      "A CSS framework",
      "A spreadsheet"
    ],
    "choicesEs": [
      "Un microcontrolador que procesa entradas y controla salidas",
      "Solo un gráfico",
      "Un framework CSS",
      "Una hoja de cálculo"
    ],
    "correctIndex": 0,
    "explanation": "The ESP32 can read sensors, execute logic and communicate over WiFi.",
    "explanationEs": "El ESP32 puede leer sensores, ejecutar lógica y comunicarse por WiFi.",
    "seconds": 20
  },
  {
    "id": "g11-iot-01",
    "grade": 11,
    "topic": "IoT",
    "prompt": "What makes a system IoT?",
    "promptEs": "¿Qué hace que un sistema sea IoT?",
    "choices": [
      "Connected devices exchange data over a network",
      "It has only an LED",
      "It uses HTML only",
      "It has no data"
    ],
    "choicesEs": [
      "Dispositivos conectados intercambian datos por una red",
      "Tiene solo un LED",
      "Usa solo HTML",
      "No tiene datos"
    ],
    "correctIndex": 0,
    "explanation": "IoT connects physical devices and data through networks.",
    "explanationEs": "IoT conecta dispositivos físicos y datos mediante redes.",
    "seconds": 20
  },
  {
    "id": "g11-sensor-01",
    "grade": 11,
    "topic": "Sensors",
    "prompt": "What is a sensor?",
    "promptEs": "¿Qué es un sensor?",
    "choices": [
      "A component that measures or detects a physical condition",
      "A web button",
      "A database table",
      "A CSS property"
    ],
    "choicesEs": [
      "Un componente que mide o detecta una condición física",
      "Un botón web",
      "Una tabla de BD",
      "Una propiedad CSS"
    ],
    "correctIndex": 0,
    "explanation": "Sensors convert physical phenomena into data the system can process.",
    "explanationEs": "Los sensores convierten fenómenos físicos en datos procesables.",
    "seconds": 20
  },
  {
    "id": "g11-actuator-01",
    "grade": 11,
    "topic": "Actuators",
    "prompt": "Which is an actuator?",
    "promptEs": "¿Cuál es un actuador?",
    "choices": [
      "Relay controlling a fan",
      "Temperature sensor",
      "PIR sensor",
      "Light sensor"
    ],
    "choicesEs": [
      "Relé que controla un ventilador",
      "Sensor de temperatura",
      "Sensor PIR",
      "Sensor de luz"
    ],
    "correctIndex": 0,
    "explanation": "Actuators produce physical actions based on control logic.",
    "explanationEs": "Los actuadores producen acciones físicas según la lógica.",
    "seconds": 20
  },
  {
    "id": "g11-wifi-01",
    "grade": 11,
    "topic": "WiFi",
    "prompt": "Why does the ESP32 use WiFi in the project?",
    "promptEs": "¿Por qué usa WiFi el ESP32 en el proyecto?",
    "choices": [
      "To send/receive data between device and web system",
      "To increase sensor size",
      "To replace code",
      "To draw CSS"
    ],
    "choicesEs": [
      "Para enviar/recibir datos entre dispositivo y sistema web",
      "Para aumentar el sensor",
      "Para reemplazar código",
      "Para dibujar CSS"
    ],
    "correctIndex": 0,
    "explanation": "WiFi connects the embedded system to other services or dashboards.",
    "explanationEs": "WiFi conecta el sistema embebido con servicios o dashboards.",
    "seconds": 20
  },
  {
    "id": "g11-dashboard-01",
    "grade": 11,
    "topic": "Web Dashboard",
    "prompt": "What should a dashboard show?",
    "promptEs": "¿Qué debería mostrar un dashboard?",
    "choices": [
      "Useful live/status data and controls",
      "Only decorative images",
      "Only source code",
      "Only passwords"
    ],
    "choicesEs": [
      "Datos/estado útiles y controles",
      "Solo imágenes decorativas",
      "Solo código fuente",
      "Solo contraseñas"
    ],
    "correctIndex": 0,
    "explanation": "A dashboard communicates system state and may allow interaction.",
    "explanationEs": "Un dashboard comunica el estado y puede permitir interacción.",
    "seconds": 20
  },
  {
    "id": "g11-rule-01",
    "grade": 11,
    "topic": "Automation Logic",
    "prompt": "IF temperature > 30 THEN fan ON. What is >30?",
    "promptEs": "SI temperatura > 30 ENTONCES ventilador ON. ¿Qué representa >30?",
    "choices": [
      "Decision threshold",
      "Sensor name",
      "HTML element",
      "WiFi password"
    ],
    "choicesEs": [
      "Umbral de decisión",
      "Nombre del sensor",
      "Elemento HTML",
      "Contraseña WiFi"
    ],
    "correctIndex": 0,
    "explanation": "The threshold determines when the actuator should respond.",
    "explanationEs": "El umbral determina cuándo debe responder el actuador.",
    "seconds": 20
  },
  {
    "id": "g11-wokwi-01",
    "grade": 11,
    "topic": "Simulation",
    "prompt": "Why simulate an ESP32 system before hardware?",
    "promptEs": "¿Por qué simular un sistema ESP32 antes del hardware?",
    "choices": [
      "Validate logic and wiring concept with lower risk",
      "Guarantee perfect hardware",
      "Avoid all testing",
      "Remove documentation"
    ],
    "choicesEs": [
      "Validar lógica y concepto de conexión con menor riesgo",
      "Garantizar hardware perfecto",
      "Evitar pruebas",
      "Eliminar documentación"
    ],
    "correctIndex": 0,
    "explanation": "Simulation reduces risk and helps expose design errors early.",
    "explanationEs": "La simulación reduce riesgos y muestra errores temprano.",
    "seconds": 20
  },
  {
    "id": "g11-telemetry-01",
    "grade": 11,
    "topic": "Telemetry",
    "prompt": "What is telemetry?",
    "promptEs": "¿Qué es telemetría?",
    "choices": [
      "Remote measurement/data sent from a system",
      "A CSS animation",
      "A local image",
      "A password manager"
    ],
    "choicesEs": [
      "Medición/datos enviados remotamente por un sistema",
      "Animación CSS",
      "Imagen local",
      "Gestor de contraseñas"
    ],
    "correctIndex": 0,
    "explanation": "Telemetry lets remote systems observe device measurements and state.",
    "explanationEs": "La telemetría permite observar mediciones y estado de dispositivos.",
    "seconds": 20
  },
  {
    "id": "g11-test-01",
    "grade": 11,
    "topic": "Testing",
    "prompt": "Which is a strong IoT test?",
    "promptEs": "¿Cuál es una prueba fuerte de IoT?",
    "choices": [
      "Change sensor input and verify device + dashboard response",
      "Only refresh the page",
      "Only rename variables",
      "Only change color"
    ],
    "choicesEs": [
      "Cambiar entrada del sensor y verificar dispositivo + dashboard",
      "Solo recargar",
      "Solo renombrar variables",
      "Solo cambiar color"
    ],
    "correctIndex": 0,
    "explanation": "End-to-end tests verify the full sensor-to-dashboard chain.",
    "explanationEs": "Las pruebas extremo a extremo verifican toda la cadena sensor-dashboard.",
    "seconds": 20
  },
  {
    "id": "g11-arch-01",
    "grade": 11,
    "topic": "Architecture",
    "prompt": "Which architecture is most complete?",
    "promptEs": "¿Cuál arquitectura es más completa?",
    "choices": [
      "Sensor → ESP32 → WiFi/Data → Web Dashboard → Action",
      "HTML → CSS only",
      "Sensor → nothing",
      "Dashboard → no data"
    ],
    "choicesEs": [
      "Sensor → ESP32 → WiFi/Datos → Dashboard Web → Acción",
      "HTML → solo CSS",
      "Sensor → nada",
      "Dashboard → sin datos"
    ],
    "correctIndex": 0,
    "explanation": "A complete solution connects physical input, processing, communication and interface.",
    "explanationEs": "Una solución completa conecta entrada física, procesamiento, comunicación e interfaz.",
    "seconds": 20
  },
  {
    "id": "g11-doc-01",
    "grade": 11,
    "topic": "Engineering Evidence",
    "prompt": "What should every team be able to explain?",
    "promptEs": "¿Qué debería poder explicar cada integrante?",
    "choices": [
      "Problem, architecture, data flow, logic and tests",
      "Only project name",
      "Only colors",
      "Only one team role"
    ],
    "choicesEs": [
      "Problema, arquitectura, flujo de datos, lógica y pruebas",
      "Solo nombre",
      "Solo colores",
      "Solo un rol"
    ],
    "correctIndex": 0,
    "explanation": "Engineering understanding should be shared across the team.",
    "explanationEs": "La comprensión de ingeniería debe ser compartida por el equipo.",
    "seconds": 20
  }
];
