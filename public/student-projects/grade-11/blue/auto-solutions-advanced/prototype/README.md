# 🤖 AUTO-SOLUTIONS: Ingeniería de Sistemas Robóticos con Interfaz Web

> **Proyecto Integrado STEM - Tecnología 11° (Tercer Periodo 2026)**  
> *Integración: Tecnología 🔹 Matemáticas 🔹 Ciencias Naturales 🔹 Sostenibilidad ODS*

---

## 🌟 Descripción General

**AUTO-SOLUTIONS** es un ecosistema educativo completo que permite simular, monitorear y controlar sistemas robóticos automatizados basados en el microcontrolador **ESP32** utilizando el simulador **Wokwi** y un Dashboard Web de alta estética con diseño **Glassmorphism**, construido en **HTML5, Vanilla CSS3, JavaScript ES6+ y Chart.js**.

---

## 🎯 Los 5 Módulos de Proyecto Integrados

1. 💧 **Riego Inteligente y Eficiencia Hídrica** (ODS 6 & 13)
   - Microcontrolador ESP32 + Potenciómetro Analógico (Humedad) + Servomotor SG90 (Válvula).
2. 🔐 **Sistema de Seguridad Escolar con PIR** (ODS 11)
   - Sensor PIR HC-SR501 + Sensor Ultrasónico HC-SR04 + Buzzer + LED Alarma.
3. ♻️ **Clasificación Automatizada de Residuos** (ODS 9 & 12)
   - Conteo inteligente de material reciclable y servomotor desviador.
4. 🌡️ **Estación de Monitoreo Ambiental** (ODS 3 & 13)
   - Sensor de temperatura y humedad DHT22 + Calidad del aire + Extractor de ventilación.
5. 🌱 **Huerta Escolar Sostenible** (ODS 2 & 15)
   - Monitoreo multi-factor agrícola en tiempo real.

---

## 📁 Estructura del Repositorio

```text
11 blue/
├── index.html                   # Interfaz SPA Principal (Dashboard + STEM + APA + Rúbrica)
├── css/
│   └── styles.css               # Sistema de diseño Glassmorphism & Modo Oscuro Cyber
├── js/
│   ├── app.js                   # Controlador principal de navegación y eventos DOM
│   ├── telemetry.js             # Motor de telemetría, Chart.js y simulación en vivo
│   ├── stem_calculator.js       # Calculadoras de Matemáticas (ADC/Stats) y Ciencias (ET0/AQI)
│   └── auth.js                  # Gestión de roles y sesión de estudiante
├── wokwi/                       # Código ESP32 C++ y diagramas para simulación Wokwi
│   ├── riego_inteligente/       # Code sketch.ino + diagram.json
│   ├── seguridad_pir/           # Code sketch.ino + diagram.json
│   ├── monitoreo_ambiental/     # Code sketch.ino + diagram.json
│   └── ...
├── docs/                        # Documentación Entregable
│   ├── documentacion_apa.md     # Artículo de Investigación Científica en Norma APA 7
│   ├── bitacora_ingenieria.md   # Registro de los 9 pasos del proyecto y 5 roles
│   └── rubrica_evaluacion.md    # Criterios de evaluación (40 pts)
└── README.md                    # Guía general de uso y presentación
```

---

## 🛠️ Cómo Ejecutar el Proyecto Localmente

1. **Abrir la Interfaz Web:**
   - Abre el archivo `index.html` en cualquier navegador web moderno (Chrome, Edge, Firefox, Safari).
   - Alternativamente, ejecuta un servidor local con Node:
     ```bash
     npx http-server ./ -p 8080
     ```
   - Visita `http://localhost:8080` en tu navegador.

2. **Simular en Wokwi:**
   - Ingresa a [Wokwi.com](https://wokwi.com).
   - Crea un nuevo proyecto **ESP32 DevKit v1**.
   - Copia el contenido de `wokwi/riego_inteligente/sketch.ino` en la pestaña de código C++.
   - Copia el esquema de `wokwi/riego_inteligente/diagram.json` en la pestaña Diagram.
   - Haz clic en el botón verde **Play ▶**.

---

## 🏆 Criterios de Evaluación y Calificación

El proyecto cumple al **100% con los 10 criterios de la Rúbrica Oficial**:
- ✅ Funcionalidad del Sistema (Robot + Web)
- ✅ Uso Creativo de Sensores y Actuadores
- ✅ Conectividad WiFi / Telemetría
- ✅ Interfaz Web Responsiva Glassmorphism con Chart.js
- ✅ Gestión de Datos (LocalStorage & Exportación CSV)
- ✅ Documentación Formal APA 7
- ✅ Trabajo Colaborativo en Equipo (5 Roles)
- ✅ Reflexión Ética y Conexión con los ODS
- ✅ Presentación Oral y Feria STEM
- ✅ Impacto y Utilidad Comunitaria
