/* ==========================================================================
   AUTO-SOLUTIONS - Main Application Logic Controller
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  console.log("🚀 AUTO-SOLUTIONS Dashboard Initializing...");

  // 1. Initialize Navigation Tabs
  initNavTabs();

  // 2. Initialize Project Chips Switcher
  initProjectChips();

  // 3. Initialize Actuator Controls
  initActuatorControls();

  // 4. Initialize STEM Calculator Binds
  initSTEMCalculatorUI();

  // 5. Load User Authentication
  window.auth.updateUI();

  // 6. Start Telemetry Engine on Default Project
  window.telemetry.switchProject('riego_inteligente');
  window.telemetry.startLiveSimulation();
});

/* Navigation Tabs Handler */
function initNavTabs() {
  const tabs = document.querySelectorAll('.nav-tab');
  const contents = document.querySelectorAll('.tab-content');

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      tabs.forEach(t => t.classList.remove('active'));
      contents.forEach(c => c.classList.remove('active'));

      tab.classList.add('active');
      const targetId = tab.getAttribute('data-tab');
      const targetContent = document.getElementById(targetId);
      if (targetContent) {
        targetContent.classList.add('active');
      }

      // Re-resize Chart.js if switching back to dashboard
      if (targetId === 'tab-dashboard' && window.telemetry.chart) {
        setTimeout(() => {
          window.telemetry.chart.resize();
        }, 100);
      }
    });
  });
}

/* Project Chips Handler */
function initProjectChips() {
  const chips = document.querySelectorAll('.project-chip');

  chips.forEach(chip => {
    chip.addEventListener('click', () => {
      chips.forEach(c => c.classList.remove('active'));
      chip.classList.add('active');

      const projectId = chip.getAttribute('data-project');
      window.telemetry.switchProject(projectId);

      // Update Wokwi embedded project frame or code links
      updateWokwiEmbedProject(projectId);
    });
  });
}

/* Update Wokwi Frame & Guide */
function updateWokwiEmbedProject(projectId) {
  const wokwiTitle = document.getElementById('wokwi-project-name');
  const wokwiDesc = document.getElementById('wokwi-project-desc');
  const iframe = document.getElementById('wokwi-iframe');

  const names = {
    riego_inteligente: "Riego Inteligente con Sensor Humedad + ESP32",
    seguridad_pir: "Sistema de Seguridad con Sensor PIR + Ultrasónico",
    clasificacion_residuos: "Clasificador Automatizado con Servo SG90",
    monitoreo_ambiental: "Estación de Monitoreo Ambiental DHT22",
    huerta_escolar: "Monitoreo Agrícola Sostenible Huerta Escolar"
  };

  const descs = {
    riego_inteligente: "Simulación de microcontrolador ESP32 con potenciómetro analógico (simulando sensor de humedad) y servomotor accionador de válvula de riego.",
    seguridad_pir: "Simulación de sensor de presencia PIR HC-SR501, sensor HC-SR04, Buzzer y LED estroboscópico de advertencia.",
    clasificacion_residuos: "Simulación de servomotor SG90 activado mediante sensor ultrasónico para desvío de materiales reciclables.",
    monitoreo_ambiental: "Simulación de sensor de temperatura y humedad DHT22 + pantalla LCD / i2C con ESP32.",
    huerta_escolar: "Simulación de monitoreo multifactorial con envío de datos mediante protocolo HTTP en Wokwi."
  };

  if (wokwiTitle) wokwiTitle.textContent = names[projectId] || "Simulación ESP32 Wokwi";
  if (wokwiDesc) wokwiDesc.textContent = descs[projectId] || "";
}

/* Actuator Controls Event Bindings */
function initActuatorControls() {
  const btnPumpToggle = document.getElementById('toggle-actuator-1');
  const servoSlider = document.getElementById('servo-angle-slider');
  const servoAngleDisplay = document.getElementById('servo-angle-val');

  if (btnPumpToggle) {
    btnPumpToggle.addEventListener('change', (e) => {
      const isChecked = e.target.checked;
      const stateVal = isChecked ? 'ON (ACTIVO)' : 'OFF (INACTIVO)';
      const p = window.telemetry.projectConfigs[window.telemetry.currentProject];
      
      if (p && p.metrics[3]) {
        p.metrics[3].state = stateVal;
        const elem = document.getElementById(`val-${p.metrics[3].id}`);
        if (elem) elem.textContent = stateVal;
      }
      showToast(`Actuador ${isChecked ? 'ACTIVADO ⚡' : 'DESACTIVADO 🛑'}`);
    });
  }

  if (servoSlider) {
    servoSlider.addEventListener('input', (e) => {
      const angle = e.target.value;
      if (servoAngleDisplay) servoAngleDisplay.textContent = `${angle}°`;
      
      // Calculate STEM Servo Microseconds
      const res = window.stemCalc.calculateServoAngle(angle);
      const pwmElem = document.getElementById('servo-pwm-calc');
      if (pwmElem) pwmElem.textContent = `${res.pwmMicroseconds} µs`;
    });
  }
}

/* STEM UI Calculator Form Bindings */
function initSTEMCalculatorUI() {
  // 1. ADC ESP32 Form
  const btnCalcADC = document.getElementById('btn-calc-adc');
  if (btnCalcADC) {
    btnCalcADC.addEventListener('click', () => {
      const val = document.getElementById('input-adc-raw').value;
      const res = window.stemCalc.calculateADC(val);
      document.getElementById('res-adc-volt').textContent = `${res.voltage} V`;
      document.getElementById('res-adc-pct').textContent = `${res.percentage} %`;
    });
  }

  // 2. Evapotranspiración Form
  const btnCalcET = document.getElementById('btn-calc-et0');
  if (btnCalcET) {
    btnCalcET.addEventListener('click', () => {
      const tmax = document.getElementById('input-tmax').value;
      const tmin = document.getElementById('input-tmin').value;
      const hum = document.getElementById('input-hum').value;
      const res = window.stemCalc.calculateEvapotranspiration(tmax, tmin, hum);
      document.getElementById('res-et0-val').textContent = `${res.et0} mm/día`;
      document.getElementById('res-water-demand').textContent = `${res.waterDemandLiters} L/m²`;
      document.getElementById('res-et-recom').textContent = res.recommendation;
    });
  }

  // 3. Calidad de Aire & Confort Form
  const btnCalcAir = document.getElementById('btn-calc-air');
  if (btnCalcAir) {
    btnCalcAir.addEventListener('click', () => {
      const temp = document.getElementById('input-air-temp').value;
      const hum = document.getElementById('input-air-hum').value;
      const ppm = document.getElementById('input-air-ppm').value;
      const res = window.stemCalc.calculateAirQualityAndComfort(temp, hum, ppm);
      document.getElementById('res-heat-index').textContent = `${res.heatIndex} °C`;
      document.getElementById('res-aqi-status').textContent = res.aqiCategory;
    });
  }
}

/* Notification Toast Helper */
function showToast(message) {
  const toast = document.createElement('div');
  toast.style.position = 'fixed';
  toast.style.bottom = '20px';
  toast.style.right = '20px';
  toast.style.backgroundColor = 'rgba(17, 24, 39, 0.95)';
  toast.style.border = '1px solid var(--accent-cyan)';
  toast.style.color = '#ffffff';
  toast.style.padding = '0.75rem 1.25rem';
  toast.style.borderRadius = '8px';
  toast.style.boxShadow = '0 10px 25px rgba(0,0,0,0.5)';
  toast.style.zIndex = '9999';
  toast.style.fontSize = '0.875rem';
  toast.style.fontWeight = '600';
  toast.style.transition = 'all 0.3s ease';

  toast.innerHTML = message;
  document.body.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(10px)';
    setTimeout(() => document.body.removeChild(toast), 300);
  }, 2500);
}
