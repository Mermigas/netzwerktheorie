int count;
int rad; 
int x;
int y;

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
  
}

void draw () {
count++;
rad = rad + 20;
ellipse (x, y, rad, rad);
}
