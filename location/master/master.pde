import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;

String hey; //first hey 
float roomWidth = 17.2; //roomWidth
float roomHeight = 11.2; //roomHeight

String ip; //to handle current ipAdress
StringList ipAdresses; //List of all ip Adresses
boolean ipStatus = false; //is the ip already in ipAdresses?

int id;
boolean[] aliveIds = new boolean[100];
boolean idStatus = false; //is the id already in aliveIds?

boolean ipMatchId = false;

float timer;

int numComputers = 20;

void setup() {
  size(640, 420);
  //listen
  oscP5 = new OscP5(this, 12001);
  //send
  remoteLocation = new NetAddress("255.255.255.255", 12001);

  ipAdresses = new StringList();
}

void draw() {
  sendId();

  timer += 1/frameRate;
  //Set all ids to false
  if (timer >= 5) {
    killIds();
    //println("ids killed");
    timer = 0;
  }
}

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

void displayClients() {
  for(int i = 0; i < aliveIds.length; i++) {
    
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

void killIds() {
  for (int i = 0; i < aliveIds.length; i++) {
    aliveIds[id] = false;
  }
}
