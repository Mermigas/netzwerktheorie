PFont light;
PFont light20;
float roomWidth;
float roomHeight;
String ownNetworkAddress;
boolean testMode = true;
String MODE="CONNECTING"; 
int fade=0;
float pxPerCm = 40;
float laptopSizeW = 32;
float laptopSizeH = 18;
float positionLeft;
float positionTop;
float positionRight;
float positionBottom;
int ID; //eigene ID
boolean gotID = false; // ID von Master erhalten
int maxLaptops;
float marginHeight = 50;
float spacerWidth = 20;
float spacerHeight = 30;
float laptopHeight = 20;
float laptopWidth = 30;
float roomHeightInPX;
float roomWidthInPX;
float laptopXInCoordinateX;
float xtest;
float ytest = 0;
float gtest=100;

float sendHeyTime = 1; // Zeit in Sekunden, wie oft "hey" gesendet wird
int sendHeyCounter = 0; // Counter für Hey-Nachrichten
int sendAliveCounter = 0; // Counter für Alive-Nachrichten
float sendAliveTime = 2; // Zeit die zwischen zwei Alive Nachrichten bestehen soll

float counterAnimateLaptop;

//LOADING SCREEN
int N = 360;
int n = 7;
float os;
float R = 100, r;
float th;
float t;
float counterAnimateText;
float timerText;
color bg = color(42, 40, 38);
float ease(float q) {
  return 3*q*q - 2*q*q*q;
}

// Necessary imports for communicating via OSC
import oscP5.*;
import netP5.*;

// Global instances for communication objects
OscP5 oscP5;
NetAddress remoteLocation;

void setup() {
  //size(800, 600, P2D);
  fullScreen();
  light = createFont("Montserrat-Light.ttf", 32);
  light20 = createFont("Montserrat-Light.ttf", 20);
  ID = -1;
  // Listen on port 12001
  oscP5 = new OscP5(this, 12001);
  remoteLocation = new NetAddress("255.255.255.255", 12001);
  ownNetworkAddress = NetInfo.getHostAddress();
  rectMode(CENTER);
  smooth();

  //TEST MODE 
  if (testMode) {
    gotID = true;
    MODE = "CONNECTED";
    ID=2;
    roomWidth = 20;
    roomHeight = 15;
    maxLaptops = 20;
  }
}
void draw() {

  //is ready
  if (MODE=="READY") {
    if (fade<255) {
      fade += 1;
    }
    //println(fade);
    background(255, 255, 255, fade);
    getPositionInRoom ();
    xtest++;
    ytest++;
    gtest++;
    
      float[] position = mapCordinates(40000, 300);
      fill(0);
      ellipse(position[0], position[1], gtest*10, gtest*10);
   
  }

  //is connected
  if (gotID && MODE=="CONNECTED") {
    background(bg);
    drawRoom();
    xtest = roomWidth * 100 * pxPerCm/2;

    //draw all laptops
    if (ID!=-1) {
      calculateSize();
      for (int i=0; i<=ID; i++) {
        if (i<ID) {
          drawLaptop(i, false);
        } else {
          drawLaptop(i, true);
        }
      }
    }
    if (timerText<3) {
      //draw text
      fill(255, 255, 255, 255);
      textSize(20);
      textAlign(CENTER);
      textFont(light20);
      text("Bitte stelle Deinen Laptop an die angegebende Position. bestätige mit Enter.", width/2, height/2);
      timerText+=1/frameRate;
    }
    //AliveMessage 
    float d = 1/sendAliveTime;
    if (millis()>(d*1000*sendAliveCounter)) {
      sendAliveCounter++;
      sendAlive();
      //println("sendAlive");
    }
  }

  //send Hey-Message 
  float d = 1/sendHeyTime;
  if (!gotID && MODE=="CONNECTING") {
    drawLoading();
    if (millis()>(d*1000*sendHeyCounter)) {
      sendHeyCounter++;
      sendHey();
    }
  }
}
void drawLaptop(int laptopID, boolean visibilityState) {
  color laptopColor;
  //print(laptopID);
  if (visibilityState) {
    counterAnimateLaptop += 0.05;
    int lv = int(map(sin(counterAnimateLaptop), -1, 1, 30, 255));
    laptopColor = color(255, 0, 0, lv);
  } else {
    laptopColor = color(255, 255, 255, 100);
  }
  float[] position = getLaptopPosition(laptopID);
  stroke(laptopColor);
  drawCorners(position[0], position[1], laptopWidth, laptopHeight);
}
void getPositionInRoom() {

  float rowHeight = (roomHeight*100 * pxPerCm)/(maxLaptops/2+1);
  float columnWidth = (roomWidth*100 * pxPerCm)/(maxLaptops+1);
  float roomWidthPx = roomWidth * 100 * pxPerCm;
  float roomHeightPx = roomHeight * 100 * pxPerCm;
  float xMitteRoomPx;
  float yMitteRoomPx;

  if (ID%2==0) {
    //right side
    xMitteRoomPx = roomWidthPx/2 + columnWidth * int( ID/2);
    yMitteRoomPx =  rowHeight * int( ID/2)+ height/2;
  } else {
    //left side
    xMitteRoomPx = roomWidthPx/2 - columnWidth * (int(ID/2)+1);
    yMitteRoomPx = rowHeight * int( ID/2) + height/2;
  }
  positionLeft = xMitteRoomPx - laptopSizeW/2*pxPerCm;
  positionTop = yMitteRoomPx - laptopSizeH/2*pxPerCm;
  positionRight = xMitteRoomPx + laptopSizeW/2*pxPerCm;
  positionBottom = yMitteRoomPx + laptopSizeH/2*pxPerCm;
  laptopXInCoordinateX = width/(positionRight-positionLeft+1);
}
float[] mapCordinates(float x, float y) {

  float tmpx = map(x, 0, roomWidth*100*pxPerCm, -positionLeft*laptopXInCoordinateX, (-positionLeft*laptopXInCoordinateX)+(roomWidth*100*pxPerCm*laptopXInCoordinateX)); 
  float tmpy = map(y, 0, roomHeight*100*pxPerCm, -positionTop*laptopXInCoordinateX, (-positionTop*laptopXInCoordinateX)+(roomHeight*100*pxPerCm*laptopXInCoordinateX)); 
  float[] position = {tmpx, tmpy}; 
  println(positionTop);
  println("X: " + x + " X-mapping: " + tmpx + " Y: " + y + " Y-Mapping: " + tmpy);
  return(position);
}
void drawCorners(float tmpX, float tmpY, float tmpW, float tmpH) {
  //oben links
  line(tmpX-tmpW/2, tmpY-tmpH/2, tmpX-tmpW/2 + tmpW/8, tmpY-tmpH/2);
  line(tmpX-tmpW/2, tmpY-tmpH/2, tmpX-tmpW/2, tmpY-tmpH/2 +tmpH/8);

  //oben rechts
  line(tmpX+tmpW/2, tmpY-tmpH/2, tmpX+tmpW/2 - tmpW/8, tmpY-tmpH/2);
  line(tmpX+tmpW/2, tmpY-tmpH/2, tmpX+tmpW/2, tmpY-tmpH/2 +tmpH/8);

  //untenlinks
  line(tmpX-tmpW/2, tmpY+tmpH/2, tmpX-tmpW/2 + tmpW/8, tmpY+tmpH/2);
  line(tmpX-tmpW/2, tmpY+tmpH/2, tmpX-tmpW/2, tmpY+tmpH/2 -tmpH/8);

  //untenrechts
  line(tmpX+tmpW/2, tmpY+tmpH/2, tmpX+tmpW/2 - tmpW/8, tmpY+tmpH/2);
  line(tmpX+tmpW/2, tmpY+tmpH/2, tmpX+tmpW/2, tmpY+tmpH/2 -tmpH/8);
}
void calculateSize() {
  int rows = maxLaptops/2 +1;
  float tmpHeight = (roomHeightInPX)/rows;
  spacerHeight = tmpHeight;
  laptopHeight = tmpHeight* 0.6;
  laptopWidth = laptopHeight * 1.3;
  spacerWidth = (roomWidthInPX/rows)/4;
}
float[] getLaptopPosition (int laptopID) {

  float x = width/2;
  float y = 50;
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
  if (key==ENTER && gotID) {
    MODE="READY";
  }
}

void sendAlive() {
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
    MODE = "CONNECTED";
    ID = theOscMessage.get(1).intValue();
    roomWidth = theOscMessage.get(2).floatValue();
    roomHeight = theOscMessage.get(3).floatValue();
    //maxLaptops = theOscMessage.get(4).intValue();
    maxLaptops = 20;
  }
}

void drawCircle(float q) {
  beginShape();
  for (int i=0; i<N; i++) {
    th = i*TWO_PI/N;
    os = map(cos(th-TWO_PI*t), -1, 1, 0, 1);
    os = 0.125*pow(os, 2.75);
    r = R*(1+os*cos(n*th + 1.5*TWO_PI*t + q));
    vertex(r*sin(th), -r*cos(th));
  }
  endShape(CLOSE);
}

void drawLoading() {
  t+=0.01;
  counterAnimateText += 0.05;
  background(bg);
  pushMatrix();
  translate(width/2, height/2);
  stroke(255);
  fill(bg);
  strokeWeight(7.5);
  pushMatrix();
  translate(2, 3);
  drawCircle(0);
  drawCircle(PI);
  popMatrix();
  stroke(230);
  strokeWeight(6);
  drawCircle(0);
  drawCircle(PI);
  popMatrix();
  textAlign(CENTER);
  int cv = int(map(sin(counterAnimateText), -1, 1, 30, 255));
  fill(255, 255, 255, cv);
  textSize(26);
  textFont(light);
  text("Waiting for Connection", width/2, height/2+170);
}
void drawRoom () {
  stroke(255);
  fill(bg);
  if (width/roomWidth<height/roomHeight) {
    //Breite ist einschränkend
    roomHeightInPX = width/roomWidth*roomHeight;
    roomWidthInPX = width-marginHeight;
    rect(25, 25, roomWidthInPX, roomHeightInPX );
  } else {
    //Höhe ist einschränkend
    roomWidthInPX = height/roomHeight*roomWidth;
    roomHeightInPX = height-marginHeight;
    rect(width/2, height/2, roomWidthInPX, roomHeightInPX);
  }
}
