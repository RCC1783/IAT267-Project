void gameTitle()
{
  //background(0);
  println("game title");
  num = int(random(1,6));
  
 
    
  displayStartScreen();
  score = 0;
  checkBuffer();
}

//hello world
void playMode(){
  println("play mode"); 
  dayNightBg();
  
  text("" + (gameTimeMax - time)/1000, width/2, height/4);  // Show time remaining in seconds
  text("" + score, width/2, height/2);                      // Show score in screen centre
  
  time = millis() - gameTimeStart;          // total time in play mode
  if (time >= gameTimeMax)
  {
    gameState = GAME_END;
  }
  
  spawnFishForCountBg();
  checkBuffer();
}

void gameEnd()
{
  println("game end");
  //background(160,214,217);
  fill(255);
  if (score <= 2) {
    ifLose();
    text("Hm...", width/3, height/4);
    text("Your score is " + score, width/3, height/4+60);
  } else if (score >= 3) {
    ifWin();
    text("Yahoooo! Get some sushi ??", width/3-30, height/4);
    text("Your score is " + score, width/3+30, height/4+60);
  }
  //text(score, width/2, height/2);
  reStart();
  checkBuffer();
}

void reStart() {
  println(timeCountDown = timeCountDown - 1, "countdown is working");
  scroll = 0;
  scrollrate = 4;
  spacePressed = false;
  isDaylight = false;
  text("Going back to the main screen in " + timeCountDown/50, width/3-80, height/2+ 100);
  text("Click on screen to go back now", width/3-50, height/2 + 150);
  if (timeCountDown <= 0) {
    gameState = GAME_TITLE;
    timeCountDown = 10 *60;
  }
}

void dayNightBg () {
  scroll -= scrollrate;
  if(scroll <= -cbg.img.width) {
    scroll = 0;
  }  
  if(scroll <= -daylightCbg.img.width) {
    scroll = 0;
  }
  if (isDaylight) {
    //draw daylight background
    image(daylightCbg.img, scroll, 0, width, height);
    image(daylightCbg.img, scroll + daylightCbg.img.width, 0, width, height);
    isDaylight = false;
  } else{
    //draw normal background
    image(bg, 0,0,1000,716);
    image(cbg.img, scroll, 0, width, height);
    image(cbg.img, scroll + cbg.img.width, 0, width, height);
    isDaylight = true;
  }
  if (frameCount % 180 == 0) {  // 180 frames = 3 seconds at 60 FPS
      scrollrate *= 1.2;  // Increase speed
  }
}

void displayStartScreen() {
  PFont font = loadFont("Skia-Regular_Black-Condensed-48.vlw");
  textFont(font);
  if (isDaylight) {
    ssDaylight.drawMe();
    spawnFish();
    pushStyle();
    textSize(100);
    fill(249, 168, 201);
    text("Welcome", width/2-150, height/2); // Display Title screen
    textSize(40);
    text("Click on screen to Start", width/3, height/2+300);
    popStyle();  
    isDaylight = false;
  } else {
    ss.drawMe();
    spawnFish();
    textSize(100);   
    text("Welcome", width/2-150, height/2); // Display Title screen
    textSize(40);
    text("Click on screen to Start", width/3, height/2+300);  
    isDaylight = true;
  }
  
}

void displayHowToPlayScreen() {
  in.drawMe();
  textSize(40);
  text("This game is about ... ", width/8, height/2-80);
  text("Click on screen to start timer ", width/8, height/2);
  spawnFish();
  checkBuffer();
}

void loadAssets() {
  cbg = new CountBackground(loadImage("countbackground.png"));
  bg = loadImage("background.png");
  daylightCbg = new CountBackground (loadImage("daylightbackground.png"));
  
  fishImg = loadImage("fish.png");
  greenFishImg = loadImage("greenFish.png");
  redFishImg = loadImage("redFish.png");
  whiteFishImg = loadImage("whiteFish.png");
  blackFishImg = loadImage("blackFish.png");
  deadFishImg = loadImage("dead.png");
  winFishImg = loadImage("winFish.png");
  ss = new StartScreen(loadImage("start.png"));
  ssDaylight = new StartScreen (loadImage("daylightBgGameTitle.png"));
  in = new Intro(loadImage("intro.png"));
  minim = new Minim(this);
  backSound = minim.loadFile("backSound.mp3");
  backSound.loop();
  click = minim.loadFile("click.mp3");
  
  for (int i = 0; i < numberFish; i ++) {
    fish.add(new Fish(new PVector(random(width), random(50, 650)), new PVector(random(-6, -1), 0), fishImg, random(1, 3)));
  }
  
  for (int i = 0; i < numberFish; i ++) {
    yellowFish.add(new Fish(new PVector(random(width), random(50, 650)), new PVector(random(6,1), 0), fishImg, random(1, 3)));
  }
  
  for (int i = 0; i < numberFish; i ++) {
    greenFish.add(new Fish(new PVector(random(width), random(50, 650)), new PVector(random(6,1), 0), greenFishImg, random(1, 3)));
  }
  
  for (int i = 0; i < numberFish; i ++) {
    redFish.add(new Fish(new PVector(random(width), random(50, 650)), new PVector(random(6,1), 0), redFishImg, random(1, 3)));
  }
  
  for (int i = 0; i < numberFish; i ++) {
    whiteFish.add(new Fish(new PVector(random(width), random(50, 650)), new PVector(random(6,1), 0), whiteFishImg, random(1, 3)));
  }
  
  for (int i = 0; i < numberFish; i ++) {
    blackFish.add(new Fish(new PVector(random(width), random(50, 650)), new PVector(random(6,1), 0), blackFishImg, random(1, 3)));
  }
}

void spawnFish() {
  for (int i = 0; i < fish.size(); i++) {
    Fish fishes = fish.get(i);
    fishes.update();
  }
}

void spawnFishForCountBg() {
  ArrayList<Fish> selectedFishList = null;
  if (num == 1) selectedFishList = yellowFish;
  else if (num == 2) selectedFishList = greenFish;
  else if (num == 3) selectedFishList = redFish;
  else if (num == 4) selectedFishList = whiteFish;
  else if (num == 5) selectedFishList = blackFish;

  if (selectedFishList != null) {
    for (int i = 0; i < selectedFishList.size(); i++) {
      Fish ff = selectedFishList.get(i);
      ff.update();
    }
  }
}

void ifLose() {
  background(233);
  image(deadFishImg, width/2 -40, height/2-20, 180, 65);
}

void ifWin() {
  background(147, 194, 245);
  image(winFishImg, width/2 -40, height/2-60, 100, 108);
}
