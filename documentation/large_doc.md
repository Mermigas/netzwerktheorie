# Schallbild - Dokumentation

## Struktur dieses Dokuments
* [Beschreibung des Projekts](#description)
    - [Schall](#physics)
* [Technische Details](#techdetails)


### Beschreibung des Projekts <a name="description"></a>
Schallbild ist eine interaktive Multi-Laptop Installation.
Mittels eines Interfaces ist es möglich simple Waveforms zu erstellen, deren Frequenz und Amplitude zu verändern und diese Signal an alle verfügbaren Client Laptops zu verschicken.
In Abhängigkeit der generierten Parameter, wird von dem versendeten Signal eine Visualisierung des Schalls erstellt.
Der Aufbau enthält die Anordnung der Laptops in einer gegebenen Position. Dadurch kennt jeder Client seine Position im Raum.
Dies ermöglicht der Visualisierung sich über alles Laptops zu zeichnen. Ein Gesamtbild entsteht.

#### Schall <a name="physics"></a>
Als Grundlage unserer Visualisierung nahmen wir den Schall und seinen Hintergrund innerhalb der Physik. Dabei wollten wir zwar diesen abstraktdarstellen, doch auch mit einer realistischen, auf den Physikalischen Gesetzten, beruhenden Basis.
Hierbei war uns wichtig, dass diese aufgestellten Regeln erkennbar seien, aber nicht den Fokus von der bestehenden abstrakten Gestaltung fortnahmen.
Einer der prägnantesten Idee, die man bei unserer Darstellung unserer Installation erkennen konnte, ist die der Interferenz. Diese, in der Physik angesiedelte, Bezeichnung beschreibt genau, wie die Amplitude sich verändert, falls eine Überlagerung zwischen zwei oder mehreren Schallwellen vorliegt.
Jedoch ist dieser Begriff nicht nur auf reine Schallwellen anwendbar, sondern auch auf andere Wellen, wie zum Beispiel Licht- und Materiewellen.
Aufgrund des speziellen Kursthemas, haben wir uns aber nur mit den Schallwellen, also dem Sound, befasst und dies mit, vor allem, der destruktiven Interferenz gepaart.
Dies kann man in unserer Visualisierung insoweit sehen, als genau wie bei der Physikalischen destruktiven Interferenz, zwei Punkte – unsere Darstellung der Waves – sich auslöschen, sollten sie eine gleiche negative Amplitude teilen.
Teilen sie sich jedoch eine positive, so beschleunigen sie sich.
Dabei ist es egal, ob der Master eine Sinus- oder eine Saw-Wave zu einem der vorhandenen Clients gesendet hat. Punkte jeglicher, von uns festgelegten, Wave-Arten interagieren in unserer Installation mit jeweils Punkten der Anderen in der gleichen festgelegten Weise.


### Technische Details <a name="techdetails"></a>

#### Master

*OSC*

Der Master bestimmt wie groß der Raum in Metern ist und wie viele Laptops an der Installation teilhaben.
Im ersten Schritt empfängt der Master die IP Adresse der Clients und trägt sie in eine StringList ein. Dies passiert nur, wenn die IP Adresse noch nicht besagter List vorhanden ist.

```
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

```

Zeitgleich schickt der Master ein Paket an alle Clients mit der eigenen IP Adresse (zur Identifizierung), Position in der StringList, Raumbreite -und Länge und Anzahl der Computer.

```
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
```

Um sicher zustellen das alle Laptops noch im Netzwerk sind, wird die StringList mit allen ip Adressen alle 5 Sekunden zurück gesetzt. Der Master wartet auf ein Lebenssignal der Clients und trägt diese dann wieder in die Liste eine.

```
//Listen to alive
  if (theOscMessage.checkAddrPattern("/alive") == true) {
    id = theOscMessage.get(0).intValue();

    aliveIds[id] = true;
  }
```

Bei Benutzen des Interfaces und drücken des "Senden"-Knopfes wird je nach dem welche Einstellung und Parameter bestimmt wurden ein Paket an die Clients geschickt. Dieses Paket enthält auch die adressierte IP Adresse, die besagt auf welchem Client die Visualisierung stattfinden soll.

```
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
  if (sinOn == true) {
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
```

Die globale Geschwindigkeit wird über ein separates Paket an alle Clients gerichtet gesendet.

```
void sendVelocity() {
  //get global velocity
  global_velocity = cp5.getController("global_velocity").getValue();
  OscMessage sendData = new OscMessage("/global_velocity");
  sendData.add(global_velocity);

  oscP5.send(sendData, remoteLocation);
}
```


*Interface*

Das Interface des Masters enthält im oberen Bereich einen Vorschaubereich der Visualisierung. Darunter befinden sich drei Osciliatoren mit den eingestellen Waveform "Sinewave", "Sawtooth" und "Squarewave". Hier lassen sich die Parameter mittels Drehreglern Frequenz, Amplitude und Dauer der Sendung einstellen. Im mittleren Teil liegt ein Slider der die globale Geschwindigkeit der Visualisierung steuert. Im unteren Bereich befindet sich der Knopf zur Sendung des eingestellten Signals.

Die Interface-Elemente sind der Library [controlP5](https://github.com/sojamo/controlp5) von Andreas Schlegel entnommen.

#### Client

Im Clientprogramm wird zwischen 3 Zuständen unterschieden: 

1. Warten auf Verbindung
2. Darstellung der Positionierug im Raum
3. Die Visualisierung

*Warten auf Verbindung*

Mit dem Start des Programms sendet der Client jede Sekunde eine "hey-Nachricht" an den Master zusammen mit der eigenen IP-Adresse. Dies geschieht solange bis der Client noch keine Zuweisung durch den Masterrechner erhalten hat. 

```
//send Hey-Message every second
float d = 1/sendHeyTime;
if (!gotID && MODE=="CONNECTING") {
    drawLoading();
    if (millis()>(d*1000*sendHeyCounter)) {
      sendHeyCounter++;
      sendHey();
    }
}
  
void sendHey() {
  OscMessage heyMessage = new OscMessage("/hey");
  heyMessage.add(ownNetworkAddress); 
  heyMessage.add("hey");
  oscP5.send(heyMessage, remoteLocation);
}
```

*Positionierung im Raum*

Hat der Client seine ID vom Master und die übermittelte Raumgröße erhalten, wird überprüft ob die Höhe oder Breite des Bildschirmes "einschränkend" ist, um die größtmögliche Zeichung des Raumes auf dem Bildschirm zu erreichen. Anhand der ID wird die Position des eigenen Laptops bestimmt und in einer maßstabgetreuen Visualsierung dargestellt, damit ist gewährleitest, dass alle Laptops in der richtigen Position zueinander stehen, was elementar für die spätere synchrone Ausbreitung des Schalls darstellt.

*Visualisierung*

Wurde der Laptop an die passende Stelle positioniert, wartet dieser auf Daten vom Master. Mit einem dieser Datenpakete wird neben der "Schallart", der Dauer, der Amplitude und Frequenz, auch die ID mitgeschickt, auf welcher die Visualisierung starten soll. Anhand dieser ID, kann die Position des Startlaptops im Raum bestimmt werden. Dazu wird in zwei Kooridnatensysteme (das eigene und das des Raumes (global)) unterschieden. Zuerst wird die Position im globalen Koordinatensystem errechnet und zurückgegegeben. 

```
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
    yMitteRoomPx =  rowHeight * int( tmpID/2)+ rowHeight/2;
  } else {
    //left side
    xMitteRoomPx = roomWidthPx/2 - columnWidth * (int(tmpID/2)+1);
    yMitteRoomPx = rowHeight * (int( tmpID/2)+1) + rowHeight/2;
  }
   
  float [] position = {xMitteRoomPx, yMitteRoomPx};
  return position;
}
```
Im nächsten Schritt wird die errechnete Position des globalen Koordinatensystems auf das eigene Koordinatensystem gemapped. Dafür 

```
float[] mapCordinates(float x, float y) {
  float eins = -positionTop * laptopPXInCoordinatePX;
  float zwei = roomHeight*100*pxPerCm * laptopPXInCoordinatePX;
  float tmpx = map(x, 0, roomWidth*100*pxPerCm, -positionLeft*laptopPXInCoordinatePX, (-positionLeft*laptopPXInCoordinatePX)+(roomWidth*100*pxPerCm*laptopPXInCoordinatePX)); 
  float tmpy = map(y, 0, roomHeight*100*pxPerCm, -positionTop*laptopPXInCoordinatePX, eins+zwei); 
  
  float[] position = {tmpx, tmpy}; 
  return(position);
}
```



