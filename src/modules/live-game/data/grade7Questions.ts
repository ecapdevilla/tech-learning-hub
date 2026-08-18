import type { LiveQuestion } from "../types/liveGame";

export const grade7Questions: LiveQuestion[] = [
  {
    "id": "g7-auto-01",
    "grade": 7,
    "topic": "Automation",
    "prompt": "What is an automated system?",
    "promptEs": "¿Qué es un sistema automatizado?",
    "choices": [
      "A system that reacts using programmed rules",
      "A device with no input",
      "Only a website",
      "A handwritten diagram"
    ],
    "choicesEs": [
      "Un sistema que responde usando reglas programadas",
      "Un dispositivo sin entrada",
      "Solo una página web",
      "Un diagrama escrito a mano"
    ],
    "correctIndex": 0,
    "explanation": "Automation combines inputs, processing/decisions and outputs.",
    "explanationEs": "La automatización combina entradas, procesamiento/decisiones y salidas.",
    "seconds": 20
  },
  {
    "id": "g7-sensor-01",
    "grade": 7,
    "topic": "Sensors",
    "prompt": "What is the role of a PIR sensor?",
    "promptEs": "¿Cuál es la función de un sensor PIR?",
    "choices": [
      "Detect motion",
      "Produce sound",
      "Store passwords",
      "Measure file size"
    ],
    "choicesEs": [
      "Detectar movimiento",
      "Producir sonido",
      "Guardar contraseñas",
      "Medir tamaño de archivos"
    ],
    "correctIndex": 0,
    "explanation": "A PIR sensor is commonly used to detect movement.",
    "explanationEs": "Un sensor PIR se usa comúnmente para detectar movimiento.",
    "seconds": 20
  },
  {
    "id": "g7-actuator-01",
    "grade": 7,
    "topic": "Actuators",
    "prompt": "Which component is an actuator?",
    "promptEs": "¿Cuál componente es un actuador?",
    "choices": [
      "LED",
      "PIR sensor",
      "Temperature sensor",
      "Light sensor"
    ],
    "choicesEs": [
      "LED",
      "Sensor PIR",
      "Sensor de temperatura",
      "Sensor de luz"
    ],
    "correctIndex": 0,
    "explanation": "An actuator performs an action or produces an output.",
    "explanationEs": "Un actuador ejecuta una acción o produce una salida.",
    "seconds": 20
  },
  {
    "id": "g7-logic-01",
    "grade": 7,
    "topic": "IF / THEN",
    "prompt": "IF motion is detected THEN turn LED on. What is the decision?",
    "promptEs": "SI se detecta movimiento ENTONCES encender LED. ¿Cuál es la decisión?",
    "choices": [
      "Check whether motion is detected",
      "The LED color",
      "The cable length",
      "The simulator name"
    ],
    "choicesEs": [
      "Comprobar si se detectó movimiento",
      "El color del LED",
      "La longitud del cable",
      "El nombre del simulador"
    ],
    "correctIndex": 0,
    "explanation": "The condition evaluates the sensor input before activating the output.",
    "explanationEs": "La condición evalúa la entrada del sensor antes de activar la salida.",
    "seconds": 20
  },
  {
    "id": "g7-wokwi-01",
    "grade": 7,
    "topic": "Simulation",
    "prompt": "Why use Wokwi or Tinkercad before physical construction?",
    "promptEs": "¿Por qué usar Wokwi o Tinkercad antes de construir físicamente?",
    "choices": [
      "To test ideas safely and find problems",
      "To avoid all documentation",
      "To replace logic",
      "To remove sensors"
    ],
    "choicesEs": [
      "Para probar ideas de forma segura y detectar problemas",
      "Para evitar toda documentación",
      "Para reemplazar la lógica",
      "Para eliminar sensores"
    ],
    "correctIndex": 0,
    "explanation": "Simulation helps test and improve a design before using hardware.",
    "explanationEs": "La simulación ayuda a probar y mejorar un diseño antes de usar hardware.",
    "seconds": 20
  },
  {
    "id": "g7-test-01",
    "grade": 7,
    "topic": "Testing",
    "prompt": "A security system does not light the LED when motion occurs. What should you do?",
    "promptEs": "Un sistema de seguridad no enciende el LED cuando hay movimiento. ¿Qué debes hacer?",
    "choices": [
      "Test sensor values and debug the logic",
      "Delete the entire project",
      "Change the project name",
      "Ignore it"
    ],
    "choicesEs": [
      "Probar los valores del sensor y depurar la lógica",
      "Borrar todo el proyecto",
      "Cambiar el nombre del proyecto",
      "Ignorarlo"
    ],
    "correctIndex": 0,
    "explanation": "Testing input, logic and output helps locate the failure.",
    "explanationEs": "Probar entrada, lógica y salida ayuda a localizar la falla.",
    "seconds": 20
  },
  {
    "id": "g7-system-01",
    "grade": 7,
    "topic": "System Flow",
    "prompt": "Which flow best describes automation?",
    "promptEs": "¿Qué flujo describe mejor la automatización?",
    "choices": [
      "Sensor → Decision → Actuator",
      "Actuator → Notebook → Sensor",
      "Image → Password → Folder",
      "LED → CSS → Keyboard"
    ],
    "choicesEs": [
      "Sensor → Decisión → Actuador",
      "Actuador → Cuaderno → Sensor",
      "Imagen → Contraseña → Carpeta",
      "LED → CSS → Teclado"
    ],
    "correctIndex": 0,
    "explanation": "Automated systems usually sense, decide and act.",
    "explanationEs": "Los sistemas automatizados normalmente detectan, deciden y actúan.",
    "seconds": 20
  },
  {
    "id": "g7-doc-01",
    "grade": 7,
    "topic": "Documentation",
    "prompt": "Which evidence best documents a simulation?",
    "promptEs": "¿Qué evidencia documenta mejor una simulación?",
    "choices": [
      "Diagram + logic + tests + improvement",
      "Only the title",
      "Only a screenshot",
      "Only the team names"
    ],
    "choicesEs": [
      "Diagrama + lógica + pruebas + mejora",
      "Solo el título",
      "Solo una captura",
      "Solo los nombres"
    ],
    "correctIndex": 0,
    "explanation": "Good engineering documentation explains how the system works and was tested.",
    "explanationEs": "Una buena documentación explica cómo funciona y cómo fue probado el sistema.",
    "seconds": 20
  },
  {
    "id": "g7-ods-01",
    "grade": 7,
    "topic": "ODS",
    "prompt": "A smart water-level alert can support which type of problem?",
    "promptEs": "Una alerta inteligente de nivel de agua puede apoyar qué tipo de problema?",
    "choices": [
      "Water management",
      "Password creation",
      "Video resolution",
      "Font selection"
    ],
    "choicesEs": [
      "Gestión del agua",
      "Creación de contraseñas",
      "Resolución de video",
      "Selección de fuente"
    ],
    "correctIndex": 0,
    "explanation": "Automation can help monitor and manage environmental resources.",
    "explanationEs": "La automatización puede ayudar a monitorear y gestionar recursos ambientales.",
    "seconds": 20
  },
  {
    "id": "g7-peer-01",
    "grade": 7,
    "topic": "Engineering Improvement",
    "prompt": "Why is peer review useful after simulation?",
    "promptEs": "¿Por qué es útil la revisión entre pares después de simular?",
    "choices": [
      "It can reveal improvements and missed problems",
      "It guarantees no bugs",
      "It replaces testing",
      "It removes the need to explain"
    ],
    "choicesEs": [
      "Puede revelar mejoras y problemas no detectados",
      "Garantiza que no haya errores",
      "Reemplaza las pruebas",
      "Elimina la necesidad de explicar"
    ],
    "correctIndex": 0,
    "explanation": "Peer feedback can expose issues the original team did not notice.",
    "explanationEs": "La retroalimentación puede revelar problemas que el equipo no notó.",
    "seconds": 20
  },
  {
    "id": "g7-input-01",
    "grade": 7,
    "topic": "Input",
    "prompt": "Which is an input in an automated temperature alert?",
    "promptEs": "¿Cuál es una entrada en una alerta automática de temperatura?",
    "choices": [
      "Temperature sensor reading",
      "Buzzer sound",
      "LED light",
      "Warning message"
    ],
    "choicesEs": [
      "Lectura del sensor de temperatura",
      "Sonido del buzzer",
      "Luz LED",
      "Mensaje de alerta"
    ],
    "correctIndex": 0,
    "explanation": "The sensor reading enters the system and is processed.",
    "explanationEs": "La lectura del sensor entra al sistema y se procesa.",
    "seconds": 20
  },
  {
    "id": "g7-output-01",
    "grade": 7,
    "topic": "Output",
    "prompt": "Which is an output of a security system?",
    "promptEs": "¿Cuál es una salida de un sistema de seguridad?",
    "choices": [
      "Buzzer alarm",
      "PIR motion value",
      "Temperature reading",
      "Button press"
    ],
    "choicesEs": [
      "Alarma del buzzer",
      "Valor de movimiento PIR",
      "Lectura de temperatura",
      "Pulsación de botón"
    ],
    "correctIndex": 0,
    "explanation": "An alarm is an action produced by the system.",
    "explanationEs": "Una alarma es una acción producida por el sistema.",
    "seconds": 20
  }
];
