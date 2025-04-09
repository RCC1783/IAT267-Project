///* TO DO : Right now this class is directly accessing variables in fishquest
//*          which is not good practice :( So its probably a good idea to either
//*          make setters and getters in fishquest or just have the methods here
//*          return the values to be changed and let fishquest handle any changes.
//*          Personally I think it makes more sense for porthandler to return values.
//*          But for now I just needed to have a class dealing with the communication
//*          stuff, and we can finetune it later - Jules
//*/

//class PortHandler 
//{
//  byte[] inBuffer;       // buffer of fish
//  String myString;       // buffer string
//  String[] f;            // fish packet
//  String[] c;               // fish color
//  String[] w;               // fish weight
//  int weightL;           // Lower weight bound
//  int weightM;           // middle weight bound
//  int tweightU;          // Upper weight bound
  
//  String[] r;
//  String[] g;
//  String[] b;
  
//  PortHandler() 
//  {
//    inBuffer = new byte[255];
    
//    // TO DO : Change to values reflecting actual weight
//    weightL = 10; 
//    weightM = 20; 
//    tweightU = 30; 
//  }
  
//  // Check for signal from arduino to change game state
//  // Or check for information on caught fish
//  void checkBuffer()
//  {
//    println("checking buffer");
//    if (myPort.available() > 0) 
//    {
//      myPort.readBytesUntil('&', inBuffer);
//      if (inBuffer != null) {
//        println("in buffer " + inBuffer);
//        println("check buffer");
//        myString = new String(inBuffer);
//        //String[] useableString = splitTokens(myString, "&");
//        println("buffer string " + myString);
//        f = splitTokens(myString, "&");
//        c = splitTokens(f[0], "C"); // Convert string value to integer (color)
//        w = splitTokens(f[0], "W"); // Convert string value to integer
//        r = splitTokens(c[0], "R"); // Grab RED color value
//        g = splitTokens(c[0], "G"); // Grab GREEN color value
//        b = splitTokens(c[0], "B"); // Grab BLUE color value
        
//      }
//      switch (gameState) 
//      {
//        case GAME_TITLE :
//        println("case: game title");
//        println("received: "  + f[0]);
//          if (f[0] == "3") 
//          {
//            println("change game state to game instruction");
//            gameState = GAMEINSTRUCTION;
//            myPort.write(gameState);
//          }
//          else
//          {
//            println("No change in game state: Title Screen");
//          }
//          myPort.clear();
//          //inBuffer = new byte[255];
//          //myString =  "";
//        break;
          
//        case GAMEINSTRUCTION :
//        println("case: game instruction " + f[0]);
//        println("received: "  + f[0]);
//          if (Integer.parseInt(f[0]) == 1) 
//          { 
//            println("change game state to play mode");
//            gameState = PLAYMODE;
//            myPort.write(gameState);
//          }
//          else 
//          {
//            println("No change in game state: Game Instruction");
//          }
//          myPort.clear();
//          //inBuffer = new byte[255];
//          //myString =  "";
          
//        break;
         
//        case PLAYMODE :
//        {
//          int s = 0;
//          println("case: playmode");
//          if (millis() >= weighTimeStart + weighTimeMax) {
            
//          int weight = Integer.parseInt(w[0]);
//          //int colorr = Integer.parseInt(c[0]);
    
//    // Checking Color
//          int diff = 20;
//          println("color: " +Integer.parseInt(r[0])+ ", " +Integer.parseInt(g[0])+ ", " + Integer.parseInt(b[0]));
//              if ((Integer.parseInt(r[0]) < gameR + diff && Integer.parseInt(r[0]) > gameR - diff) &&
//                  (Integer.parseInt(g[0]) < gameG + diff && Integer.parseInt(g[0]) > gameG - diff) &&
//                  (Integer.parseInt(b[0]) < gameB + diff && Integer.parseInt(b[0]) > gameB - diff) ) { 
//                    s += 3; 
//                    ChangeFishColour();
//              } else {s+=1;}
    
//          //if(colorr == num) {
//          //  score += 2;
//          //}
          
          
          
//          //Weight-based scoring
//          println("weight: " + weight);
//            // Check info received about fish
//            if (weight >= weightL && weight < weightM) 
//            {
//              s += 1;
//            }
//            else if (weight >= weightM && weight < weightL)
//            {
//              s += 2;
//            }
//            else if (weight >= weightL)
//            {
//              s += 3;
//            }  
//            else
//            {
//              println("No change to score from weight");
//            }  
//            score += s;
//            // TO DO : add score increase based on color
//            }
//        }
//        break;
        
//        case GAME_END :
//        println("case: game instruction" + f[0]);
//        println("received: "  + f[0]);      
//          if (f[0] == "0") 
//          {
//            println("change game state to game title");
//            gameState = GAME_TITLE;
//            myPort.write(gameState);
//          }      
//        break;
        
//        default :
//        println("nothing happened");
//        break;
//      }
//    }
//  }
//}
