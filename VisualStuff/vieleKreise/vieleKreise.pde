float count;
int initialTime;
int interval = 1000;

void setup () {
    size (1250, 800);
    background (0, 0, 0);
    stroke (255, 255, 255); 
    noFill ();
    count = 0;
    initialTime = millis();
    frameRate(7.5);
}

void draw () {
  count++;
  for (int i=50; i<width; i+=10) {
if (i < mouseX){ 
  rotate(count);
ellipse (width/2,height/2,i+0,i);
} else { 
ellipse (width/2,height/2,i+10,i);
}
}
}
