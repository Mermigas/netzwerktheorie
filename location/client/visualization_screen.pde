float[] getPositionInRoomByID(int tmpID) {
  
  float roomWidthPx = roomWidth * 100 * pxPerCm;
  float roomHeightPx = roomHeight * 100 * pxPerCm;
  float rowHeight = roomHeightPx/(maxLaptops/2+1);
  float columnWidth = roomWidthPx/(maxLaptops);

  float xMitteRoomPx;
  float yMitteRoomPx;
 
  if (tmpID%2==0) {
    //right side and first one
    xMitteRoomPx = roomWidthPx/2 + columnWidth * int( tmpID/2);
    //yMitteRoomPx =  rowHeight * int( tmpID/2)+ height/2;
    yMitteRoomPx =  rowHeight * int( tmpID/2)+ rowHeight/2;
  } else {
    //left side
    xMitteRoomPx = roomWidthPx/2 - columnWidth * (int(tmpID/2)+1);
    //yMitteRoomPx = rowHeight * (int( tmpID/2)+1) + height/2;
    yMitteRoomPx = rowHeight * (int( tmpID/2)+1) + rowHeight/2;
  }
   //println("xEcho: " + xMitteRoomPx + " yEcho: " + yMitteRoomPx);
   
  float [] position = {xMitteRoomPx, yMitteRoomPx};
  return position;
}
void getPositionInRoom() {
  float roomWidthPx = roomWidth * 100 * pxPerCm;
  float roomHeightPx = roomHeight * 100 * pxPerCm;
  
  float rowHeight = roomHeightPx/(maxLaptops/2+1);
  float columnWidth = roomWidthPx/(maxLaptops);

  float xMitteRoomPx;
  float yMitteRoomPx;

  if (ID%2==0) {
    //right side
    xMitteRoomPx = roomWidthPx/2 + columnWidth * int( ID/2);
    //yMitteRoomPx =  rowHeight * int( ID/2)+ (pxPerCm*laptopSizeH/2);
    yMitteRoomPx =  rowHeight * int( ID/2) + rowHeight/2;
    
  } else {
    //left side
    xMitteRoomPx = roomWidthPx/2 - columnWidth * (int(ID/2)+1);
    //yMitteRoomPx = rowHeight * (int( ID/2)+1) + (laptopSizeH*pxPerCm/2);
     yMitteRoomPx = rowHeight * (int( ID/2)+1) + rowHeight/2;
    
  }
  //println("xMitteRoom: " + xMitteRoomPx + " yMitteRoom: " + yMitteRoomPx);
  positionLeft = xMitteRoomPx - width/2;
  //println("positionLeft: " + positionLeft);
  positionTop = yMitteRoomPx - height/2;
  positionRight = xMitteRoomPx + width/2;
  positionBottom = yMitteRoomPx + height/2;
  laptopPXInCoordinatePX = width/(positionRight-positionLeft+1);
 // laptopXInCoordinateX = mapSizeW(laptopXInCoordinateX);
  laptopYInCoordinateY = height/(positionBottom-positionTop+1);
  //laptopYInCoordinateY = mapSizeH(laptopYInCoordinateY);
  //println("positionRight:" +  positionRight);
  float[] positionTest  = mapCordinates(positionRight, positionBottom);
  //println("mapping: " + positionTest[0] + " " + positionTest[1] + " height: " + height );
  float mapvoll =  (-positionTop*laptopPXInCoordinatePX)+(roomHeight*100*pxPerCm*laptopPXInCoordinatePX);
  float mapnull = -positionTop*laptopPXInCoordinatePX;
  //println("roomheighinpx:" + roomHeight*100*pxPerCm + "map0: " + mapnull + "mapvoll: " + mapvoll); 
}
float[] mapCordinates(float x, float y) {
  float eins = -positionTop * laptopPXInCoordinatePX;
  float zwei = roomHeight*100*pxPerCm * laptopPXInCoordinatePX;
  float tmpx = map(x, 0, roomWidth*100*pxPerCm, -positionLeft*laptopPXInCoordinatePX, (-positionLeft*laptopPXInCoordinatePX)+(roomWidth*100*pxPerCm*laptopPXInCoordinatePX)); 
  float tmpy = map(y, 0, roomHeight*100*pxPerCm, -positionTop*laptopPXInCoordinatePX, eins+zwei); 
  
  float[] position = {tmpx, tmpy}; 
  //float tmp1 = -positionLeft*laptopXInCoordinateX;
  //float tmp2 = (-positionLeft*laptopXInCoordinateX)+(roomWidth*100*pxPerCm*laptopXInCoordinateX);
  //println("ID:" + ID + "left-border:" + tmp1 + "rightBorder: " + tmp2 );
  //println("X: " + x + " X-mapping: " + tmpx + " Y: " + y + " Y-Mapping: " + tmpy);
  return(position);
}
float mapSizeW(float size) {
  float newSize = size * width/(laptopSizeW * pxPerCm);
  return(newSize);
}
float mapSizeH(float size) {
  float newSize = size * height/(laptopSizeH * pxPerCm);
  return(newSize);
}
void drawVisualization (int tmpID, String tmpType, Float tmpFreq, float time, Float tmpAmp, Float tmpGlobalVelocity, int tmpEchoID) {
  
  boolean check = false;
 for (EchoSystem tmpEcho : echo) {
   if(tmpEcho.echoID == tmpEchoID) {
     check = true;
   }
 }
// check = false;
 if (!check) {
  //get postion of echo in room
  float [] position = getPositionInRoomByID(tmpID);
  //float [] positionMapped = mapCordinates(position[0], position[1]);
  //println("xEchoMapped: " + position[0] + " yEchoMapped: " + position[1]);
  //println("add a new system");
  echo.add(new EchoSystem(position[0], position[1], tmpFreq, 20, tmpAmp, tmpType, time, tmpEchoID, tmpID));
 }
//println("tempID: " +tmpID);
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
