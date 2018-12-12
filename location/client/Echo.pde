class Echo {

  PVector position;
  PVector velocity;
  float radius;
  int alpha = 255;
  float freq, amp;
    int echoID;
    int counter;
    int kreisEndeCounter;
    float timeStart = millis();
    float timeEnde;


  Echo(float tmpX, float tmpY, float tmpR, float tmpFreq, float tmpAmp, String tmpType, float tmpTime, int tmpEchoID) {
    position = new PVector(tmpX, tmpY);
    velocity = new PVector(0, 0);
    radius = tmpR;
    freq = tmpFreq;
    amp = tmpAmp;
    echoID = tmpEchoID;
    timeEnde = timeStart + tmpTime*1000;

  }

  void move() {
    position.add(velocity);
  }

  
  void display() {
    //background(255);
    noFill();
    float alphaPerS = 255/map (amp, 0, 1, 0, 10);
    if(alpha>0){
    alpha = int(alpha - alphaPerS/frameRate);
    }
    //alpha =255;
    float timeBetween = map (freq, 0, 5000, 0, frameRate);
    strokeWeight(int(10*amp));
    stroke(255,255,255,alpha);
    radius +=10;
    counter++;
    
    for (int i=0; i<counter;i++){
      if(millis()>timeEnde){
        kreisEndeCounter++;
        i = kreisEndeCounter;
        //alpha = int(alpha - (i*(alphaPerS/frameRate)));
      }
   
    println("alpha: " + alpha + " radius:" + radius);
    println("position: " + position.x);
    float [] positionnew = mapCordinates(position.x, position.y);
    ellipse(positionnew[0], positionnew[1], radius, radius);
    
    
    }
  }
}
