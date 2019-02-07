void drawRoom () {
  stroke(255);
  fill(bg);
  if (width/roomWidth<height/roomHeight) {
    //Breite ist einschränkend
    roomHeightInPX = width/roomWidth*roomHeight;
    roomWidthInPX = width-marginHeight;
    
    rect(25, 25, roomWidthInPX, roomHeightInPX );
  } else {
    //Höhe ist einschränkend
    roomWidthInPX = height/roomHeight*roomWidth;
    roomHeightInPX = height-marginHeight;
    rect(width/2, height/2, roomWidthInPX, roomHeightInPX);
  }
}
void calculateSize() {
  int rows = maxLaptops/2 +1;
  float tmpHeight = (roomHeightInPX)/rows;
  spacerHeight = tmpHeight;
  laptopHeight = tmpHeight* 0.6;
  laptopWidth = laptopHeight * 1.3;
  spacerWidth = (roomWidthInPX/rows)/4;
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
void drawLaptop(int laptopID, boolean visibilityState) {
  color laptopColor;
  if (visibilityState) {
    counterAnimateLaptop += 0.05;
    int lv = int(map(sin(counterAnimateLaptop), -1, 1, 30, 255));
    laptopColor = color(255, 0, 0, lv);
  } else {
    laptopColor = color(255, 255, 255, 100);
  }
  float[] position = getLaptopPosition(laptopID);
  stroke(laptopColor);
  strokeWeight(1);
  drawCorners(position[0], position[1], laptopWidth, laptopHeight);
}

float[] getLaptopPosition (int laptopID) {

  float x = width/2;
  float y = marginHeight + 25;
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
