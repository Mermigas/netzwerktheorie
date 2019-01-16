 class EchoSystem {
  ArrayList<EchoParticle> particles;
  PVector origin;
  float freq, amp;
  int echoID;
  float timeStart = millis();
  float lifetime;
  float radius;
  float oLifetime;
  float timeAfter;
  int particlesPerRound = 60;
  float timer = 0;
  float counter = 1;

  EchoSystem(float tmpX, float tmpY, float tmpFreq, float tmpradius, float tmpAmp, String tmpType, float tmpTime, int tmpEchoID) {
    origin = new PVector(tmpX, tmpY);
    particles = new ArrayList<EchoParticle>();
    freq = tmpFreq;
    amp = tmpAmp;
    echoID = tmpEchoID;
    radius = tmpAmp * tmpradius;
    particlesPerRound *=  amp;
    oLifetime = tmpTime;
    timeAfter = 3 * (0.5 * tmpAmp);
    lifetime = tmpTime + timeAfter;
    
  }

  void addParticle() {
     for (int i=0; i<particlesPerRound; i++) {
      particles.add(new EchoParticle(origin, i, particlesPerRound, radius, lifetime, oLifetime));
  }
    
  }
  boolean isDead() {
      if (lifetime < 0.0) {
        return true;
      } else {
        return false;
      }
    }
  void run() {
    timer += (1/frameRate) * timeController;
    lifetime -= (1/frameRate) * timeController;
    oLifetime -= (1/frameRate) * timeController;
    
    
    float tmpFreq = 1/(freq/200);
    if(timer>counter*tmpFreq) {
     counter++;
     if(oLifetime>0) {
       addParticle();
     }
    }
    for (int i = particles.size()-1; i >= 0; i--) {
      EchoParticle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


class EchoParticle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float alpha;
  float radius;
  float lifetime;
  float oLifetime;

  float alphaPerCircle;

  EchoParticle(PVector l, float num, float maxNum, float tmpRadius, float tmpLifetime, float tmpOLifetime) {
    //acceleration = new PVector(1.0, 1.00);
     velocity = new PVector(sin(map(num, 0, maxNum, 0, 2*PI)), cos(map(num, 0, maxNum, 0, 2*PI)));
    position = l.copy();
    radius = tmpRadius;
    lifetime = tmpLifetime;
    oLifetime = tmpOLifetime;

    alpha = 255.0;
    alphaPerCircle = alpha/(lifetime-oLifetime);
    
  }

  void run() {
    update();
    display();
  }
 void checkForEnd() {
   
   //--------just for tests
  //float roomWidthInPX = width;
 // float roomHeightInPX = height;
  //--------- end 
  
    if ((position.x + radius > roomWidthInPX) || (position.x - radius < 0)) {
      velocity.x = velocity.x * - 1;
      radius *= 0.8;
    }
    if ((position.y + radius > roomHeightInPX) || (position.y - radius < 0)) {
      velocity.y = velocity.y * - 1;
    } 
    
  }
  // Method to update position
  void update() {
    //velocity.add(acceleration);
    velocity = velocity.mult(1.02);
    //velocity = velocity.mult(0.5);
    checkForEnd();
    position.add(velocity);
    println(velocity);
    
    lifetime -= (1/frameRate) * timeController;
    oLifetime -= (1/frameRate) * timeController;
    if (oLifetime < 0) {
      alpha -= (alphaPerCircle/frameRate) * timeController;
    }
    
  }

  // Method to display
  void display() {
    stroke(alpha);
    fill(alpha);
   //fill(255);

    float newSize = mapSize(radius);
   // float newSize = radius;
   // float [] positionnew = {position.x, position.y};
    float [] positionnew = mapCordinates(position.x, position.y);
     
    ellipse(positionnew[0], positionnew[1], newSize, newSize);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifetime < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
