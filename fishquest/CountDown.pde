class CountDown 
{
  private int timeMax;      // Max play time in ms
  private int timeStart;    // Time of game start
  private int timeLeft;     // Time remaining
  
  CountDown(int timeMax) 
  {
    this.timeMax = timeMax;
    timeStart = millis();
    timeLeft = timeMax - timeStart;
  }
}
