//Variables for different screens.
int TITLE = 0;
int GAME = 1;
int GAMEOVER = 2;

int gameState = TITLE;

//Sprites
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
  
}

void draw() {
  
  if (gameState == TITLE) drawTitleScreen();
  else if (gameState == GAME) drawGameScreen();
  else if (gameState == GAMEOVER) drawGameOverScreen();
  
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
      if (lives <= 0) gameState = GAMEOVER;
    }
  }

  if (displayTime > 0) displayTime--;
  else idleMC = loadImage("idleMC.png");
  
}

void keyPressed() {
  
  if (gameState == TITLE && key == 'p') gameState = GAME;

//Power-up activation.
  if (gameState == GAME && powerUpAvailable && key == ' ') {
    powerUpActive = true;
    powerUpAvailable = false;
    return;
    
  }

  if (gameState == GAME && prompts.size() > 0) {
    Prompt p = prompts.get(0);
    boolean correct = false;

    if (key == ' ') return;

    if ((key == 'w' || key == 'W') && p.type.equals("up")) {
      correct = true;
      idleMC = upDanceMC;
    } 
    else if ((key == 's' || key == 'S') && p.type.equals("down")) {
      correct = true;
      idleMC = downDanceMC;
    } 
    else if ((key == 'a' || key == 'A') && p.type.equals("left")) {
      correct = true;
      idleMC = leftDanceMC;
    } 
    else if ((key == 'd' || key == 'D') && p.type.equals("right")) {
      correct = true;
      idleMC = rightDanceMC;
    }

    displayTime = 15;

    if (correct) {
      score += (powerUpActive) ? 10 : 5;
      powerUpActive = false;
      p.active = false;
      prompts.remove(0);
      spawnArrow();

      if (score % 100 == 0) {
        powerUpAvailable = true;
      }
    } else if (p.active) {
      idleMC = mistakeMC;
      lives--;
      if (lives <= 0) gameState = GAMEOVER;
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
  text("GAME OVER", width/2, height/2);
  
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
