void drawLoading() {
  t+=0.01;
  counterAnimateText += 0.05;
  background(bg);
  pushMatrix();
  translate(width/2, height/2);
  stroke(255);
  fill(bg);
  strokeWeight(7.5);
  pushMatrix();
  translate(2, 3);
  drawCircle(0);
  drawCircle(PI);
  popMatrix();
  stroke(230);
  strokeWeight(6);
  drawCircle(0);
  drawCircle(PI);
  popMatrix();
  textAlign(CENTER);
  int cv = int(map(sin(counterAnimateText), -1, 1, 30, 255));
  fill(255, 255, 255, cv);
  textSize(26);
  textFont(light);
  text("Waiting for Connection", width/2, height/2+170);
}
void drawCircle(float q) {
  beginShape();
  for (int i=0; i<N; i++) {
    th = i*TWO_PI/N;
    os = map(cos(th-TWO_PI*t), -1, 1, 0, 1);
    os = 0.125*pow(os, 2.75);
    r = R*(1+os*cos(n*th + 1.5*TWO_PI*t + q));
    vertex(r*sin(th), -r*cos(th));
  }
  endShape(CLOSE);
}
