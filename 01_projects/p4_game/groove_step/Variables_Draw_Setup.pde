//Sound files.
import processing.sound.*;
SoundFile correctSound;
SoundFile wrongSound;

//Game states.
int TITLE = 0;
int GAME = 1; 
int GAMEOVER = 2;
int ENTER_INITIALS = 3;
int gameState = TITLE;
int CONTINUE = 4;

//Assets (sprites, UI, etc).
PImage idleMC, mistakeMC, leftDanceMC, rightDanceMC, upDanceMC, downDanceMC;
PImage arrowUp, arrowDown, arrowLeft, arrowRight;
PImage heartFull, heartEmpty, starPowerup, danceFloor;

//Game data.
ArrayList <Prompt> prompts = new ArrayList <Prompt> ();
Player player;

//Power-up information.
int displayTime = 0;
boolean powerUpAvailable = false;
boolean powerUpActive = false;
int powerUpTimer = 0;
int powerUpDuration = 300;

//Leaderboard data & displays.
Table highscores;
String playerInitials = "";
int maxInitialsLength = 3;
boolean ignoreNextKey = false;
boolean underscoreVisible = true;
int underscoreTimer = 0;
int underscoreSpeed = 30;

//Screen shake variables.
float shakeX = 0;
float shakeY = 0;
int shakeTimer = 0;

//Credit system variables.
int credits = 0;
int continueTimer = 0;
boolean continueCreditInserted = false;

//Game screen size.
final int GAME_WIDTH = 800;
final int GAME_HEIGHT = 785;

void setup () {
  
  fullScreen ();
  noSmooth ();

//Loads sprites.
  idleMC = loadImage ("idleMC.png");
  mistakeMC = loadImage ("mistakeMC.png");
  leftDanceMC = loadImage ("leftDanceMC.png");
  rightDanceMC = loadImage ("rightDanceMC.png");
  upDanceMC = loadImage ("upDanceMC.png");
  downDanceMC = loadImage ("downDanceMC.png");

  arrowUp = loadImage ("arrowUp.png");
  arrowDown = loadImage ("arrowDown.png");
  arrowLeft = loadImage ("arrowLeft.png");
  arrowRight = loadImage ("arrowRight.png");

  heartFull = loadImage ("heartFull.png");
  heartEmpty = loadImage ("heartEmpty.png");
  starPowerup = loadImage ("star.png");
  danceFloor = loadImage ("dancefloor.png");

//Loads leaderboard from CSV file.
  try {
    
    highscores = loadTable ("highscores.csv", "header,csv");
 
  } catch (Exception e) {
    
    highscores = new Table ();
    highscores.addColumn ("initials");
    highscores.addColumn ("score");
    saveTable (highscores, "data/highscores.csv");
    
  }
  
  player = new Player (3);

  correctSound = new SoundFile (this, "correctarrow.mp3");
  wrongSound = new SoundFile (this, "mistakearrow.wav");
  
}

void draw () {
  
  //Keeps screen size consistent.
  float scaleFactor = min((float) width / GAME_WIDTH, (float) height / GAME_HEIGHT);
  float scaledWidth = GAME_WIDTH * scaleFactor;
  float scaledHeight = GAME_HEIGHT * scaleFactor;
  float offsetX = (width - scaledWidth) / 2;
  float offsetY = (height - scaledHeight) / 2;

  background (0);
  noStroke ();
  fill (0);
  
  rect (0, 0, width, offsetY);
  rect (0, height - offsetY, width, offsetY);
  rect (0, 0, offsetX, height);
  rect (width - offsetX, 0, offsetX, height);

  pushMatrix ();
  translate (offsetX, offsetY);
  scale (scaleFactor);

//Blinking underscore for initials entry screen. Looks more like a classic arcade leaderboard entry screen.
  underscoreTimer++;
  
  if (underscoreTimer >= underscoreSpeed) {
    
    underscoreVisible = !underscoreVisible;
    underscoreTimer = 0;
    
  }

//Establishing game states/screens.
  if (gameState == TITLE) drawTitleScreen ();
  else if (gameState == GAME) drawGameScreen ();
  else if (gameState == GAMEOVER) drawGameOverScreen ();
  else if (gameState == ENTER_INITIALS) drawEnterInitialsScreen ();
  
  if (gameState == CONTINUE) {
    
  drawContinueScreen ();
  
  if (!continueCreditInserted) {
    
    continueTimer--;
    if (continueTimer <= 0) gameState = ENTER_INITIALS;
    
  }
  
}

  popMatrix ();
  
}
