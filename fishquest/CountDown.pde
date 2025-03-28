class CountDown 
{
  private int timeMax;      // Max play time in ms
  private int timeStart;    // Time of game start
  private int time;         // Total time so far
  
  CountDown(int timeMax) 
  {
    this.timeMax = timeMax;
  }
  
  void start() 
  {
    timeStart = millis();
    updateTime();
  }
  
  boolean timeLeft() 
  {
    updateTime();
    return time <= timeMax;
  }
  
  int getTime() 
  {
    return (timeMax - time)/1000;
  }
  
  private void updateTime()
  {
    time = millis() - timeStart;
  }
}
