import processing.serial.*;
import ddf.minim.*;

Serial myPort; // serial port object

String[] portList = Serial.list();
final int PORT_NUM = 0;
//PortHandler portHandler;

final int GAME_TITLE = 0;
final int PLAYMODE = 1;
final int GAME_END = 2;
final int GAMEINSTRUCTION = 3;

byte[] inBuffer;       // buffer of fish
String myString;       // buffer string
String[] f;            // fish packet
String[] c;               // fish color
String[] w;               // fish weight
int weightL;           // Lower weight bound
int weightM;           // middle weight bound
int tweightU;          // Upper weight bound

StartScreen ss;
StartScreen ssDaylight;
CountBackground cbg;
CountBackground daylightCbg;
Intro in;
Minim minim;
AudioPlayer backSound, click;

boolean spacePressed = false;
boolean isDaylight = false;
ArrayList<Fish> fish = new ArrayList<Fish>();

ArrayList<Fish> yellowFish = new ArrayList<Fish>();
ArrayList<Fish> redFish = new ArrayList<Fish>();
ArrayList<Fish> greenFish = new ArrayList<Fish>();
ArrayList<Fish> blackFish = new ArrayList<Fish>();
ArrayList<Fish> whiteFish = new ArrayList<Fish>();

PImage fishImg;

PImage yellowFishImg;
PImage redFishImg;
PImage greenFishImg;
PImage blackFishImg;
PImage whiteFishImg;

PImage deadFishImg;
PImage winFishImg;
PImage bg;

int gameState = GAME_TITLE;   // Begin gamestate at game title screen
int gameTimeMax = 5000;      // Max play time in ms
int gameTimeStart = 0;        // Time of game start
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

void setup()
{
  size(1000, 716);
  loadAssets();
  for (int i = 0; i < numberFish; i ++) {
    fish.add(new Fish(new PVector(random(width), random(50, 650)), new PVector(random(-6, -1), 0), fishImg, random(1, 3)));
  }
  
  println(Serial.list());
  myPort = new Serial (this, Serial.list()[PORT_NUM], 9600);
  //portHandler = new PortHandler(myPort);
      inBuffer = new byte[255];
    
    // TO DO : Change to values reflecting actual weight
    weightL = 10; 
    weightM = 20; 
    tweightU = 30; 
}

void draw(){
  //spacePressed is used as an alternative condition for light sensor
   if (spacePressed) {
    isDaylight = true;
  } else {
    isDaylight = false;
  }
  
  println(gameState);
  switch (gameState)
  {
  case GAME_TITLE : 
    gameTitle();
    break;

  case GAMEINSTRUCTION :
    displayHowToPlayScreen();
    gameTimeStart = millis();
    break;

  case PLAYMODE :
    playMode();
    break;

  case GAME_END :
    gameEnd();
    break;
  }
}

void checkBuffer()
{
  println("checking buffer");
  if (myPort.available() > 0) 
  {
    myPort.readBytesUntil('&', inBuffer);
    if (inBuffer != null) {
      println("in buffer " + inBuffer);
      println("check buffer");
      myString = new String(inBuffer);
      //String[] useableString = splitTokens(myString, "&");
      println("buffer string " + myString);
      f = splitTokens(myString, "&");
      c = splitTokens(f[0], "C"); // Convert string value to integer (color)
      w = splitTokens(f[0], "W"); // Convert string value to integer
    }
    switch (gameState) 
    {
      case GAME_TITLE :
      println("case: game title");
      println("received: "  + f[0]);
        if (f[0] == "3") 
        {
          println("change game state to game instruction");
          gameState = GAMEINSTRUCTION;
          myPort.write(gameState);
        }
        else
        {
          println("No change in game state: Title Screen");
        }
        myPort.clear();
        //inBuffer = new byte[255];
        //myString =  "";
      break;
        
      case GAMEINSTRUCTION :
      println("case: game instruction " + f[0]);
      println("received: "  + f[0]);
        if (Integer.parseInt(f[0]) == 1) 
        { 
          println("change game state to play mode");
          gameState = PLAYMODE;
          myPort.write(gameState);
        }
        else 
        {
          println("No change in game state: Game Instruction");
        }
        myPort.clear();
        //inBuffer = new byte[255];
        //myString =  "";
        
      break;
       
      case PLAYMODE :
      int s = 0;
      println("case: playmode");
      if (millis() >= weighTimeStart + weighTimeMax) {
        
      int weight = Integer.parseInt(w[0]);
      int colorr = Integer.parseInt(c[0]);
      
      if(colorr == num) {
        score += 2;
      }
      
      
      
      //Weight-based scoring
      println("weight: " + weight);
        // Check info received about fish
        if (weight >= weightL && weight < weightM) 
        {
          s += 1;
        }
        else if (weight >= weightM && weight < weightL)
        {
          s += 2;
        }
        else if (weight >= weightL)
        {
          s += 3;
        }  
        else
        {
          println("No change to score from weight");
        }  
        score += s;
        // TO DO : add score increase based on color
        }
      break;
      
      case GAME_END :
      println("case: game instruction" + f[0]);
      println("received: "  + f[0]);      
        if (f[0] == "0") 
        {
          println("change game state to game title");
          gameState = GAME_TITLE;
          myPort.write(gameState);
        }      
      break;
      
      default :
      println("nothing happened");
      break;
    }
  }
}
