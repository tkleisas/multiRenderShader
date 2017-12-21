import com.hamoid.*;
VideoExport videoExport;
CA1D ca1d;
PFont f;
int frame = 0;
int gen =0;
GOL gol;
Mandel mandel;
MandelShader mandelShader;
SlideShow slideShow;
long prevTime = 0;
long currTime = 0;
boolean recording = false;
XML xml;
int DISPLAY_MANDEL =0;
int DISPLAY_CA1D = 1;
int DISPLAY_GOL = 2;
int DISPLAY_SLIDESHOW = 3;
int displayMode = DISPLAY_MANDEL;
long timeAcc = 0;
int textsize = 18;
int textspeed = 2000;
boolean record = false;
void setup()
{
  //size(640,350,P3D);
  size(1280,720,P3D); //<>//
  //fullScreen(P3D);
  if(record)
  {
    videoExport = new VideoExport(this,"recording.mp4");
    videoExport.startMovie();
  }
  
  gol = new GOL();
  textsize = (int)((18.0/640.0)*width);
  //mandel = new Mandel();
  //mandel.animatePalette();
  mandelShader = new MandelShader((float)width,(float)height);
  f = loadFont("Arial-Black-30.vlw");
  textFont(f);
  ca1d = new CA1D();
  ca1d.setZoom(2);
  ca1d.setRule(110,false);
  
  ca1d.animatePalette();
  //ca1d.randomizeLine();
  textSize(24/2);
  slideShow = new SlideShow(textsize);
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
    }
     outlineText(textsize,color(0,0,0,255),color(255,0,0,255),"CA1D",textsize,textsize);
     outlineText(textsize,color(0,0,0,255),color(255,0,0,255),"R:"+ca1d.getRule(),width-10*textsize,textsize);
     scrollingText(0,height-6*textsize,width,6*textsize,textsize,6,ca1d.getLabels(),textspeed,timeAcc,color(255,0,0,255),color(0,0,0,255),color(0,0,0,128));
  }
  
  if(displayMode==DISPLAY_MANDEL) 
  {
    mandelShader.draw();
    mandelShader.zoom();
     outlineText(textsize,color(0,0,0,255),color(255,0,0,255),"MNDL:"+frame,textsize,textsize);
     outlineText(textsize,color(0,0,0,255),color(255,0,0,255),"z->"+mandelShader.getPos(),textsize,textsize*3);
     scrollingText(0,height-6*textsize,width,6*textsize,textsize,6,mandelShader.getLabels(),textspeed,timeAcc,color(255,0,0,255),color(0,0,0,255),color(0,0,0,128));
     
  }
  if(displayMode==DISPLAY_GOL)
  {

     gol.generate();
     gol.display();
     outlineText(textsize,color(0,0,0,255),color(255,0,0,255),"LIFE",textsize,textsize);
     outlineText(textsize,color(0,0,0,255),color(255,0,0,255),"G:"+gen++,width-textsize*12,textsize);
     scrollingText(0,height-6*textsize,width,6*textsize,textsize,6,gol.getLabels(),textspeed,timeAcc,color(255,0,0,255),color(0,0,0,255),color(0,0,0,128));
  }
  if(displayMode==DISPLAY_SLIDESHOW)
  {
    slideShow.display(timeAcc);
    scrollingText(0,height-6*textsize,width,6*textsize,textsize,6,slideShow.getLabels(),textspeed,timeAcc,color(255,0,0,255),color(0,0,0,255),color(0,0,0,128));
  }
  if(recording && record)
  {
    
    //saveFrame("output/mf######.png"); //<>//
    videoExport.saveFrame();
    outlineText(textsize,color(0,0,0,255),color(255,0,0,255),"REC",10,height-50);
  }
}




void outlineText(float textSize,color outerColor,color innerColor,String text, int x, int y)
{
  if(text==null)
  return;
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

void scrollingText(int x, int y,  int boxwidth, int boxheight, int lineheight, int linecount, String[] text, long lineDisplayTime, long timevalue, color textcolor, color textoutlinecolor, color backgroundColor)
{
     if(text==null)
     return;
     fill(backgroundColor);
     stroke(backgroundColor);
     rect (x,y,boxwidth,boxheight);
         
     long timeToDisplay = text.length*lineDisplayTime;
     long slideshowTime = timevalue % timeToDisplay;
     long lineTime = slideshowTime % lineDisplayTime;
     int labelidx = (int)(slideshowTime/lineDisplayTime);
     int a = (int)(((float)lineTime*(float)lineheight)/(float)lineDisplayTime);
     //int a = (int)(((int)(((float)slideshowTime)/(float)timeToDisplay)*(float)lineheight)%lineheight);
     //outlineText (lineheight,color(0,0,0,255),color(255,255,255,255),"a:"+a+" ttd:"+timeToDisplay+" slideshowTime:"+slideshowTime+" lidx:"+labelidx+"lt:"+lineTime,0, 60);
     int alphaval1 = (int) (((float)a/(float)lineheight)*255.0);
     color textcolor1 = color (red(textcolor),green(textcolor),blue(textcolor),alphaval1);
     color textoutlinecolor1 = color(red(textoutlinecolor),green(textoutlinecolor),blue(textoutlinecolor),alphaval1);
     outlineText(lineheight,textoutlinecolor1,textcolor1,text[labelidx],x,y+boxheight+lineheight-a);
     for(int i=1;i<linecount-2;i++)
     {
       if (labelidx-i>=0)
       {
         outlineText(lineheight,textoutlinecolor,textcolor,text[labelidx-i],x,y+boxheight-lineheight*(i-1)-a);
       }
     }
     if (labelidx - (linecount-2)>=0)
     {
       int alphaval2 = (int)(((float)(lineheight - (float)a)/lineheight)*255.0);
       color textcolor2 = color (red(textcolor),green(textcolor),blue(textcolor),alphaval2);
       color textoutlinecolor2 = color(red(textoutlinecolor),green(textoutlinecolor),blue(textoutlinecolor),alphaval2);
       outlineText(lineheight,textoutlinecolor2,textcolor2,text[labelidx-(linecount-2)],x,y+boxheight-lineheight*(linecount-3)-a);
     }
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
  if(key=='4')
  {
    displayMode = DISPLAY_SLIDESHOW;
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
    if(record)
    {
      videoExport.endMovie();
    }
    exit();
  }
}
void mousePressed()
{
  mandelShader.click(mouseX,mouseY);
  //mandel.click(mouseX,mouseY); 
}