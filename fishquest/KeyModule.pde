void mouseClicked() 
{
  click.play(0);
  switch (gameState) 
  {
    case GAME_TITLE :
      gameState = GAMEINSTRUCTION;     
      break;
    case GAMEINSTRUCTION :
      gameState = PLAYMODE;
      break;
    case PLAYMODE : 
      score++;
      break;
    case GAME_END : 
      gameState = GAME_TITLE;
      timeCountDown = 10 *60;
      break;
  }
}
