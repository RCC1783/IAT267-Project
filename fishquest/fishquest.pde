import processing.serial.*;
import ddf.minim.*;

final int PORT_NUM = 0;
byte[] inBuffer = new byte[255];   // buffer of fish
Serial myPort;                     // serial port object
String[] portList = Serial.list();

String myString;                   // buffer string
String[] f;                        // fish packet
String[] c;                        // fish color
String[] w;                        // fish weight

final int GAME_TITLE = 0;
final int PLAYMODE = 1;
final int GAME_END = 2;
final int GAMEINSTRUCTION = 3;

StartScreen ss;
Intro in;
Minim minim;
AudioPlayer backSound, click;

boolean spacePressed = false;
ArrayList<Fish> fish = new ArrayList<Fish>();
PImage fishImg;
PImage reversedFishImg;

int gameState = GAME_TITLE; // Begin gamestate at game title screen
int gameTimeMax = 2000;    // Max play time in ms
int gameTimeStart = 0;      // Time of game start
int time = 0;               // Time remaining
int score = 0;              // Player score

int gameState = GAME_TITLE;  // Begin gamestate at game title screen
final int GAME_TIME_MAX = 60000;     // Max play time in ms
int gameTimeStart;       // Time of game start
int time;                // Time remaining
int score = 0;               // Player score

int timeCountDown = 10 * 60; // Start count down after the game ends and starts the game again
int numberFish = 5; // Number of the fish

void setup() 
{

size(1000, 716);  
loadAssets();
for (int i = 0; i < numberFish; i ++) {
  fish.add(new Fish(new PVector(random(width),random(50, 650)), new PVector(random(-6,-1),0), fishImg, random(1,3)));  
}
  
ss = new StartScreen(loadImage("start.png"));
in = new Intro(loadImage("intro.png"));
myPort = new Serial (this, Serial.list()[PORT_NUM], 9600);

}

void draw() 
{

  myPort.write(gameState); // Send current game state to Arduino
 
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

void gameTitle() 
{
  myPort.write(GAME_TITLE);
  displayStartScreen();
  score = 0;
}

void playMode() 
{
  myPort.write(PLAYMODE);
  background(160,214,217);
  text("" + (GAME_TIME_MAX - time)/1000, width/2, height/4);  // Show time remaining in seconds
  text("" + score, width/2, height/2);                      // Show score in screen centre
  
  checkBuffer();
  
  time = millis() - gameTimeStart;          // total time in play mode 
  if (time >= GAME_TIME_MAX) 
  {
    gameState = GAME_END;
  }
 
}

void gameEnd()
{
  myPort.write(GAME_END);
  background(160,214,217);
  fill(255);
  if(score <= 2) {
    text("Hm...", width/3, height/4);
    text("Your score is", width/3, height/4+50);
  } else if (score >= 3) {
    text("Yahoooo! ", width/3, height/4);
    text("Your score is", width/3, height/4+50);
  }
  text(score, width/2, height/2);
  reStart();
}

void reStart() 
{
  println(timeCountDown = timeCountDown - 1, "countdown is working");
  text("Going back to the main screen in " + timeCountDown/50, width/3, height/2+ 100);
  text("Click on screen to go back now", width/3, height/2 + 150);
  if (timeCountDown <= 0) 
  {
    gameState = GAME_TITLE;    
    timeCountDown = 10 *60;
  } 
}

void displayStartScreen() 
{
  ss.drawMe();
  spawnFish();
  textSize(100);
  PFont font = loadFont("Skia-Regular_Black-Condensed-48.vlw");
  textFont(font);
  textSize(100);
  text("Welcome", width/2-150, height/2); // Display Title screen
  textSize(40);
  text("Click on screen to Start", width/3,height/2+300);
}

void displayHowToPlayScreen()
{
  in.drawMe();
  textSize(40);
  text("This game is about ... ", width/8,height/2-80);
  text("Click on screen to start timer ", width/8,height/2); 
  spawnFish();
}

void loadAssets() {
  fishImg = loadImage("fish.png");
  reversedFishImg = loadImage("reversedFish.png");
  ss = new StartScreen(loadImage("start.png"));
  in = new Intro(loadImage("intro.png"));
  minim = new Minim(this);
  backSound = minim.loadFile("backSound.mp3");
  backSound.loop();
  click = minim.loadFile("click.mp3");
}

void spawnFish() {
  for (int i = 0; i < fish.size(); i++) {
    Fish fishes = fish.get(i);
    fishes.update();
  }
}

// Check for signal from arduino to start game
// Or check for information on caught fish
void checkBuffer()
{
  myString = new String(inBuffer);

  f = splitTokens(myString, "&");
  c = splitTokens(myString, "C");
  w = splitTokens(myString, "W");
  
  switch (gameState) 
  {
    case GAME_TITLE :
      if (f[0] == "3") 
      {
        gameState = GAMEINSTRUCTION;
      }
      else
      {
        println("No change in game state: Title Screen");
      }
    break;
        
    case GAMEINSTRUCTION :
      if (f[0] == "1") 
      {
        gameState = PLAYMODE;
      }
      else 
      {
        println("No change in game state: Game Instruction");
      }
    break;
       
    case PLAYMODE :
    // Check info received about fish
    int weight = Integer.parseInt(w[0]);
      
      // small
      if (weight <= 10) 
      {
        score += 1;
      }
      // medium
      else if (weight > 10 && weight <= 20) 
      {
        score += 2;
      }  
      // large
      else if (weight > 20)
      {
        score += 3;
      } 
      else
      {
        println("No change to score from weight");
      }
    
    
    case GAME_END :
      if (f[0] == "0") 
      {
        gameState = GAME_TITLE;
      }      
    break; 
  }
}
