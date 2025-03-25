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
  int[] c;               // fish color
  int[] w;               // fish weight

  int weightL;           // Lower weight bound
  int weightM;           // middle weight bound
  int tweightU;          // Upper weight bound
  

  int red;
  int green;
  int white;
  int yellow;
  int black;
  
  void PortHandler(Serial p) 
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
    println("check buffer");
    myString = new String(inBuffer);

    f = splitTokens(myString, "&");
    c = Integer.parseInt(splitTokens(myString, "C")); // Convert string value to integer
    w = Integer.parseInt(splitTokens(myString, "W")); // Convert string value to integer
    
    switch (fishquest.gameState) 
    {
      case fishquest.GAME_TITLE :
      println("case: game title");
      println("received: "  + f[0]);
        if (f[0] == "3") 
        {
          println("change game state to game instruction");
          fishquest.gameState = fishquest.GAMEINSTRUCTION;
        }
        else
        {
          println("No change in game state: Title Screen");
        }
      break;
        
      case fishquest.GAMEINSTRUCTION :
      println("case: game instruction" + f[0]);
      println("received: "  + f[0]);
        if (f[0] == "1") 
        { 
          println("change game state to play mode");
          fishquest.gameState = fishquest.PLAYMODE;
        }
        else 
        {
          println("No change in game state: Game Instruction");
        }
      break;
       
      case fishquest.PLAYMODE :
      println("case: playmode");
      println("weight: " + w[0]);
        // Check info received about fish
        if (w[0] >= weightL && w[0] < weightM) 
        {
          fishquest.score += 1;
        }
        else if (w[0] >= weightM && w[0] < weightL)
        {
          fishquest.score += 2;
        }
        else if (w[0] >= weightL)
        {
          fishquest.score += 3;
        }  
        else
        {
          println("No change to score from weight");
        }  
        
        // TO DO : add score increase based on color
      break;
      
      case fishquest.GAME_END :
      println("case: game instruction" + f[0]);
      println("received: "  + f[0]);      
        if (f[0] == "0") 
        {
          println("change game state to game title");
          fishquest.gameState = fishquest.GAME_TITLE;
        }      
      break; 
    } 
}
