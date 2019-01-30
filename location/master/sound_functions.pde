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

void sw_OnOff(boolean on) {
  if (on == true) {
    isOver = false;
    saw.play();
    sawOn = true;
  } else {
    saw.stop();
    sawOn = false;
  }
}

void sin_OnOff(boolean on) {
  if (on == true) {
    isOver = false;
    sin.play();
    sinOn = true;
  } else {
    sin.stop();
    sinOn = false;
  }
}



float[] squareFunction() {

  float freqV = cp5.getController("sq_freq").getValue();
  float ampV = cp5.getController("sq_amp").getValue();
  float durationV = cp5.getController("sq_duration").getValue();
  float[] array = {freqV, ampV};

  square.freq(freqV);
  square.amp(ampV);
  duration_sq = durationV;

  return array;
}

float[] sawFunction() {

  float freqV = cp5.getController("sw_freq").getValue();
  float ampV = cp5.getController("sw_amp").getValue();
  float durationV = cp5.getController("sw_duration").getValue();
  float[] array = {freqV, ampV};

  saw.freq(freqV);
  saw.amp(ampV);
  duration_sw = durationV;

  return array;
}

float[] sineFunction() {

  float freqV = cp5.getController("sin_freq").getValue();
  float ampV = cp5.getController("sin_amp").getValue();
  float durationV = cp5.getController("sin_duration").getValue();
  float[] array = {freqV, ampV};

  sin.freq(freqV);
  sin.amp(ampV);
  duration_sin = durationV;

  return array;
}


//Turn off toggle when time is over (PLEASE MAKE IT CLEAN WHEN YOU HAVE TIME)
void turnOff() {
  if (toggle_1.getState() == true && isOver == true) {
    toggle_1.setState(false);
  }
  if (toggle_2.getState() == true && isOver == true) {
    toggle_2.setState(false);
  }
}
