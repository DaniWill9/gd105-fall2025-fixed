import processing.sound.*;

//Variables for sound files.
SoundFile one;
SoundFile two;
SoundFile three;
SoundFile four;
SoundFile five;
SoundFile six;
SoundFile seven;
SoundFile eight;

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
int rows = 8;
int cols = 16;
boolean[][] buttons = new boolean[rows][cols];

//Button colors when clicked.
int[] rowColors = {
  
  color (199, 82, 42),
  color (229, 193, 133),
  color (240, 218, 165),
  color (251, 242, 196),
  color (184, 205, 171),
  color (116, 168, 146),
  color (0, 133, 133),
  color (0, 67, 67)
  
};

//Button colors when unclicked.
int[] rowInactiveColors = {
  
  color (203, 165, 153),
  color (230, 216, 194),
  color (242, 237, 223),
  color (252, 250, 241),
  color (233, 243, 226),
  color (209, 239, 226),
  color (144, 244, 244),
  color (115, 158, 158)
  
};

//Initial start positions and spacing between buttons.
float startX = 79;
float startY = 190;
float spacingX = 74;
float spacingY = 43;
float circleSize = 33;

int currentColumn = 0;
int interval = 200;
int lastStepTime = 0;

void setup() {
      
  //Sound file variables being assigned.
  one = new SoundFile(this, "sound_one.wav");
  two = new SoundFile(this, "sound_two.wav");
  three = new SoundFile(this, "sound_three.mp3");
  four = new SoundFile(this, "sound_four.wav");
  five = new SoundFile(this, "sound_five.mp3");
  six = new SoundFile(this, "sound_six.mp3");
  seven = new SoundFile(this, "sound_seven.wav");
  eight = new SoundFile(this, "sound_eight.wav");
  
  size (1280, 800);
  drumbg = loadImage ("drum_image.png");
  
}

void draw() {

  background (255);
  image (drumbg, 0, 0);
  
  one.amp(volume);
  two.amp(volume);
  three.amp(volume);
  four.amp(volume);
  five.amp(volume);
  six.amp(volume);
  seven.amp(volume);
  eight.amp(volume);
  
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
          case 4: five.play(); break;
          case 5: six.play(); break;
          case 6: seven.play(); break;
          case 7: eight.play(); break;
          
        }
      }
    }
  }
  }
  
  //Visual rectangle for the sequence loop.
  noStroke();
  fill (30, 36, 39, 60);
  float columnX = startX + (currentColumn * spacingX);
  rectMode (CENTER);
  rect (columnX, height / 2 - 62, 70, 387);
  
  //Drawing the stars on the top of the image when it lands on that specific column.
  float starX = startX + currentColumn * spacingX;
  float starY = startY - 125;
  drawStar (starX, starY, 13);
  
  for (int r=0; r < rows; r++) {
    
    for (int c = 0; c < cols; c++) {
      
      if (buttons[r][c]) {
        
        stroke(0);
        strokeWeight(2);
        fill (rowColors[r]);
        
      } else {
        
        stroke(57, 70, 77);
        strokeWeight(2);
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

//A function for a mini star drawing.
void drawStar (float x, float y, float radius) {
  
  pushStyle ();
  
  noStroke ();
  for (float i = 5; i >= 1; i -= 0.5) {
    float glowR = radius + i * 1;
    float alpha = 8 * i;
    fill (255, 255, 255, alpha);
    drawStarShape (x, y, glowR);
  }
  
  fill (255);
  drawStarShape (x, y, radius);
  
  popStyle();
}

void drawStarShape (float x, float y, float radius) {
  
  beginShape();
  for (int i = 0; i < 10; i++) {
    float angle = TWO_PI * i / 10 - PI / 2;
    float r = (i % 2 == 0) ? radius : radius * 0.4;
    vertex (x + cos(angle) * r, y + sin(angle) * r);
  }
  endShape(CLOSE);
}
