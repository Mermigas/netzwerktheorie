import processing.sound.*;

int count;
int rad; 

TriOsc tri;
int x = 0;
float y = 0.0;


void setup () {
  size (1250, 800);
  background (0, 0, 0);
  stroke (255, 255, 255);
  noFill ();
  count = 0;
  rad = 2;
  
  tri = new TriOsc(this);
  tri.play();
  
}

void draw () {
count++;
rad++;

ellipse (rad, rad, rad, rad);

  //float amplitude = map(y, 0, height, 1.0, 0.0);
  //tri.amp(amplitude);
  //y++;
  
  float frequency = map(x, 0, width, 80.0, 1000.0);
  tri.freq(frequency);
  x++;
 
}
