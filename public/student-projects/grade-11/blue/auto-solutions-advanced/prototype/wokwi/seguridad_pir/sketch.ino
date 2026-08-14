/*
  ==========================================================================
  AUTO-SOLUTIONS - PROYECTO 2: SISTEMA DE SEGURIDAD CON PIR (ESP32 + Wokwi)
  Integración ODS 11 (Ciudades y Comunidades Sostenibles)
  ==========================================================================
*/

#include <WiFi.h>

const int PIN_PIR = 19;        // Sensor infrarrojo de movimiento PIR
const int PIN_TRIG = 5;        // HC-SR04 Trigger
const int PIN_ECHO = 18;       // HC-SR04 Echo
const int PIN_BUZZER = 21;     // Zumbador piezoeléctrico
const int PIN_LED_ALARMA = 4;  // LED Alarma estroboscópica

void setup() {
  Serial.begin(115200);
  pinMode(PIN_PIR, INPUT);
  pinMode(PIN_TRIG, OUTPUT);
  pinMode(PIN_ECHO, INPUT);
  pinMode(PIN_BUZZER, OUTPUT);
  pinMode(PIN_LED_ALARMA, OUTPUT);

  Serial.println("🔐 Sistema de Seguridad Escolar Iniciado.");
}

void loop() {
  // 1. Lectura Sensor PIR
  int movimiento = digitalRead(PIN_PIR);

  // 2. Lectura Sensor Ultrasónico HC-SR04
  digitalWrite(PIN_TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(PIN_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG, LOW);

  long duracion = pulseIn(PIN_ECHO, HIGH);
  float distanciaCm = duracion * 0.0343 / 2.0; // Matemática STEM: Velocidad del sonido (343 m/s)

  // 3. Imprimir Telemetría JSON
  Serial.print("{\"proyecto\":\"seguridad\",\"movimiento\":");
  Serial.print(movimiento ? "\"DETECTADO\"" : "\"INACTIVO\"");
  Serial.print(",\"distancia_cm\":");
  Serial.print(distanciaCm, 1);

  // 4. Lógica de Alarma Inteligente
  if (movimiento == HIGH || distanciaCm < 50.0) {
    digitalWrite(PIN_LED_ALARMA, HIGH);
    tone(PIN_BUZZER, 1000, 200); // Tono de 1000 Hz
    Serial.println(",\"estado_alarma\":\"ALERTA_ACTIVA\"}");
  } else {
    digitalWrite(PIN_LED_ALARMA, LOW);
    noTone(PIN_BUZZER);
    Serial.println(",\"estado_alarma\":\"SEGURO\"}");
  }

  delay(1000);
}
