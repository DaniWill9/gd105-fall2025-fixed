PImage drumbg;

float powerX = 123;
float powerY = 670;
float powerR = 80;

int columns = 16;
int rows = 4;

int cellW, cellH;

int cusW = 1200;
int cusH = 450;

void setup() {
  size(1280, 800);
  drumbg = loadImage("drum_image.png");
  
  cellW = cusW / columns;
  cellH = cusH / rows;
}

void draw() {
  background(255);
  image(drumbg, 0, 0);
  
  noFill();
  stroke(255, 50);
  for (int i = 0; i < columns; i++){
    for (int j = 0; j < rows; j++){
      rect (i * cellW, j * cellH, cellW, cellH);
    }
  }
}
  
void mouseClicked(){
  float powerD = dist(mouseX, mouseY, powerX, powerY);
  
  if(powerD < powerR){
    exit();
  }
}

void mousePressed(){
  int cols = mouseX / cellW;
  int rws = mouseY / cellH;
  
  print("Clicked on col " + cols + 
 ", row " + rws);
}
