import processing.sound.*;

//Variables for sound files.
SoundFile one;
SoundFile two;
SoundFile three;
SoundFile four;

//Background image.
PImage drumbg;

//Power button's X, Y, radius.
float powerX = 123;
float powerY = 670;
float powerR = 80;

//Pause button's X, Y, and radius.
float pauseX = 317;
float pauseY = 669;
float pauseR = 40;

//Boolean to check if the sequence is running.
boolean isPlaying = true;

//Increase volume button's X, Y, and radius.
float volUpX = 435;
float volUpY = 669;
float volUpR = 40;

//Decrease volume button's X, Y, and radius.
float volDownX = 562;
float volDownY = 669;
float volDownR = 40;

//Base volume for program.
float volume = 0.5;

//Circle highlight info for the volume buttons.
int volUpHighlightTime = -1000;
int volDownHighlightTime = -1000;
int highlightDuration = 100;

//Row, column, and button variables.
int rows = 4;
int cols = 16;
boolean[][] buttons = new boolean[rows][cols];

//Button colors when clicked.
int[] rowColors = {
  
  color (78, 148, 79),
  color (136, 176, 75),
  color (179, 159, 114),
  color (217, 140, 75)
  
};

//Button colors when unclicked.
int[] rowInactiveColors = {
  
  color (150, 200, 150),
  color (200, 220, 150),
  color (250, 230, 180),
  color (240, 180, 140)
  
};

//Initial start positions and spacing between buttons.
float startX = 79;
float startY = 198;
float spacingX = 74;
float spacingY = 92;
float circleSize = 58;

int currentColumn = 0;
int interval = 200;
int lastStepTime = 0;

void setup() {
      
  //Sound file variables being assigned.
  one = new SoundFile(this, "sound_one.wav");
  two = new SoundFile(this, "sound_two.wav");
  three = new SoundFile(this, "sound_three.mp3");
  four = new SoundFile(this, "sound_four.wav");
  
  size (1280, 800);
  drumbg = loadImage ("drum_image.png");
  
}

void draw() {

  background (255);
  image (drumbg, 0, 0);
  
  //Puts white highlight around pause button when not sequence is not running.
  if (!isPlaying) {
    
    pushStyle ();
    noFill ();
    stroke (255);
    strokeWeight (4);
    circle (312, 672, 90);
    popStyle ();
  
  }
  
  //Puts white highlight around increase volume button for a few milliseconds to indicate user clicked it.
  if (millis() - volUpHighlightTime < highlightDuration) {
    
    pushStyle ();
    noFill ();
    stroke (255);
    strokeWeight (4);
    circle (438, 669, 90);
    popStyle ();
  }
  
  //Puts white highlight around decrease volume button for a few milliseconds to indicate user clicked it.
  if (millis() - volDownHighlightTime < highlightDuration) {
    
    pushStyle ();
    noFill ();
    stroke (255);
    strokeWeight (4);
    circle (565, 669, 90);
    popStyle ();
  }
  
  //Setting base volume to buttons.
  one.amp(volume);
  two.amp(volume);
  three.amp(volume);
  four.amp(volume);
  
  //Sequence loop activate if it is playing.
  if (isPlaying) {
    
    if (millis() - lastStepTime >= interval) {
    
    currentColumn = (currentColumn + 1) % cols;
    lastStepTime = millis();
    
    for (int r = 0; r < rows; r++) {
      
      if (buttons [r][currentColumn]) {
        
        switch (r) {
          
          case 0: one.play(); break;
          case 1: two.play(); break;
          case 2: three.play(); break;
          case 3: four.play(); break;
          
        }
      }
    }
  }
  }
  
  //Visual rectangle for the sequence loop.
  noStroke();
  fill (76, 221, 18, 60);
  float columnX = startX + (currentColumn * spacingX);
  rectMode (CENTER);
  rect (columnX, height / 2, 70, height);
  
  for (int r=0; r < rows; r++) {
    
    for (int c = 0; c < cols; c++) {
      
      if (buttons[r][c]) {
        
        fill (rowColors[r]);
        
      } else {
        
        fill (rowInactiveColors[r]);
      }
      
      float x = startX + c * spacingX;
      float y = startY + r * spacingY;
      circle (x, y, circleSize);
      
    }
  }
}

void mousePressed() {
  
  //Power button details.
  float powerD = dist (mouseX, mouseY, powerX, powerY);
  
  if (powerD < powerR) {
    
    pushStyle ();
    noFill ();
    stroke (255);
    strokeWeight (4);
    circle (122, 672, 165);
    popStyle ();
    
    redraw ();
    delay (100);
    
    exit();
    
  }
  
  //Pause button details.
  float pauseD = dist (mouseX, mouseY, pauseX, pauseY);
  
  if (pauseD < pauseR) {
    
    isPlaying = !isPlaying;
    return;
  }
  
  //Increase volume button details.
  float volUpD = dist (mouseX, mouseY, volUpX, volUpY);
  
  if (volUpD < volUpR) {
    
    volume += 0.1;
    
    if (volume > 1.0) {
      
      volume = 1.0;
    
    }
    
    volUpHighlightTime = millis();
    return;
  }
  
  //Decrease volume button details.
  float volDownD = dist (mouseX, mouseY, volDownX, volDownY);
  
  if (volDownD < volDownR) {
    
    volume -= 0.1;
    
    if (volume < 0.0) {
      
      volume = 0.0;
    
    }
    
    volDownHighlightTime = millis();
    return;
  }
  
  //Loop to register buttons being clicked.
  for (int r = 0; r < rows; r++) {
    
    for (int c = 0; c < cols; c++) {
      
      float x = startX + c * spacingX;
      float y = startY + r * spacingY;
      
      if (dist (mouseX, mouseY, x, y) < circleSize / 2) {
        
        buttons [r][c] = !buttons [r][c];
        
      }
    }
  }
}
