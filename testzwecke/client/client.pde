import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

String hey = "hey";
int id;

float roomWidth, roomHeight;

void setup() {
  size(640,420);
  //listen
  oscP5 = new OscP5(this, 12001);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12000);
}

void draw() {
  
}

void keyPressed() {
  if(key == 's') {
    sendData();
  }
}

void sendData() {
  //send id
  OscMessage sendHey = new OscMessage("/schall");
  sendHey.add(hey);
  
  oscP5.send(sendHey, remoteLocation);
}

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/schall") == true) {
    id = theOscMessage.get(0).intValue();
    roomWidth = theOscMessage.get(1).floatValue();
    roomHeight = theOscMessage.get(2).floatValue();
    
    println(id);
    println(roomWidth);
    println(roomHeight);
  }
}
