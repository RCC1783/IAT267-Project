import processing.serial.*;
import ddf.minim.*;

Serial myPort; // serial port object

String[] portList = Serial.list();
final int PORT_NUM = 2;
//PortHandler portHandler;

final int GAME_TITLE = 0;
final int PLAYMODE = 1;
final int GAME_END = 2;
final int GAMEINSTRUCTION = 3;

StartScreen ss;
StartScreen ssDaylight;
CountBackground cbg;
CountBackground daylightCbg;
Intro in;
Minim minim;
AudioPlayer backSound, click;

boolean spacePressed = false;
boolean isDaylight = false;

PImage deadFishImg;
PImage winFishImg;
PImage bg;

int gameState = GAME_TITLE;   // Begin gamestate at game title screen
int time = 0;                 // Time remaining
int score = 0;                // Player score
int timeCountDown = 10 * 60;  // Start count down after the game ends and starts the game again
int numberFish = 5;           // Number of the fish
int scrollrate = 4;
int scroll;

int weighTime = millis();
int weighTimeMax = 3000;
int weighTimeStart = 0;

int num;//random num to decided the color of the fish
final int RED = 0, GREEN = 1, YELLOW = 2, BLACK = 3, WHITE = 4;
int gameR;
int gameG;
int gameB;

void setup()
{
  size(1000, 716);
  loadAssets();
  for (int i = 0; i < numberFish; i ++) {
    fish.add(new Fish(new PVector(random(width), random(50, 650)), new PVector(random(-6, -1), 0), fishImg, random(1, 3)));
  }
  
  println(Serial.list());
  myPort = new Serial (this, Serial.list()[PORT_NUM], 9600);
  //portHandler = new PortHandler();
  inBuffer = new byte[255];
    
    // TO DO : Change to values reflecting actual weight
    weightL = 10; 
    weightM = 20; 
    tweightU = 30; 
}

void draw(){
  //spacePressed is used as an alternative condition for light sensor
  // if (spacePressed) {
  //  isDaylight = true;
  //} else {
  //  isDaylight = false;
  //}
  
  switch (gameState)
  {
  case GAME_TITLE : 
    gameTitle();
    break;

  case GAMEINSTRUCTION :
    displayHowToPlayScreen();
    //gameTimeStart = millis();
    break;

  case PLAYMODE :
    playMode();
    break;

  case GAME_END :
    gameEnd();
    break;
  }
}

void ChangeFishColour(){
  num = int(random(4));
  
  switch(num){
    case RED:
      gameR = 180;
      gameG = 25;
      gameB = 35;
      break;
    case GREEN:
      gameR = 28;
      gameG = 70;
      gameB = 75;
      break;
    case YELLOW:
      gameR = 250;
      gameG = 135;
      gameB = 65;
      break;
    case BLACK:
      gameR = 255;
      gameG = 0;
      gameB = 0;
      break;
    case WHITE:
      gameR = 255;
      gameG = 260;
      gameB = 380;
      break;
    default :
      gameR = 180;
      gameG = 25;
      gameB = 35;
    }
}
