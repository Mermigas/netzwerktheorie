class troete {

  // Variablen
  int count;
  int rad;
  
  //TriOsc
  TriOsc tri;
  int x = 0;
  float y = 0.0;
  
  void setup() {
   stroke (255, 255, 255);
  noFill ();
  count = 0;
  rad = 2;
  
 
  }
  
  void draw () {
    circle () ;
    
  }
  
  void circle (){
    count++;
rad++;

ellipse (rad, rad, rad, rad);

  //float amplitude = map(y, 0, height, 1.0, 0.0);
  //tri.amp(amplitude);
  //y++;
  
  float frequency = map(x, 0, width, 80.0, 1000.0);

  x++;}
  
  }
