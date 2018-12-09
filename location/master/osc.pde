//Send ip, id, room width, room height
void sendId() {
  //send id
  OscMessage sendIP = new OscMessage("/id");

  for (int i = 0; i < ipAdresses.size(); i++) {
    if (!aliveIds[i]) {
      sendIP.add(ipAdresses.get(i));
      sendIP.add(i);
      sendIP.add(roomWidth);
      sendIP.add(roomHeight);
      //sendIP.add(numComputers);
      oscP5.send(sendIP, remoteLocation);
    }
  }
}

//send data (0 = type of wave; 1 = frequency; 2 = amp)
void sendData() {
  OscMessage sendData = new OscMessage("/data");
  if (squareOn == true) {
    sendData.add(0); //The id to which you should send it
    sendData.add("squarewave"); //is square active?
    sendData.add(squareFunction()[0]); //send frequency of square
    sendData.add(squareFunction()[1]); //send amp of square
    sendData.add(100.0); //global velocity
    oscP5.send(sendData, remoteLocation);
  }
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
