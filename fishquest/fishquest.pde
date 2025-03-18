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
int gameTimeMax = 2000;    // Max play time in ms
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
  //background(0);
  displayStartScreen();
  score = 0;
  
  /* if (myPort.available() > 0) 
  {
    gameState = PLAYMODE;   // Start game if signal received from arduino
    myPort.clear();         // Clear port buffer
    gameTimeStart = millis();
  } */
}

void playMode() 
{
  background(160,214,217);
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
  background(160,214,217);
  fill(255);
  if(score <= 2) {
    text("Hm... Your score is  ", width/3, height/4);
  } else if (score >= 3) {
    text("Yay! Your score is ", width/3, height/4);
  }
  text(score, width/2, height/2);
  reStart();
}

void reStart() {
  println(timeCountDown = timeCountDown - 1, "countdown is working");
  text("Going back to the main screen in " + timeCountDown/50, width/3, height/2+ 100);
  text("Click on screen to go back now", width/3, height/2 + 150);
  if (timeCountDown <= 0) {
    gameState = GAME_TITLE;    
    timeCountDown = 10 *60;
  } 
}

void displayStartScreen() {
  ss.drawMe();
  textSize(100);
  text("Welcome", width/2-150, height/2); // Display Title screen
  textSize(40);
  text("Click on screen to Start", width/3,height/2+300);
}

void displayHowToPlayScreen(){
  in.drawMe();
  textSize(40);
  text("This game is about ... ", width/8,height/2-80);
  text("Click on screen to start timer ", width/8,height/2);  
}
