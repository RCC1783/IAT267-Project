//count background is the background of the countdown (or play mode) state
class CountBackground {
  PImage img;
  int repeatX;
  int repeatY;
  
  CountBackground(PImage img) {
    this.img = img; 
    repeatX = (((int) width/img.width) +1) *2;
    repeatY = (((int) height/img.height) +1) *2;
  }
  
  void drawMe(float scrollX, float scrollY) {
    for (int i=-repeatX; i<repeatX; i++) {
      for (int j=-1; j<repeatY; j++)
        image(img, i*img.width+scrollX, j*img.height+scrollY+716);
    }
  }
}
