class Mandel
{
  float cstep1 = (float)(2 * Math.PI / 256);
  float cstep2 = (float)(2 * Math.PI / 257);
  float cstep3 = (float)(2 * Math.PI / 258);
  float phaseR = 0;
  float phaseStepR = (float)(2 * Math.PI / 64);
  float phaseG = 0;
  float phaseStepG = (float)(2 * Math.PI / (64 + 16));
  float phaseB = 0;
  float phaseStepB = (float)(2 * Math.PI / (64 + 16 + 16)); 
  double x0=-2.0;
  double y0=-1.0;
  double x1=1.0;
  double y1=1.0;
  double posX = x0 + (x1-x0) / 2.0;
  double posY = y0 + (y1-y0) / 2.0;
  double zoomf = 0.99;
  double stepPosX = 0.0;
  double stepPosY = 0.0;
  double targetX;
  double targetY;
  int stepCount = 0;
  int currStep = 0;
  int maxiteration=256;
  color[] colors;
  Mandel()
  {
    colors = new color[height];    
  }
  void animatePalette()
  {
    for (int i = 0; i < height; i++)
    {
      int r = (int)Math.floor((Math.sin(i * cstep1+phaseR) + 1) * 127);
      int g = (int)Math.floor((Math.sin(i * cstep2+phaseG) + 1) * 127);
      int b = (int)Math.floor((Math.sin(i * cstep3+phaseB) + 1) * 127);
      colors[i] = color(r,g,b);
      
    }
  }
  void zoom()
  {
    if (currStep >= stepCount) {
        stepPosX = 0;
        stepPosY = 0;
    }
    else
    {
        currStep++;
    }
    double xposition=posX + stepPosX;
    double yposition=posY + stepPosY;
    double vwidth = (x1-x0)*zoomf;
    double vheight = (y1-y0)*zoomf;
    double stepx = vwidth / width;
    double stepy = vheight / height;
    x0=xposition-(width*stepx)/2.0;
    y0=yposition-(height*stepy)/2.0;
    x1=xposition+(width*stepx)/2.0;
    y1=yposition+(height*stepy)/2.0;
    posX = x0+(x1-x0)/2.0;
    posY = y0+(y1-y0)/2.0;  
    phaseR= phaseR + phaseStepR;
    phaseG= phaseG + phaseStepG;
    phaseB = phaseB + phaseStepB;
  }
  
  void click(int x, int y)
  {
      currStep = 0;
      stepCount = 20;
    double stepx = (x1-x0)/width;
    double stepy = (y1-y0)/height;
    double xNewPos = x0 + stepx*x;
    double yNewPos = y0 + stepy*y;
    targetX = xNewPos;
    targetY = yNewPos;
    stepPosX = (xNewPos-posX) / stepCount;
    stepPosY = (yNewPos-posY) / stepCount;
  }
  String getPos()
  {
    return "x="+posX+",y="+posY;
  }
  void display()
  {

  double stepx = (double)((x1-x0)/width); //<>//
  double stepy = (double)((y1-y0)/height);
  for(int y=0;y<height;y++)
  {
    for(int x=0;x<width;x++)
    {
      double xpixel = x0+stepx*x;
      double xstart = xpixel;
      double ypixel = y0+stepy*y;
      double ystart = ypixel;
      int iteration = 0;
      while((xpixel*xpixel + ypixel*ypixel) <= 4.0)
      {
        if(iteration >= maxiteration)
          break;
        double xtemp = xpixel*xpixel-ypixel*ypixel+xstart;
        ypixel = 2*xpixel*ypixel+ystart;
        xpixel = xtemp;
        iteration++;
      }
      if (iteration >= maxiteration )  //<>//
      {
        //fill(0);
        stroke(0);
      }
      else
      {
        //fill(255);
          
        //fill(colors[iteration%256]);
        stroke(colors[iteration%256]);
      }
      point(x,y);
    }
  }
}    
  
  
}