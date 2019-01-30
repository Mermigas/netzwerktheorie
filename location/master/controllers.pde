void controller() {
  //General
  cp5 = new ControlP5(this);

  pfont_l = createFont("Montserrat-Light.ttf", 20, true); // use true/false for smooth/no-smooth
  font_l = new ControlFont(pfont_b, 16);

  pfont_r = createFont("Montserrat-Regular.ttf", 20, true); // use true/false for smooth/no-smooth
  font_r = new ControlFont(pfont_b, 12);

  pfont_b = createFont("Montserrat-SemiBold.ttf", 18, true); // use true/false for smooth/no-smooth
  font_b = new ControlFont(pfont_b, 12);


  cp5.addButton("send")
    .setPosition(width/2+150, height-35)
    .setCaptionLabel("Senden")
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(0, 0, 0))
    .setColorActive(color(#FFED5F))
    .setColorLabel(#FFED5F)
    ;


  //Main interfaces
  cp5.getController("send")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;

  cp5.addSlider("global_velocity")
    .setPosition(width/2-150, height-35)
    .setSize(100, 15)
    .setCaptionLabel("Globale Geschwindigkeit")
    .setRange(0, 100)
    .setValue(100)
    .setColorActive(color(#FFED5F))
    .setColorValue(color(#6d6d6d))
    .setColorForeground(color(#FFED5F))
    .setColorLabel(#ffffff)
    ;

  cp5.getController("global_velocity")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;
}

void sq_Controller() {
  //Toggle ON/Off
  toggle_1 = cp5.addToggle("sq_OnOff")
    .setPosition(sq_location.x+controlArea-buttonS_w, sq_location.y+15)
    .setColorActive(color(#FFED5F))
    .setColorForeground(#FFED5F)
    .setColorBackground(#000000)
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff)
    .setCaptionLabel("")
    .setSize(40, 20);
  ;

  cp5.getController("sq_OnOff")
    .getCaptionLabel()
    .setFont(pfont_l)
    .toUpperCase(false)
    ;

  //Frequency knob
  cp5.addKnob("sq_freq")
    .setPosition(sq_location.x, sq_location.y+space_t_k)
    .setRange(0, 500)
    .setRadius(knobR)
    .setCaptionLabel("Frequenz")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sq_freq")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;

  //amp knob
  cp5.addKnob("sq_amp")
    .setPosition(sq_location.x+knobR*2+space_k_k, sq_location.y+space_t_k)
    .setRange(0, 1)
    .setValue(0.5)
    .setRadius(knobR)
    .setCaptionLabel("Amplitude")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sq_amp")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;

  //duration knob
  cp5.addKnob("sq_duration")
    .setPosition(sq_location.x+knobR*4+space_k_k*2, sq_location.y+space_t_k)
    .setRange(0, 30)
    .setValue(1)
    .setRadius(knobR)
    .setCaptionLabel("Dauer")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sq_duration")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;
}

void sw_Controller() {
  //Toggle ON/Off
  toggle_2 = cp5.addToggle("sw_OnOff")
    .setPosition(sw_location.x+controlArea-buttonS_w, sw_location.y+15)
    .setColorActive(color(#FFED5F))
    .setColorForeground(#FFED5F)
    .setColorBackground(#000000)
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff)
    .setCaptionLabel("")
    .setSize(buttonS_w, 20);
  ;

  cp5.getController("sw_OnOff")
    .getCaptionLabel()
    .setFont(pfont_l)
    .toUpperCase(false)
    ;

  //Frequency knob
  cp5.addKnob("sw_freq")
    .setPosition(sw_location.x, sw_location.y+space_t_k)
    .setRange(0, 500)
    .setRadius(knobR)
    .setCaptionLabel("Frequenz")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sw_freq")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;

  //amp knob
  cp5.addKnob("sw_amp")
    .setPosition(sw_location.x+knobR*2+space_k_k, sw_location.y+space_t_k)
    .setRange(0, 1)
    .setValue(0.5)
    .setRadius(knobR)
    .setCaptionLabel("Amplitude")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sw_amp")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;

  //duration knob
  cp5.addKnob("sw_duration")
    .setPosition(sw_location.x+knobR*4+space_k_k*2, sw_location.y+space_t_k)
    .setRange(0, 5)
    .setValue(1)
    .setRadius(knobR)
    .setCaptionLabel("Dauer")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sw_duration")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;
}

void sin_Controller() {
  //Toggle ON/Off
  toggle_3 = cp5.addToggle("sin_OnOff")
    .setPosition(sin_location.x+controlArea-buttonS_w, sin_location.y+15)
    .setColorActive(color(#FFED5F))
    .setColorForeground(#FFED5F)
    .setColorBackground(#000000)
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff)
    .setCaptionLabel("")
    .setSize(buttonS_w, 20);
  ;

  cp5.getController("sin_OnOff")
    .getCaptionLabel()
    .setFont(pfont_l)
    .toUpperCase(false)
    ;

  //Frequency knob
  cp5.addKnob("sin_freq")
    .setPosition(sin_location.x, sin_location.y+space_t_k)
    .setRange(0, 500)
    .setRadius(knobR)
    .setCaptionLabel("Frequenz")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sin_freq")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;

  //amp knob
  cp5.addKnob("sin_amp")
    .setPosition(sin_location.x+knobR*2+space_k_k, sin_location.y+space_t_k)
    .setRange(0, 1)
    .setValue(0.5)
    .setRadius(knobR)
    .setCaptionLabel("Amplitude")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sin_amp")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;

  //duration knob
  cp5.addKnob("sin_duration")
    .setPosition(sin_location.x+knobR*4+space_k_k*2, sin_location.y+space_t_k)
    .setRange(0, 5)
    .setValue(1)
    .setRadius(knobR)
    .setCaptionLabel("Dauer")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255))
    .setColorLabel(#ffffff)
    .setColorValue(#ffffff);
  ;

  cp5.getController("sin_duration")
    .getCaptionLabel()
    .setFont(font_b)
    .toUpperCase(false)
    ;
}
