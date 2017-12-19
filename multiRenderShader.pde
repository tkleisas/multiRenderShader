import com.hamoid.*;
VideoExport videoExport;
CA1D ca1d;
PFont f;
int frame = 0;
int gen =0;
GOL gol;
Mandel mandel;
MandelShader mandelShader;
long prevTime = 0;
long currTime = 0;
boolean recording = false;
XML xml;
int DISPLAY_MANDEL =0;
int DISPLAY_CA1D = 1;
int DISPLAY_GOL = 2;
int displayMode = DISPLAY_MANDEL;
long timeAcc = 0;
void setup()
{
  
  size(1280,720,P3D); //<>//
  //fullScreen(P3D);
  videoExport = new VideoExport(this,"recording.mp4");
  videoExport.startMovie();
  gol = new GOL();
  
  //mandel = new Mandel();
  //mandel.animatePalette();
  mandelShader = new MandelShader((float)width,(float)height);
  f = loadFont("Arial-Black-30.vlw");
  textFont(f);
  ca1d = new CA1D();
  ca1d.setZoom(5);
  ca1d.setRule(110,false);
  
  ca1d.animatePalette();
  //ca1d.randomizeLine();
  textSize(24);
  currTime = millis();
}
void drawOther()
{
 mandelShader.draw();
 mandelShader.zoom();
}
long getTimeDelta()
{
  prevTime = currTime;
  currTime = millis();
  return currTime-prevTime;
}
void draw()
{
  long dt = getTimeDelta();
  timeAcc = timeAcc + dt;
  
  background(0,0,0,255);  
  frame++;
  resetShader();
  if(displayMode==DISPLAY_CA1D)
  {
   
    ca1d.display();
    ca1d.calcCALine();
    if(frame%10==0)
    {
      ca1d.animatePalette();
    }
    if(frame%150==0 || ca1d.isBlack() || ca1d.isWhite())
    {
      ca1d.setRule((int)(Math.random()*255),false);
      //ca1d.randomizeLine();
      
    }
     outlineText(40,color(0,0,0,255),color(255,0,0,255),"CA1D",10,40);
     outlineText(40,color(0,0,0,255),color(255,0,0,255),"R:"+ca1d.getRule(),400,40);
     fill(color(0,0,0,255));
     stroke(color(0,0,0,255));
     rect (0,height-4*50,width,height);    
     long timeToDisplay = ca1d.getLabelCount()*10000;
     long slideshowTime = timeAcc % timeToDisplay;
     int labelidx = ((int)slideshowTime/10000);
     outlineText(40,color(0,0,0,255),color(255,0,0,255),ca1d.getLabel(labelidx),0,height-40);
     if((labelidx-1) >=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),ca1d.getLabel(labelidx-1),0,height-40*2);
     }
     if((labelidx-2)>=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),ca1d.getLabel(labelidx-2),0,height-40*3);
     }
     if((labelidx-3)>=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),ca1d.getLabel(labelidx-3),0,height-40*4);
     }
  }
  
  if(displayMode==DISPLAY_MANDEL) 
  {

    //mandel.display();
    mandelShader.draw();
    mandelShader.zoom();
    //fill(color(255,0,0));
    //text("MNDL:"+frame,10,40);
    //text("z->"+mandel.getPos(),10,300);
     outlineText(40,color(0,0,0,255),color(255,0,0,255),"MNDL:"+frame,10,40);
     outlineText(40,color(0,0,0,255),color(255,0,0,255),"z->"+mandelShader.getPos(),10,300);
     fill(color(0,0,0,64));
     stroke(color(0,0,0,64));
     rect (0,height-4*50,width,height);    
     long timeToDisplay = mandelShader.getLabelCount()*5000;
     long slideshowTime = timeAcc % timeToDisplay;
     int a = (int)(((((float)slideshowTime)/5000.0)*40)%40);
     int labelidx = ((int)slideshowTime/5000);
     outlineText (40,color(255,255,255),color(255,255,255,255),""+a,0, 60);
     outlineText(40,color(0,0,0,255),color(255,0,0,255),mandelShader.getLabel(labelidx),0,height+40-a);
     if((labelidx-1) >=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),mandelShader.getLabel(labelidx-1),0,height-a);
     }
     if((labelidx-2)>=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),mandelShader.getLabel(labelidx-2),0,height-40-a);
     }
     if((labelidx-3)>=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),mandelShader.getLabel(labelidx-3),0,height-80-a);
     }
     if((labelidx-4)>=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),mandelShader.getLabel(labelidx-4),0,height-120-a);
     }
     
  }
  if(displayMode==DISPLAY_GOL)
  {

     gol.generate();
     gol.display();
     //fill(color(255,0,0));
     //text("LIFE",10,40);
     //text("G:"+gen++,400,40);
     outlineText(40,color(0,0,0,255),color(255,0,0,255),"LIFE",10,40);
     outlineText(40,color(0,0,0,255),color(255,0,0,255),"G:"+gen++,400,40);
     fill(color(0,0,0,128));
     stroke(color(0,0,0,128));
     rect (0,height-4*30,width,height);
     fill(color(0,0,0,255));
     stroke(color(0,0,0,255));
     rect (0,height-4*50,width,height);    
     long timeToDisplay = gol.getLabelCount()*10000;
     long slideshowTime = timeAcc % timeToDisplay;
     int labelidx = ((int)slideshowTime/10000);
     outlineText(40,color(0,0,0,255),color(255,0,0,255),gol.getLabel(labelidx),0,height-40);
     if((labelidx-1) >=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),gol.getLabel(labelidx-1),0,height-40*2);
     }
     if((labelidx-2)>=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),gol.getLabel(labelidx-2),0,height-40*3);
     }
     if((labelidx-3)>=0)
     {
       outlineText(40,color(0,0,0,255),color(255,0,0,255),gol.getLabel(labelidx-3),0,height-40*4);
     }

  }
  if(recording)
  {
    //saveFrame("output/mf######.png"); //<>//
    videoExport.saveFrame();
    outlineText(40,color(0,0,0,255),color(255,0,0,255),"REC",10,height-50);
  }

}
void outlineText(float textSize,color outerColor,color innerColor,String text, int x, int y)
{
  float w = textWidth(text);
  
  stroke(outerColor);
  fill(outerColor);
  //rect((float)x,(float)y,(float)x+w,(float)-40);
  textSize(textSize);
  text(text, x-1, y-1);
  text(text, x, y-1);
  text(text, x+1, y-1);
  text(text, x-1, y);
  text(text, x,y); //redundant?
  text(text, x+1,y);
  text(text, x-1,y+1);
  text(text, x,y+1);
  text(text, x+1,y+1);
  fill(innerColor);
  stroke(innerColor);
  text(text, x, y);
}
void keyPressed()
{
  if(key=='1')
  {
    displayMode = DISPLAY_MANDEL;
    timeAcc = 0;
  }
  if(key=='2')
  {
    displayMode = DISPLAY_CA1D;
    timeAcc = 0;
  }
  if(key=='3')
  {
    displayMode = DISPLAY_GOL;
    timeAcc = 0;
  }
  if(key=='g' || key=='G')
  {
    gol.init();
  }
  if(key=='r' || key =='R')
  {
    recording = !recording;
  }
  if(key=='q' || key =='Q')
  {
    videoExport.endMovie();
    exit();
  }
}
void mousePressed()
{
  mandelShader.click(mouseX,mouseY);
  //mandel.click(mouseX,mouseY); 
}