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
  int particlesPerRound = 300;
  float timer = 0;
  float counter = 1;
  float counterPhase = 0;
  boolean phase = true;



  EchoSystem(float tmpX, float tmpY, float tmpFreq, float tmpradius, float tmpAmp, String tmpType, float tmpTime, int tmpEchoID) {
    origin = new PVector(tmpX, tmpY);
    particles = new ArrayList<EchoParticle>();
    freq = tmpFreq;
    amp = tmpAmp;
    echoID = tmpEchoID;
    radius = tmpAmp * tmpradius;
    println("tmpAmp: " + tmpAmp);
    println("init radius: " + tmpradius + " init2: " + radius);
    particlesPerRound *=  amp;
    oLifetime = tmpTime;
    timeAfter = 3 * (0.5 * tmpAmp);
    lifetime = tmpTime + timeAfter;
    
  }

  void addParticle() {
    //phasenveschiebung)
      if (phase) {
        phase = false;
      }else {
       phase = true; 
      }
    
    for (int i=0; i<particlesPerRound; i++) {
      particles.add(new EchoParticle(origin, i, particlesPerRound, radius, lifetime, oLifetime, freq, phase));
    }
    counterPhase++;
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
    if (timer>counter*tmpFreq) {
      counter++;
      if (oLifetime>0) {
        addParticle();
        println(counter);
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
  float freq;
  boolean phase;

  float alphaPerCircle;

  EchoParticle(PVector l, float num, float maxNum, float tmpRadius, float tmpLifetime, float tmpOLifetime, float tmpFreq, boolean tmpPhase) {
    //acceleration = new PVector(1.0, 1.00);
    velocity = new PVector(sin(map(num, 0, maxNum, 0, 2*PI)), cos(map(num, 0, maxNum, 0, 2*PI)));
    phase = tmpPhase;
    position = l.copy();
    radius = tmpRadius;
    lifetime = tmpLifetime;
    oLifetime = tmpOLifetime;
    freq = tmpFreq;

    alpha = 255.0;
    alphaPerCircle = (alpha-bg)/(lifetime-oLifetime);
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

    if ((position.x + radius > globalRoomWidthInPx) || (position.x - radius < 0)) {
      velocity.x = velocity.x * - 1;
      radius *= 0.8;
    }
    if ((position.y + radius > globalRoomHeightInPx) || (position.y - radius < 0)) {
      velocity.y = velocity.y * - 1;
    }
  }
  void checkForCollision() {
    for (int i = echo.size()-1; i >= 0; i--) {
      EchoSystem p = echo.get(i);
      for (int y = p.particles.size()-1; i >=0; i--) {
        EchoParticle eP = p.particles.get(y);
        // Get distances between the balls components
        PVector distanceVect = PVector.sub(eP.position, position);

        // Calculate magnitude of the vector separating the balls
        float distanceVectMag = distanceVect.mag();

        // Minimum distance before they are touching
        float minDistance = radius + eP.radius;

        if (distanceVectMag < minDistance) {
          //Collision
          if (freq - eP.freq < 50) {
           //if freqdifference < 50
           float newRadius = (radius + eP.radius)/1.5;
           radius = newRadius;
           eP.radius = newRadius;
           float addLifetime = map(radius + eP.radius, 0, 20, 0,1)*1.5;
           oLifetime += addLifetime;
           lifetime += addLifetime;
           eP.oLifetime += addLifetime;
           eP.lifetime += addLifetime;
          }
          
          
        }
      }
    }
  }

  // Method to update position
  void update() {
    //velocity.add(acceleration);
    //velocity = velocity.mult(1.2);
    velocity.x *=  1.1;
    velocity.y *= 1.1;

    //velocity.x = mapSize(velocity.x);
    //velocity.y = mapSize(velocity.y);
    // velocity.x *= 1.45;
    // velocity.y *= 1.3;
    //velocity = velocity.mult(0.5);
    //checkForEnd();
    position.add(velocity);
    //println(velocity);

    lifetime -= (1/frameRate) * timeController;
    oLifetime -= (1/frameRate) * timeController;
    if (oLifetime < 0) {
      alpha -= (alphaPerCircle/frameRate) * timeController;
    }
  }

  // Method to display
  void display() {
    strokeWeight(1);
    stroke(alpha);
    if(phase) {
      println("voll");
      fill(alpha);
    }else {
      println("leer");
      fill(bg);
    }
    
    //println("XPositionXAlt: " + position.x + "positionYAlt: " + position.y);
    float newSize = mapSizeW(radius);
    // println("radius: " + radius + "newSize: " + newSize + "int: " + int(newSize));
    float [] positionnew = mapCordinates(position.x, position.y);
    //println("Xpostion-mapped: " + positionnew[0] + "YpositionMapped: " + positionnew[1]);

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
