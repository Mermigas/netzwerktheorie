import processing.sound.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

/* Osc */
OscP5 oscP5;
NetAddress remoteLocation;

/* Controllers */
ControlP5 cp5;
boolean squareActive = false;

/* Sound */
SqrOsc square;

/* State Machine */

int STATE = 0;

void setup() {
  size(960, 675);

  /*** Osc ***/

  //listen
  oscP5 = new OscP5(this, 12001);

  //send
  remoteLocation = new NetAddress("255.255.255.255", 12001);

  /*** Controllers ***/
  cp5 = new ControlP5(this);


  /* Tab */
  cp5.getTab("default")
    .activateEvent(true)
    .setLabel("Modulieren")
    .setId(0)
    .setSize(200,200)
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(0, 0, 0))
    .setColorActive(color(#FFED5F))
    ;

  cp5.getTab("Standort")
    .activateEvent(true)
    .setId(1)
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(0, 0, 0))
    .setColorActive(color(#FFED5F))
    ;



  /* Square */
  //Main Button to active square
  cp5.addButton("square")
    .setPosition(50, 50)
    .setCaptionLabel("Squarewave")
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(0, 0, 0))
    .setColorActive(color(0, 0, 0))
    .setColorCaptionLabel(color(#FFED5F))
    .setMouseOver(false);

  //Frequency knob
  cp5.addKnob("freq")
    .setPosition(50, 100)
    .setRange(0, 500)
    .setRadius(30)
    .setCaptionLabel("Frequenz")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255));

  //amp knob
  cp5.addKnob("amp")
    .setPosition(120, 100)
    .setRange(0, 1)
    .setValue(0.5)
    .setRadius(30)
    .setCaptionLabel("Amplitude")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255));

  /*** Sound ***/
  square = new SqrOsc(this);
}

void draw() {
  background(#404040);
  
  rectMode(CENTER);
  fill(0,0);
  stroke(#FFED5F);
  rect(width/2,height-45,480,90);

  //Call the waves
  squareFunction();

  //send Data into network
  sendData();
  
  if(STATE == 1) {
   displayClients();
  }
}

//send data
void sendData() {
  OscMessage sendData = new OscMessage("/data");
  sendData.add(squareActive); //is square active?
  sendData.add(squareFunction()[0]); //send frequency of square
  sendData.add(squareFunction()[1]); //send amp of square
}

//Activate waves
void square(int theValue) {
  if (!squareActive) {
    squareActive = true; 
    square.play();
  } else {
    squareActive = false; 
    square.stop();
  }
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    if(theControlEvent.getTab().getId() == 1) {
     STATE = 1;
    } else {
     STATE = 0; 
    }
  }
}

void displayClients() {
   rectMode(CENTER);
   for(int i = 0; i < 20; i++) {
    rect(width/2, 20 + i, 40, 40);
   }
}

float[] squareFunction() {
  float freqV = cp5.getController("freq").getValue();
  float ampV = cp5.getController("amp").getValue();
  float[] array = {freqV, ampV};

  square.freq(freqV);
  square.amp(ampV);

  return array;
}
