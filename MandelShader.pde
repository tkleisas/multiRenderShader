class Trajectory
{
  Trajectory()
  {
    waypoints = new ArrayList<Waypoint>();
  }
  ArrayList<Waypoint> waypoints;
}
class Waypoint
{
  float x0;
  float y0;
  float x1;
  float y1;
  int frame;
  float zoom;
}

class MandelShader
{
  final int MODE_INTERACTIVE = 0;
  final int MODE_DEMO = 1;
  int mode = MODE_INTERACTIVE;
float heightF;
float widthF;
float zoom;
float cstep1 = (float)(2 * Math.PI / 256);
float cstep2 = (float)(2 * Math.PI / 257);
float cstep3 = (float)(2 * Math.PI / 258);
float phaseR = 0;
float phaseStepR = (float)(2 * Math.PI / 64);
float phaseG = 0;
float phaseStepG = (float)(2 * Math.PI / (64 + 16));
float phaseB = 0;
float phaseStepB = (float)(2 * Math.PI / (64 + 16 + 16)); 
float x0=-2.0;
float y0=-1.0;
float x1=1.0;
float y1=1.0;
float posX = x0 + (x1-x0) / 2.0;
float posY = y0 + (y1-y0) / 2.0;
float zoomf = 0.99;
float stepPosX = 0.0;
float stepPosY = 0.0;
float targetX;
float targetY;
int stepCount = 0;
int currStep = 0;
int maxiteration=256;
long currTime;
long prevTime = 0;

color[] colors;
  PShader fractal;
  MandelShader(float width, float height)
  {
    this.widthF = width; //<>//
    this.heightF = height;
    fractal = loadShader("mandel.glsl");
    
    fractal.set("iResolution", widthF, heightF); //<>//
    fractal.set("x0", x0);
    fractal.set("x1", x1);
    fractal.set("y0", y0);
    fractal.set("y1", y1);
    fractal.set("cstep1",cstep1);
    fractal.set("cstep2",cstep2);
    fractal.set("cstep3",cstep3); //<>//
    fractal.set("phaseR",phaseR);
    fractal.set("phaseG",phaseG);
    fractal.set("phaseB",phaseB);
    currTime=millis();
  }
  
  void init()
  {
    x0=-2.0;
    y0=-1.0;
    x1=1.0;
    y1=1.0;
    posX = x0 + (x1-x0) / 2.0;
    posY = y0 + (y1-y0) / 2.0;
    zoomf = 0.99;
    stepPosX = 0.0;
    stepPosY = 0.0;
    
    stepCount = 0;
    currStep = 0;
    maxiteration=256;
  }
String[] labels=
  {
    "Βλέπετε μια απεικόνιση του συνόλου Mandelbrot,   ",
    "από τις πιο συνηθισμένες απεικονίσεις fractal    ",
    "Το σύνολο Mandelbrot έχει μερικές ενδιαφέρουσες  ",
    "ιδιότητες. Όσο το μεγενθύνουμε, διακρίνουμε      ",
    "καινούριες λεπτομέρειες, ενώ μορφολογικά του     ",
    "χαρακτηριστικά επαναλαμβάνονται σε διάφορες      ",
    "κλίμακες. Το πρόγραμμα που βλέπετε κάνει  ζουμ   ",
    "σε διάφορες περιοχές του συνόλου Mandelbrot      ",
    "και το κάνει πολύ γρήγορα γιατί χρησιμοποιεί     ",
    "την κάρτα γραφικών για να υπολογίσει παράλληλα   ",
    "πολλά σημεία ταυτόχρονα.                         ",
    "                                                 ",
    "ΑΝΑΠΤΥΞΗ ΕΦΑΡΜΟΓΗΣ:                              ",
    "  ΚΕ.ΠΛΗ.ΝΕ.Τ. ΔΙΕΥΘΥΝΣΗΣ ΔΕΥΤΕΡΟΒΑΘΜΙΑΣ         ",
    "  ΕΚΠΑΙΔΕΥΣΗΣ ΝΟΜΟΥ ΜΕΣΣΗΝΙΑΣ.                   ",
    " Ο κώδικας της εφαρμογής είναι διαθέσιμος στη    ",
    "διεύθυνση:                                       ",
    "https://github.com/tkleisas/multiRenderShader.git",
    "                                                 ",
    "                                                 ",
    "                                                 ",
    "                                                 "
  };
  
  int getLabelCount()
  {
    return this.labels.length;
  }
  String getLabel(int label)
  {
    return labels[label%labels.length];
  }
   String[] getLabels()
  {
    return labels;
  }
  void zoom()
  {
    long dt = getTimeDelta();
    float thezoom = (float)Math.pow(zoomf, (float)dt*0.001);
    if (currStep >= stepCount) {
        stepPosX = 0;
        stepPosY = 0;
    }
    else
    {
        currStep++;
    }
    float xposition=posX + stepPosX;
    float yposition=posY + stepPosY;
    float vwidth = (x1-x0)*thezoom;
    float vheight = (y1-y0)*thezoom;
    float stepx = vwidth / width;
    float stepy = vheight / height;
    if(stepx<0.0)
    {
      stepx = -stepx;
    }
    if(stepy<0.0)
    {
      stepy = -stepy;
    }
    
    x0=xposition-(width*stepx)/2.0;
    y0=yposition-(height*stepy)/2.0;
    x1=xposition+(width*stepx)/2.0;
    y1=yposition+(height*stepy)/2.0;
    posX = x0+(x1-x0)/2.0;
    posY = y0+(y1-y0)/2.0;  
    phaseR= phaseR + phaseStepR*0.001*dt;
    phaseG= phaseG + phaseStepG*0.001*dt;
    phaseB = phaseB + phaseStepB*0.001*dt;
  }
  long getTimeDelta()
  {
    prevTime = currTime;
    currTime = millis();
    return currTime-prevTime;
  }
  void click(int x, int y)
  {
    y = height-y;
    currStep = 0;
    float stepx = (x1-x0)/(float)width;
    float stepy = (y1-y0)/(float)height;
    float xNewPos = x0 + stepx*x;
    float yNewPos = y0 + stepy*y;
    float distance = (float)Math.sqrt((xNewPos-posX)*(xNewPos-posX)+(yNewPos-posY)*(yNewPos-posY));
    float fwidth = (float)Math.sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0));
    stepCount = (int)((distance/fwidth)*(float)width)/4; //<>//
    if(stepCount==0)
    {
      stepCount=1;
    }
    targetX = xNewPos;
    targetY = yNewPos;
    stepPosX = (xNewPos-posX) / (float)stepCount;
    stepPosY = (yNewPos-posY) / (float)stepCount;
  }
  String getPos()
  {
    return "x="+posX+",y="+posY+",zoom="+zoomf;
  }  
  void draw() {
    background(0); //<>//
    //set which shader
    fractal.set("iResolution", widthF, heightF);
    fractal.set("x0", x0);
    fractal.set("x1", x1);
    fractal.set("y0", y0);
    fractal.set("y1", y1);
    fractal.set("cstep1",cstep1);
    fractal.set("cstep2",cstep2);
    fractal.set("cstep3",cstep3);
    fractal.set("phaseR",phaseR);
    fractal.set("phaseG",phaseG);
    fractal.set("phaseB",phaseB);
    shader(fractal);
    //render blank box to use the shader on
    rect(0,0,width,height);
    resetShader();
    //handle movement
    //set shader variables

 }
 void handleKey(int key)
 {
   if(key=='D' || key=='d')
   {
     mode = MODE_DEMO;
   }
   if(key=='I' || key=='i')
   {
     mode = MODE_INTERACTIVE;
   }
   if(key=='Z' || key=='z')
   {
     if (zoomf>0.1)
     {
       zoomf = zoomf - 0.01;
     }
   }
   if(key=='X' || key=='x')
   {
     if(zoomf<2.01)
     {
       zoomf = zoomf + 0.01;
     }
   }
   if(key=='0')
   {
     init();
   }
 }
}