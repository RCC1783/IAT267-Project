import processing.serial.*;
//Serial myPort; // serial port object
//String[] portList = Serial.list();
//final int PORT_NUM = 0;

final int GAME_TITLE = 0;
final int PLAYMODE = 1;
final int GAME_END = 2;
final int GAMEINSTRUCTION = 3;

StartScreen ss;
Intro in;

boolean spacePressed = false;

int gameState = GAME_TITLE; // Begin gamestate at game title screen
int gameTimeMax = 60000;    // Max play time in ms
int gameTimeStart = 0;      // Time of game start
int time = 0;               // Time remaining
int score = 0;              // Player score
int timeCountDown = 10 * 60; // Start count down after the game ends and starts the game again

void setup() 
{
size(1000, 716);   
ss = new StartScreen(loadImage("start.png"));
in = new Intro(loadImage("intro.png"));
//myPort = new Serial (this, Serial.list()[PORT_NUM], 9600);

}

void draw() 
{
  switch (gameState) 
  {   
    case GAME_TITLE :
      gameTitle();
      if (key == ' ' && !spacePressed) {
        spacePressed = true;
        gameState = GAMEINSTRUCTION;
      }
    break;
    
    case GAMEINSTRUCTION :
      displayHowToPlayScreen();
      gameTimeStart = millis();
      if (key == ' ' && !spacePressed) {
        spacePressed = true;
        gameState = PLAYMODE;
      }
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
  //background(0);
  displayStartScreen();
  
  /* if (myPort.available() > 0) 
  {
    gameState = PLAYMODE;   // Start game if signal received from arduino
    myPort.clear();         // Clear port buffer
    gameTimeStart = millis();
  } */
}

void playMode() 
{
  background(0);
  text("" + (gameTimeMax - time)/1000, width/2, height/4);  // Show time remaining in seconds
  text("" + score, width/2, height/2);                      // Show score in screen centre
  
  time = millis() - gameTimeStart;          // total time in play mode 
  if (time >= gameTimeMax) 
  {
    gameState = GAME_END;
  }
  
  /*if (myPort.available() > 0) 
  {
    score++;                // Increment score if signal received from arduino
    myPort.clear();         // Clear port buffer
  }*/
}

void gameEnd()
{
  background(0);
  text("Thanks for playing!", width/2, height/4);
  text("" + score, width/2, height/2);
  reStart();
}

void reStart() {
  println(timeCountDown = timeCountDown - 1, "countdown is working");
  if (timeCountDown <= 0) {
    gameState = GAME_TITLE;
    timeCountDown = 10*60;
  }
}

void displayStartScreen() {
  ss.drawMe();
  textSize(100);
  text("Welcome", width/2-150, height/2); // Display Title screen
  textSize(40);
  text("Press 'Space' or click on screen to Start", width/4.5,height/2+300);
}

void displayHowToPlayScreen(){
  in.drawMe();
  textSize(40);
  text("This game is about ... ", width/8,height/2-80);
  text("Press 'Space' or click on screen to start timer ", width/8,height/2);  
}
