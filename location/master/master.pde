import processing.sound.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

/* Controllers */
ControlP5 cp5; //Setup Controller

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
float roomWidth = 17.2; //roomWidth
float roomHeight = 11.2; //roomHeight

String ip; //to handle current ipAdress
StringList ipAdresses; //List of all ip Adresses
boolean ipStatus = false; //is the ip already in ipAdresses?

int id;
boolean[] aliveIds = new boolean[100];
boolean idStatus = false; //is the id already in aliveIds?

boolean ipMatchId = false;

float timer; //timer to kill all ids

int numComputers = 20;

int counter_sq = -1; //a counter to let client check if the data was already send

void setup() {
  size(640, 420);
  
  /*** OSC ***/
  //listen
  oscP5 = new OscP5(this, 12000);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12001);

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

  if (STATE == 1) {
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
  
  println(counter_sq);
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
  for (int i = 0; i < 20; i++) {
    rect(width/2, 20 + i, 40, 40);
  }
}

//This function creates the duration and sends the value
void durationAndsend(float d_value) {
  time = time + 1/frameRate;
  
  //As long as time is under choosen time --> send data
  if (time <= d_value) {
    sendData();
  }
  
  //If time is over choosen time --> set everything to default
  if(time > d_value) {
    time = 0;
    senden = false;
  }
}

void killIds() {
  for (int i = 0; i < aliveIds.length; i++) {
    aliveIds[id] = false;
  }
}
