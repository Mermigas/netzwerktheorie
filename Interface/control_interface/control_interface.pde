import processing.sound.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

/* Osc */
OscP5 oscP5;
NetAddress remoteLocation;

/* Controllers */
ControlP5 cp5;

boolean senden = false;

boolean squareOn = false;
PVector sq_location = new PVector(200, 150);

//All inner controller messures
int knobR = 30;
int knobArea = 250;
int space_t_k = 50;

/* Sound */
SqrOsc square;

/* State Machine */
int STATE = 0;

/* Extra Stuff */
float duration_sq;
float time = 0;

void setup() {
  size(960, 675);

  /*** Osc ***/

  //listen
  oscP5 = new OscP5(this, 12000);

  //send
  remoteLocation = new NetAddress("255.255.255.255", 12001);

  /*** Controllers ***/
  controller();

  /*** Sound ***/
  square = new SqrOsc(this);
}

void draw() {
  background(#404040);

  //send area
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
}

//send data (0 = type of wave; 1 = frequency; 2 = amp)
void sendData() {
  OscMessage sendData = new OscMessage("/data");
  if (squareOn == true) {
    sendData.add("squarewave"); //is square active?
    sendData.add(squareFunction()[0]); //send frequency of square
    sendData.add(squareFunction()[1]); //send amp of square
    oscP5.send(sendData, remoteLocation);
  }
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
  
  println(time);
}
