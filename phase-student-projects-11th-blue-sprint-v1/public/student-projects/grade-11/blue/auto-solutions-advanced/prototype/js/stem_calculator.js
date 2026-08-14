/* ==========================================================================
   AUTO-SOLUTIONS - STEM Calculator & Cross-Disciplinary Analytics
   Integración: Matemáticas + Ciencias Naturales + Robótica ESP32
   ========================================================================== */

class STEMCalculator {
  constructor() {}

  // 1. MATEMÁTICAS: Conversión ADC ESP32 12-bits (0 - 4095 -> 0.0V - 3.3V)
  calculateADC(rawADC) {
    const adc = parseFloat(rawADC) || 0;
    const voltage = (adc / 4095.0) * 3.3;
    const percentage = (adc / 4095.0) * 100.0;
    return {
      voltage: voltage.toFixed(2),
      percentage: percentage.toFixed(1),
      resolutionBits: 12
    };
  }

  // 2. MATEMÁTICAS: Estadística Descriptiva (Media μ, Desviación Estándar σ)
  calculateStatistics(readingsArray) {
    if (!readingsArray || readingsArray.length === 0) return { mean: 0, stdDev: 0, min: 0, max: 0 };

    const n = readingsArray.length;
    const mean = readingsArray.reduce((a, b) => a + b, 0) / n;
    const variance = readingsArray.reduce((a, b) => a + Math.pow(b - mean, 2), 0) / n;
    const stdDev = Math.sqrt(variance);
    const min = Math.min(...readingsArray);
    const max = Math.max(...readingsArray);

    return {
      mean: mean.toFixed(2),
      stdDev: stdDev.toFixed(2),
      variance: variance.toFixed(2),
      min: min,
      max: max,
      count: n
    };
  }

  // 3. CIENCIAS NATURALES: Estimación de Evapotranspiración (Hargreaves/Penman)
  calculateEvapotranspiration(tMax, tMin, humidity) {
    const tmax = parseFloat(tMax) || 30;
    const tmin = parseFloat(tMin) || 18;
    const rh = parseFloat(humidity) || 60;

    const tMean = (tmax + tmin) / 2.0;
    const ra = 15.2; // Radiación solar en la parte superior (MJ/m²/día promedio)
    const et0 = 0.0023 * (tMean + 17.8) * Math.sqrt(tmax - tmin) * ra;
    const adjustedET0 = et0 * (1 - (rh / 200.0)); // Ajuste por humedad relativa

    // Necesidad de agua en Litros/m² por día
    const lPerM2 = adjustedET0 * 1.0;

    return {
      et0: adjustedET0.toFixed(2), // mm/día
      waterDemandLiters: lPerM2.toFixed(2), // Litros / m²
      recommendation: adjustedET0 > 5.0 ? "Riego Alto Requerido 💧" : "Riego Moderado / Suficiente 🌿"
    };
  }

  // 4. CIENCIAS NATURALES: Cálculo del Índice de Calidad del Aire (AQI) y Confort Térmico
  calculateAirQualityAndComfort(temp, hum, rawSensorPPM) {
    const t = parseFloat(temp) || 24;
    const h = parseFloat(hum) || 50;
    const ppm = parseFloat(rawSensorPPM) || 400;

    // Heat Index (Índice de Calor / Sensación Térmica)
    const heatIndex = t + 0.5555 * (6.11 * Math.exp(5417.7530 * (1/273.16 - 1/(273.15 + t))) * (h/100) - 10);

    // Criterio de Calidad de Aire según CO2/PPM
    let aqiCategory = "Excelente 🍃";
    let aqiClass = "status-ok";

    if (ppm > 1000 && ppm <= 1500) {
      aqiCategory = "Aceptable / Ventilar ⚠️";
      aqiClass = "status-warn";
    } else if (ppm > 1500) {
      aqiCategory = "Pobre / Alerta Vaciado 🚨";
      aqiClass = "status-alert";
    }

    return {
      heatIndex: heatIndex.toFixed(1),
      aqiCategory: aqiCategory,
      aqiClass: aqiClass
    };
  }

  // 5. ROBÓTICA & GEOMETRÍA: Ángulo del Servomotor SG90 según distancia ultrasónica HC-SR04
  calculateServoAngle(distanceCm) {
    const d = Math.min(Math.max(parseFloat(distanceCm) || 0, 5), 200); // 5cm - 200cm
    // Mapeo lineal: 5cm -> 180° (Completamente Cerrado/Activo), 200cm -> 0° (Abierto)
    const angle = 180 - ((d - 5) / (200 - 5)) * 180;
    const pwmUs = 500 + (angle / 180.0) * 2000; // Ancho de pulso PWM microsegundos (500us - 2500us)

    return {
      angleDegrees: Math.round(angle),
      pwmMicroseconds: Math.round(pwmUs)
    };
  }
}

// Global Export
window.stemCalc = new STEMCalculator();
