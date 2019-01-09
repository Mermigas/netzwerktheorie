//Main function to draw the laptops
void drawLaptop(int laptopID, boolean visibilityState) {
  color laptopColor;
  //print(laptopID);
  if (visibilityState) {
    counterAnimateLaptop += 0.05;
    int lv = int(map(sin(counterAnimateLaptop), -1, 1, 30, 255));
    laptopColor = color(255, 0, 0, lv);
  } else {
    laptopColor = color(255, 255, 255, 100);
  }
  float[] position = getLaptopPosition(laptopID);
  stroke(laptopColor);
  drawCorners(position[0], position[1], laptopWidth, laptopHeight);
}

void drawCorners(float tmpX, float tmpY, float tmpW, float tmpH) {
  //oben links
  line(tmpX-tmpW/2, tmpY-tmpH/2, tmpX-tmpW/2 + tmpW/8, tmpY-tmpH/2);
  line(tmpX-tmpW/2, tmpY-tmpH/2, tmpX-tmpW/2, tmpY-tmpH/2 +tmpH/8);

  //oben rechts
  line(tmpX+tmpW/2, tmpY-tmpH/2, tmpX+tmpW/2 - tmpW/8, tmpY-tmpH/2);
  line(tmpX+tmpW/2, tmpY-tmpH/2, tmpX+tmpW/2, tmpY-tmpH/2 +tmpH/8);

  //untenlinks
  line(tmpX-tmpW/2, tmpY+tmpH/2, tmpX-tmpW/2 + tmpW/8, tmpY+tmpH/2);
  line(tmpX-tmpW/2, tmpY+tmpH/2, tmpX-tmpW/2, tmpY+tmpH/2 -tmpH/8);

  //untenrechts
  line(tmpX+tmpW/2, tmpY+tmpH/2, tmpX+tmpW/2 - tmpW/8, tmpY+tmpH/2);
  line(tmpX+tmpW/2, tmpY+tmpH/2, tmpX+tmpW/2, tmpY+tmpH/2 -tmpH/8);
}

float[] getLaptopPosition (int laptopID) {

  float x = width/2;
  float y = 50;
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
