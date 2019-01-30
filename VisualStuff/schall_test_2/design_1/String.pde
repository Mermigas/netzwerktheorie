class StringClass {
  float xoff = 0.0;

  StringClass() {
  }

  void display() {
    xoff = xoff + 0.01;
    float n = noise(xoff) * width;
    line(10, 10, n, n);
    
    drawLine(width/2, 280, 6);
  }

  void drawLine(int x, int y, int level) {
    float tt = 126 * level/4.0;
    fill(tt);
    ellipse(x, height/2, y*2, y*2);      
    if (level > 1) {
      level = level - 1;
      drawLine(x - y/2, y/2, level);
      drawLine(x + y/2, y/2, level);
    }
  }
}
