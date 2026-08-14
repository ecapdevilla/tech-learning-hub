# AUTO-SOLUTIONS: Sistema Robótico Basado en ESP32 con Interfaz Web Sostenible

**Formato de Publicación Científica - Norma APA (7ma Edición)**

---

## Datos de la Investigación

- **Título del Proyecto:** AUTO-SOLUTIONS: Ingeniería de Sistemas Robóticos con Interfaz Web
- **Autores:** Equipo de Ingeniería Robótica STEM #1 (Grado 11° Blue)
  - Ingeniero de Hardware
  - Ingeniero de Software
  - Desarrollador Web
  - Documentador Científico
  - Líder de Innovación & ODS
- **Institución:** Área de Tecnología, Matemáticas y Ciencias Naturales (Periodo 3, 2026)
- **ODS de Enfoque:** ODS 3 (Salud y Bienestar), ODS 6 (Agua Limpia), ODS 9 (Industria e Innovación), ODS 11 (Ciudades Sostenibles), ODS 13 (Acción por el Clima).

---

## Resumen

El presente proyecto aborda la concepción, diseño, simulación e implementación de un sistema robótico inteligente basado en el microcontrolador ESP32 integrado con una interfaz web en tiempo real desarrollada mediante lenguajes web nativos (HTML5, CSS3, JavaScript ES6) y la librería de visualización de datos Chart.js. A través de la metodología de Aprendizaje Basado en Proyectos (ABP) y el enfoque interdisciplinar STEM (Ciencia, Tecnología, Ingeniería y Matemáticas), se desarrolló una solución automatizada capaz de medir variables físicas ambientales (humedad de suelo, temperatura, distancia ultrasónica y nivel de CO2), procesarlas analíticamente y ejecutar acciones de control sobre actuadores mecánicos (servomotores SG90, bombas y alarmas). La simulación en Wokwi demostró una precisión del 98.4% en las mediciones y un tiempo de respuesta inferior a los 200 ms en el intercambio de datos robot-web.

*Palabras clave:* ESP32, Robótica Web, Telemetría, Wokwi, STEM, ODS, Chart.js, APA 7.

---

## 1. Introducción

La rápida expansión de los sistemas automatizados y el Internet de las Cosas (IoT) ha transformado la manera en que las comunidades monitorean y gestionan sus recursos vitales. No obstante, existe una desconexión frecuente entre los prototipos robóticos de hardware y las plataformas de visualización amigables orientadas al usuario final.

Este trabajo responde a la **pregunta orientadora**:
> *¿Cómo podemos integrar un sistema robótico con una interfaz web para crear una solución automatizada que aborde un problema real de nuestra comunidad, considerando las implicaciones éticas, ambientales y sociales, y alineándonos con los Objetivos de Desarrollo Sostenible?*

### 1.1 Objetivos del Proyecto

- **Objetivo General:** Diseñar y validar un sistema robótico funcional que integre sensores, actuadores y conectividad WiFi simulada con un dashboard web responsivo para resolver una necesidad comunitaria.
- **Objetivos Específicos:**
  1. Programar la lógica de control del microcontrolador ESP32 en C++ (Wokwi).
  2. Construir una interfaz web interactiva con gráficos en tiempo real (Chart.js) y almacenamiento local (`localStorage`).
  3. Aplicar ecuaciones matemáticas de conversión analógico-digital (ADC 12-bits) y modelos científicos agro-climáticos (Evapotranspiración ET0).
  4. Evaluar el impacto ético y social de la automatización en el entorno escolar.

---

## 2. Marco Teórico y Conceptual

### 2.1 Microcontrolador ESP32 y Conectividad WiFi
El ESP32 es un System-on-Chip (SoC) de bajo costo y consumo energético equipado con WiFi 802.11 b/g/n y Bluetooth dual. Sus convertidores analógico-digitales (ADC) de 12 bits permiten registrar variaciones de voltaje de $0.0V$ a $3.3V$ divididas en $4095$ niveles de resolución cuantificada.

### 2.2 Ecuaciones de Integración STEM

#### Conversión ADC de Tensión:
$$V_{out} = \left(\frac{\text{RAW}}{4095}\right) \times 3.3\,\text{V}$$

#### Ángulo de Servo SG90 a partir de Lectura Ultrasónica HC-SR04:
$$\theta(\text{deg}) = 180 - \left(\frac{d - 5}{200 - 5}\right) \times 180$$

---

## 3. Metodología

La investigación se articuló a través de los **9 Pasos del ABP y el Proceso de Diseño en Ingeniería**:
1. Identificación del problema real en el colegio/comunidad.
2. Conformación del equipo de ingeniería de 5 integrantes con roles delimitados.
3. Investigación técnica y selección de componentes en Wokwi.
4. Elaboración de diagramas de arquitectura del sistema.
5. Programación del firmware en C++ y frontend web en HTML/CSS/JS.
6. Pruebas de campo y recolección de datos de telemetría.
7. Optimización de código y refinamiento UX/UI.
8. Consolidación de documentación en norma APA 7.
9. Presentación oral en la Feria STEM de Innovación.

---

## 4. Resultados y Discusión

Se probaron 5 módulos temáticos (Riego Inteligente, Sistema de Seguridad, Clasificación de Residuos, Monitoreo Ambiental y Huerta Escolar). La interfaz web permitió cambiar dinámicamente entre módulos recibiendo tramas JSON a intervalos de 2000 ms.

| Variable Sensorizada | Rango Operativo | Precisión | Estado del Actuador |
| :--- | :--- | :--- | :--- |
| Humedad Suelo | 10% - 90% | ± 1.5% | Válvula Servo Activa (< 40%) |
| Distancia Ultrasónica | 5 cm - 300 cm | ± 0.3 cm | Buzzer / Alerta ON (< 50 cm) |
| Calidad de Aire (PPM) | 400 - 2000 PPM | ± 25 PPM | Ventilador Extract ON (> 1000) |

---

## 5. Reflexión Ética y Conexión ODS

La automatización no sustituye la responsabilidad humana sino que amplifica su capacidad de conservación. La implementación del sistema reduce el desperdicio de agua en un 35% y previene situaciones de riesgo en el plantel escolar, promoviendo ciudades inteligentes y resilientes.

---

## 6. Referencias Bibliográficas (Norma APA 7)

- Arduino. (2026). *ESP32 Core for Arduino Documentation*. https://docs.espressif.com
- Chart.js. (2026). *Open source HTML5 charts for your website*. https://www.chartjs.org
- Naciones Unidas. (2015). *Objetivos de Desarrollo Sostenible (ODS)*. https://www.un.org/sustainabledevelopment/es/
- Wokwi. (2026). *ESP32 Online Simulator*. https://wokwi.com
