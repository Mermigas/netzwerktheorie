# Schallbild - Dokumentation

## Struktur dieses Dokuments
* [Beschreibung des Projektes](#description)
    - [Schall](#physics)
    - [Visualsierung](#looks)
* [Technische Details] (#techdetails)


### Beschreibung des Projekts <a name="description"></a>
Schallbild ist eine interaktive Multi-Laptop Installation.
Mittels eines Interfaces ist es möglich simple Waveforms zu erstellen, deren Frequenz und Amplitude zu verändern und dieses Signal an alle verfügbaren Client Laptops zu verschicken.
In Abhängigkeit der generierten Parameter, wird von dem versendeten Signal eine Visualisierung des Schalls erstellt.
Der Aufbau enthält die Anordnung der Laptops in einer gegebenen Position. Dadurch kennt jeder Client seine Position im Raum.
Dies ermöglicht der Visualisierung sich über alles Laptops zu zeichnen. Ein Gesamtbild entsteht.

#### Schall <a name="physics"></a>
Mit dem Kursthema im Hinterkopf, eine Art Orchester mithilfe verschiedener Laptops zu erschaffen, fingen wir an uns über mögliche Herangehensweisen zu unterhalten. Nach längeren Diskussionen entschieden wir uns, als Grundlage unserer Visualisierung das Thema „Schall“ unter Berücksichtigung seiner physikalischen Gesetze zu behandeln. Dabei ist das Ziel sowohl eine abstrakte als auch eine korrekte Darstellung umzusetzen. Die abstrakte Gestaltung der mechanischen Ausbreitung soll dabei jedoch im Fokus stehen.  

Unsere Visualisierung der Schwingungen beschränkt sich auf drei primitive Wellenformen, die Sinus-Welle (sine wave), die Rechteck-Welle (square wave) und die Sägezahn-Welle (saw wave). 	
Es werden pro Phase Partikel entsandt, welche sich kreisförmig ausbreiten. Jede Wellenform hat ihre eigenen Partikel. Somit werden die der Sinus-Welle durch weiße Kreise visualisiert, die der Rechteck-Welle durch jeweils vier weiße Rechtecke und die Sägezahn-Welle durch ein Rechteck mit Farbverlauf von schwarz nach weiß. Die Ausbreitung der Partikel findet kontinuierlich statt, es sei denn, sie prallen von einer der Wände ab oder sie kollidieren miteinander.
Ausschlaggebend für unsere Visualisierung sind die Interaktionen der Partikel einer Schwingungsart. Beispielsweise interagieren Sinus-Wellen mit Sinus-Wellen, Rechteck-Wellen mit Rechteckwellen und Sägezahn-Wellen mit Sägezahnwellen.
Im Falle eines Aufeinandertreffens zweier Partikel derselben Art innerhalb eines bestimmten Frequenzbereichs verhalten sich diese abhängig von ihrer Amplitude. Treffen zwei positive Amplituden aufeinander, interferieren diese. Sie überlagern sich. In unserer Visualisierung wird dies beispielsweise durch zwei weiß-gefüllte Kreise (sine wave) symbolisiert, welche sich im Interferenzfall innerhalb des Frequenzbereichs vereinen und vergrößern.  Überlagern sich zwei negative Amplituden, passiert dies mit weiß-konturierten Kreisen. Im Falle einer Kollision eines Partikels mit negativer und eines mit positiver Amplitude erfolgt wie in der Physik eine destruktive Interferenz, das heißt, dass sich die Partikel gegenseitig auslöschen.  


### Visualsierung <a name="looks"></a>

Um die Idee, die wir über die Visualisierungsmöglichkeiten von den verschiedensten Schallwellen hatten, eine größtmögliche Wirkung zu geben, entschieden wir uns früh in einem monochromatischen Raum zu arbeiten. Dabei waren weiß und schwarz innerhalb der Darstellung bei den Client-Laptops nur vorzufinden. Jedoch entschieden wir uns, den Master zwar auch eher grau zu halten, ihm aber gleichzeitig durch die Hinzugabe einer Akzentfarbe von den restlichen Laptops abzuheben. Damit wollten wir eine stärkere Trennlinie zwischen den Clients, die passiv in unserem virtuellen Raum stehen, und die aktive Rolle des Masters setzten. Mit dieser Trennlinie konnten wir auch so eine gewisse Dynanmik innerhalb der Perfomance erzielen. Jeder der Zuschauer und Nutzer unserer Perfomance wusste sofort, welchen Laptop er nutzen musste, um eine gewünschte Reaktion innerhalb des virtuellen Raumes zu erzeugen.

Diese rein technische Visualisierung, wurde durch die Form des Aufbaus noch weiter unterstützt. Hierbei waren wir uns schon sehr früh einig, dass sich eine umgedrehte V-Form am besten dafür eignete, jeden der vielen Bildschirme sehen zu können, sowie die Hauptidee unseres Programmes wiederzugeben. Um dabei noch einen größeren Rahmen des virtuellen Raumes darzustellen, entschieden wir die Höhe der einzelnen Podeste zu unserem Vorteil zu nutzen. Für die Höhe entschieden wir uns für den ersten Laptop, der die Spitze der Form bildete, das höchste Podest zu nehmen. Je weiter die Laptops von der Spitze wegstehen, desto niedriger werden die Podeste. Der Maste bekommt, wie bei der digitalen Visualisierung, sein eigenes Podest. Dieses steht vor der Form, die die Clients bilden, damit sich der Master auch räumlich von den Clients abheben kann.



### Technische Details <a name="techdetails"></a>

#### Master

*OSC*

Innerhalb des Codes für den Master, kann man die spezielle Raumgröße indivduell angeben. Auch kann man die gesamte Anzahl an Clients
eintragen und so die Teilnehmeranzahl von Laptops festlegen.
Im ersten Schritt empfängt der Master die IP Adresse der Clients und trägt sie in eine StringList ein. Dies passiert nur, wenn die IP Adresse noch nicht, in der besagte List vorhanden ist.

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

Zeitgleich schickt der Master ein Paket an alle Clients mit der eigenen IP Adresse (zur Identifizierung), die damit verknüpfte Position in der StringList, Breite und Länge des vorherigen angebenen Raumes, sowie die Anzahl der teilnehmenden Laptops.

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

Um sicher zu stellen das alle Laptops noch im Netzwerk sind, wird die StringList mit allen IP-Adressen nach immer 5 Sekunden zurückgesetzt.
Nachdem diese Liste gelösch wurde, erwartet der Master ein erneutes Lebenssignal von den Clients und trägt diese dann in eine neue
Liste ein. Dieser Kreislauf wird während der gesamten Performance immer wieder durchgeführt.

```
//Listen to alive
  if (theOscMessage.checkAddrPattern("/alive") == true) {
    id = theOscMessage.get(0).intValue();

    aliveIds[id] = true;
  }
```


Ein vorheriges angepasstes Paket, das die Parameter und Einstellungen der Waves beinhaltet, wird bei dem drücken des Senden-Knopfes
im Master-Interface, an jegliche Clients gesendet.
Um jedoch zu vermeiden, dass dieses Paket auf allen Rechnern gleichzeitig dargestellt wird, enthält es auch die spezifische IP-Adresse des empfangenden Laptops, der dieses Paket abspielen soll.

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


Im Interface kann der Benutzter auch eine globale Geschwindigkeit einstellen, die dann in einem separaten Paket immer wieder an die Clients gesendet wird.

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

Das Interface des Masters enthält im oberen Bereich einen Vorschaubereich der Visualisierung. Darunter befinden sich drei Osciliatoren mit den eingestellten Waveform "Sinewave", "Sawtooth" und "Squarewave".
Hier lassen sich die Parameter mittels Drehreglern Frequenz, Amplitude und Dauer der Sendung einstellen.
Unter dieser Einstellung der Waveform liegt ein Slider der die globale Geschwindigkeit der Visualisierung steuert.
Zuletzt kann der Nutzer im untersten Bereich des Interfaces, den Knopf zur endgültigen Sendung des eingestellten Signals benutzten.

Die Interface-Elemente sind der Library [controlP5](https://github.com/sojamo/controlp5) von Andreas Schlegel entnommen.

#### Client

Im Clientprogramm wird zwischen 3 Zuständen unterschieden:

1. Warten auf Verbindung
2. Darstellung der Positionierung im Raum
3. Die Visualisierung

*Warten auf Verbindung*

Mit dem Start des Programms sendet der Client jede Sekunde eine "hey-Nachricht" an den Master zusammen mit der eigenen IP-Adresse.
Dies geschieht solange, bis der Master den Client seine Zuweisung innerhalb des Raumes geschickt hat.
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

Hat der Client seine ID vom Master und die übermittelte Raumgröße erhalten, wird überprüft ob die Höhe oder Breite des Bildschirmes "einschränkend" ist, um die größtmögliche Zeichnung des Raumes auf dem Bildschirm zu erreichen.
 Anhand der ID wird die Position des eigenen Laptops bestimmt und in einer maßstabgetreuen Visualisierung dargestellt, damit ist gewährleitest, dass alle Laptops in der richtigen Position zueinander stehen, was elementar für die spätere synchrone Ausbreitung des Schalls darstellt.

*Visualisierung*

Wurde der Laptop an die passende Stelle positioniert, wartet dieser auf Daten vom Master. Mit einem dieser Datenpakete wird neben der "Schallart", der Dauer, der Amplitude und Frequenz, auch die ID mitgeschickt, auf welcher die Visualisierung starten soll. Anhand dieser ID, kann die Position des Startlaptops im Raum bestimmt werden. Dazu wird in zwei Koordinatensysteme (das eigene und das des Raumes (global)) unterschieden. Zuerst wird die Position im globalen Koordinatensystem errechnet und zurückgegeben.

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
Im nächsten Schritt wird die errechnete Position des globalen Koordinatensystems auf das eigene Koordinatensystem gemapped.
Dafür

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
