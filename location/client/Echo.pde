class Echo {

  PVector position;
  PVector velocity;
  float radius;
  int alpha = 255;
  float freq, amp;
    int echoID;
    int counter;


  Echo(float tmpX, float tmpY, float tmpR, float tmpFreq, float tmpAmp, String tmpType, float tmpTime, int tmpEchoID) {
    position = new PVector(tmpX, tmpY);
    velocity = new PVector(0, 0);
    radius = tmpR;
    freq = tmpFreq;
    amp = tmpAmp;
    echoID = tmpEchoID;

  }

  void move() {
    position.add(velocity);
  }

  
  void display() {
    float alphaPerS = 255/map (amp, 0, 1, 0, 10);
    alpha = int(alpha - alphaPerS/frameRate);
    float timeBetween = map (freq, 0, 5000, 0, frameRate);
    strokeWeight(int(10*amp));
    stroke(255,255,255,alpha);
    radius +=10;
  }
}
