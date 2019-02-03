/*** Squarewave ***/

//Function to turn on/off squarewave
void sq_OnOff(boolean on) {
  if (on == true) {
    //square.play();
    squareOn = true;
  } else {
    square.stop();
    squareOn = false;
    duration_sq = 0; //set duration to 0 so duration will be send if wave is off
  }
}

void sw_OnOff(boolean on) {
  if (on == true) {
    //saw.play();
    sawOn = true;
  } else {
    //saw.stop();
    sawOn = false;
    duration_sw = 0; //set duration to 0 so duration will be send if wave is off
  }
}

void sin_OnOff(boolean on) {
  if (on == true) {
    //sin.play();
    sinOn = true;
  } else {
    //sin.stop();
    sinOn = false;
    duration_sin = 0; //set duration to 0 so duration will be send if wave is off
  }
}

float[] squareFunction() {

  float freqV = cp5.getController("sq_freq").getValue();
  float ampV = cp5.getController("sq_amp").getValue();
  float durationV = 0;
  //Just read duration if turned on
  if(squareOn) {
    durationV = cp5.getController("sq_duration").getValue();
  }
  float[] array = {freqV, ampV};

  square.freq(freqV);
  square.amp(ampV);
  duration_sq = durationV;
  
  return array;
}

float[] sawFunction() {

  float freqV = cp5.getController("sw_freq").getValue();
  float ampV = cp5.getController("sw_amp").getValue();
  float durationV = 0;
  //Just read duration if turned on
  if(sawOn) {
    durationV = cp5.getController("sw_duration").getValue();
  }
  float[] array = {freqV, ampV};

  saw.freq(freqV);
  saw.amp(ampV);
  duration_sw = durationV;

  return array;
}

float[] sineFunction() {

  float freqV = cp5.getController("sin_freq").getValue();
  float ampV = cp5.getController("sin_amp").getValue();
  float durationV = 0;
  //Just read duration if turned on
  if(sinOn) {
    durationV = cp5.getController("sin_duration").getValue();
  }
  float[] array = {freqV, ampV};

  sin.freq(freqV);
  sin.amp(ampV);
  duration_sin = durationV;

  return array;
}
