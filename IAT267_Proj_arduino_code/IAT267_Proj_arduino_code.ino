#include <Servo.h>
//#include <SparkFun_TB6612.h>

enum analogInPins {ROT_SENSOR_IN = A0, FWD_BCK_SLIDER_IN = A1, WGHT_SENSOR_IN = A2, CLR_SENSOR_IN = A3};
enum analogOutPins {ROD_ROTATOR_OUT = 11, ROD_MOVER_OUT = 10};


//Digital 
const int REEL_BUTTON_PIN = 2; //reel in/out button (digital)

//Pins for the DC motor
const int REEL_MOTOR_AI1 = 4; //direction control 1 (digital)
const int REEL_MOTOR_AI2 = 7; //direction control 2 (digital)
const int REEL_MOTOR_STBY = 8; //standby mode control (digital)
const int REEL_MOTOR_PWMA = 3; //speed of motor (analog)

Servo rodRotator;
Servo rodFwdBk;

bool lineReelDown = true;
int reelTime = 0;
const int REEL_TIME_MAX = 50;

int buttonInputTimer = 0;
const int BUTTON_INPUT_TIMER_DELAY_MAX = 100;

const int GAME_TITLE = 0;
const int PLAYMODE = 1;
const int GAME_END = 2;

unsigned long gameState = 0;
unsigned long gameTimeMax = 10000;

unsigned long gameTime = 0;

void setup() {
  Serial.begin(9600);

  rodRotator.attach(ROD_ROTATOR_OUT);
  rodFwdBk.attach(ROD_MOVER_OUT);

  pinMode(REEL_BUTTON_PIN, INPUT);
  pinMode(REEL_MOTOR_AI1, OUTPUT);
  pinMode(REEL_MOTOR_AI2, OUTPUT);
  pinMode(REEL_MOTOR_STBY, OUTPUT);
}

void loop() {

  switch(gameState){
    case(GAME_TITLE):
      char keystroke;
      if(Serial.available() > 0){
        keystroke = Serial.read();

        if(keystroke == " "){
          gameState = PLAYMODE;
          gameTime = millis();
        }
      }
      break;
    case(PLAYMODE):
      if(Serial.available() > 0){
         Serial.write(millis() - gameTime); //sends game time to processing 
      }
      
      if(gameTime + gameTimeMax >= millis()){
        gameState = GAME_END;
        if(lineReelDown == true){
          reelTime = 0;
        }
        Serial.write(gameState);
        return;
      }
    
      int force = analogRead(WGHT_SENSOR_IN);

      if(Serial.available() > 0){
        Serial.write(force); //sends the force to processing to be converted to weight
      }

      rodRotator.write(AnalogInToDegrees180(ROT_SENSOR_IN));
      rodFwdBk.write(AnalogInToDegrees180(FWD_BCK_SLIDER_IN));
    
      ReelController();
  
      delay(15);
      break;
    case GAME_END: // Should Reset everything?
      // raise the line back up
      if(lineReelDown == false && reelTime < REEL_TIME_MAX){
        Serial.println("reelingUp");
        reelTime++;
        
        //Spin Counter-Clockwise at speed 150
        digitalWrite(REEL_MOTOR_STBY, HIGH);
        analogWrite(REEL_MOTOR_PWMA, 150);
        digitalWrite(REEL_MOTOR_AI1, LOW); 
        digitalWrite(REEL_MOTOR_AI2, HIGH); 
        if(reelTime >= REEL_TIME_MAX){
          Serial.println("switch to true");
          lineReelDown == true;
        }else{
          digitalWrite(REEL_MOTOR_STBY, LOW);
          analogWrite(REEL_MOTOR_PWMA, 0);
        }
      }
      
      rodRotator.write(90);
      rodFwdBk.write(90);
        
      break;
    default:
      break;
  }
}

int AnalogInToDegrees180(int analogIn){
  int rotVal = analogRead(analogIn);
  rotVal = map(rotVal, 0, 1023, 0, 180);
  return rotVal;
}

void ReelController(){
  if(digitalRead(REEL_BUTTON_PIN) == HIGH && buttonInputTimer == 0){
    if(lineReelDown == true){
      lineReelDown = false;
      Serial.println("reel up");
    }else if(lineReelDown == false){
      lineReelDown = true;
      Serial.println("reel down");
    }
    buttonInputTimer = BUTTON_INPUT_TIMER_DELAY_MAX;
    reelTime = 0;
  }

  if(buttonInputTimer > 0){buttonInputTimer -= 1;}

  if(lineReelDown == true && reelTime < REEL_TIME_MAX){
    Serial.println("reelingDown");
    reelTime++;
    
    //Spin Clockwise at speed 150
    digitalWrite(REEL_MOTOR_STBY, HIGH);
    analogWrite(REEL_MOTOR_PWMA, 150);
    digitalWrite(REEL_MOTOR_AI1, HIGH); 
    digitalWrite(REEL_MOTOR_AI2, LOW); 
    if(reelTime >= REEL_TIME_MAX){
      Serial.println("switch to false");
      lineReelDown == false;
    }
  }
  else if(lineReelDown == false && reelTime < REEL_TIME_MAX){
    Serial.println("reelingUp");
    reelTime++;
    
    //Spin Counter-Clockwise at speed 150
    digitalWrite(REEL_MOTOR_STBY, HIGH);
    analogWrite(REEL_MOTOR_PWMA, 150);
    digitalWrite(REEL_MOTOR_AI1, LOW); 
    digitalWrite(REEL_MOTOR_AI2, HIGH); 
    if(reelTime >= REEL_TIME_MAX){
      Serial.println("switch to true");
      lineReelDown == true;
    }
  }else{
    digitalWrite(REEL_MOTOR_STBY, LOW);
    analogWrite(REEL_MOTOR_PWMA, 0);
  }
}
