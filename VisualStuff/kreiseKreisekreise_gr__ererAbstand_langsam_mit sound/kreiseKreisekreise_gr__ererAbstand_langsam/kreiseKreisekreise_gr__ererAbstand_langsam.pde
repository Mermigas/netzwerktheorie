import processing.sound.*;
Sound s;

int count;
int rad; 
int x;
int y;
int initialTime;
int interval = 1000;
int fade = 255;

void setup () {
  size (1250, 800);
  background (0, 0, 0);
  stroke (255, 255, 255, fade);
 
  noFill ();
  count = 0;
  rad = 2;
  x = 625;
  y = 400;
  ellipseMode(CENTER);
  
  SinOsc c = new SinOsc(this);
  c.play(200, 0.5);
  c = new SinOsc(this);
  c.play(205, 0.5);
  
   s = new Sound(this);

}

void draw () {
  stroke (255, 255, 255, fade);
  
  count++;
  
  rad = rad + 20;
  ellipse (x, y, rad, rad);
  
  fade--;

initialTime = millis();
    frameRate(7.5);
    
     float amplitude = map(mouseY, 0, height, 0.4, 0.0);
     s.volume(amplitude);

}
