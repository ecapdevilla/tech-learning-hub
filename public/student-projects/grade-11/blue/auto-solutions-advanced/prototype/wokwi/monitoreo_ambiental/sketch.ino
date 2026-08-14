/*
  ==========================================================================
  AUTO-SOLUTIONS - PROYECTO 4: MONITOREO AMBIENTAL (ESP32 + Wokwi)
  Integración ODS 3 (Salud y Bienestar) y ODS 13 (Acción por el Clima)
  ==========================================================================
*/

#include <WiFi.h>
#include "DHT.h"

#define DHTPIN 15
#define DHTTYPE DHT22

DHT dht(DHTPIN, DHTTYPE);

const int PIN_LDR = 35; // Sensor Analógico de Luz
const int PIN_VENTILADOR = 17; // Actuador de ventilación

void setup() {
  Serial.begin(115200);
  dht.begin();
  pinMode(PIN_VENTILADOR, OUTPUT);
  Serial.println("🌡️ Estación de Monitoreo Ambiental Iniciada.");
}

void loop() {
  float temp = dht.readTemperature();
  float hum = dht.readHumidity();
  int ldrVal = analogRead(PIN_LDR);

  if (isnan(temp) || isnan(hum)) {
    Serial.println("{\"error\":\"Fallo en lectura de DHT22\"}");
    delay(2000);
    return;
  }

  // Sensación Térmica
  float hi = dht.computeHeatIndex(temp, hum, false);

  Serial.print("{\"proyecto\":\"ambiental\",\"temperatura\":");
  Serial.print(temp, 1);
  Serial.print(",\"humedad\":");
  Serial.print(hum, 1);
  Serial.print(",\"sensacion_termica\":");
  Serial.print(hi, 1);
  Serial.print(",\"luz_raw\":");
  Serial.print(ldrVal);

  if (temp > 28.0 || hum > 75.0) {
    digitalWrite(PIN_VENTILADOR, HIGH);
    Serial.println(",\"ventilador\":\"ON\"}");
  } else {
    digitalWrite(PIN_VENTILADOR, LOW);
    Serial.println(",\"ventilador\":\"OFF\"}");
  }

  delay(2000);
}
