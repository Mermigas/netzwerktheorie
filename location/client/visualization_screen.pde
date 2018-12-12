float[] getPositionInRoomByID(int tmpID) {
  
  float rowHeight = (roomHeight*100 * pxPerCm)/(maxLaptops/2+1);
  float columnWidth = (roomWidth*100 * pxPerCm)/(maxLaptops+1);
  float roomWidthPx = roomWidth * 100 * pxPerCm;
  float roomHeightPx = roomHeight * 100 * pxPerCm;
  float xMitteRoomPx;
  float yMitteRoomPx;

  if (ID%2==0) {
    //right side
    xMitteRoomPx = roomWidthPx/2 + columnWidth * int( ID/2);
    yMitteRoomPx =  rowHeight * int( ID/2)+ height/2;
  } else {
    //left side
    xMitteRoomPx = roomWidthPx/2 - columnWidth * (int(ID/2)+1);
    yMitteRoomPx = rowHeight * int( ID/2) + height/2;
  }
  float [] position = {xMitteRoomPx, yMitteRoomPx};
  return position;
}
void getPositionInRoom() {

  float rowHeight = (roomHeight*100 * pxPerCm)/(maxLaptops/2+1);
  float columnWidth = (roomWidth*100 * pxPerCm)/(maxLaptops+1);
  float roomWidthPx = roomWidth * 100 * pxPerCm;
  float roomHeightPx = roomHeight * 100 * pxPerCm;
  float xMitteRoomPx;
  float yMitteRoomPx;

  if (ID%2==0) {
    //right side
    xMitteRoomPx = roomWidthPx/2 + columnWidth * int( ID/2);
    yMitteRoomPx =  rowHeight * int( ID/2)+ height/2;
  } else {
    //left side
    xMitteRoomPx = roomWidthPx/2 - columnWidth * (int(ID/2)+1);
    yMitteRoomPx = rowHeight * int( ID/2) + height/2;
  }
  positionLeft = xMitteRoomPx - laptopSizeW/2*pxPerCm;
  positionTop = yMitteRoomPx - laptopSizeH/2*pxPerCm;
  positionRight = xMitteRoomPx + laptopSizeW/2*pxPerCm;
  positionBottom = yMitteRoomPx + laptopSizeH/2*pxPerCm;
  laptopXInCoordinateX = width/(positionRight-positionLeft+1);
}
float[] mapCordinates(float x, float y) {

  float tmpx = map(x, 0, roomWidth*100*pxPerCm, -positionLeft*laptopXInCoordinateX, (-positionLeft*laptopXInCoordinateX)+(roomWidth*100*pxPerCm*laptopXInCoordinateX)); 
  float tmpy = map(y, 0, roomHeight*100*pxPerCm, -positionTop*laptopXInCoordinateX, (-positionTop*laptopXInCoordinateX)+(roomHeight*100*pxPerCm*laptopXInCoordinateX)); 
  float[] position = {tmpx, tmpy}; 
  println(positionTop);
  println("X: " + x + " X-mapping: " + tmpx + " Y: " + y + " Y-Mapping: " + tmpy);
  return(position);
}
void drawVisualization (int tmpID, String tmpType, Float tmpFreq, float time, Float tmpAmp, Float tmpGlobalVelocity, int tmpEchoID) {
  
  boolean check = false;
 for (Echo tmpEcho : echo) {
   if(tmpEcho.echoID == tmpEchoID) {
     check = true;
   }
 }
 if (!check) {
  //get postion of echo in room
  float [] position = getPositionInRoomByID(tmpID);
  
  
  echo.add(new Echo(position[0], position[1], r, tmpFreq, tmpAmp, tmpType, time, tmpEchoID));
  //play sound 
  if (tmpID == ID){
    //sin.play(tmpFreq, tmpAmp);
  }
 }
  for (Echo tmpEcho : echo) {
    tmpEcho.display();
    
  }
}
