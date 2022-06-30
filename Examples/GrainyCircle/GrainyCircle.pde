final float myStep = 5f;
final float endR = 1000f;
final int density = 1;

void setup(){
  //size(4961,7016);
  //size(874,1240);
  //size(1240,874);
  //size(1080,1080);
  size(1920,1080);
  background(0);
}

void draw(){
  translate(width/2, height/2);
  float circleR = 200;
  int n = 2000;
  for (int i=0; i<n; i++) {
    float a = i * 2 * PI/n;
    float b = 1 * a;
    //println(i);
    //float b = frameCount * 0.03 * a;
    float x1 = circleR * cos(a);
    float y1 = circleR * sin(a);
    float x2 = circleR * cos(b);
    float y2 = circleR * sin(b);
    strokeWeight(0.2);
    stroke(255);
    grainyLine(x1, y1, x2, y2);
    stroke(#447edf);
    grainyLine(x1, y1, x2, y2);
    strokeWeight(1);
    stroke(0,200);
    //line(x1, y1, x2, y2);
  }

  println(frameCount);
  if(frameCount==30)saveFrame("GrainyCircle_Wallpaper.png");
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
        r=easeInExpo(rStep)*endR;
        //r=easeInOutSine(rStep)*endR;
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
