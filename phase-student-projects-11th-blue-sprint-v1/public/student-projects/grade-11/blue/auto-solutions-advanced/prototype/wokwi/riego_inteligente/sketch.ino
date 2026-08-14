/*
  ==========================================================================
  AUTO-SOLUTIONS - PROYECTO 1: RIEGO INTELIGENTE (ESP32 + Wokwi)
  Integración ODS 6 (Agua Limpia) y ODS 13 (Acción por el Clima)
  ==========================================================================
*/

#include <WiFi.h>
#include <ESP32Servo.h>

// Configuración de Pines
const int PIN_POT_HUMEDAD = 34; // Entrada analógica ADC1_CH6 (Simula sensor de humedad)
const int PIN_SERVO_VALVULA = 18; // Salida PWM para Servomotor SG90
const int PIN_LED_ESTADO = 2;     // LED incorporado de estado

// Objetos y variables globales
Servo servoValvula;
const char* ssid = "Wokwi-GUEST";
const char* password = "";

void setup() {
  Serial.begin(115200);
  pinMode(PIN_LED_ESTADO, OUTPUT);
  
  // Inicializar servomotor
  servoValvula.attach(PIN_SERVO_VALVULA, 500, 2400);
  servoValvula.write(0); // Válvula inicialmente cerrada (0°)

  // Conexión WiFi Simulada Wokwi
  Serial.println("🌐 Iniciando conexión WiFi ESP32...");
  WiFi.begin(ssid, password);
  
  int intentos = 0;
  while (WiFi.status() != WL_CONNECTED && intentos < 10) {
    delay(500);
    Serial.print(".");
    intentos++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n✅ WiFi Conectado Exitosamente!");
    Serial.print("IP ESP32: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("\n⚠️ Modos Simulación Offline Activado.");
  }
}

void loop() {
  // 1. Lectura de ADC 12-bits (0 - 4095)
  int lecturaRaw = analogRead(PIN_POT_HUMEDAD);
  
  // 2. Conversión Matemática STEM: Porcentaje de Humedad (0% a 100%)
  float porcentajeHumedad = (lecturaRaw / 4095.0) * 100.0;
  float voltaje = (lecturaRaw / 4095.0) * 3.3;

  // 3. Imprimir Telemetría JSON por Serial
  Serial.print("{\"proyecto\":\"riego\",\"raw\":");
  Serial.print(lecturaRaw);
  Serial.print(",\"humedad_pct\":");
  Serial.print(porcentajeHumedad, 1);
  Serial.print(",\"voltaje\":");
  Serial.print(voltaje, 2);

  // 4. Lógica de Control Automatizado de Riego
  if (porcentajeHumedad < 40.0) {
    // Humedad baja -> Abrir Válvula de Riego (180°)
    servoValvula.write(180);
    digitalWrite(PIN_LED_ESTADO, HIGH);
    Serial.println(",\"bomba\":\"ON\",\"valvula_deg\":180}");
  } else {
    // Humedad adecuada -> Cerrar Válvula (0°)
    servoValvula.write(0);
    digitalWrite(PIN_LED_ESTADO, LOW);
    Serial.println(",\"bomba\":\"OFF\",\"valvula_deg\":0}");
  }

  delay(2000);
}
