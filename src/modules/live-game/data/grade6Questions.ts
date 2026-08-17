import type { LiveQuestion } from "../types/liveGame";

export const grade6Questions: LiveQuestion[] = [
  {
    "id": "g6-sequence-01",
    "grade": 6,
    "topic": "Algorithms",
    "prompt": "Which sequence is an algorithm?",
    "promptEs": "¿Cuál secuencia representa un algoritmo?",
    "choices": [
      "Random actions with no order",
      "Ordered steps to solve a problem",
      "Only one variable",
      "A picture without instructions"
    ],
    "choicesEs": [
      "Acciones al azar sin orden",
      "Pasos ordenados para resolver un problema",
      "Solo una variable",
      "Una imagen sin instrucciones"
    ],
    "correctIndex": 1,
    "explanation": "An algorithm is an ordered sequence of instructions used to solve a problem.",
    "explanationEs": "Un algoritmo es una secuencia ordenada de instrucciones para resolver un problema.",
    "seconds": 20
  },
  {
    "id": "g6-variable-01",
    "grade": 6,
    "topic": "Variables",
    "prompt": "What is a variable used for?",
    "promptEs": "¿Para qué se usa una variable?",
    "choices": [
      "Store information that can change",
      "Repeat forever",
      "Draw only images",
      "Turn off the computer"
    ],
    "choicesEs": [
      "Guardar información que puede cambiar",
      "Repetir para siempre",
      "Dibujar únicamente imágenes",
      "Apagar el computador"
    ],
    "correctIndex": 0,
    "explanation": "Variables store values such as score, lives, names or counters.",
    "explanationEs": "Las variables almacenan valores como puntaje, vidas, nombres o contadores.",
    "seconds": 20
  },
  {
    "id": "g6-condition-01",
    "grade": 6,
    "topic": "Conditionals",
    "prompt": "IF score >= 10 THEN show 'Level Up'. What happens when score is 12?",
    "promptEs": "SI score >= 10 ENTONCES mostrar 'Level Up'. ¿Qué ocurre cuando score vale 12?",
    "choices": [
      "Nothing",
      "Level Up appears",
      "Score becomes zero",
      "The loop stops automatically"
    ],
    "choicesEs": [
      "Nada",
      "Aparece Level Up",
      "El puntaje se vuelve cero",
      "El ciclo se detiene automáticamente"
    ],
    "correctIndex": 1,
    "explanation": "12 satisfies the condition score >= 10.",
    "explanationEs": "12 cumple la condición score >= 10.",
    "seconds": 20
  },
  {
    "id": "g6-loop-01",
    "grade": 6,
    "topic": "Loops",
    "prompt": "REPEAT 4 TIMES → MOVE FORWARD. How many moves occur?",
    "promptEs": "REPETIR 4 VECES → AVANZAR. ¿Cuántos movimientos ocurren?",
    "choices": [
      "1",
      "2",
      "4",
      "8"
    ],
    "choicesEs": [
      "1",
      "2",
      "4",
      "8"
    ],
    "correctIndex": 2,
    "explanation": "The instruction is executed four times.",
    "explanationEs": "La instrucción se ejecuta cuatro veces.",
    "seconds": 15
  },
  {
    "id": "g6-debug-01",
    "grade": 6,
    "topic": "Debugging",
    "prompt": "A robot falls into a hole. What should the programmer do first?",
    "promptEs": "Un robot cae en un hueco. ¿Qué debería hacer primero el programador?",
    "choices": [
      "Delete everything",
      "Debug the sequence and find the failing step",
      "Add random commands",
      "Ignore the result"
    ],
    "choicesEs": [
      "Borrar todo",
      "Depurar la secuencia y encontrar el paso que falla",
      "Agregar comandos al azar",
      "Ignorar el resultado"
    ],
    "correctIndex": 1,
    "explanation": "Debugging means finding and correcting the cause of an incorrect result.",
    "explanationEs": "Depurar significa encontrar y corregir la causa de un resultado incorrecto.",
    "seconds": 20
  },
  {
    "id": "g6-array-01",
    "grade": 6,
    "topic": "Lists / Arrays",
    "prompt": "Which is the best reason to use a list or array?",
    "promptEs": "¿Cuál es la mejor razón para usar una lista o arreglo?",
    "choices": [
      "Store a collection of related items",
      "Replace every condition",
      "Make the screen brighter",
      "Connect to WiFi"
    ],
    "choicesEs": [
      "Guardar una colección de elementos relacionados",
      "Reemplazar todas las condiciones",
      "Hacer la pantalla más brillante",
      "Conectarse a WiFi"
    ],
    "correctIndex": 0,
    "explanation": "Lists and arrays organize collections such as enemies, questions or scores.",
    "explanationEs": "Las listas y arreglos organizan colecciones como enemigos, preguntas o puntajes.",
    "seconds": 20
  },
  {
    "id": "g6-input-01",
    "grade": 6,
    "topic": "Input / Output",
    "prompt": "The player presses the SPACE key to jump. SPACE is...",
    "promptEs": "El jugador presiona la tecla ESPACIO para saltar. ESPACIO es...",
    "choices": [
      "Input",
      "Output",
      "Loop",
      "Array"
    ],
    "choicesEs": [
      "Entrada",
      "Salida",
      "Ciclo",
      "Arreglo"
    ],
    "correctIndex": 0,
    "explanation": "A key press is information entering the program: an input.",
    "explanationEs": "Presionar una tecla es información que entra al programa: una entrada.",
    "seconds": 15
  },
  {
    "id": "g6-output-01",
    "grade": 6,
    "topic": "Input / Output",
    "prompt": "The screen shows 'YOU WIN!'. This is...",
    "promptEs": "La pantalla muestra 'YOU WIN!'. Esto es...",
    "choices": [
      "Input",
      "Output",
      "Condition",
      "Variable"
    ],
    "choicesEs": [
      "Entrada",
      "Salida",
      "Condición",
      "Variable"
    ],
    "correctIndex": 1,
    "explanation": "Information shown by the program is an output.",
    "explanationEs": "La información mostrada por el programa es una salida.",
    "seconds": 15
  },
  {
    "id": "g6-state-01",
    "grade": 6,
    "topic": "Game State",
    "prompt": "Which variable would best track how many chances a player has left?",
    "promptEs": "¿Qué variable serviría mejor para controlar cuántas oportunidades le quedan al jugador?",
    "choices": [
      "background",
      "lives",
      "title",
      "button"
    ],
    "choicesEs": [
      "background",
      "lives",
      "title",
      "button"
    ],
    "correctIndex": 1,
    "explanation": "A lives variable can decrease when the player makes a mistake.",
    "explanationEs": "Una variable lives puede disminuir cuando el jugador comete un error.",
    "seconds": 20
  },
  {
    "id": "g6-ods-01",
    "grade": 6,
    "topic": "Technology + ODS",
    "prompt": "A recycling game that teaches correct waste classification mainly supports...",
    "promptEs": "Un juego de reciclaje que enseña a clasificar correctamente los residuos apoya principalmente...",
    "choices": [
      "Responsible consumption",
      "Faster gaming computers",
      "More passwords",
      "Longer code files"
    ],
    "choicesEs": [
      "Consumo responsable",
      "Computadores para juegos más rápidos",
      "Más contraseñas",
      "Archivos de código más largos"
    ],
    "correctIndex": 0,
    "explanation": "Responsible consumption and production is directly related to correct waste management.",
    "explanationEs": "El consumo y producción responsables se relacionan directamente con el manejo adecuado de residuos.",
    "seconds": 20
  },
  {
    "id": "g6-logic-01",
    "grade": 6,
    "topic": "Logic",
    "prompt": "IF lives == 0 THEN gameOver = true. When does the game end?",
    "promptEs": "SI lives == 0 ENTONCES gameOver = true. ¿Cuándo termina el juego?",
    "choices": [
      "When score is 0",
      "When lives is 0",
      "Every 10 seconds",
      "When the player moves"
    ],
    "choicesEs": [
      "Cuando score es 0",
      "Cuando lives es 0",
      "Cada 10 segundos",
      "Cuando el jugador se mueve"
    ],
    "correctIndex": 1,
    "explanation": "The game-over condition depends on lives reaching zero.",
    "explanationEs": "La condición de fin del juego depende de que las vidas lleguen a cero.",
    "seconds": 20
  },
  {
    "id": "g6-loop-debug-01",
    "grade": 6,
    "topic": "Loops + Debugging",
    "prompt": "A loop never stops and freezes the game. This is most likely...",
    "promptEs": "Un ciclo nunca se detiene y congela el juego. Lo más probable es que sea...",
    "choices": [
      "A useful variable",
      "An infinite loop bug",
      "A correct array",
      "A user interface"
    ],
    "choicesEs": [
      "Una variable útil",
      "Un error de ciclo infinito",
      "Un arreglo correcto",
      "Una interfaz de usuario"
    ],
    "correctIndex": 1,
    "explanation": "A loop without a valid stop condition can become infinite.",
    "explanationEs": "Un ciclo sin una condición válida de salida puede volverse infinito.",
    "seconds": 20
  }
];
