void controller() {
  //General
  cp5 = new ControlP5(this);

  /* Tab */
  cp5.getTab("default")
    .activateEvent(true)
    .setLabel("Modulieren")
    .setId(0)
    .setSize(200, 200)
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(0, 0, 0))
    .setColorActive(color(#FFED5F))
    .setColorLabel(#cccccc)
    ;

  cp5.getTab("Standort")
    .activateEvent(true)
    .setId(1)
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(0, 0, 0))
    .setColorActive(color(#FFED5F))
    .setColorLabel(#cccccc)
    ;

  cp5.addButton("send")
    .setPosition(width/2+150, height-35)
    .setCaptionLabel("Senden")
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(0, 0, 0))
    .setColorActive(color(#FFED5F))
    .setColorLabel(#cccccc)
    ;

  /* Square */
  //Toggle ON/Off
  cp5.addToggle("sq_OnOff")
    .setPosition(sq_location.x+knobArea/2, sq_location.y-12)
    .setCaptionLabel("On/Off")
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
    .setColorActive(color(255, 255, 255));

  //amp knob
  cp5.addKnob("sq_amp")
    .setPosition(sq_location.x+knobArea/3, sq_location.y+space_t_k)
    .setRange(0, 1)
    .setValue(0.5)
    .setRadius(knobR)
    .setCaptionLabel("Amplitude")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255));

  //duration knob
  cp5.addKnob("sq_duration")
    .setPosition(sq_location.x+knobArea/3+knobArea/3, sq_location.y+space_t_k)
    .setRange(0, 5)
    .setValue(1)
    .setRadius(knobR)
    .setCaptionLabel("Dauer")
    .setColorCaptionLabel(color(#FFED5F))
    .setColorBackground(color(0, 0, 0))
    .setColorForeground(color(255, 255, 255))
    .setColorActive(color(255, 255, 255));
}
