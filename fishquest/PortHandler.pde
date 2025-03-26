/* TO DO : Right now this class is directly accessing variables in fishquest
*          which is not good practice :( So its probably a good idea to either
*          make setters and getters in fishquest or just have the methods here
*          return the values to be changed and let fishquest handle any changes.
*          Personally I think it makes more sense for porthandler to return values.
*          But for now I just needed to have a class dealing with the communication
*          stuff, and we can finetune it later - Jules
*/

class PortHandler 
{
  Serial port;
  byte[] inBuffer;       // buffer of fish
  String myString;       // buffer string
  String[] f;            // fish packet
  String[] c;               // fish color
  String[] w;               // fish weight

  int weightL;           // Lower weight bound
  int weightM;           // middle weight bound
  int tweightU;          // Upper weight bound
  

  int red;
  int green;
  int white;
  int yellow;
  int black;
  
  PortHandler(Serial p) 
  {
    port = p;
    inBuffer = new byte[255];
    
    // TO DO : Change to values reflecting actual weight
    weightL = 10; 
    weightM = 20; 
    tweightU = 30; 
  }
  
  // Check for signal from arduino to change game state
  // Or check for information on caught fish
  void checkBuffer()
  {
    if (myPort.available() > 0) 
    {
      myPort.readBytesUntil('&', inBuffer);
      if (inBuffer != null) {
        println("in buffer " + inBuffer);
        println("check buffer");
        myString = new String(inBuffer);
        //String[] useableString = splitTokens(myString, "&");
        println("buffer string " + myString);
        f = splitTokens(myString, "&");
        c = splitTokens(f[0], "C"); // Convert string value to integer
        w = splitTokens(f[0], "W"); // Convert string value to integer
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
        break;
          
        case GAMEINSTRUCTION :
        println("case: game instruction" + f[0]);
        println("received: "  + f[0]);
          if (Integer.parseInt(f[0]) == 1) 
          { 
            println("change game state to play mode");
            gameState = PLAYMODE;
          }
          else 
          {
            println("No change in game state: Game Instruction");
          }
        break;
         
        case PLAYMODE :
        println("case: playmode");
        println("weight: " + w[0]);
          // Check info received about fish
          if (Integer.parseInt(w[0]) >= weightL && Integer.parseInt(w[0]) < weightM) 
          {
            score += 1;
          }
          else if (Integer.parseInt(w[0]) >= weightM && Integer.parseInt(w[0]) < weightL)
          {
            score += 2;
          }
          else if (Integer.parseInt(w[0]) >= weightL)
          {
            score += 3;
          }  
          else
          {
            println("No change to score from weight");
          }  
          
          // TO DO : add score increase based on color
        break;
        
        case GAME_END :
        println("case: game instruction" + f[0]);
        println("received: "  + f[0]);      
          if (f[0] == "0") 
          {
            println("change game state to game title");
            gameState = GAME_TITLE;
          }      
        break;
        
        default :
        println("nothing happened");
        break;
      }
    }
  }
}
