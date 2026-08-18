import type { LiveQuestion } from "../types/liveGame";

export const grade9Questions: LiveQuestion[] = [
  {
    "id": "g9-mvc-01",
    "grade": 9,
    "topic": "MVC",
    "prompt": "What does MVC stand for?",
    "promptEs": "¿Qué significa MVC?",
    "choices": [
      "Model View Controller",
      "Main Variable Code",
      "Model Version Chart",
      "Multiple View Class"
    ],
    "choicesEs": [
      "Model View Controller",
      "Main Variable Code",
      "Model Version Chart",
      "Multiple View Class"
    ],
    "correctIndex": 0,
    "explanation": "MVC separates data/logic, interface and interaction control.",
    "explanationEs": "MVC separa datos/lógica, interfaz y control de interacción.",
    "seconds": 20
  },
  {
    "id": "g9-model-01",
    "grade": 9,
    "topic": "Model",
    "prompt": "In a To-Do app, where should task data primarily live?",
    "promptEs": "En una To-Do app, ¿dónde deberían vivir principalmente los datos de tareas?",
    "choices": [
      "Model",
      "View",
      "CSS",
      "HTML title"
    ],
    "choicesEs": [
      "Model",
      "View",
      "CSS",
      "Título HTML"
    ],
    "correctIndex": 0,
    "explanation": "The Model manages application data and business rules.",
    "explanationEs": "El Model gestiona datos y reglas del sistema.",
    "seconds": 20
  },
  {
    "id": "g9-view-01",
    "grade": 9,
    "topic": "View",
    "prompt": "Which MVC layer renders the task list to the user?",
    "promptEs": "¿Qué capa MVC muestra la lista de tareas al usuario?",
    "choices": [
      "View",
      "Model",
      "Database only",
      "Sensor"
    ],
    "choicesEs": [
      "View",
      "Model",
      "Solo base de datos",
      "Sensor"
    ],
    "correctIndex": 0,
    "explanation": "The View is responsible for what users see.",
    "explanationEs": "La View es responsable de lo que ve el usuario.",
    "seconds": 20
  },
  {
    "id": "g9-controller-01",
    "grade": 9,
    "topic": "Controller",
    "prompt": "The user clicks 'Add Task'. Which layer handles that event?",
    "promptEs": "El usuario hace clic en 'Add Task'. ¿Qué capa maneja ese evento?",
    "choices": [
      "Controller",
      "Model only",
      "CSS",
      "Category"
    ],
    "choicesEs": [
      "Controller",
      "Solo Model",
      "CSS",
      "Category"
    ],
    "correctIndex": 0,
    "explanation": "The Controller receives user actions and coordinates Model and View.",
    "explanationEs": "El Controller recibe acciones y coordina Model y View.",
    "seconds": 20
  },
  {
    "id": "g9-entity-01",
    "grade": 9,
    "topic": "Data Model",
    "prompt": "Which three entities are central to the Cycle 4 To-Do project?",
    "promptEs": "¿Qué tres entidades son centrales en el proyecto To-Do del Ciclo 4?",
    "choices": [
      "User, Task, Category",
      "Sensor, LED, Buzzer",
      "Chart, Pivot, Slicer",
      "ESP32, WiFi, PIR"
    ],
    "choicesEs": [
      "Usuario, Tarea, Categoría",
      "Sensor, LED, Buzzer",
      "Gráfico, Tabla dinámica, Segmentador",
      "ESP32, WiFi, PIR"
    ],
    "correctIndex": 0,
    "explanation": "The project is structured around User, Task and Category.",
    "explanationEs": "El proyecto se estructura alrededor de Usuario, Tarea y Categoría.",
    "seconds": 20
  },
  {
    "id": "g9-crud-01",
    "grade": 9,
    "topic": "CRUD",
    "prompt": "Which action changes an existing task?",
    "promptEs": "¿Qué acción modifica una tarea existente?",
    "choices": [
      "Edit / Update",
      "Create only",
      "Read only",
      "Filter only"
    ],
    "choicesEs": [
      "Editar / Actualizar",
      "Solo Crear",
      "Solo Leer",
      "Solo Filtrar"
    ],
    "correctIndex": 0,
    "explanation": "Updating modifies data that already exists.",
    "explanationEs": "Actualizar modifica datos existentes.",
    "seconds": 20
  },
  {
    "id": "g9-validation-01",
    "grade": 9,
    "topic": "Validation",
    "prompt": "Why validate a task title before saving?",
    "promptEs": "¿Por qué validar el título antes de guardar una tarea?",
    "choices": [
      "Prevent invalid empty records",
      "Make CSS faster",
      "Create a sensor",
      "Change WiFi"
    ],
    "choicesEs": [
      "Evitar registros vacíos inválidos",
      "Hacer CSS más rápido",
      "Crear un sensor",
      "Cambiar WiFi"
    ],
    "correctIndex": 0,
    "explanation": "Validation protects data quality and user experience.",
    "explanationEs": "La validación protege la calidad de datos y la experiencia.",
    "seconds": 20
  },
  {
    "id": "g9-storage-01",
    "grade": 9,
    "topic": "Persistence",
    "prompt": "What does localStorage help a web app do?",
    "promptEs": "¿Qué permite hacer localStorage en una aplicación web?",
    "choices": [
      "Keep data after a page refresh",
      "Create hardware",
      "Compile Java",
      "Draw charts automatically"
    ],
    "choicesEs": [
      "Conservar datos después de recargar",
      "Crear hardware",
      "Compilar Java",
      "Dibujar gráficos automáticamente"
    ],
    "correctIndex": 0,
    "explanation": "localStorage can persist browser data between page loads.",
    "explanationEs": "localStorage puede conservar datos entre cargas de página.",
    "seconds": 20
  },
  {
    "id": "g9-debug-01",
    "grade": 9,
    "topic": "Debugging",
    "prompt": "The button works but the task list does not refresh. Which connection should you inspect?",
    "promptEs": "El botón funciona pero la lista no se actualiza. ¿Qué conexión debes revisar?",
    "choices": [
      "Controller → Model → View flow",
      "Only CSS colors",
      "Only HTML title",
      "Only browser zoom"
    ],
    "choicesEs": [
      "Flujo Controller → Model → View",
      "Solo colores CSS",
      "Solo título HTML",
      "Solo zoom"
    ],
    "correctIndex": 0,
    "explanation": "MVC problems often come from broken coordination between layers.",
    "explanationEs": "Los problemas MVC suelen venir de coordinación rota entre capas.",
    "seconds": 20
  },
  {
    "id": "g9-refactor-01",
    "grade": 9,
    "topic": "Refactoring",
    "prompt": "What is refactoring?",
    "promptEs": "¿Qué es refactorizar?",
    "choices": [
      "Improving code structure without changing intended behavior",
      "Deleting the project",
      "Adding random features",
      "Changing only colors"
    ],
    "choicesEs": [
      "Mejorar la estructura sin cambiar el comportamiento esperado",
      "Eliminar el proyecto",
      "Agregar funciones al azar",
      "Cambiar solo colores"
    ],
    "correctIndex": 0,
    "explanation": "Refactoring improves maintainability while preserving behavior.",
    "explanationEs": "Refactorizar mejora mantenibilidad conservando comportamiento.",
    "seconds": 20
  },
  {
    "id": "g9-test-01",
    "grade": 9,
    "topic": "Testing",
    "prompt": "Which is a good test case?",
    "promptEs": "¿Cuál es un buen caso de prueba?",
    "choices": [
      "Try to create a task with an empty title",
      "Look only at the homepage",
      "Change font size",
      "Rename the folder"
    ],
    "choicesEs": [
      "Intentar crear una tarea con título vacío",
      "Mirar solo la portada",
      "Cambiar tamaño de fuente",
      "Renombrar carpeta"
    ],
    "correctIndex": 0,
    "explanation": "Testing edge cases checks whether validation works.",
    "explanationEs": "Probar casos límite verifica si funciona la validación.",
    "seconds": 20
  },
  {
    "id": "g9-ods-01",
    "grade": 9,
    "topic": "ODS",
    "prompt": "Why connect a To-Do system to a real school/community problem?",
    "promptEs": "¿Por qué conectar una To-Do con un problema real?",
    "choices": [
      "Technology should solve meaningful needs",
      "MVC requires an ODS to compile",
      "CSS needs it",
      "Browsers block apps without it"
    ],
    "choicesEs": [
      "La tecnología debe resolver necesidades significativas",
      "MVC lo requiere para compilar",
      "CSS lo necesita",
      "El navegador lo exige"
    ],
    "correctIndex": 0,
    "explanation": "STEM projects gain meaning when technology addresses authentic problems.",
    "explanationEs": "Los proyectos STEM cobran sentido al resolver problemas auténticos.",
    "seconds": 20
  }
];
