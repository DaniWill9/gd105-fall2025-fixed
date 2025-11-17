PImage drumbg;

float powerX = 123;
float powerY = 670;
float powerR = 80;

boolean buttonClicked = false;

void setup() {
  
  size (1280, 800);
  drumbg = loadImage ("drum_image.png");
  
}

void draw() {

  background (255);
  image (drumbg, 0, 0);
  strokeWeight (2);
  
  if (buttonClicked == true){
    fill (255, 0, 0);
  } else {
    fill (255, 175, 175);
  }

  buttonPress(79, 198);
  circle (79, 198, 58);
  //circle (153, 198, 58);
  //circle (227, 198, 58);
  //circle (301, 198, 58);
  //circle (380, 198, 58);
  //circle (455, 198, 58);
  //circle (529, 198, 58);
  //circle (603, 198, 58);

}
  
void mousePressed(){
  
  float powerD = dist (mouseX, mouseY, powerX, powerY);
  
  if (powerD < powerR) {
    exit();
  }
  
}

void buttonPress (int buttonX, int buttonY) {
  
  float buttonD = dist (mouseX, mouseY, buttonX, buttonY);

  if (buttonD < 30 && mousePressed){
    buttonClicked = !buttonClicked;
  }  
}
