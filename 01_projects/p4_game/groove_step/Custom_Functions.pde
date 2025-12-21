//Draws credit amount in bottom-right of screen constantly.
void drawCredits () {
  
  pushStyle ();
  fill (255);
  textAlign (LEFT, BOTTOM);
  textSize (16);
  text ("CREDITS: " + credits, 10, GAME_HEIGHT - 10);
  popStyle ();
  
}

//Draws title screen text.
void drawTitleScreen() {
  
  fill (255);
  textAlign (CENTER, CENTER);
  textSize (40);
  text ("GROOVE STEP!", GAME_WIDTH/2, GAME_HEIGHT/2);
  textSize (24);
  
  if (credits == 0) {
    
    text ("INSERT COIN (P)", GAME_WIDTH/2, GAME_HEIGHT/2 + 60);
    
  } else {
    
    text ("PRESS SPACE TO START", GAME_WIDTH/2, GAME_HEIGHT/2 + 60);
    
  }

  drawCredits ();
  
}

//Draws main game screen assets, sprites, prompts, and more.
void drawGameScreen() {
  
  drawCredits ();
  image (danceFloor, 0, 0);
  shakeScreen ();
  pushMatrix ();
  translate (shakeX, shakeY);
  
  int heartSpacing = 50;

//Displays lives on top-right of screen.
  for (int i=0; i<player.maxLives; i++) {
    
    int heartX = 10 + i * heartSpacing;
    int heartY = 10;
    if (i < player.lives) image (heartFull, heartX, heartY);
    else image (heartEmpty, heartX, heartY);
    
  }

//Displays score amount on top-left of screen.
  fill (255);
  textAlign (LEFT, TOP);
  textSize (32);
  text ("Score: " + player.score, 10, 50);

//Power-up display.
  if (powerUpAvailable) image (starPowerup, GAME_WIDTH - 60, 10);
  image (idleMC, GAME_WIDTH / 2 - idleMC.width / 2, GAME_HEIGHT / 2 - idleMC.height / 2);

//Power-up timer bar.
  if (powerUpActive) {
    
    powerUpTimer--;
    float puBarWidth = map (powerUpTimer, 0, powerUpDuration, 0, GAME_WIDTH * 0.95);
    float puBarHeight = 15;
    fill (255, 255, 0);
    rect ((GAME_WIDTH - puBarWidth) / 2, GAME_HEIGHT - 40 - puBarHeight, puBarWidth, puBarHeight);

    if (powerUpTimer <= 0) {
      
      powerUpActive = false;
      powerUpTimer = 0;
      
    }
    
  }

  if (prompts.size () == 0) spawnArrow ();

//Arrow displays.
  for (int i = prompts.size () - 1; i >= 0; i--) {
    
    Prompt p = prompts.get (i);
    p.update ();
    float arrowX = GAME_WIDTH / 2 - p.sprite.width / 2;
    float arrowY = 0;
    image (p.sprite, arrowX, arrowY);
    float barWidth = map (p.lifetime, 0, 120, 0, GAME_WIDTH * 0.95);
    float barHeight = 20;
    fill (0, 255, 0);
    rect ((GAME_WIDTH - barWidth) / 2, GAME_HEIGHT - barHeight - 10, barWidth, barHeight);

    if (!p.active && p.lifetime <= 0) {
      
      prompts.remove (i);
      idleMC = mistakeMC;
      displayTime = 15;
      wrongSound.play ();
      shakeTimer = 3;
      player.loseLife ();
      
      if (player.lives <= 0) {
        
        gameState = CONTINUE;
        continueTimer = 600;
        
      }
      
    }
    
  }

  if (displayTime > 0) displayTime--;
  else idleMC = loadImage ("idleMC.png");

  popMatrix();
}

//Function for keys pressed on every screen (WASD, P, Space).
void keyPressed() {
  
//Credits input (P).
  if (gameState == CONTINUE) {
    
    if (!continueCreditInserted && (key == 'p' || key == 'P') && credits > 0) {
      
      credits--;
      continueCreditInserted = true;
      continueTimer = 0;
      return;
      
    } 
    
    else if (continueCreditInserted && key == ' ') {
      
      resetGame();
      gameState = GAME;
      continueCreditInserted = false;
      return;
      
    }
    
  }

  if (key == 'p' || key == 'P') { credits++; return; }

//Entering initials and saving to leaderboard.
  if (gameState == ENTER_INITIALS) {
    
    if (key == BACKSPACE && playerInitials.length() > 0) playerInitials = playerInitials.substring (0, playerInitials.length ()-1);
    
    else if ((key >= 'A' && key <= 'Z' || key >= 'a' && key <= 'z') && playerInitials.length () < maxInitialsLength) playerInitials += Character.toUpperCase(key);
   
    else if (key == ' ') {
      
      TableRow newRow = highscores.addRow ();
      newRow.setString ("initials", playerInitials);
      newRow.setInt ("score", player.score);
      saveTable (highscores, "data/highscores.csv");
      gameState = GAMEOVER;
      
    }
    
    return;
    
  }

  if (gameState == TITLE && key == ' ' && credits > 0) {
    
    credits--; resetGame (); gameState = GAME;
    ignoreNextKey = true; return;
    
  }

  if (gameState == GAMEOVER && key == ' ' && credits > 0) {
    
    credits--; resetGame (); gameState = GAME;
    ignoreNextKey = true; return;
    
  }

  if (gameState == GAME && powerUpAvailable && key == ' ') {
    
    powerUpActive = true; powerUpAvailable = false; powerUpTimer = powerUpDuration; return;
    
  }

  if (ignoreNextKey) { ignoreNextKey = false; return; }

//Game controls (WASD).
  if (gameState == GAME && prompts.size () > 0) {
    
    Prompt p = prompts.get (0);
    boolean correct = false;

    if ((key == 'w' || key == 'W') && p.type.equals ("up") ) { correct = true; idleMC = upDanceMC; }
    else if ((key == 's' || key == 'S') && p.type.equals ("down") ) { correct = true; idleMC = downDanceMC; }
    else if ((key == 'a' || key == 'A') && p.type.equals ("left") ) { correct = true; idleMC = leftDanceMC; }
    else if ((key == 'd' || key == 'D') && p.type.equals ("right") ) { correct = true; idleMC = rightDanceMC; }

    displayTime = 15;

//Correct and incorrect arrow input.
    if (correct) {
      
      player.score += (powerUpActive) ? 10 : 5;
      correctSound.play ();
      prompts.remove (0);
      spawnArrow ();
      if (player.score % 200 == 0) powerUpAvailable = true;
      
    } else {
      
      idleMC = mistakeMC;
      wrongSound.play ();
      shakeTimer = 3;
      player.loseLife ();
      
      if (player.lives <= 0) {
        
        gameState = CONTINUE;
        continueTimer = 600;
        
      }
      
    }
    
  }
  
}

//Randomly spawns arrows one at a time.
void spawnArrow () {
  
  String[] types = {"up", "down", "left", "right"};
  String randomType = types [int(random (4))];
  prompts.add (new Prompt (randomType) );
  
}

//Draws the game over screen.
void drawGameOverScreen () {

  fill (255, 0, 0);
  textAlign (CENTER);
  textSize (40);
  text ("GAME OVER", GAME_WIDTH/2, GAME_HEIGHT/2 - 100);

//Displays top 5 scores on leaderboard.
  int rowCount = highscores.getRowCount ();
  TableRow [] topRows = new TableRow [min(5, rowCount)];
  TableRow [] allRows = new TableRow [rowCount];
  for (int i = 0; i < rowCount; i++) allRows [i] = highscores.getRow(i);

  for (int i = 0; i < topRows.length; i++) {
    
    int maxIndex = -1;
    int maxScore = -1;
    
    for (int j = 0; j < allRows.length; j++) {
      
      if (allRows [j] != null && allRows [j].getInt ("score") > maxScore) {
        
        maxScore = allRows [j].getInt ("score");
        maxIndex = j;
        
      }
      
    }
    
    if (maxIndex != -1) { topRows[i] = allRows[maxIndex]; allRows[maxIndex] = null; }
    
  }

  fill(255);
  textAlign(LEFT, TOP);
  textSize(24);
  text("Top 5 Player Scores:", GAME_WIDTH / 2 - 100, GAME_HEIGHT / 2 - 50);

  for (int i = 0; i < topRows.length; i++) {
    TableRow r = topRows [i];
    text ( (i+1) + ". " + r.getString ("initials") + " - " + r.getInt ("score"), GAME_WIDTH / 2 - 100, GAME_HEIGHT / 2 - 20 + i * 30);
  }

  textSize (20);
  textAlign (CENTER);
  text ("Press SPACE to play again", GAME_WIDTH / 2, GAME_HEIGHT - 60);

  drawCredits();
  
}

//Draws leaderboard entry screen.
void drawEnterInitialsScreen () {
  
  fill (255);
  textAlign (CENTER);
  textSize (32);
  text ("NEW HIGH SCORE: " + player.score, GAME_WIDTH / 2, GAME_HEIGHT / 2 - 40);
  text ("ENTER YOUR INITIALS:", GAME_WIDTH / 2, GAME_HEIGHT / 2);
  String displayInitials = playerInitials;
  if (underscoreVisible && playerInitials.length () < maxInitialsLength) displayInitials += "_";
  text (displayInitials, GAME_WIDTH / 2, GAME_HEIGHT / 2 + 40);

  drawCredits();
}

//Function for reseting the game.
void resetGame () {
  
  player.reset ();
  prompts.clear ();
  powerUpActive = false;
  powerUpAvailable = false;
  powerUpTimer = 0;
  playerInitials = "";
  ignoreNextKey = false;
  
}

//Screen shake function on mistake.
void shakeScreen () {
  
  if (shakeTimer > 0) {
    
    shakeX = random (-5, 5);
    shakeY = random (-5, 5);
    shakeTimer--;
    
  } else {
    
    shakeX = 0;
    shakeY = 0;
    
  }
  
}

//Draws continue screen WITH timer and prompts.
void drawContinueScreen () {
  
  background (0);
  fill (255);
  textAlign (CENTER, CENTER);
  textSize (40);
  text ("CONTINUE?", GAME_WIDTH / 2, GAME_HEIGHT / 2 - 40);
  
  textSize (24);
  
  if (!continueCreditInserted) {
    
    text ("INSERT COIN (P) TO CONTINUE", GAME_WIDTH / 2, GAME_HEIGHT / 2 + 20);
    text("Time left: " + continueTimer / 60, GAME_WIDTH / 2, GAME_HEIGHT / 2 + 60);
    
  } else {
    
    text ("PRESS SPACE TO CONTINUE", GAME_WIDTH / 2, GAME_HEIGHT / 2 + 20);
    
  }
  
  drawCredits ();
  
}
