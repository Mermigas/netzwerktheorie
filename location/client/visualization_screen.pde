float[] getPositionInRoomByID(int tmpID) {
  
  float rowHeight = (roomHeight*100 * pxPerCm)/(maxLaptops/2+1);
  float columnWidth = (roomWidth*100 * pxPerCm)/(maxLaptops);
  float roomWidthPx = roomWidth * 100 * pxPerCm;
  float roomHeightPx = roomHeight * 100 * pxPerCm;
  float xMitteRoomPx;
  float yMitteRoomPx;
 
  if (tmpID%2==0) {
    //right side and first one
    xMitteRoomPx = roomWidthPx/2 + columnWidth * int( tmpID/2);
    //yMitteRoomPx =  rowHeight * int( tmpID/2)+ height/2;
    yMitteRoomPx =  rowHeight * int( ID/2)+ (laptopSizeH*pxPerCm/2);
  } else {
    //left side
    xMitteRoomPx = roomWidthPx/2 - columnWidth * (int(tmpID/2)+1);
    //yMitteRoomPx = rowHeight * (int( tmpID/2)+1) + height/2;
    yMitteRoomPx = rowHeight * (int( ID/2)+1) + (laptopSizeH*pxPerCm/2);
  }
   //println("xEcho: " + xMitteRoomPx + " yEcho: " + yMitteRoomPx);
   
  float [] position = {xMitteRoomPx, yMitteRoomPx};
  return position;
}
void getPositionInRoom() {

  float rowHeight = (roomHeight*100 * pxPerCm)/(maxLaptops/2+1);
  float columnWidth = (roomWidth*100 * pxPerCm)/(maxLaptops);
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
    yMitteRoomPx = rowHeight * (int( ID/2)+1) + height/2;
    
  }
  //println("xMitteRoom: " + xMitteRoomPx + " yMitteRoom: " + yMitteRoomPx);
  positionLeft = xMitteRoomPx - laptopSizeW/2*pxPerCm;
  //println("positionLeft: " + positionLeft);
  positionTop = yMitteRoomPx - laptopSizeH/2*pxPerCm;
  positionRight = xMitteRoomPx + laptopSizeW/2*pxPerCm;
  positionBottom = yMitteRoomPx + laptopSizeH/2*pxPerCm;
  laptopPXInCoordinatePX = width/(positionRight-positionLeft+1);
 // laptopXInCoordinateX = mapSizeW(laptopXInCoordinateX);
  laptopYInCoordinateY = height/(positionBottom-positionTop+1);
  //laptopYInCoordinateY = mapSizeH(laptopYInCoordinateY);
  //println("positionRight:" +  positionRight);
}
float[] mapCordinates(float x, float y) {
  float tmpx = map(x, 0, roomWidth*100*pxPerCm, -positionLeft*laptopPXInCoordinatePX, (-positionLeft*laptopPXInCoordinatePX)+(roomWidth*100*pxPerCm*laptopPXInCoordinatePX)); 
  float tmpy = map(y, 0, roomHeight*100*pxPerCm, -positionTop*laptopPXInCoordinatePX, (-positionTop*laptopPXInCoordinatePX)+(roomHeight*100*pxPerCm*laptopPXInCoordinatePX)); 
  
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
  println("add a new system");
  echo.add(new EchoSystem(position[0], position[1], tmpFreq, 20, tmpAmp, tmpType, time, tmpEchoID));
  //play sound 
  if (tmpID == ID){
    //sin.play(tmpFreq, tmpAmp);
  }
 }
//println("tempID: " +tmpID);
}
