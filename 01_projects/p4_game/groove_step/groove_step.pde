import processing.sound.*;
SoundFile correctSound;
SoundFile wrongSound;
SoundFile gameMusic;

int TITLE = 0;
int GAME = 1;
int GAMEOVER = 2;
int ENTER_INITIALS = 3;
int gameState = TITLE;
int CONTINUE = 4;

PImage idleMC, mistakeMC, leftDanceMC, rightDanceMC, upDanceMC, downDanceMC;
PImage arrowUp, arrowDown, arrowLeft, arrowRight;
PImage heartFull, heartEmpty, starPowerup, danceFloor;

ArrayList<Prompt> prompts = new ArrayList<Prompt>();

int lives = 3;
int maxLives = 3;
int displayTime = 0;
int score = 0;
boolean powerUpAvailable = false;
boolean powerUpActive = false;
int powerUpTimer = 0;
int powerUpDuration = 300;

Table highscores;
String playerInitials = "";
int maxInitialsLength = 3;
boolean ignoreNextKey = false;

boolean underscoreVisible = true;
int underscoreTimer = 0;
int underscoreSpeed = 30;
float shakeX = 0;
float shakeY = 0;
int shakeTimer = 0;
int credits = 0;

int continueTimer = 0;
boolean continueCreditInserted = false;

final int GAME_WIDTH = 800;
final int GAME_HEIGHT = 785;

void setup() {
  fullScreen();
  noSmooth();

  idleMC = loadImage("idleMC.png");
  mistakeMC = loadImage("mistakeMC.png");
  leftDanceMC = loadImage("leftDanceMC.png");
  rightDanceMC = loadImage("rightDanceMC.png");
  upDanceMC = loadImage("upDanceMC.png");
  downDanceMC = loadImage("downDanceMC.png");

  arrowUp = loadImage("arrowUp.png");
  arrowDown = loadImage("arrowDown.png");
  arrowLeft = loadImage("arrowLeft.png");
  arrowRight = loadImage("arrowRight.png");

  heartFull = loadImage("heartFull.png");
  heartEmpty = loadImage("heartEmpty.png");
  starPowerup = loadImage("star.png");
  danceFloor = loadImage("dancefloor.png");

  try {
    highscores = loadTable("highscores.csv", "header,csv");
  } catch (Exception e) {
    highscores = new Table();
    highscores.addColumn("initials");
    highscores.addColumn("score");
    saveTable(highscores, "data/highscores.csv");
  }

  correctSound = new SoundFile(this, "correctarrow.mp3");
  wrongSound = new SoundFile(this, "mistakearrow.wav");
  gameMusic = new SoundFile(this, "gamemusic.mp3");
  gameMusic.amp(0.1);
  
}

void draw() {
  float scaleFactor = min((float) width / GAME_WIDTH, (float) height / GAME_HEIGHT);
  float scaledWidth = GAME_WIDTH * scaleFactor;
  float scaledHeight = GAME_HEIGHT * scaleFactor;
  float offsetX = (width - scaledWidth) / 2;
  float offsetY = (height - scaledHeight) / 2;

  background(0);
  noStroke();
  fill(0);
  rect(0, 0, width, offsetY);
  rect(0, height - offsetY, width, offsetY);
  rect(0, 0, offsetX, height);
  rect(width - offsetX, 0, offsetX, height);

  pushMatrix();
  translate(offsetX, offsetY);
  scale(scaleFactor);

  underscoreTimer++;
  if (underscoreTimer >= underscoreSpeed) {
    underscoreVisible = !underscoreVisible;
    underscoreTimer = 0;
  }

  if (gameState == TITLE) drawTitleScreen();
  else if (gameState == GAME) drawGameScreen();
  else if (gameState == GAMEOVER) drawGameOverScreen();
  else if (gameState == ENTER_INITIALS) drawEnterInitialsScreen();
  
  if (gameState == CONTINUE) {
  drawContinueScreen();
  if (!continueCreditInserted) {
    continueTimer--;
    if (continueTimer <= 0) gameState = ENTER_INITIALS;
  }
}

  popMatrix();
}

void drawCredits() {
  pushStyle();
  fill(255);
  textAlign(LEFT, BOTTOM);
  textSize(16);
  text("CREDITS: " + credits, 10, GAME_HEIGHT - 10);
  popStyle();
}

void drawTitleScreen() {
  if (gameMusic.isPlaying()) gameMusic.stop();
  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("GROOVE STEP!", GAME_WIDTH/2, GAME_HEIGHT/2);
  
  textSize(24);
  if (credits == 0) {
    text("INSERT COIN (P)", GAME_WIDTH/2, GAME_HEIGHT/2 + 60);
  } else {
    text("PRESS SPACE TO START", GAME_WIDTH/2, GAME_HEIGHT/2 + 60);
  }

  drawCredits();
}

void drawGameScreen() {
  drawCredits();
  image(danceFloor, 0, 0);

  shakeScreen();
  pushMatrix();
  translate(shakeX, shakeY);
  
  int heartSpacing = 50;

  for (int i=0; i<maxLives; i++) {
    int heartX = 10 + i * heartSpacing;
    int heartY = 10;
    if (i < lives) image(heartFull, heartX, heartY);
    else image(heartEmpty, heartX, heartY);
  }

  fill(255);
  textAlign(LEFT, TOP);
  textSize(32);
  text("Score: " + score, 10, 50);

  if (powerUpAvailable) image(starPowerup, GAME_WIDTH - 60, 10);

  image(idleMC, GAME_WIDTH/2 - idleMC.width/2, GAME_HEIGHT/2 - idleMC.height/2);

  if (powerUpActive) {
    powerUpTimer--;
    float puBarWidth = map(powerUpTimer, 0, powerUpDuration, 0, GAME_WIDTH * 0.95);
    float puBarHeight = 15;
    fill(255, 255, 0);
    rect((GAME_WIDTH - puBarWidth)/2, GAME_HEIGHT - 40 - puBarHeight, puBarWidth, puBarHeight);

    if (powerUpTimer <= 0) {
      powerUpActive = false;
      powerUpTimer = 0;
    }
  }

  if (prompts.size() == 0) spawnArrow();

  for (int i = prompts.size()-1; i >= 0; i--) {
    Prompt p = prompts.get(i);
    p.update();
    
    float arrowX = GAME_WIDTH/2 - p.sprite.width/2;
    float arrowY = 0;
    image (p.sprite, arrowX, arrowY);

    float barWidth = map(p.lifetime, 0, 120, 0, GAME_WIDTH*0.95);
    float barHeight = 20;
    fill(0, 255, 0);
    rect((GAME_WIDTH - barWidth)/2, GAME_HEIGHT - barHeight - 10, barWidth, barHeight);

    if (!p.active && p.lifetime <= 0) {
      prompts.remove(i);
      idleMC = mistakeMC;
      displayTime = 15;
      wrongSound.play();
      shakeTimer = 3;
      lives--;
      
      if (lives <= 0) {
        gameMusic.stop();
        gameState = CONTINUE;
        continueTimer = 600;
      }
      
    }
  }

  if (displayTime > 0) displayTime--;
  else idleMC = loadImage("idleMC.png");

  popMatrix();
}

void keyPressed() {
  
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
      if (!gameMusic.isPlaying()) gameMusic.loop();
      continueCreditInserted = false;
      return;
    }
  }

  if (key == 'p' || key == 'P') { credits++; return; }

  if (gameState == ENTER_INITIALS) {
    if (key == BACKSPACE && playerInitials.length() > 0) playerInitials = playerInitials.substring(0, playerInitials.length()-1);
    else if ((key >= 'A' && key <= 'Z' || key >= 'a' && key <= 'z') && playerInitials.length() < maxInitialsLength) playerInitials += Character.toUpperCase(key);
    else if (key == ' ') {
      TableRow newRow = highscores.addRow();
      newRow.setString("initials", playerInitials);
      newRow.setInt("score", score);
      saveTable(highscores, "data/highscores.csv");
      gameState = GAMEOVER;
    }
    return;
  }

  if (gameState == TITLE && key == ' ' && credits > 0) {
    credits--; resetGame(); gameState = GAME;
    if (!gameMusic.isPlaying()) gameMusic.loop();
    ignoreNextKey = true; return;
  }

  if (gameState == GAMEOVER && key == ' ' && credits > 0) {
    credits--; resetGame(); gameState = GAME;
    if (!gameMusic.isPlaying()) gameMusic.loop();
    ignoreNextKey = true; return;
  }

  if (gameState == GAME && powerUpAvailable && key == ' ') {
    powerUpActive = true; powerUpAvailable = false; powerUpTimer = powerUpDuration; return;
  }

  if (ignoreNextKey) { ignoreNextKey = false; return; }

  if (gameState == GAME && prompts.size() > 0) {
    Prompt p = prompts.get(0);
    boolean correct = false;

    if ((key == 'w' || key == 'W') && p.type.equals("up")) { correct = true; idleMC = upDanceMC; }
    else if ((key == 's' || key == 'S') && p.type.equals("down")) { correct = true; idleMC = downDanceMC; }
    else if ((key == 'a' || key == 'A') && p.type.equals("left")) { correct = true; idleMC = leftDanceMC; }
    else if ((key == 'd' || key == 'D') && p.type.equals("right")) { correct = true; idleMC = rightDanceMC; }

    displayTime = 15;

    if (correct) {
      
      score += (powerUpActive) ? 10 : 5;
      correctSound.play();
      prompts.remove(0);
      spawnArrow();
      if (score % 200 == 0) powerUpAvailable = true;
      
    } else {
      
      idleMC = mistakeMC;
      wrongSound.play();
      shakeTimer = 3;
      lives--;
      
      if (lives <= 0) {
        
        gameMusic.stop();
        gameState = CONTINUE;
        continueTimer = 600;
        
      }
    }
  }
}

void spawnArrow() {
  String[] types = {"up", "down", "left", "right"};
  String randomType = types[int(random(4))];
  prompts.add(new Prompt(randomType));
}

void drawGameOverScreen() {
  if (gameMusic.isPlaying()) gameMusic.stop();

  fill(255, 0, 0);
  textAlign(CENTER);
  textSize(40);
  text("GAME OVER", GAME_WIDTH/2, GAME_HEIGHT/2 - 100);

  int rowCount = highscores.getRowCount();
  TableRow[] topRows = new TableRow[min(5, rowCount)];
  TableRow[] allRows = new TableRow[rowCount];
  for (int i = 0; i < rowCount; i++) allRows[i] = highscores.getRow(i);

  for (int i = 0; i < topRows.length; i++) {
    int maxIndex = -1;
    int maxScore = -1;
    for (int j = 0; j < allRows.length; j++) {
      if (allRows[j] != null && allRows[j].getInt("score") > maxScore) {
        maxScore = allRows[j].getInt("score");
        maxIndex = j;
      }
    }
    if (maxIndex != -1) { topRows[i] = allRows[maxIndex]; allRows[maxIndex] = null; }
  }

  fill(255);
  textAlign(LEFT, TOP);
  textSize(24);
  text("Top 5 Player Scores:", GAME_WIDTH/2 - 100, GAME_HEIGHT/2 - 50);

  for (int i = 0; i < topRows.length; i++) {
    TableRow r = topRows[i];
    text((i+1) + ". " + r.getString("initials") + " - " + r.getInt("score"), GAME_WIDTH/2 - 100, GAME_HEIGHT/2 - 20 + i*30);
  }

  textSize(20);
  textAlign(CENTER);
  text("Press SPACE to play again", GAME_WIDTH/2, GAME_HEIGHT - 60);

  drawCredits();
}

void drawEnterInitialsScreen() {
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("NEW HIGH SCORE: " + score, GAME_WIDTH/2, GAME_HEIGHT/2 - 40);
  text("ENTER YOUR INITIALS:", GAME_WIDTH/2, GAME_HEIGHT/2);

  String displayInitials = playerInitials;
  if (underscoreVisible && playerInitials.length() < maxInitialsLength) displayInitials += "_";

  text(displayInitials, GAME_WIDTH/2, GAME_HEIGHT/2 + 40);

  drawCredits();
}

void resetGame() {
  lives = maxLives;
  score = 0;
  prompts.clear();
  powerUpActive = false;
  powerUpAvailable = false;
  powerUpTimer = 0;
  playerInitials = "";
  ignoreNextKey = false;
}

void shakeScreen() {
  if (shakeTimer > 0) {
    shakeX = random(-5, 5);
    shakeY = random(-5, 5);
    shakeTimer--;
  } else {
    shakeX = 0;
    shakeY = 0;
  }
}

void drawContinueScreen() {
  
  background (0);
  fill (255);
  textAlign (CENTER, CENTER);
  textSize (40);
  text ("CONTINUE?", GAME_WIDTH/2, GAME_HEIGHT/2 - 40);
  
  textSize (24);
  
  if (!continueCreditInserted) {
    
    text ("INSERT COIN (P) TO CONTINUE", GAME_WIDTH/2, GAME_HEIGHT/2 + 20);
    text("Time left: " + continueTimer/60, GAME_WIDTH/2, GAME_HEIGHT/2 + 60);
    
  } else {
    
    text("PRESS SPACE TO CONTINUE", GAME_WIDTH/2, GAME_HEIGHT/2 + 20);
    
  }
  
  drawCredits();
  
}

class Prompt {
  PImage sprite;
  String type;
  boolean active = true;
  int lifetime = 120;

  Prompt(String type) {
    this.type = type; 
    if (type.equals("up")) sprite = arrowUp;
    else if (type.equals("down")) sprite = arrowDown;
    else if (type.equals("left")) sprite = arrowLeft;
    else if (type.equals("right")) sprite = arrowRight;
  }

  void update() {
    lifetime--;
    if (lifetime <= 0) active = false;
  }

  void display() {
    image(sprite, GAME_WIDTH/2 - sprite.width/2, 150);
  }
}
