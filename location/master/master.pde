import processing.sound.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

/* Controllers */
ControlP5 cp5; //Setup Controller

Toggle toggle_1;

//All inner controller messures
int knobR = 30;
int knobArea = 250;
int space_t_k = 50;

//different controllers
SqrOsc square;
boolean squareOn = false;
PVector sq_location = new PVector(200, 150);

/* State Machine */
int STATE = 0;

/* Send/receive stuff sound */
boolean senden = false;

/* Extra Stuff */
float duration_sq;
float time = 0; //time for how long to send

/* Send/receive stuff with client */
String hey; //first hey 
float roomWidth = 2; //roomWidth
float roomHeight = 2; //roomHeight

String ip; //to handle current ipAdress
StringList ipAdresses; //List of all ip Adresses
boolean ipStatus = false; //is the ip already in ipAdresses?

int id;
int adressedId; //the id that gets send, so the computer know if its addressed
boolean[] aliveIds = new boolean[100];
boolean idStatus = false; //is the id already in aliveIds?

boolean ipMatchId = false;

float timer; //timer to kill all ids

int numComputers = 6;

int counter_sq = -1; //a counter to let client check if the data was already send
boolean isOver = false;

//draw screens
float spacerWidth = 20;
float spacerHeight = 30;
float counterAnimateLaptop;
float laptopHeight = 20;
float laptopWidth = 30;
boolean detect = false;

//laptop thumnails
int colorThumbnails = color(255,0,0);

void setup() {
  size(640, 420);
  //fullScreen();

  /*** OSC ***/
  //listen
  oscP5 = new OscP5(this, 12001);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12000);

  ipAdresses = new StringList();

  /*** Controllers ***/
  controller();

  /*** Sound ***/
  square = new SqrOsc(this);
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

  //set how long Data should be send into the network
  if (senden == true) {
    durationAndsend(duration_sq);
  }

  if (STATE == 0) {
    //Text for the controllers
    fill(255);
    textAlign(LEFT);
    textSize(18);
    text("Squarewave", sq_location.x, sq_location.y);
    
    
  } else if (STATE == 1) {
    displayClients();
  }

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
  
  println(adressedId);
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
    counter_sq++;
  }
}

//Display the clients
void displayClients() {
  rectMode(CENTER);
  for (int i = 0; i < ipAdresses.size(); i++) {
    drawLaptop(i, true, colorThumbnails);
    if(mousePressed == true && detect == true) {
      adressedId = i;
      colorThumbnails = color(255);
    }
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

//void mousePressed() {
//  if(detect) {
//   println("hey");
//  }
//}
