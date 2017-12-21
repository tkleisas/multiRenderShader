class Trajectory
{
  Trajectory()
  {
    waypoints = new ArrayList<Waypoint>();
  }
  void addWaypoint(Waypoint waypoint)
  {
    waypoints.add(waypoint);
  }
  int getWaypointCount()
  {
    return waypoints.size();
  }
  Waypoint getWaypoint(int i)
  {
    return (Waypoint)waypoints.get(i);
  }
  Waypoint first()
  {
    if(waypoints.size()>0)
    {
      Waypoint w = waypoints.get(0);
      currWaypoint = 1;
      return w;
    }
    return null;
  }
  Waypoint next()
  {
    if(currWaypoint<waypoints.size())
    {
      return waypoints.get(currWaypoint++);
    }
    return null;
  }
  boolean hasNext()
  {
    if(currWaypoint<waypoints.size())
    {
      return true;
    }
    return false;
  }
  ArrayList<Waypoint> waypoints;
  int currWaypoint = -1;
}
class Waypoint
{
  Waypoint(float x0, float y0, float x1, float y1, int frame, float zoomf)
  {
    this.x0 = x0;
    this.y0 = y0;
    this.x1 = x1;
    this.y1 = y1;
    this.frame = frame;
    this.zoomf = zoomf;
  }
  float x0;
  float y0;
  float x1;
  float y1;
  int frame;
  float zoomf;
}
class TrajectoryManager
{
  TrajectoryManager()
  {
    trajectories = new ArrayList<Trajectory>();
  }
  
  ArrayList <Trajectory> trajectories;
  Trajectory createTrajectory()
  {
    Trajectory trajectory = new Trajectory();
    trajectories.add(trajectory);
    return trajectory;
  }
  int getTrajectoryCount()
  {
    return trajectories.size();
  }
  Trajectory getTrajectory(int i)
  {
    return (Trajectory)trajectories.get(i);
  }
  void deleteTrajectory(int i)
  {
    if (i>=0 && i<trajectories.size())
    {
      trajectories.remove(i);
    }
  }
  void loadFromXML(String xmlFilename)
  {
    trajectories.clear();
    XML xml;
    xml = loadXML(xmlFilename);
    XML[] xmlTrajectories = xml.getChildren();
    for(int i=0;i<xmlTrajectories.length;i++)
    {
      Trajectory trajectory = new Trajectory();
      XML[] xmlWaypoints = xmlTrajectories[i].getChildren("Trajectory");
      for(int j=0;j<xmlWaypoints.length;j++)
      {
        Waypoint waypoint = new Waypoint(
                                          xmlWaypoints[j].getFloat("x0"),
                                          xmlWaypoints[j].getFloat("y0"),
                                          xmlWaypoints[j].getFloat("x1"),
                                          xmlWaypoints[j].getFloat("y1"),
                                          xmlWaypoints[j].getInt("frame"),
                                          xmlWaypoints[j].getFloat("zoomf")
                                          );
        trajectory.addWaypoint(waypoint);
      }
    }
  }
  void saveToXML(String xmlFilename)
  {
    XML xml = new XML("Trajectories");
    for(int i = 0;i<trajectories.size();i++)
    {
      XML xmlTrajectory = xml.addChild("Trajectory");
      xmlTrajectory.setInt("id",i);
      Trajectory trajectory = trajectories.get(i);
      for(int j=0;j<trajectory.waypoints.size();j++)
      {
        Waypoint waypoint = trajectory.waypoints.get(j);
        XML xmlWaypoint = xmlTrajectory.addChild("Waypoint");
        xmlWaypoint.setInt("id",j);
        xmlWaypoint.setFloat("x0",waypoint.x0);
        xmlWaypoint.setFloat("y0",waypoint.y0);
        xmlWaypoint.setFloat("x1",waypoint.x1);
        xmlWaypoint.setFloat("y1",waypoint.y1);
        xmlWaypoint.setInt("frame",waypoint.frame);
        xmlWaypoint.setFloat("zoomf",waypoint.zoomf);
        
      }
    }
    saveXML(xml,xmlFilename);
  }
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
int frame = 0;
boolean recording = false;
color[] colors;
TrajectoryManager trajectoryManager = null;
Trajectory currentTrajectory = null;
Waypoint currentWaypoint = null;
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
    frame = 0;
    currTime=millis();
    trajectoryManager = new TrajectoryManager();
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
    frame = 0;
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
    if(mode == MODE_DEMO)
    {
      if(currentWaypoint!=null)
      {
        if(frame == currentWaypoint.frame)
        {
          x0 = currentWaypoint.x0;
          y0 = currentWaypoint.y0;
          x1 = currentWaypoint.x1;
          y1 = currentWaypoint.y1;
          zoomf = currentWaypoint.zoomf;
          
        }
      }
    }
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
    if(mode==MODE_DEMO)
    {
      return;
    }
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
    if(recording)
    {
      if(currentTrajectory!=null)
      {
        Waypoint waypoint = new Waypoint(x0,y0,x1,y1,frame,zoomf);
        currentTrajectory.addWaypoint(waypoint);
      }
    }
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
    frame++;
    //handle movement
    //set shader variables

 }
 void handleKey(int key)
 {
   if(key=='D' || key=='d')
   {
     mode = MODE_DEMO;
     trajectoryManager.loadFromXML("data/trajectories.xml");
     currentTrajectory = trajectoryManager.getTrajectory(0);
     if(currentTrajectory!=null)
     {
       if(currentTrajectory.getWaypointCount()>0)
       {
         currentWaypoint = currentTrajectory.getWaypoint(0);
       }
     }
     init();
     frame=0;
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
      if(recording)
      {
        if(currentTrajectory!=null)
        {
          Waypoint waypoint = new Waypoint(x0,y0,x1,y1,frame,zoomf);
          currentTrajectory.addWaypoint(waypoint);
        }
      }
       
     }
   }
   if(key=='X' || key=='x')
   {
     if(zoomf<2.01)
     {
       zoomf = zoomf + 0.01;
       if(recording)
       {
         if(currentTrajectory!=null)
         {
           Waypoint waypoint = new Waypoint(x0,y0,x1,y1,frame,zoomf);
           currentTrajectory.addWaypoint(waypoint);
         }
       }
     }
   }
   if(key=='E' || key=='e')
   {
     recording =!recording;
   }
   if(key=='W' || key=='w')
   {
     trajectoryManager.saveToXML("data/trajectories.xml");
   }
   if(key=='0')
   {
     init();
     if(recording)
     {
       currentTrajectory = trajectoryManager.createTrajectory();
     }
   }
 }
}