//Include a delay from when the weight/colour is first measured to get a more accurate reading

#include <Servo.h>
#include <ColorPAL.h>

enum analogInPins {ROT_SENSOR_IN = A0, FWD_BCK_SLIDER_IN = A1, WGHT_SENSOR_IN = A2, LGHT_SENSOR_IN = A3};
enum analogOutPins {ROD_ROTATOR_OUT = 11, ROD_MOVER_OUT_L = 10, ROD_MOVER_OUT_R = 9};


//Digital 
const int REEL_BUTTON_PIN = 2; //reel in/out button (digital)
const int RED_LED = 5;
const int GREEN_LED = 6;
const int CLR_SENSOR_IN = 12;

//Pins for the DC motor
const int REEL_MOTOR_PWMA = 3; //speed of motor (analog)
const int REEL_MOTOR_AI1 = 4; //direction control 1 (digital)
const int REEL_MOTOR_AI2 = 7; //direction control 2 (digital)
const int REEL_MOTOR_STBY = 8; //standby mode control (digital)

Servo rodRotator;
Servo rodFwdBk_L;
Servo rodFwdBk_R;

ColorPAL clrSensor;

bool lineReelDown = true;
int reelTime = 0;
const int REEL_TIME_MAX = 50;

int buttonInputTimer = 0;
const int BUTTON_INPUT_TIMER_DELAY_MAX = 100;

const int GAME_TITLE = 0;
const int PLAYMODE = 1;
const int GAME_END = 2;
const int INSTRUCTION = 3;

unsigned int gameState = 0;

unsigned long gameTimeMax = 60000; //1 minute
unsigned long gameStartTime = 0;

void setup() {
  Serial.begin(9600);
  while(!Serial){;}

  rodRotator.attach(ROD_ROTATOR_OUT);
  rodFwdBk_L.attach(ROD_MOVER_OUT_L);
  rodFwdBk_R.attach(ROD_MOVER_OUT_R);

  clrSensor.attachPAL(CLR_SENSOR_IN);

  pinMode(REEL_BUTTON_PIN, INPUT);
  pinMode(REEL_MOTOR_AI1, OUTPUT);
  pinMode(REEL_MOTOR_AI2, OUTPUT);
  pinMode(REEL_MOTOR_STBY, OUTPUT);

  rodRotator.write(90);
  rodFwdBk_L.write(90);
  rodFwdBk_R.write(90);
}

void loop() {
  if(buttonInputTimer > 0){
    buttonInputTimer -= 1;
    digitalWrite(RED_LED, HIGH);
    digitalWrite(GREEN_LED, LOW);
  }else{
    digitalWrite(RED_LED, LOW);
    digitalWrite(GREEN_LED, HIGH);
  }
  switch (gameState){
    case GAME_TITLE:
        if(digitalRead(REEL_BUTTON_PIN) == HIGH && buttonInputTimer <= 0){
          buttonInputTimer = BUTTON_INPUT_TIMER_DELAY_MAX;
          gameState = INSTRUCTION;
          Serial.println("3&");
          delay(20);
        }
      break;
    case INSTRUCTION: //Instruction
        if(digitalRead(REEL_BUTTON_PIN) == HIGH && buttonInputTimer <= 0){
          buttonInputTimer = BUTTON_INPUT_TIMER_DELAY_MAX;
          gameState = PLAYMODE;
          gameStartTime = millis();
          
          Serial.println("1&");
          delay(20);
        }
        break;
    case PLAYMODE:
      {
        delay(10);
        
        rodRotator.write(AnalogInToDegrees180(ROT_SENSOR_IN));
        
        rodFwdBk_L.write(180 - AnalogInToDegrees180(FWD_BCK_SLIDER_IN));
        rodFwdBk_R.write(AnalogInToDegrees180(FWD_BCK_SLIDER_IN));
  
        ReelController();

        // Gets all colour data
        int r = clrSensor.redPAL();
        int g = clrSensor.greenPAL();
        int b = clrSensor.bluePAL();

        //Gets light sensor data (set up so higher val = darker)
        int light = analogRead(LGHT_SENSOR_IN);

        // Gets Force data (currently unused)
        int force = analogRead(WGHT_SENSOR_IN);

        printToSerial(r, g, b, light, force);
      }
      break;
    case GAME_END:
      {
        if(millis() >= gameStartTime + gameTimeMax){
          gameState = GAME_TITLE; 
          gameTimeMax = 60000;
          Serial.println("0&");
          break;
        }
        
//        Serial.println("end");
        // raise the line back up
        if(lineReelDown == false && reelTime < REEL_TIME_MAX){
          reelTime++;
          
          //Spin Counter-Clockwise at speed 150
          digitalWrite(REEL_MOTOR_STBY, HIGH);
          analogWrite(REEL_MOTOR_PWMA, 150);
          digitalWrite(REEL_MOTOR_AI1, LOW); 
          digitalWrite(REEL_MOTOR_AI2, HIGH); 
          if(reelTime >= REEL_TIME_MAX){
            lineReelDown == true;
          }else{
            digitalWrite(REEL_MOTOR_STBY, LOW);
            analogWrite(REEL_MOTOR_PWMA, 0);
          }
        }

        rodRotator.write(90);
        rodFwdBk_L.write(90);
        rodFwdBk_R.write(90);
      }
      break;
    default:
      {
//        Serial.println("default");
        delay(10);
      }
  }
  delay(20);
}

void printToSerial(int r, int g, int b, int light, int force){
  if(millis() >= gameStartTime + gameTimeMax){
    gameState = GAME_END; 
    gameStartTime = millis();
    gameTimeMax = 10000;
//          Serial.flush();
    Serial.println("2&");
    delay(20);
    return;
  }
  Serial.print("R");
  Serial.print(r);
  Serial.print("R");
    
  Serial.print("G");
  Serial.print(g);
  Serial.print("G");
    
  Serial.print("B");
  Serial.print(b);
  Serial.print("B");
  
  Serial.print("L");
    Serial.print(light);
  Serial.print("L");
  
  Serial.print("W");
    Serial.print(force);
  Serial.print("W");
  
  Serial.print("T");
    unsigned int currentTime = (millis() - gameStartTime);
    Serial.print((gameTimeMax - currentTime)/1000);
  Serial.print("T");
  
  Serial.print("&");
  Serial.println();
}

int AnalogInToDegrees180(int analogIn){
  int rotVal = analogRead(analogIn);
  if(analogIn == ROT_SENSOR_IN){
    rotVal = map(rotVal, 200, 1023, 30, 120);
  }else{
    rotVal = map(rotVal, 0, 1023, 0, 180);
  }
  
  return rotVal;
}

void ReelController(){
  if(digitalRead(REEL_BUTTON_PIN) == HIGH && buttonInputTimer == 0){
    if(lineReelDown == true){
      lineReelDown = false;
    }else if(lineReelDown == false){
      lineReelDown = true;
    }
    buttonInputTimer = BUTTON_INPUT_TIMER_DELAY_MAX;
    reelTime = 0;
  }

  if(lineReelDown == true && reelTime < REEL_TIME_MAX){

    reelTime++;
    
    //Spin Clockwise at speed 150
    digitalWrite(REEL_MOTOR_STBY, HIGH);
    analogWrite(REEL_MOTOR_PWMA, 150);
    digitalWrite(REEL_MOTOR_AI1, HIGH); 
    digitalWrite(REEL_MOTOR_AI2, LOW); 
    if(reelTime >= REEL_TIME_MAX){
      lineReelDown == false;
    }
  }
  else if(lineReelDown == false && reelTime < REEL_TIME_MAX){
    
    reelTime++;
    
    //Spin Counter-Clockwise at speed 150
    digitalWrite(REEL_MOTOR_STBY, HIGH);
    analogWrite(REEL_MOTOR_PWMA, 150);
    digitalWrite(REEL_MOTOR_AI1, LOW); 
    digitalWrite(REEL_MOTOR_AI2, HIGH); 
    if(reelTime >= REEL_TIME_MAX){
      lineReelDown == true;
    }
  }else{
    digitalWrite(REEL_MOTOR_STBY, LOW);
    analogWrite(REEL_MOTOR_PWMA, 0);
  }
}
