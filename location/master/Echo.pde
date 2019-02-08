class EchoSystem {
  ArrayList<EchoParticle> particles;
  PVector origin;
  float freq, amp;
  int echoID;
  float radius;
  int particlesPerRound = 150;
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

  void display() {
    if (sinOn) {
      strokeWeight(1);
      stroke(alpha);
      if (phase) {
        fill(alpha);
      } else {
        noFill();
      }

      float newSize = radius;
      ellipse(position.x, position.y, newSize, newSize);
    } else if (sawOn) {
      rectMode(CENTER);
      float gradientMiddle = map(freq, 20, 300, 50, 205); 

      int fromColor = int(gradientMiddle) - 50;
      int toColor = int(gradientMiddle) + 50;

      if (phase) {
        setGradient(int(position.x-radius/2), int(position.y-4), radius, 8, fromColor, toColor, X_AXIS);
        noStroke();
      } else {
        stroke(alpha);
        strokeWeight(1);
        noFill();
      }

      rect(position.x, position.y, radius, 8);
    } else if (squareOn) {
      strokeWeight(1);

      stroke(alpha);
      if (phase) {
        fill(alpha);
      } else {
        noFill();
      }
      rectMode(CENTER);
      
      float positionNew = position.x - radius/2;
      for ( int i = 1; i<=8; i++) {
        if (i%2 != 0) {
          rect (positionNew +i*5, position.y, radius/4, radius/4);
        }
      }
    }
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

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
