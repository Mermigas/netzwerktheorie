Kreise k1;
int fade = 255;

void setup () {
  size (1250, 800);
  background (0, 0, 0);
  stroke(255, 255, 255, fade);
  k1 = new Kreise();
  
  c.play(200, 0.5);
  c = new SinOsc(this);
  c.play(205, 0.5);
  s = new Sound(this);
}

void draw () {
k1.display();
k1.spread();
//k1.controlText();
}
