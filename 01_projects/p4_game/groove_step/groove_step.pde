//Variables for different screens/states.
int TITLE = 0;
int GAME = 1;
int GAMEOVER = 2;
int ENTER_INITIALS = 3;

int gameState = TITLE;

//Sprites.
PImage idleMC, mistakeMC, leftDanceMC, rightDanceMC, upDanceMC, downDanceMC;
PImage arrowUp, arrowDown, arrowLeft, arrowRight;
PImage heartFull, heartEmpty, starPowerup, danceFloor;

ArrayList<Prompt> prompts = new ArrayList<Prompt>();

//Variables for in-game features.
int lives = 3;
int maxLives = 3;
int displayTime = 0;
int score = 0;

boolean powerUpAvailable = false;
boolean powerUpActive = false;

//Power-up timer.
int powerUpTimer = 0;
int powerUpDuration = 300; // 5 seconds (60 FPS * 5)

//Highscore variables.
Table highscores;
String playerInitials = ""; // store initials as they are typed
int maxInitialsLength = 3;

//Ignore first key press after (re)starting game.
boolean ignoreNextKey = false;

void setup() {
  size(800, 800);

  //Sprites being loaded.
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
}

void draw() {
  if (gameState == TITLE) drawTitleScreen();
  else if (gameState == GAME) drawGameScreen();
  else if (gameState == GAMEOVER) drawGameOverScreen();
  else if (gameState == ENTER_INITIALS) drawEnterInitialsScreen();
}

void drawTitleScreen() {
  background(0);
  textAlign(CENTER);
  textSize(40);
  fill(255);
  text("GROOVE STEP!", width/2, height/2);
  text("Press P to Insert Coin", width/2, height/2 + 60);
}

void drawGameScreen() {
  background(0);
  image(danceFloor, 0, 0);

  //Drawing the hearts/lives.
  for (int i=0; i<maxLives; i++){
    if (i < lives) image(heartFull, -100*i, 0);
    else image(heartEmpty, -100*i, 0);
  }

  //The score on the top-left.
  fill(255);
  textAlign(LEFT, TOP);
  textSize(32);
  text("Score: " + score, 10, 10);

  //Creating the power-up.
  if (powerUpAvailable) {
    image(starPowerup, 0, 0);
  }

  //Character idle sprite placement.
  image(idleMC, 0, 0);

  //Power-up timer countdown and bar.
  if (powerUpActive) {
    powerUpTimer--;
    float puBarWidth = map(powerUpTimer, 0, powerUpDuration, 0, width * 0.95);
    float puBarHeight = 15;
    fill(255, 255, 0);
    rect((width - puBarWidth) / 2, height - 40 - puBarHeight, puBarWidth, puBarHeight);

    if (powerUpTimer <= 0) {
      powerUpActive = false;
      powerUpTimer = 0;
    }
  }

  //Arrow functions.
  if (prompts.size() == 0) {
    spawnArrow();
  }

  for (int i = prompts.size()-1; i >= 0; i--) {
    Prompt p = prompts.get(i);
    p.update();
    p.display();

    //Timer.
    float barWidth = map(p.lifetime, 0, 120, 0, width*0.95);
    float barHeight = 20;
    fill(0, 255, 0);
    rect((width-barWidth)/2, height-barHeight-10, barWidth, barHeight);

    //If the player misses an arrow, remove a life.
    if (!p.active && p.lifetime <= 0) {
      prompts.remove(i);
      lives--;
      if (lives <= 0) gameState = ENTER_INITIALS;
    }
  }

  if (displayTime > 0) displayTime--;
  else idleMC = loadImage("idleMC.png");
}

void keyPressed() {
  if ((gameState == TITLE || gameState == GAMEOVER) && (key == 'p' || key == 'P')) {
    resetGame();
    gameState = GAME;
    ignoreNextKey = true;
    return;
  }

  if (gameState == ENTER_INITIALS) {
    if (key == BACKSPACE && playerInitials.length() > 0) {
      playerInitials = playerInitials.substring(0, playerInitials.length()-1);
    } else if ((key >= 'A' && key <= 'Z' || key >= 'a' && key <= 'z') && playerInitials.length() < maxInitialsLength) {
      playerInitials += Character.toUpperCase(key);
    } else if (keyCode == ENTER || keyCode == RETURN) {
      TableRow newRow = highscores.addRow();
      newRow.setString("initials", playerInitials);
      newRow.setInt("score", score);
      saveTable(highscores, "data/highscores.csv");

      resetGame();
      gameState = GAMEOVER;
    }
    return;
  }

  if (gameState == GAME && powerUpAvailable && key == ' ') {
    powerUpActive = true;
    powerUpAvailable = false;
    powerUpTimer = powerUpDuration;
    return;
  }

  if (ignoreNextKey) {
    ignoreNextKey = false;
    return;
  }

  if (gameState == GAME && prompts.size() > 0) {
    Prompt p = prompts.get(0);
    boolean correct = false;
    if (key == ' ') return;

    if ((key == 'w' || key == 'W') && p.type.equals("up")) { correct = true; idleMC = upDanceMC; } 
    else if ((key == 's' || key == 'S') && p.type.equals("down")) { correct = true; idleMC = downDanceMC; } 
    else if ((key == 'a' || key == 'A') && p.type.equals("left")) { correct = true; idleMC = leftDanceMC; } 
    else if ((key == 'd' || key == 'D') && p.type.equals("right")) { correct = true; idleMC = rightDanceMC; }

    displayTime = 15;

    if (correct) {
      score += (powerUpActive) ? 10 : 5;
      p.active = false;
      prompts.remove(0);
      spawnArrow();
      if (score % 200 == 0) powerUpAvailable = true;
    } else if (p.active) {
      idleMC = mistakeMC;
      lives--;
      if (lives <= 0) gameState = ENTER_INITIALS;
    }
  }
}

void spawnArrow() {
  String[] types = {"up", "down", "left", "right"};
  String randomType = types[int(random(4))];
  prompts.add(new Prompt(randomType, 0, 0));
}

void drawGameOverScreen() {
  background(0);
  fill(255, 0, 0);
  textAlign(CENTER);
  textSize(40);
  text("GAME OVER", width/2, height/2 - 100);

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
    if (maxIndex != -1) {
      topRows[i] = allRows[maxIndex];
      allRows[maxIndex] = null;
    }
  }

  fill(255);
  textAlign(LEFT, TOP);
  textSize(24);
  text("Top 5 Player Scores:", width/2 - 100, height/2 - 50);
  for (int i = 0; i < topRows.length; i++) {
    TableRow r = topRows[i];
    text((i+1) + ". " + r.getString("initials") + " - " + r.getInt("score"), width/2 - 100, height/2 - 20 + i*30);
  }

  textSize(20);
  textAlign(CENTER);
  text("Press P to play again", width/2, height - 60);
}

void drawEnterInitialsScreen() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("NEW HIGH SCORE: " + score, width/2, height/2 - 40);
  text("ENTER YOUR INITIALS:", width/2, height/2);
  text(playerInitials + "_", width/2, height/2 + 40);
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

class Prompt {
  PImage sprite;
  String type;
  float x, y;
  boolean active = true;
  int lifetime = 120;

  Prompt(String type, float x, float y) {
    this.type = type;
    this.x = x;
    this.y = y;

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
    image(sprite, 0, 0);
  }
}
