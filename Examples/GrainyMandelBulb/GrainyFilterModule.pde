//grainyFilter(img,step, blackClip,whiteClip,myStrokeWeight,10).save("xxx.jpg");

import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PGraphics grainyFilter(PImage img,int step,int blackClip,int whiteClip,float myStrokeWeight,int drawTimes){
  PostFXSupervisor supervisor;
  PGraphics canvas;
  PGraphics buffer;
  PGraphics baseBuffer;
  
  supervisor = new PostFXSupervisor(this, img.width, img.height);
  surface.setResizable(false);
  surface.setLocation(100,100);
  
  blendMode(BLEND);
  canvas = createGraphics(img.width,img.height,P2D);
  buffer = createGraphics(img.width,img.height,P2D);
  baseBuffer = createGraphics(img.width,img.height,P2D);
  
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();
  
  baseBuffer.beginDraw();
  baseBuffer.image(img,0,0,img.width,img.height);
  baseBuffer.endDraw();
  
  supervisor.render(baseBuffer);
  supervisor.pass(new BlurPass(this, 100, 100, true));
  supervisor.pass(new SobelPass(this));
  supervisor.compose(buffer);
  
  img.loadPixels();
  buffer.loadPixels();
  baseBuffer.loadPixels();
  buffer.save("SobelPassReference.jpg");
  println("GrainyFilter is Ready!");
  
  canvas.strokeWeight(myStrokeWeight);
  canvas.beginDraw();
  for(int v = 1; v < drawTimes;v++){
    for(int i = 0; i < img.height ; i+=step){
      for(int j = 0; j < img.width ; j+=step){
        if(
        brightness(buffer.pixels[i*img.width+j])>=blackClip
        && brightness(buffer.pixels[i*img.width+j])<=whiteClip &&
        alpha(buffer.pixels[i*img.width+j])>0)
        {
          canvas.stroke(img.pixels[i*img.width+j]);
          grainyPoint(j,i,canvas);
        }
      }
    }
    canvas.endDraw();
    println("Draw Count:"+v);
    image(canvas,0,0);
  }
  
  return canvas;
}
