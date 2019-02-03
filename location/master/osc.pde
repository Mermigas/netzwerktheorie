//Send ip, id, room width, room height
void sendId() {
  //send id
  OscMessage sendIP = new OscMessage("/id");

  for (int i = 0; i < ipAdresses.size(); i++) {
    if (!aliveIds[i]) {
      sendIP.add(ipAdresses.get(i)); //#0
      sendIP.add(i); //#1
      sendIP.add(roomWidth); //#2
      sendIP.add(roomHeight); //#3
      sendIP.add(numComputers); //#4
      oscP5.send(sendIP, remoteLocation);
    }
  }
}

//send data (0 = type of wave; 1 = frequency; 2 = amp)
void sendData() {
  OscMessage sendData = new OscMessage("/data");
  if (squareOn == true) {
    sendData.add(adressedId); //The id to which you should send it #0
    sendData.add("squarewave"); //is square active? #1
    sendData.add(squareFunction()[0]); //send frequency of square #2
    sendData.add(squareFunction()[1]); //send amp of square #3
    sendData.add(global_velocity); //global velocity #4
    sendData.add(duration_sq); //time (how long should it send) #5
    sendData.add(echoCounter); //counter #6
    oscP5.send(sendData, remoteLocation);
  }
  if (sawOn == true) {
    sendData.add(adressedId); //The id to which you should send it #0
    sendData.add("sawtooth"); //is square active? #1
    sendData.add(sawFunction()[0]); //send frequency of square #2
    sendData.add(sawFunction()[1]); //send amp of square #3
    sendData.add(global_velocity); //global velocity #4
    sendData.add(duration_sw); // time (how long should it send) #5
    sendData.add(echoCounter); // counter #6
    oscP5.send(sendData, remoteLocation);
  }
  if (squareOn == true) {
    sendData.add(adressedId); //The id to which you should send it #0
    sendData.add("sinewave"); //is square active? #1
    sendData.add(sineFunction()[0]); //send frequency of square #2
    sendData.add(sineFunction()[1]); //send amp of square #3
    sendData.add(global_velocity); //global velocity #4
    sendData.add(duration_sin); // time (how long should it send) #5
    sendData.add(echoCounter); // counter #6
    oscP5.send(sendData, remoteLocation);
  }
}

void sendVelocity() {
  //get global velocity
  global_velocity = cp5.getController("global_velocity").getValue();
  OscMessage sendData = new OscMessage("/global_velocity");
  sendData.add(global_velocity);
  
  oscP5.send(sendData, remoteLocation);
}

//listen to client
void oscEvent(OscMessage theOscMessage) {

  //Listen to hey
  if (theOscMessage.checkAddrPattern("/hey") == true) {

    ip = theOscMessage.get(0).stringValue();
    println(ip);

    //Check if current ip is already in StringList ipAdresses
    for (int i = 0; i < ipAdresses.size(); i++) {
      String currentId = ipAdresses.get(i);
      //If yes (ipStatus = true) --> ip won't get in list again
      if (ip.equals(currentId)) {
        ipStatus = true;
      }
    }

    //If ip is not in ipAdresses (ipStatus = false) --> append current ip to ipAdresses
    if (ipStatus == false) {
      aliveIds[ipAdresses.size()] = false;
      ipAdresses.append(ip);
    }

    //save hey
    hey = theOscMessage.get(1).stringValue();
    println(hey);

    //Print ipAdresses
    println(ipAdresses);
  }

  //Listen to alive
  if (theOscMessage.checkAddrPattern("/alive") == true) {
    id = theOscMessage.get(0).intValue();

    aliveIds[id] = true;
  }
}
