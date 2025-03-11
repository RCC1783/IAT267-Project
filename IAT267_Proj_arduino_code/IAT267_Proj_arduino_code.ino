#include <Servo.h>
//#include <SparkFun_TB6612.h>

enum analogSensorPins {ROT_SENSOR_PIN, FWD_BCK_SLIDER_PIN, WHGHT_SENSOR_PIN};
//const int ROT_SENSOR_PIN = 0;
//const int FWD_BCK_SLIDER_PIN = 1;
//const int WHGHT_SENSOR_PIN = 2;

//Digital 
const int REEL_BUTTON_PIN = 2;
const int REEL_MOTOR_AI1 = 4;
const int REEL_MOTOR_AI2 = 7;
const int REEL_MOTOR_STBY = 8;

const int REEL_MOTOR_PWMA = 3; //analog write

Servo armRotator;
Servo armFwdBk;

bool lineReelDown = true;
int reelTime = 10;
const int REEL_TIME_MAX = 10;

void setup() {
  Serial.begin(9600);

  pinMode(REEL_BUTTON_PIN, INPUT);
  pinMode(REEL_MOTOR_AI1, OUTPUT);
  pinMode(REEL_MOTOR_AI2, OUTPUT);
  pinMode(REEL_MOTOR_STBY, OUTPUT);
}

void loop() {
//  Serial.println(ROT_SENSOR_PIN);
  
  armRotator.write(AnalogInToDegrees180(ROT_SENSOR_PIN));
  armFwdBk.write(AnalogInToDegrees180(FWD_BCK_SLIDER_PIN));

  Serial.println(digitalRead(REEL_BUTTON_PIN));
  if(digitalRead(REEL_BUTTON_PIN) == HIGH && (lineReelDown == true || lineReelDown == false)){
    reelTime = 0;
  }

//  if(lineReelDown == true && reelTime < REEL_TIME_MAX){
//    reelTime++;
//    digitalWrite(REEL_MOTOR_STBY, HIGH);
//    analogWrite(REEL_MOTOR_PWMA, 100);
//    //Spin Clockwise
//    digitalWrite(REEL_MOTOR_AI1, HIGH); 
//    digitalWrite(REEL_MOTOR_AI2, LOW); 
//    if(reelTime >= REEL_TIME_MAX){
//      lineReelDown == false;
//    }
//  }else if(lineReelDown == false && reelTime < REEL_TIME_MAX){
//    reelTime++;
//    digitalWrite(REEL_MOTOR_STBY, HIGH);
//    analogWrite(REEL_MOTOR_PWMA, 100);
//    //Spin Counter-Clockwise
//    digitalWrite(REEL_MOTOR_AI1, LOW); 
//    digitalWrite(REEL_MOTOR_AI2, HIGH); 
//    if(reelTime >= REEL_TIME_MAX){
//      lineReelDown == true;
//    }
//  }else{
//    digitalWrite(REEL_MOTOR_STBY, LOW);
//    analogWrite(REEL_MOTOR_PWMA, 0);
//  }
  
  delay(15);
}

int AnalogInToDegrees180(int analogIn){
  int rotVal = analogRead(analogIn);
  rotVal = map(rotVal, 0, 1023, 0, 180);
  return rotVal;
}
