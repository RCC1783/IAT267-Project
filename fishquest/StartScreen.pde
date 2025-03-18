class StartScreen {
  PImage img;
  
  StartScreen(PImage img) {
    this.img = img;
  }
  
  void drawMe() {
    image(img,0,0,1000,716);
  }
}
