import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

ArrayList<Circle> circles;
Circle circle;

float xVal = 50, yVal = 50;
float radius = 20;

float counter;
float duration = 1;

//OSC

String type = "";
float freq, amp;
int myId = 0;
int id;
float globalVelocity;

void setup() {
  size(640, 420);
  circles = new ArrayList<Circle>();

  // Listen on port 12001
  oscP5 = new OscP5(this, 12001);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12000);
}

void draw() {
  background(#000000);
  counter = counter + 1/frameRate;


  //Add Circles
  if (counter < duration) {
    circles.add(new Circle(xVal, yVal, radius));
  }

  //diplay circles
  for (int i = 0; i < circles.size(); i++) {
    Circle c = circles.get(i);
    c.display();
    c.move();
    c.update();
    c.fade();

    //if (c.isDead()) {
    //  circles.remove(i);
    //}
  }
  
  controlText();
}

void controlText() {
  fill(255);
  text("id" + " " + id, width-150, 50);
  text("waveform" + " " + type, width-150, 70);
  text("frequency" + " " + freq, width-150, 90);
  text("amplitude" + " " + amp, width-150, 110);
  text("global velocity" + " " + globalVelocity, width-150, 130);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/data") == true) {
    id = theOscMessage.get(0).intValue();
    type = theOscMessage.get(1).stringValue();
    freq = theOscMessage.get(2).floatValue();
    amp = theOscMessage.get(3).floatValue();
    globalVelocity = theOscMessage.get(4).floatValue();
    println(type + " " + freq + " " + amp);
  }
}
