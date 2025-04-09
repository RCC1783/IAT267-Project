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

class Fish {
  PImage img;
  PVector pos, vel;
  float xHeight;
  float xWidth;
  float scale;
  
  Fish(PVector pos, PVector vel, PImage img, float scale) {
    this.pos = pos;
    this.vel = vel;
    this.img = img;
    this.scale = scale;
    xHeight = 50;
    xWidth = 60;
  }
  
  void update() {
    drawMe();
    move();
    handleWall();
  }
  
  void drawMe() {
    pushMatrix() ;
    if (vel.x < 0) {
      translate(pos.x +xWidth/2, pos.y);
      image(img, 0,0,xWidth*scale,xHeight*scale);
    } else {
      translate(pos.x, pos.y);
      scale(-1,1);
      image(img, 0,0,xWidth*scale,xHeight*scale);
    }
    popMatrix();
  }
  
  void move() {
    pos.add(vel);
  }
  
  void accelerate(PVector acc) {
    vel.add(acc);
  }
  
  void handleWall() {
    if (pos.x < -xWidth*scale || pos.x > width + xWidth/2*scale){
      vel.x = -vel.x;
      pos.y = random(50, 600);
    }
    if (pos.y < -xHeight/2*scale || pos.y > height + xHeight/2*scale){
      vel.y = -vel.y;
    }
  }
}
