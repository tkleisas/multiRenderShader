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

void setup()
{
  
  size(1280,720,P3D); //<>//
  videoExport = new VideoExport(this,"recording.mp4");
  videoExport.startMovie();
  gol = new GOL();
  //mandel = new Mandel();
  //mandel.animatePalette();
  mandelShader = new MandelShader((float)width,(float)height);
  f = loadFont("SegoeUI-Bold-1.vlw");
  ca1d = new CA1D();
  ca1d.setRule(110);
  ca1d.setZoom(4);
  ca1d.animatePalette();
  ca1d.randomizeLine();
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
  background(0,0,0,255);  
  frame++;
  resetShader();
  if(displayMode==DISPLAY_CA1D)
  {
    ca1d.display();
    ca1d.calcCALine();
    if(frame%100==0)
    {
      ca1d.animatePalette();
    }
    if(frame%150==0||ca1d.isBlack())
    {
      ca1d.setRule((int)(Math.random()*255));
      ca1d.randomizeLine();
      
    }
    
     outlineText(40,color(0,0,0),color(255,0,0),"CA1D",10,40);
     outlineText(40,color(0,0,0),color(255,0,0),"R:"+ca1d.getRule(),400,40);
    
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
  fill(outerColor);
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
  text(text, x, y);
}
void keyPressed()
{
  if(key=='1')
  {
    displayMode = DISPLAY_MANDEL;
  }
  if(key=='2')
  {
    displayMode = DISPLAY_CA1D;
  }
  if(key=='3')
  {
    displayMode = DISPLAY_GOL;
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