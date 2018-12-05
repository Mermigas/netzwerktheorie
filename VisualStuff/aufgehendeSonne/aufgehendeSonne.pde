import processing.sound.*;

WhiteNoise noise;
LowPass lowPass;

int count;
int rad; 
int x;
int y;
int z;

void setup () {
  size (1250, 800);
  background (0, 0, 0);
  stroke (255, 255, 255);
  noFill ();
  count = 0;
  rad = 2;
  x = 625;
  y = 400;
  ellipseMode(CENTER);
  
  noise = new WhiteNoise(this);
  lowPass = new LowPass(this);

  noise.play(0.5);
  lowPass.process(noise);
}

void draw () {
count++;
rad++;
ellipse (x, y, rad, rad);

float cutoff = map(z, 0, width, 20, 10000);
  lowPass.freq(cutoff);
  z++;
}
