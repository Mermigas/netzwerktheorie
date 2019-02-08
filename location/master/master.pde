import processing.sound.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

/* Controllers */
ControlP5 cp5; //Setup Controllers

Toggle toggle_1;
Toggle toggle_2;
Toggle toggle_3;

//All inner controller messures
int knobR = 30;
int space_t_k = 60;
int space_k_k = 20;
int buttonS_w = 40;
int controlArea = knobR*6+space_k_k*2;

color sendingStateColor = color(#FFED5F);

//different controllers
SqrOsc square;
boolean squareOn = false;
PVector sq_location = new PVector(910, 270);
float duration_sq = 0;

SawOsc saw;
boolean sawOn = false;
PVector sw_location = new PVector(620, 270);
float duration_sw = 0;

SinOsc sin;
boolean sinOn = false;
PVector sin_location = new PVector(330, 270);
float duration_sin = 0;

int echoCounter = -1; //counts how often the waves were sent

float global_velocity;

/* State Machine */
int STATE = 0;

/* Send/receive stuff sound */
boolean senden = false;

/* Extra Stuff */
float time = 0; //time for how long to send

/* Send/receive stuff with client */
String hey; //first hey 
float roomWidth = 3; //roomWidth
float roomHeight = 4; //roomHeight

String ip; //to handle current ipAdress
StringList ipAdresses; //List of all ip Adresses
boolean ipStatus = false; //is the ip already in ipAdresses?

int id;
int adressedId = 0; //the id that gets send, so the computer know if its addressed
boolean[] aliveIds = new boolean[100];
boolean idStatus = false; //is the id already in aliveIds?

boolean ipMatchId = false;

float timer; //timer to kill all ids

int numComputers = 8;

boolean isOver = false;


int colorThumbnails = color(255, 0, 0);
boolean displayState = false;

//fonts
PFont pfont_l;
PFont pfont_r;
PFont pfont_b;
ControlFont font_l;
ControlFont font_r;
ControlFont font_b;

//display visualisation
ArrayList<EchoSystem> echo;
int displayVX, displayVY, displayVW, displayVH;
color bg = color(42);
boolean displayClicked = false;

float freq;
float amp;
//float duration;

ArrayList <Screen> screens;

boolean Toggle_1State;
boolean Toggle_2State;
boolean Toggle_3State;

int Y_AXIS = 1;
int X_AXIS = 2;

void setup() {
  //size(1200, 850);
  fullScreen();

  /*** OSC ***/
  //listen
  oscP5 = new OscP5(this, 12001);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12001);

  ipAdresses = new StringList();

  /*** Controllers controlP5 ***/
  controller();
  sq_Controller();
  sw_Controller();
  sin_Controller();

  /*** Sound ***/
  square = new SqrOsc(this);
  saw = new SawOsc(this);
  sin = new SinOsc(this);

  /*** font ***/
  textFont(pfont_r);

  /*** visual display ***/
  displayVW = width;
  displayVH = 260;
  displayVX = 0;
  displayVY = 0;

  echo = new ArrayList<EchoSystem>();
  echo.add(new EchoSystem(displayVX + displayVW/2, displayVY + displayVH/2, 100, 5, 0.5, "sinus", 1));

  screens = new ArrayList<Screen>();
}

void draw() {
  /* DRAW BEGIN */
  background(42);

  //get Toggle States
  Toggle_1State = toggle_1.getState();
  Toggle_2State = toggle_2.getState();
  Toggle_3State = toggle_3.getState();

  //Call the waves
  squareFunction();
  sawFunction();
  sineFunction();

  //has nothing do to with the actual sending. But calculates the current sending duration
  if (senden == true) {
    duration(duration_sq + duration_sw + duration_sin);
  }
  //interface element: sending status
  sendingSignal();

  //send globalVelocity
  sendVelocity();

  //Text for the controllers
  fill(255);
  stroke(#FFED5F);
  textAlign(LEFT);
  textSize(18);
  text("Squarewave", sq_location.x, sq_location.y+30);
  text("Sawtooth", sw_location.x, sw_location.y+30);
  text("Sinewave", sin_location.x, sin_location.y+30);

  /*** Communication with client ***/
  sendId();

  timer += 1/frameRate;
  //Set all ids to false
  if (timer >= 5) {
    killIds();
    timer = 0;
  }

  /*** Interface ***/
  //area for sending
  rectMode(CENTER);
  fill(0, 0);
  stroke(sendingStateColor);
  rect(width/2, height-22, 180, 40);

  //display visualisations
  stroke(#FFED5F);
  noFill();
  if (sinOn) {
    for (int i = echo.size()-1; i >= 0; i--) {
      EchoSystem p = echo.get(i);
      p.freq = sineFunction()[0];
      p.amp = sineFunction()[1];
      p.run();
    }
  } else if (sawOn) {
    for (int i = echo.size()-1; i >= 0; i--) {
      EchoSystem p = echo.get(i);
      p.freq = sawFunction()[0];
      p.amp = sawFunction()[1];
      p.run();
    }
  } else if (squareOn) {
    for (int i = echo.size()-1; i >= 0; i--) {
      EchoSystem p = echo.get(i);
      p.freq = squareFunction()[0];
      p.amp = squareFunction()[1];
      p.run();
    }
  }

  //seperators
  stroke(#FFED5F);
  line(0, displayVH, width, displayVH);
  line(0, sq_location.y+170, width, sq_location.y+170);

  //Display the clients
  screens.clear();
  for (int i = 0; i < ipAdresses.size(); i++) {
    screens.add(new Screen(i));
  }

  for (int i = 0; i < ipAdresses.size(); i++) {
    Screen s = screens.get(i);
      s.laptopColor = color(255);
    if (adressedId == i) {
      s.laptopColor = color(#FFED5F);
    }
    s.display();
  }
  /* DRAW END */
}

//Bring state machine and tabs together
void controlEvent(ControlEvent theControlEvent) {

  //turn send true if "senden" is clicked and count up echoCounter for each waveform
  if (theControlEvent.getController().getName().equals("send")) {
    senden = true;
    //if "senden" is clicked --> sendData() once!
    if (squareOn == true) {
      echoCounter++;
      sendData();
    }
    if (sawOn == true) {
      echoCounter++;
      sendData();
    }
    if (sinOn == true) {
      echoCounter++;
      sendData();
    }
  }
}

//This function creates the duration and sends the value
void duration(float durationWave) {
  time = time + 1/frameRate * global_velocity;

  if (time >= durationWave) {
    senden = false;
    time = 0;
  }
}

//is the sending 
void sendingSignal() {
  if (senden == false) {
    sendingStateColor = color(#FFED5F);
  } else {
    sendingStateColor = color(#55F063);
  }
}

void killIds() {
  for (int i = 0; i < aliveIds.length; i++) {
    aliveIds[id] = false;
  }
}

//get ip adressed
void mousePressed() {
  for (int i = 0; i < ipAdresses.size(); i++) {
    Screen s = screens.get(i);
    if (s.detectCollision()) {
      adressedId = i;
      displayClicked = true;
    } else {
      displayClicked = false;
    }
  }
}
