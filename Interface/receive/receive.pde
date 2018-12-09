// Necessary imports for communicating via OSC
import oscP5.*;
import netP5.*;

String type = "";
float freq, amp;
int myId = 0;
int id;
float globalVelocity;

// Global instances for communication objects
OscP5 oscP5;
NetAddress remoteLocation;

void setup() {
  size(500, 500);
  // Listen on port 12001
  oscP5 = new OscP5(this, 12001);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12000);
}

void draw() {
  background(#ffffff);
  if (type.equals("squarewave") && id == myId) {
    fill(#000000);
    ellipse(width/2, height/2, freq, amp*300);
  }

  controlText();
}

void controlText() {
  fill(0);
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
