// Daniel Shiffman
// http://youtube.com/thecodingtrain
// http://codingtra.in
//
// Coding Challenge #24: Perlin Noise Flow  Field
// https://youtu.be/BjoM9oKOAKY

final float myStep = 2f;
final float endR = 80f;
final int density = 1;

public class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector previousPos;
  float maxSpeed;
   
  Particle(PVector start, float maxspeed) {
    maxSpeed = maxspeed;
    pos = start;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    previousPos = pos.copy();
  }
  void run() {
    update();
    edges();
    show();
  }
  void update() {
    pos.add(vel);
    vel.limit(maxSpeed);
    vel.add(acc);
    acc.mult(0);
  }
  void applyForce(PVector force) {
    acc.add(force); 
  }
  void show() {
    stroke(#447edf, 5);
    strokeWeight(0.5);
    grainyLine(pos.x, pos.y, previousPos.x, previousPos.y);
    //line(pos.x, pos.y, previousPos.x, previousPos.y);
    //point(pos.x, pos.y);
    updatePreviousPos();
  }
  void showLine() {
    stroke(#447edf, 6);
    strokeWeight(0.6);
    //grainyLine(pos.x, pos.y, previousPos.x, previousPos.y);
    line(pos.x, pos.y, previousPos.x, previousPos.y);
    //point(pos.x, pos.y);
    updatePreviousPos();
  }
  void edges() {
    if (pos.x > width) {
      pos.x = 0;
      updatePreviousPos();
    }
    if (pos.x < 0) {
      pos.x = width;    
      updatePreviousPos();
    }
    if (pos.y > height) {
      pos.y = 0;
      updatePreviousPos();
    }
    if (pos.y < 0) {
      pos.y = height;
      updatePreviousPos();
    }
  }
  void updatePreviousPos() {
    this.previousPos.x = pos.x;
    this.previousPos.y = pos.y;
  }
  void follow(FlowField flowfield) {
    int x = floor(pos.x / flowfield.scl);
    int y = floor(pos.y / flowfield.scl);
    int index = x + y * flowfield.cols;
    
    PVector force = flowfield.vectors[index];
    applyForce(force);
  }
}

void grainyLine(float startX,float startY,float endX,float endY){
  float t;
  if (startX>endX){
    t = startX;
    startX = endX;
    endX = t;
  }
  if (startY>endY){
    t = startY;
    startY = endY;
    endY = t;
  }
  float x = startX;
  do{
    x+=myStep;
    float y = startY;
    do{
      y+=myStep;
      float rStep = 0.0;
      float r = 1f;
      do{
        for(int drops = 0; drops < density;drops++){
          float tempX = random(1)-0.5f;
          float tempY = random(1)-0.5f;
          tempX *= r; tempY *= r;
          while(dist(x+tempX,y+tempY,x,y)>r){
            tempX = random(1)-0.5f;
            tempY = random(1)-0.5f;
            tempX *= r; tempY *= r;
          }
          point(x+tempX,y+tempY);
        }
        rStep+=0.01f;
        //r=rStep;
        //r=easeOutCirc(rStep)*endR;
        //r=easeInExpo(rStep)*endR;
        r=easeInOutSine(rStep)*endR;
      }while(r<endR);
    }while(y<endY);
  }while(x<endX);
}

float easeOutCirc(float x){
  return sqrt(1 - pow(x - 1, 2));
}

float easeInExpo(float x){
  if(x==0){
    return 0;
  }
  else{
    return pow(2, 10 * x - 10);
  }
}

float easeInOutSine(float x){
  return -(cos(PI * x) - 1) / 2;
}
