class EchoSystem {
  ArrayList<EchoParticle> particles;
  PVector origin;
  float freq, amp;
  int echoID;
  float radius;
  int particlesPerRound = 300;
  float counter = 1;
  float counterPhase = 0;
  boolean phase = true;
  float timerEcho;
  float nextTime;

  EchoSystem(float tmpX, float tmpY, float tmpFreq, float tmpradius, float tmpAmp, String tmpType, int tmpEchoID) {
    origin = new PVector(tmpX, tmpY);
    particles = new ArrayList<EchoParticle>();
    freq = tmpFreq;
    amp = tmpAmp;
    echoID = tmpEchoID;
    radius = tmpAmp * tmpradius;
    particlesPerRound *=  amp;
  }

  void addParticle() {
    //phasenveschiebung
    if (phase) {
      phase = false;
    } else {
      phase = true;
    }

    for (int i=0; i<particlesPerRound; i++) {
      particles.add(new EchoParticle(origin, i, particlesPerRound, radius, freq, phase));
    }
    counterPhase++;
  }

  void run() {
    float tmpFreq = 1/(freq/200);
    timerEcho += 1/frameRate;

    if (timerEcho>nextTime) {
      addParticle();
      nextTime += tmpFreq;
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
  float alpha;
  float radius;
  float freq;
  boolean phase;

  EchoParticle(PVector l, float num, float maxNum, float tmpRadius, float tmpFreq, boolean tmpPhase) {
    velocity = new PVector(sin(map(num, 0, maxNum, 0, 2*PI)), cos(map(num, 0, maxNum, 0, 2*PI)));
    phase = tmpPhase;
    position = l.copy();
    radius = tmpRadius;
    freq = tmpFreq;

    alpha = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    position.add(velocity);
  }

  // Method to display
  void display() {
    strokeWeight(1);
    stroke(alpha);
    if (phase) {
      fill(alpha);
    } else {
      fill(bg);
    }

    //println("XPositionXAlt: " + position.x + "positionYAlt: " + position.y);
    float newSize = radius;
    // println("radius: " + radius + "newSize: " + newSize + "int: " + int(newSize));
    //println(position.x + " " + position.y);
    ellipse(position.x, position.y, newSize, newSize);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (position.x < displayVX || position.x > displayVX + displayVW || position.y < displayVY || position.y > displayVY + displayVH) {
      return true;
    } else {
      return false;
    }
  }
}
