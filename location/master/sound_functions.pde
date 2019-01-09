/*** Squarewave ***/

//Function to turn on/off squarewave
void sq_OnOff(boolean on) {
  if (on == true) {
    isOver = false;
    square.play();
    squareOn = true;
  } else {
    square.stop();
    squareOn = false;
  }
}

float[] squareFunction() {
  fill(255);
  textAlign(LEFT);
  textSize(18);
  text("Squarewave", sq_location.x, sq_location.y);

  float freqV = cp5.getController("sq_freq").getValue();
  float ampV = cp5.getController("sq_amp").getValue();
  float durationV = cp5.getController("sq_duration").getValue();
  float[] array = {freqV, ampV};

  square.freq(freqV);
  square.amp(ampV);
  duration_sq = durationV;

  return array;
}

//Turn off toggle when time is over (PLEASE MAKE IT CLEAN WHEN YOU HAVE TIME)
void turnOff() {
 if(toggle_1.getState() == true && isOver == true) {
   toggle_1.setState(false);
 }
}
