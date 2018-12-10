class Echo {

  PVector position;
  PVector velocity;
  float radius;
  int alpha = 255;

  Echo(float tmpX, float tmpY, float tmpR, float tmpFreq, float tmpAmp, String tmpType) {
    position = new PVector(tmpX, tmpY);
    velocity = new PVector(5, 2);
    radius = tmpR;
  }

  void move() {
    position.add(velocity);
  }
  
  void display() {
    
  }
}
