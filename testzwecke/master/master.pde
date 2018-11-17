import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

String hey; 
int id = -1;
float roomWidth = 17.2;
float roomHeight = 11.2;

void setup() {
  size(640,420);
  //listen
  oscP5 = new OscP5(this, 12001);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12001);
}

void draw() {
  
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
    
    //count up the id
    id++;
    sendData();
    println(hey);
    println(id); 
  }
}

void online() {
  
}
