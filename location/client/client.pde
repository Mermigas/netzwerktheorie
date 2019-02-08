// Necessary imports for communicating via OSC
import oscP5.*;
import netP5.*;
import processing.sound.*;

// Global instances for communication objects
OscP5 oscP5;
NetAddress remoteLocation;
boolean test = false;
//GLOBALE VARIABLEN
boolean testMode = false;
String MODE="CONNECTING"; 
float roomWidth;
float roomHeight;
int maxLaptops;
int ID; //eigene ID
float laptopHeight = 20;
float laptopWidth = 30;
float roomHeightInPX;
float roomWidthInPX;
float globalRoomWidthInPx;
float globalRoomHeightInPx;
float laptopPXInCoordinatePX;
float laptopYInCoordinateY;
float timeController = 1;

int Y_AXIS = 1;
int X_AXIS = 2;

//NETWORK
String ownNetworkAddress;
boolean gotID = false; // ID von Master erhalten
float sendHeyTime = 1; // Zeit in Sekunden, wie oft "hey" gesendet wird
int sendHeyCounter = 0; // Counter für Hey-Nachrichten
int sendAliveCounter = 0; // Counter für Alive-Nachrichten
float sendAliveTime = 2; // Zeit die zwischen zwei Alive Nachrichten bestehen soll

//FONTS
PFont light;
PFont light20;

//FOR VISUALIZATION
ArrayList<EchoSystem> echo;
float pxPerCm = 40;
float laptopSizeW = 32;
float laptopSizeH = 18;
float positionLeft;
float positionTop;
float positionRight;
float positionBottom;


int fade=0;


//POSITION MODE
float marginHeight = 50;
float spacerWidth = 20;
float spacerHeight = 30;
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
color bg = color(42);
float bgFloat = 42;
float ease(float q) {
  return 3*q*q - 2*q*q*q;
}

//TEST
float xtest;
float ytest = 0;
float gtest=100;

//Sounds
SqrOsc square;
SawOsc saw;
SinOsc sine;

void setup() {
 // fullScreen();
 size(800,600);
  //FONTS
  light = createFont("Montserrat-Light.ttf", 32);
  light20 = createFont("Montserrat-Light.ttf", 20);

  //ID = -1;
  //NETWORK
  // Listen on port 12000
  oscP5 = new OscP5(this, 12001);
  remoteLocation = new NetAddress("255.255.255.255", 12001);
  ownNetworkAddress = NetInfo.getHostAddress();
  rectMode(CENTER);
  smooth();

  //TEST MODE 
  if (testMode) {
    gotID = true;
    MODE = "CONNECTED";
    ID=0;
    roomWidth = 20;
    roomHeight = 15;
    maxLaptops = 20;
  }
  echo = new ArrayList<EchoSystem>();

  //SOUND
  sine = new SinOsc(this);
  sine.play();
  sine.amp(0);
  
  saw = new SawOsc(this);
  saw.play();
  saw.amp(0);
  
  square = new SqrOsc(this);
  square.play();
  square.amp(0);
  
  

  ellipseMode(CENTER);
}
void draw() {

  //is ready
  if (MODE=="READY") {
    if (fade<255) {
      fade += 1;
    }
      getPositionInRoom ();
      background(bg);
      for (int i = echo.size()-1; i >= 0; i--) {
      EchoSystem p = echo.get(i);
      p.run();
      if (p.isDead()) {
        echo.remove(i);
      }
    }
    

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
    }
  }

  //send Hey-Message 
  float d = 1/sendHeyTime;
  if (!gotID && MODE=="CONNECTING") {
    drawLoading();
    if (millis()>(d*1000*sendHeyCounter)) {
      sendHeyCounter++;
      sendHey();
      print("hey");
    }
  }
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
    //!address.contains(ownNetworkAddress) && 
    theOscMessage.checkAddrPattern("/id") &&
    theOscMessage.get(0).stringValue().equals(ownNetworkAddress))
  {
    gotID = true;
    MODE = "CONNECTED";
    ID = theOscMessage.get(1).intValue();
    roomWidth = theOscMessage.get(2).floatValue();
    roomHeight = theOscMessage.get(3).floatValue();
    globalRoomWidthInPx = roomWidth*100*pxPerCm;
    globalRoomHeightInPx = roomHeight*100*pxPerCm;
    maxLaptops = theOscMessage.get(4).intValue();
    
    //maxLaptops = 20;
  } else if (theOscMessage.checkAddrPattern("/data") == true) {
    int id = theOscMessage.get(0).intValue();
    String type = theOscMessage.get(1).stringValue();
    float freq = theOscMessage.get(2).floatValue();
    float amp = theOscMessage.get(3).floatValue();
    float  globalVelocity = theOscMessage.get(4).floatValue();
    float time = theOscMessage.get(5).floatValue();
    int echoID = theOscMessage.get(6).intValue();
    println("getData for id: " + id + "width echo id: " + echoID + "width type:" + type);
    drawVisualization(id, type, freq, time, amp, globalVelocity, echoID);
  } else if (theOscMessage.checkAddrPattern("/global_velocity") == true) {
      timeController = theOscMessage.get(0).floatValue();
  }
}
