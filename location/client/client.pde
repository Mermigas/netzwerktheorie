
float roamWidth;
float roamHeight;
String ownNetworkAddress;

int ID; //eigene ID
boolean gotID = false; // ID von Master erhalten

float sendHeyTime = 1; // Zeit in Sekunden, wie oft "hey" gesendet wird
int sendHeyCounter = 0; // Counter für Hey-Nachrichten
int sendAliveCounter = 0; // Counter für Alive-Nachrichten
float sendAliveTime = 2; // Zeit die zwischen zwei Alive Nachrichten bestehen soll

// Necessary imports for communicating via OSC
import oscP5.*;
import netP5.*;

// Global instances for communication objects
OscP5 oscP5;
NetAddress remoteLocation;

void setup() {
  size(800, 600);
  ID = -1;
  // Listen on port 12001
  oscP5 = new OscP5(this, 12001);
  remoteLocation = new NetAddress("255.255.255.255", 12001);
  ownNetworkAddress = NetInfo.getHostAddress();
  rectMode(CENTER);
}
void draw() {
  
  
  //AliveMessage  
  if(gotID){
    float d = 1/sendAliveTime;
    if (millis()>(d*1000*sendAliveCounter)) {
      sendAliveCounter++;
      sendAlive();
      println("sendAlive");
    }
  }
  
  //Hey-Message
  float d = 1/sendHeyTime;
  if (!gotID) {
    if (millis()>(d*1000*sendHeyCounter)) {
      sendHeyCounter++;
      sendHey();
    }
  }

  if (ID!=-1) {
    for (int i=0; i<=ID; i++) {
      if (i<ID) {
        drawLaptop(i, false);
      } else {
        drawLaptop(i, true);
      }
    }
  }
}
void drawLaptop(int laptopID, boolean visibilityState) {
  color laptopColor;
  //print(laptopID);
  if (visibilityState) {
    laptopColor = color(0, 0, 0, 255);
  } else {
    laptopColor = color(0, 0, 0, 123);
  }
  float[] position = getLaptopPosition(laptopID);
  fill(laptopColor);
  rect(position[0], position[1], 30, 20);
}
float[] getLaptopPosition (int laptopID) {
  float x = width/2;
  float y = 30;
  float spacerWidth = 20;
  float spacerHeight = 20;
  float spaceH = 0;
  if (laptopID%2==0) {
    //right side
    x = spacerWidth * laptopID + x;
  } else {
    //left side
    x = x - (spacerWidth * laptopID)- 20;
  }

  for (int i = 0; i<= laptopID; i++) {
    if (laptopID>0) {
      if (i%2!=0) {
        spaceH += spacerHeight;
      }
    }
  }
  y += spaceH;
  float[] postion = new float[2];
  postion[0] = x;
  postion[1] = y;
  return postion;
}
void keyPressed() {
  if (key=='s') {
    sendHey();
  }
}

void sendAlive(){
   OscMessage aliveMessage = new OscMessage("/alive");
   aliveMessage.add(ID);
   oscP5.send(aliveMessage, remoteLocation);
}
void sendHey() {
  OscMessage heyMessage = new OscMessage("/hey");
  heyMessage.add(ownNetworkAddress); 
  heyMessage.add("hey");
  oscP5.send(heyMessage, remoteLocation);
}
void oscEvent(OscMessage theOscMessage) {

  String address = theOscMessage.address();
  if (
    !gotID && 
    !address.contains(ownNetworkAddress) && 
    theOscMessage.checkAddrPattern("/id") &&
    theOscMessage.get(0).stringValue().equals(ownNetworkAddress))
  {
    //print("get");
    gotID = true;
    ID = theOscMessage.get(1).intValue();
    roamWidth = theOscMessage.get(2).floatValue();
    roamHeight = theOscMessage.get(3).floatValue();
  }
}
