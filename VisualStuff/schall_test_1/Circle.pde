class Circle {
  
  PVector position;
  PVector velocity;
  float r;
  int alpha = 255;
  
  color theColor = color(255);
  
 
  Circle(float tmpX, float tmpY, float tmpR) {
    position = new PVector(tmpX, tmpY);
    velocity = new PVector(5,2);
    r = tmpR;
  }
  
  void move() {
    position.add(velocity);
  }
  
 void update() {
  if ((position.x + r > width) || (position.x - r < 0)) {
      velocity.x = velocity.x * - 1;
      theColor = color(random(0,255),random(0,255),random(0,255));
    }
    if ((position.y + r > height) || (position.y - r < 0)) {
      velocity.y = velocity.y * - 1;
      theColor = color(random(0,255),random(0,255),random(0,255));
    } 
 }
  
  void display() {
    ellipseMode(RADIUS);
    noFill();
    stroke(theColor, alpha);
    
    //for(int i = 0; i < 10; i+=3) {
    // ellipse(position.x,position.y,r*i,r*i);
    //}
    
    ellipse(position.x,position.y,r,r);
    
    fade();
    move();
    update();
  }
  
  void fade() {
   //alpha -= 10;
  }
  
  boolean isDead() {
   if(alpha <= 0) {
     return true;
   } else {
  
     alpha = 255;  return false; 
   }
  }
  
}
