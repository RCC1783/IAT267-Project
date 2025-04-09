int weightL;           // Lower weight bound
int weightM;           // middle weight bound
int tweightU;          // Upper weight bound

byte[] inBuffer;       // buffer of fish
String myString;       // buffer string
String[] f;            // packet
String[] r;
String[] g;
String[] b;
String[] l;             // light val
String[] w;            // fish weight
String[] t;            // time

int fishCheckDelay = 120;
final int FISH_CHECK_DELAY = 120;

void checkBuffer()
{
  println("checking buffer");
  
  if(fishCheckDelay < 120){
    fishCheckDelay++;
  }
  
  if (myPort.available() > 0) 
  {
    myPort.readBytesUntil('&', inBuffer);
    if (inBuffer != null) {
      //println("check buffer");
      myString = new String(inBuffer);
      println("buffer string " + myString);
      f = splitTokens(myString, "&");
      if(f[0].length() > 2){
        
        r = splitTokens(f[0], "R"); // Grab RED color value
        g = splitTokens(f[0], "G"); // Grab GREEN color value
        b = splitTokens(f[0], "B"); // Grab BLUE color value
        
        l = splitTokens(f[0], "L"); // Gets light val
        
        w = splitTokens(f[0], "W"); // Convert string value to integer
        
        t = splitTokens(f[0], "T"); // game time
        
        if(t.length > 1){
          time = Integer.parseInt(t[1]);
        }
        
        if(l.length > 1 && int(l[1]) <= 300){
          isDaylight = true;
        }else{
          isDaylight = false;
        }
      }
    }
    
    switch (gameState) 
    {
      case GAME_TITLE :
        println("case: game title");
        println("received: "  + f[0]);
        if (Integer.parseInt(f[0]) == 3) 
        {
          println("change game state to game instruction");
          gameState = GAMEINSTRUCTION;
        }
        else
        {
          println("No change in game state: Title Screen");
        }
        myPort.clear();
      break;
        
      case GAMEINSTRUCTION :
        println("case: game instruction " + f[0]);
        println("received: "  + f[0]);
        if (Integer.parseInt(f[0]) == 1) 
        { 
          println("change game state to play mode");
          gameState = PLAYMODE;
          ChangeFishColour();
        }
        else 
        {
          println("No change in game state: Game Instruction");
        }
        myPort.clear();
        
      break;
       
      case PLAYMODE :
      {
        println("f[0]: " + f[0].trim() + "  f[0] length: " + f[0].length());
        if(f[0].length() < 5){
          println("change game state to end mode");
          gameState = GAME_END;
          myPort.clear();
          return;
        }
        int s = 0;
        println("case: playmode");
        
        if (millis() >= weighTimeStart + weighTimeMax) {
          
        //int weight = Integer.parseInt(w[1]);
  
  // Checking Color
        int diff = 40;
        int rIndex = 0;
        if(r.length > 2) {rIndex = 1;} // WHEN I MAKE THE INDEX 1 ITS 0 WHEN I MAKE IT 0 ITS 1 AHHHHHHHHHHH
        //println("color: " +Integer.parseInt(r[0])+ ", " +Integer.parseInt(g[1])+ ", " + Integer.parseInt(b[1]));
            if (fishCheckDelay == FISH_CHECK_DELAY && (Integer.parseInt(r[rIndex]) < gameR + diff && Integer.parseInt(r[rIndex]) > gameR - diff) &&
                (Integer.parseInt(g[1]) < gameG + diff && Integer.parseInt(g[1]) > gameG - diff) &&
                (Integer.parseInt(b[1]) < gameB + diff && Integer.parseInt(b[1]) > gameB - diff) ) { 
                  s += 3; 
                  ChangeFishColour();
                  fishTimer = 0;
                  fishCheckDelay = 0;
            }else if (fishCheckDelay == FISH_CHECK_DELAY && (Integer.parseInt(r[rIndex]) > 5) && (Integer.parseInt(g[1]) > 5) &&
                      (Integer.parseInt(b[1]) > 5)) {
                  s += 1;
                  fishCheckDelay = 0;
              }
  
        //if(colorr == num) {
        //  score += 2;
        //}
        
        
        
        //Weight-based scoring
        //println("weight: " + weight);
        //  // Check info received about fish
        //  if (weight >= weightL && weight < weightM) 
        //  {
        //    s += 1;
        //  }
        //  else if (weight >= weightM && weight < weightL)
        //  {
        //    s += 2;
        //  }
        //  else if (weight >= weightL)
        //  {
        //    s += 3;
        //  }  
        //  else
        //  {
        //    println("No change to score from weight");
        //  }  
          score += s;
        //  // TO DO : add score increase based on color
          }
      }
      break;
      
      case GAME_END :
        println("case: game instruction");
        println("received: "  + f[0]);      
        if (Integer.parseInt(f[0]) == 0) 
        {
          println("change game state to game title");
          gameState = GAME_TITLE;
        }      
        //myPort.clear();
      break;
      
      default :
        println("nothing happened");
      break;
    }
  }
}
