PImage drumbg;

void setup() {
  size(1280, 800);
  drumbg = loadImage("drum_image.png");
}

void draw() {
  background(255);
  image(drumbg, 0, 0);
  }
