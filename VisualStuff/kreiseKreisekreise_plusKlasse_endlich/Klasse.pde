import oscP5.*;
import netP5.*;
import processing.sound.*;
Sound s;
Kreise k;
OscP5 oscP5;
NetAddress remoteLocation;
SinOsc c = new SinOsc(this);

//OSC
String type = "";
float freq, amp;
int myId = 0;
int id;
float globalVelocity;

  //Listen on port 12001
  //oscP5 = new OscP5(this, 12001);
  //send
  //remoteLocation = new NetAddress("255.255.255.255", 12000);

class Kreise {
  int count;
  int rad; 
  int hoehe;
  int breite;
  int initialTime;
  int interval = 1000;
  int fade = 255;
  color linienfarbe = color(255, 255, 255, fade);
  color hintergrund = color(0, 0, 0);
  
   Kreise() {
     breite = 625;
     hoehe = 400;
     count = 0;
     rad = 2;
      ellipseMode(CENTER);
    
  //c.play(200, 0.5);
  //c = new SinOsc(this);
  //c.play(205, 0.5);
  //s = new Sound(this);
}

   void display () {
    stroke(linienfarbe);
    //fill(hintergrund);
    noFill();
    ellipse(breite, hoehe, freq, amp); //rad to amp

initialTime = millis();
    frameRate(7.5);
    
    float amp = map(fade--, 0, height, 0.4, 0.0);
   s.volume(amp);
}

   void spread() {
     count++;
  //rad = rad + 20;
  ellipse (breite, hoehe, freq, amp);
  freq = freq + 20;
  amp = amp + 20;
  //fade--;
}

  //void controlText() {
  //fill(255);
  //text("id" + " " + id, width-150, 50);
  //text("waveform" + " " + type, width-150, 70);
  //text("frequency" + " " + freq, width-150, 90);
  //text("amplitude" + " " + amp, width-150, 110);
  //text("global velocity" + " " + globalVelocity, width-150, 130);
//}

//void oscEvent(OscMessage theOscMessage) {
  //if (theOscMessage.checkAddrPattern("/data") == true) {
    //id = theOscMessage.get(0).intValue();
    //type = theOscMessage.get(1).stringValue();
    //freq = theOscMessage.get(2).floatValue();
    //amp = theOscMessage.get(3).floatValue();
    //globalVelocity = theOscMessage.get(4).floatValue();
    //println(type + " " + freq + " " + amp);
  //}

}
