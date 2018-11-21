int ID;
float roamWidth;
float roamHeight;
String ownNetworkAddress;

// Necessary imports for communicating via OSC
import oscP5.*;
import netP5.*;

// Global instances for communication objects
OscP5 oscP5;
NetAddress remoteLocation;

void setup(){
  size(1400,800);
  ID = -1;
    // Listen on port 12001
  oscP5 = new OscP5(this, 12001);
  remoteLocation = new NetAddress("255.255.255.255", 12001);
  ownNetworkAddress = NetInfo.getHostAddress();
  rectMode(CENTER);
}
void draw(){
if (ID!=-1){
      for(int i=0; i<=ID; i++){
    if(i<ID){
      drawLaptop(i, false);
    }else{
      drawLaptop(i, true);
    }
  }
}
}
void drawLaptop(int laptopID, boolean visibilityState){
  color laptopColor;
  print(laptopID);
  if(visibilityState){
    laptopColor = color(0,0,0,255);
  }else{
    laptopColor = color(0,0,0,123);
  }
  float[] position = getLaptopPosition(laptopID);
  fill(laptopColor);
  rect(position[0], position[1], 30, 20);

}
float[] getLaptopPosition (int laptopID){
  float x = width/2;
  float y = 30;
  float spacerWidth = 50;
  float spacerHeight = 50;
  float spaceH = 0;
  if(laptopID%2==0){
    //right side
    x = spacerWidth * laptopID + x;
  }else {
    //left side
    x = x - (spacerWidth * laptopID);
  }

  for(int i = 0; i<= laptopID; i++){
    if(laptopID>0){
      if(i%2!=0){
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
void sendData() {
  OscMessage heyMessage = new OscMessage("/schall");
  heyMessage.add("hey"); 
  oscP5.send(heyMessage, remoteLocation);
}
void oscEvent(OscMessage theOscMessage) {
 // String address = theOscMessage.address();
  //if (!address.contains(ownNetworkAddress))
  if(theOscMessage.checkAddrPattern("/schall_2"))
  {
    ID = theOscMessage.get(0).intValue();
    roamWidth = theOscMessage.get(1).floatValue();
    roamHeight = theOscMessage.get(2).floatValue();
  }
}
