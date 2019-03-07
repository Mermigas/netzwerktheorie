# Schallbild - Dokumentation

## Struktur dieses Dokuments
* [Beschreibung des Projekts](#description)
* [Technische Details](#techdetails)


### Beschreibung des Projekts <a name="description"></a>
Schallbild ist eine interaktive Multi-Laptop Installation.
Mittels eines Interfaces, ist es möglich simple Waveforms zu erstellen, deren Frequenz und Amplitude zuverändern und diese Signal an alle verfügbaren Client Laptops zu verschicken.
In Abhängigkeit der generierten Parameter, wird von dem versendeten Signal eine Visualisierung des Schals erstellt.
Der Aufbau enthält die Anordnung der Laptops in einer gegebenen Position. Dadurch kennt jeder Client seine Position im Raum.
Dies ermöglicht der Visualisierung sich über alles Laptops zu zeichnen. Ein Gesamtbild entsteht.

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
