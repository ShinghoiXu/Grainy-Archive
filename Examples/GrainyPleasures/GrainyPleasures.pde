float xStep = 1;
float yStep = 10;
float xMargin,yMargin;
float noiseScale = 110;
float noiseAmp = 0.016;
int row = 60;

void setup(){
  size(600,900);
  background(0);
  stroke(255);
  strokeWeight(0.2);
  xMargin = width * 0.1f;
  yMargin = height * 0.1f;
  xStep = 0.4f;
  yStep = (height-2*yMargin) / (row-1);
  noiseDetail(6);
}

void draw(){
  if(frameCount % 2 == 1){
    background(0);
    noiseSeed(round(random(10000)));
  }
  for(float i = yStep; i < (height - yMargin*1.5f); i+=yStep){
    for(float j = xMargin; j < width - xMargin; j+=xStep){
      if(j<width*0.2){
        stroke(255,map(j,0,width*0.2,0,255));
        //if(j<width*0.1) noiseScale = 1; else noiseScale = map(j,0,width*0.2,1,36);
        grainyPoint(j,i+noise(i*noiseAmp,width*0.2*noiseAmp)*noiseScale);
      }
      else if(j>width*0.8){
        stroke(255,map(j,width*0.8,width,255,0));
        grainyPoint(j,i+noise(i*noiseAmp,width*0.8*noiseAmp)*noiseScale);
      }
      else{
        stroke(255,255);
        grainyPoint(j,i+noise(i*noiseAmp,j*noiseAmp)*noiseScale);
      }
    }
  }
  
}

void mouseClicked(){
  if(frameCount % 2 == 0){
    saveFrame("GrainyPleasures-####.png");
    exit();
  }
}
