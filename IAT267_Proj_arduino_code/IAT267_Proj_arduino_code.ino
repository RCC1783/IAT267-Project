#include <Servo.h>

enum analogSensorPins {ROT_SENSOR_PIN, FWD_BCK_SLIDER_PIN, WHGHT_SENSOR_PIN};
//const int ROT_SENSOR_PIN = 0;
//const int FWD_BCK_SLIDER_PIN = 1;
//const int WHGHT_SENSOR_PIN = 2;

//Digital 
const int REEL_BUTTON_PIN = 0;

Servo armRotator;
Servo armFwdBk;

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.println(ROT_SENSOR_PIN);
  
}
