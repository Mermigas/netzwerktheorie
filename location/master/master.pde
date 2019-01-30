import processing.sound.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

/* Controllers */
ControlP5 cp5; //Setup Controller

Toggle toggle_1;
Toggle toggle_2;
Toggle toggle_3;

//All inner controller messures
int knobR = 30;
int space_t_k = 60;
int space_k_k = 20;
int buttonS_w = 40;
int controlArea = knobR*6+space_k_k*2;

//different controllers
SqrOsc square;
boolean squareOn = false;
PVector sq_location = new PVector(180, 300);
float duration_sq;

SawOsc saw;
boolean sawOn = false;
PVector sw_location = new PVector(470, 300);
float duration_sw;

SinOsc sin;
boolean sinOn = false;
PVector sin_location = new PVector(760, 300);
float duration_sin;

int echoCounter = -1; //counts how often the waves were sent

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

int numComputers = 12;

boolean isOver = false;

//draw screens
float spacerWidth = 20;
float spacerHeight = 30;
float counterAnimateLaptop;
float laptopHeight = 20;
float laptopWidth = 30;
boolean detect = false;

//laptop thumnails
int colorThumbnails = color(255, 0, 0);
boolean displayState = false;

//fonts
PFont pfont_l;
PFont pfont_r;
PFont pfont_b;
ControlFont font_l;
ControlFont font_r;
ControlFont font_b;

void setup() {
  //size(640, 420);
  size(1200, 850);
  //fullScreen();

  /*** OSC ***/
  //listen
  oscP5 = new OscP5(this, 12000);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12000);

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
}

void draw() {
  background(#404040);

  /*** Interface ***/
  //area for sending
  rectMode(CENTER);
  fill(0, 0);
  stroke(#FFED5F);
  rect(width/2, height-30, 560, 60);

  //Call the waves
  squareFunction();
  sawFunction();
  sineFunction();

  //set how long Data should be send into the network
  if (senden == true) {
    durationAndsend(duration_sq);
    durationAndsend(duration_sw);
    durationAndsend(duration_sin);
  }

  //Text for the controllers
  fill(255);
  textAlign(LEFT);
  textSize(18);
  text("Squarewave", sq_location.x, sq_location.y+30);
  stroke(#FFED5F);

  fill(255);
  text("Sawtooth", sw_location.x, sw_location.y+30);

  text("Sinewave", sin_location.x, sin_location.y+30);

  //display the clients
  noFill();
  displayClients();


  /*** Communication with client ***/
  sendId();

  timer += 1/frameRate;
  //Set all ids to false
  if (timer >= 5) {
    killIds();
    //println("ids killed");
    timer = 0;
  }
  turnOff();
  
  //waveform display
  stroke(#FFED5F);
  rectMode(CORNER);
  rect(width/2-200,30,400,220);
}

//Bring state machine and tabs together
void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    if (theControlEvent.getTab().getId() == 1) {
      STATE = 1;
    } else {
      STATE = 0;
    }
  }

  if (theControlEvent.getController().getName().equals("send")) {
    senden = true;
    echoCounter++;
  }
}

//Display the clients
void displayClients() {
  rectMode(CENTER);
  for (int i = 0; i < ipAdresses.size(); i++) {
    drawLaptop(i, colorThumbnails);
  }
}

//This function creates the duration and sends the value
void durationAndsend(float d_value) {
  time = time + 1/frameRate;

  //As long as time is under choosen time --> send data
  if (time <= d_value) {
    isOver = false;
    sendData();
  }

  //If time is over choosen time --> set everything to default
  if (time > d_value) {
    time = 0;
    senden = false;
    isOver = true;
  }
}

void killIds() {
  for (int i = 0; i < aliveIds.length; i++) {
    aliveIds[id] = false;
  }
}

//display laptop interface (STATE 1)
void mousePressed() {
  for (int i = 0; i < ipAdresses.size(); i++) {
    if (detect == true && displayState == false) {
      adressedId = i;
      displayState = true;
      colorThumbnails = color(255);
    } else if (detect == true && displayState == true) {
      displayState = false;
      colorThumbnails = color(255, 0, 0);
    }
  }
}
