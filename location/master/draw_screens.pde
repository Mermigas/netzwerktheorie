class Screen {

  float spacerWidth = 20;
  float spacerHeight = 30;
  float laptopHeight = 20;
  float laptopWidth = 30;

  float[] position;
  color laptopColor;

  Screen(int laptopID) {
    position = getLaptopPosition(laptopID);
  }

  void display() {
    stroke(laptopColor);
    noFill();
    rect(position[0], position[1], laptopWidth, laptopHeight);
  }

  boolean detectCollision() {
    if (mouseX >= position[0] - laptopWidth/2 && mouseX <= position[0] + laptopWidth/2 && mouseY >= position[1] - laptopHeight/2 && mouseY <= position[1] + laptopHeight/2) {
      return true;
    } else {
      return false;
    }
  }

  float[] getLaptopPosition (int laptopID) {

    float x = width/2;
    float y = sq_location.y+260;
    float spaceH = 0;

    if (laptopID%2==0) {
      //right side
      x = spacerWidth * laptopID + x;
    } else {
      //left side
      x = x - (spacerWidth * laptopID)- 20;
    }

    for (int i = 0; i<= laptopID; i++) {
      if (laptopID>0) {
        if (i%2!=0) {
          spaceH += spacerHeight;
        }
      }
    }
    y += spaceH;
    float[] postion = new float[2];
    postion[0] = x;
    postion[1] = y;
    return postion;
  }
}
