import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

String hey; 
int id = -1;
float roomWidth = 17.2;
float roomHeight = 11.2;

int statusId = -1;

void setup() {
  size(640,420);
  //listen
  oscP5 = new OscP5(this, 12000);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12001);
}

void draw() {
  online();
}

//Send back to client: id, room width, room height
void sendData() {
  //send id
  OscMessage sendBack = new OscMessage("/schall");
  sendBack.add(id);
  sendBack.add(roomWidth);
  sendBack.add(roomHeight);
  
  oscP5.send(sendBack, remoteLocation);
}

void keyPressed() {
 if(key == 's') {
  sendData(); 
  println("back");
 }
}

//listen to client
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/schall") == true) {
    //save hey
    hey = theOscMessage.get(0).stringValue();
    
    //count up the id and send id, roomWidth and roomLength back
    id++;
    sendData();
    
    println(hey);
    println(id); 
  }
  
  if(theOscMessage.checkAddrPattern("/status") == true) {
    statusId = theOscMessage.get(0).intValue();
  }
}

void online() {
  if(statusId == 0) {
    text(0, width/2, 50);
  }
  
  if(statusId == 1) {
    text(1, width/2, 100);
  }
  
  if(statusId == 2) {
    text(2, width/2, 150);
  }
}
