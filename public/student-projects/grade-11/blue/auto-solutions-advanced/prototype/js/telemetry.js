/* ==========================================================================
   AUTO-SOLUTIONS - Telemetry Engine & Chart.js Controller
   Telemetría en tiempo real, simulación de sensores y persistencia
   ========================================================================== */

class TelemetryEngine {
  constructor() {
    this.chart = null;
    this.currentProject = 'riego_inteligente';
    this.isLiveSimulating = true;
    this.simulationInterval = null;
    this.dataLogs = [];
    
    // Project configurations & baseline metrics
    this.projectConfigs = {
      riego_inteligente: {
        title: "Riego Inteligente y Eficiencia Hídrica",
        sdg: "ODS 6 (Agua Limpia) / ODS 13 (Clima)",
        sdgClass: "bg-sdg-6",
        metrics: [
          { id: 'm1', label: 'Humedad Suelo', unit: '%', icon: '💧', min: 10, max: 90, normMin: 45, normMax: 75 },
          { id: 'm2', label: 'Temperatura Riego', unit: '°C', icon: '🌡️', min: 15, max: 38, normMin: 18, normMax: 28 },
          { id: 'm3', label: 'Nivel Tanque Agua', unit: 'L', icon: '🛢️', min: 0, max: 100, normMin: 30, normMax: 95 },
          { id: 'm4', label: 'Estado Bomba', unit: '', icon: '⚡', isActuator: true, state: 'OFF' }
        ],
        chartLabels: ['Humedad Suelo (%)', 'Nivel Tanque (L)'],
        colors: ['#06b6d4', '#3b82f6']
      },
      seguridad_pir: {
        title: "Sistema de Seguridad Escolar con Detección PIR",
        sdg: "ODS 11 (Ciudades y Comunidades Sostenibles)",
        sdgClass: "bg-sdg-11",
        metrics: [
          { id: 'm1', label: 'Distancia Ultrasónica', unit: 'cm', icon: '📏', min: 5, max: 300, normMin: 50, normMax: 250 },
          { id: 'm2', label: 'Sensor Movimiento PIR', unit: '', icon: '👁️', isBinary: true, state: 'INACTIVO' },
          { id: 'm3', label: 'Intensidad Alarma', unit: 'dB', icon: '🔊', min: 0, max: 95, normMin: 0, normMax: 60 },
          { id: 'm4', label: 'Luz Estroboscópica', unit: '', icon: '🚨', isActuator: true, state: 'OFF' }
        ],
        chartLabels: ['Distancia Ultrasónica (cm)', 'Nivel Ruido Alarma (dB)'],
        colors: ['#f59e0b', '#f43f5e']
      },
      clasificacion_residuos: {
        title: "Clasificación Automatizada de Residuos",
        sdg: "ODS 9 (Industria e Innovación) / ODS 12",
        sdgClass: "bg-sdg-9",
        metrics: [
          { id: 'm1', label: 'Nivel Contenedor', unit: '%', icon: '🗑️', min: 0, max: 100, normMin: 0, normMax: 80 },
          { id: 'm2', label: 'Conteo de Objetos', unit: 'uds', icon: '🔢', isCounter: true, val: 42 },
          { id: 'm3', label: 'Ángulo Servo Separador', unit: '°', icon: '⚙️', min: 0, max: 180, normMin: 0, normMax: 180 },
          { id: 'm4', label: 'Compactor Servo', unit: '', icon: '🦾', isActuator: true, state: 'STANDBY' }
        ],
        chartLabels: ['Capacidad Contenedor (%)', 'Flujo de Conteo (uds)'],
        colors: ['#10b981', '#8b5cf6']
      },
      monitoreo_ambiental: {
        title: "Monitoreo Ambiental y Calidad del Aire",
        sdg: "ODS 3 (Salud y Bienestar) / ODS 13 (Clima)",
        sdgClass: "bg-sdg-3",
        metrics: [
          { id: 'm1', label: 'Temperatura Aire', unit: '°C', icon: '🌡️', min: 16, max: 36, normMin: 18, normMax: 26 },
          { id: 'm2', label: 'Humedad Relativa', unit: '%', icon: '💦', min: 20, max: 95, normMin: 40, normMax: 70 },
          { id: 'm3', label: 'Índice Aire AQI', unit: 'PPM', icon: '🍃', min: 10, max: 300, normMin: 15, normMax: 75 },
          { id: 'm4', label: 'Ventilador Extract', unit: '', icon: '🌀', isActuator: true, state: 'OFF' }
        ],
        chartLabels: ['Temperatura (°C)', 'Humedad Relativa (%)', 'Calidad Aire (AQI PPM)'],
        colors: ['#f43f5e', '#06b6d4', '#10b981']
      },
      huerta_escolar: {
        title: "Huerta Escolar Sostenible en Tiempo Real",
        sdg: "ODS 2 (Hambre Cero) / ODS 15 (Vida Terrestre)",
        sdgClass: "bg-sdg-3",
        metrics: [
          { id: 'm1', label: 'Luz Radiación PAR', unit: 'Lux', icon: '☀️', min: 100, max: 5000, normMin: 800, normMax: 4000 },
          { id: 'm2', label: 'Humedad Suelo Cultivo', unit: '%', icon: '🌱', min: 20, max: 90, normMin: 50, normMax: 80 },
          { id: 'm3', label: 'Temperatura Ambiente', unit: '°C', icon: '🌡️', min: 14, max: 32, normMin: 18, normMax: 25 },
          { id: 'm4', label: 'Malla Sombra Servo', unit: '', icon: '🛡️', isActuator: true, state: 'ABIERTA' }
        ],
        chartLabels: ['Radiación Solar (Lux / 10)', 'Humedad Cultivo (%)'],
        colors: ['#f59e0b', '#10b981']
      }
    };
  }

  initChart() {
    const ctx = document.getElementById('telemetryChart');
    if (!ctx) return;

    if (this.chart) {
      this.chart.destroy();
    }

    const config = this.projectConfigs[this.currentProject];
    const initialLabels = Array.from({ length: 10 }, (_, i) => `${(9 - i) * 2}s atrás`);

    const datasets = config.chartLabels.map((label, idx) => ({
      label: label,
      data: Array.from({ length: 10 }, () => Math.floor(Math.random() * 40) + 30),
      borderColor: config.colors[idx % config.colors.length],
      backgroundColor: this.hexToRgba(config.colors[idx % config.colors.length], 0.15),
      borderWidth: 3,
      fill: true,
      tension: 0.35,
      pointRadius: 4,
      pointHoverRadius: 7
    }));

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: initialLabels,
        datasets: datasets
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            labels: { color: '#9ca3af', font: { family: 'Inter', size: 12, weight: '600' } }
          },
          tooltip: {
            mode: 'index',
            intersect: false,
            backgroundColor: '#111827',
            titleColor: '#06b6d4',
            bodyColor: '#f9fafb',
            borderColor: 'rgba(255,255,255,0.1)',
            borderWidth: 1
          }
        },
        scales: {
          x: {
            grid: { color: 'rgba(255, 255, 255, 0.05)' },
            ticks: { color: '#9ca3af' }
          },
          y: {
            grid: { color: 'rgba(255, 255, 255, 0.05)' },
            ticks: { color: '#9ca3af' }
          }
        }
      }
    });
  }

  hexToRgba(hex, alpha) {
    const r = parseInt(hex.slice(1, 3), 16);
    const g = parseInt(hex.slice(3, 5), 16);
    const b = parseInt(hex.slice(5, 7), 16);
    return `rgba(${r}, ${g}, ${b}, ${alpha})`;
  }

  switchProject(projectId) {
    if (!this.projectConfigs[projectId]) return;
    this.currentProject = projectId;
    
    // Update Header Text & Badges
    const p = this.projectConfigs[projectId];
    document.getElementById('project-title').textContent = p.title;
    document.getElementById('project-sdg-tag').textContent = p.sdg;

    // Render Metric Cards
    this.renderMetricCards();
    
    // Re-initialize Chart
    this.initChart();
  }

  renderMetricCards() {
    const container = document.getElementById('metrics-cards-container');
    if (!container) return;

    const p = this.projectConfigs[this.currentProject];
    container.innerHTML = '';

    p.metrics.forEach((m, idx) => {
      let valDisplay = '';
      let statusText = 'Normal';
      let statusClass = 'status-ok';

      if (m.isActuator) {
        valDisplay = `<span id="val-${m.id}">${m.state}</span>`;
        statusText = 'Actuador Controlado';
      } else if (m.isBinary) {
        valDisplay = `<span id="val-${m.id}">${m.state}</span>`;
        statusText = m.state === 'DETECTADO' ? 'ALERTA' : 'Supervisando';
        statusClass = m.state === 'DETECTADO' ? 'status-alert' : 'status-ok';
      } else if (m.isCounter) {
        valDisplay = `<span id="val-${m.id}">${m.val}</span> <span class="metric-unit">${m.unit}</span>`;
        statusText = 'Total Registrado';
      } else {
        const randVal = Math.floor(Math.random() * (m.max - m.min)) + m.min;
        valDisplay = `<span id="val-${m.id}">${randVal}</span> <span class="metric-unit">${m.unit}</span>`;
        if (randVal < m.normMin || randVal > m.normMax) {
          statusText = 'Fuera de Rango Opt. ';
          statusClass = 'status-warn';
        }
      }

      const card = document.createElement('div');
      card.className = 'glass-panel metric-card';
      card.innerHTML = `
        <div class="metric-header">
          <span class="metric-title">${m.label}</span>
          <div class="metric-icon">${m.icon}</div>
        </div>
        <div class="metric-value-wrapper">
          <div class="metric-value">${valDisplay}</div>
        </div>
        <div class="metric-status ${statusClass}">
          <span>●</span> ${statusText}
        </div>
      `;
      container.appendChild(card);
    });
  }

  startLiveSimulation() {
    if (this.simulationInterval) clearInterval(this.simulationInterval);

    this.simulationInterval = setInterval(() => {
      if (!this.isLiveSimulating || !this.chart) return;

      const p = this.projectConfigs[this.currentProject];
      const nowTime = new Date().toLocaleTimeString();

      // Generate simulated readings
      const newReadings = p.chartLabels.map((_, idx) => {
        const base = Math.sin(Date.now() / 3000 + idx) * 20 + 50;
        const noise = (Math.random() - 0.5) * 8;
        return Math.max(0, Math.round(base + noise));
      });

      // Push to Chart
      this.chart.data.labels.shift();
      this.chart.data.labels.push(nowTime);

      this.chart.data.datasets.forEach((ds, idx) => {
        ds.data.shift();
        ds.data.push(newReadings[idx]);
      });

      this.chart.update('none');

      // Update Metric Values
      p.metrics.forEach((m, idx) => {
        const valElem = document.getElementById(`val-${m.id}`);
        if (valElem && !m.isActuator) {
          if (!m.isBinary && !m.isCounter) {
            const currentVal = Math.round(newReadings[idx % newReadings.length]);
            valElem.textContent = currentVal;
          }
        }
      });

      // Log entry
      this.logTelemetryData(nowTime, newReadings);

    }, 2000);
  }

  logTelemetryData(timeStr, readings) {
    const entry = {
      timestamp: timeStr,
      project: this.currentProject,
      data: readings
    };
    this.dataLogs.push(entry);
    if (this.dataLogs.length > 50) this.dataLogs.shift();
    
    // Save to LocalStorage
    localStorage.setItem('auto_solutions_logs', JSON.stringify(this.dataLogs));
  }

  exportCSV() {
    if (this.dataLogs.length === 0) {
      alert("No hay registros de telemetría guardados aún.");
      return;
    }

    let csvContent = "data:text/csv;charset=utf-8,Hora,Proyecto,Lectura_1,Lectura_2\n";
    this.dataLogs.forEach(row => {
      csvContent += `${row.timestamp},${row.project},${row.data[0] || 0},${row.data[1] || 0}\n`;
    });

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `telemetria_${this.currentProject}_${Date.now()}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
}

// Global Export
window.telemetry = new TelemetryEngine();
