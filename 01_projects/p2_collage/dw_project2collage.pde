PImage[][] frames = new PImage[4][4];
int frameIndex = 0;
int timer = 0;

float[][][] pos = {
  { {150, 100}, {650, 450}, {150, 450} }, // frame 1 (skeleton, waterfall, etc)
  { {125, 100}, {400, 300}, {700, 500} }, // frame 2 (lizard, statue, etc)
  { {100, 350}, {375, 250}, {650, 150} }, // frame 3 (pigeon, comic, etc)
  { {450, 250}, {750, 450}, {150, 475} }  // frame 4 (cat, lotso, etc)
};

void setup() {
  size(800, 600);
  
  for (int f = 0; f < 4; f++) {
    frames[f][0] = loadImage("frame" + (f+1) + "_bg.png");
    frames[f][1] = loadImage("frame" + (f+1) + "_1.png");
    frames[f][2] = loadImage("frame" + (f+1) + "_2.png");
    frames[f][3] = loadImage("frame" + (f+1) + "_3.png");
  }
}

void draw() {
  background(#ff00ff);
  image(frames[frameIndex][0], 0, 0, width, height);
  imageMode(CENTER);
  
  for (int i = 1; i < 4; i++) {
    float x = pos[frameIndex][i-1][0];
    float y = pos[frameIndex][i-1][1];
    image(frames[frameIndex][i], x, y, 300, 300);
  }
  
  imageMode(CORNER);
  
  timer++;
  if (timer > 60) {
    timer = 0;
    frameIndex++;
    if (frameIndex > 3) frameIndex = 0; //2 second timer for the frames
  }
  
  saveFrame("output/frame####.png");
}
