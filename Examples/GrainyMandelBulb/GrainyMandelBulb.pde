//GrainyMandelBulb, Written by Chengkai Xu, 2022-06-05

//change the hyper parameters here to play with this program :)
int n = 11;  //n >= 3
int maxiterations = 5;  //>4
int DIM = 128;
float myStrokeWeight = 5f;
float offsetPercent = 0.9f;  //Color Offset should be set between 0.0f to 1.0f
//

PGraphics canvas;
int distributionScale;
float myHue,offset;
ArrayList<PVector> mandelbulb = new ArrayList<PVector>();

void setup() {
  //A2 size: 4961 x 7016
  size(4961, 7016, P2D);
  distributionScale = round(min(height,width) * 0.32f);
  offset = offsetPercent*distributionScale;
  canvas = createGraphics(width,height,P2D);
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();
  colorMode(HSB,distributionScale);
  background(0);
  StringList points = new StringList();

  for (int i = 0; i < DIM; i++) {
    println(i+" / "+DIM);
    for (int j = 0; j < DIM; j++) {
      boolean edge = false;
      for (int k = 0; k < DIM; k++) {
        float x = map(i, 0.0, DIM, -1.1, 1.1);
        float y = map(j, 0.0, DIM, -1.1, 1.1);
        float z = map(k, 0.0, DIM, -1.1, 1.1);
        PVector zeta = new PVector(0, 0, 0);
        int iteration = 0;
        while (true) {
          Spherical c = spherical(zeta.x, zeta.y, zeta.z);
          float newx = pow(c.r, n) * sin(c.theta*n) * cos(c.phi*n);
          float newy = pow(c.r, n) * sin(c.theta*n) * sin(c.phi*n);
          float newz = pow(c.r, n) * cos(c.theta*n);
          zeta.x = newx + x;
          zeta.y = newy + y;
          zeta.z = newz + z;
          iteration++;
          if (c.r > 2) {
            if (edge) {
              edge = false;
            }
            break;
          }
          if (iteration > maxiterations) {
            if (!edge) {
              edge = true;
              mandelbulb.add(new PVector(x, y, z));
            }
            break;
          }
        }
      }
    }
  }
  //I tried to generate the cloud points and save them for further processing in Blender/Houdini
  String[] output = new String[mandelbulb.size()];
  for (int i = 0; i < output.length; i++) {
    PVector v = mandelbulb.get(i);
    output[i] = v.x + " " + v.y + " " + v.z;
  }
  saveStrings("mandelbulb.txt", output);
  
}

class Spherical {
  float r, theta, phi;
  Spherical(float r, float theta, float phi) {
    this.r = r;
    this.theta = theta;
    this.phi = phi;
  }
}

Spherical spherical(float x, float y, float z) {
  float r = sqrt(x*x + y*y + z*z);
  float theta = atan2( sqrt(x*x+y*y), z);
  float phi = atan2(y, x);
  return new Spherical(r, theta, phi);
}

void draw() {
  windowMove(50,100);
  background(0);
  canvas.beginDraw();
  canvas.colorMode(HSB,distributionScale);
  canvas.strokeWeight(myStrokeWeight);
  canvas.blendMode(BLEND);
  canvas.translate(width/2,height/2);
  
  for (PVector v : mandelbulb) {
    myHue = dist(v.x*distributionScale,v.y*distributionScale,0,0)*0.4+offset;
    if (myHue>distributionScale) myHue -= distributionScale;
    canvas.stroke(myHue,distributionScale*0.9,map(v.z,-1,1,distributionScale*0.3f,distributionScale*0.99f),map(v.z,-1,1,distributionScale*0.0f,distributionScale*0.04f));
    //point(v.x*200, v.y*200, v.z*200);
    grainyPoint(v.x*distributionScale, v.y*distributionScale,canvas);
  }
  canvas.endDraw();
  
  image(canvas,0,0);
  println(frameCount);
  if(frameCount == 120) saveAndQuit(); // change the drawing time here
}

void saveAndQuit(){
  canvas.beginDraw();
  canvas.blendMode(REPLACE);
  canvas.strokeWeight(myStrokeWeight*1.2f);
  canvas.translate(width/2,height/2);
  
  for (PVector v : mandelbulb) {
    myHue = dist(v.x*distributionScale,v.y*distributionScale,0,0)*0.4+offset;
    if (myHue>distributionScale) myHue -= distributionScale;
    canvas.stroke(myHue,distributionScale,map(v.z,-1,1,distributionScale*0.0f,distributionScale*0.7f),map(v.z,-1,1,distributionScale*0.0f,distributionScale*0.05f));
    canvas.point(v.x*distributionScale, v.y*distributionScale);
  }
  
  canvas.endDraw();
  canvas.save("MandelBulb_"+n+"_"+maxiterations+".jpg");
  exit();
}

void keyPressed() {
  if (key == 's') saveAndQuit();
}
