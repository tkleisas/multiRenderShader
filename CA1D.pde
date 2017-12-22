class CA1D
{
  float cstep1 = (float)(2 * Math.PI / 256);
  float cstep2 = (float)(2 * Math.PI / 512);
  float cstep3 = (float)(2 * Math.PI / 1024);
  float phaseR = 0;
  float phaseStepR = (float)(2 * Math.PI / 64);
  float phaseG = 0;
  float phaseStepG = (float)(2 * Math.PI / (64 + 16));
  float phaseB = 0;
  float phaseStepB = (float)(2 * Math.PI / (64 + 16 + 16));
  int columns;
  int rows;
  int[][] grid;
  color[] colors;
  int zoom=1;
  int rule=110;
  int currline=0;
  boolean wraparound = true;
  String [] labels = 
{
  "Βλέπετε ένα μονοδιάστατο κυψελιδωτό αυτόματο",
  "που είναι μια σειρά από κελιά που μπορούν να",
  "πάρουν τις τιμές 0 ή 1. Η επόμενη κατάσταση ",
  "ενός κελιού εξαρτάται από την προηγούμενή   ",
  "και από την κατάσταση των δύο γειτόνων του, ",
  "του αριστερού και του δεξιού γείτονα.       ",
  "Το σύνολο των δυνατών κανόνων είναι 256,    ",
  "και έχουν μελετηθεί εκτενώς.                "
};
  
  CA1D()
  {
    grid = new int[width][height];
    colors = new color[height];
    columns = (int)(width/zoom);
    rows = (int)(height/zoom);
  }
  void randomizeLine()
  {
    for(int x=0;x<width;x++)
    {
      grid[x][currline]=(int)Math.round(Math.random());
    }
  }
  int getLabelCount()
  {
    return this.labels.length;
  }
  void setRule(int newrule, boolean initRandom)
  {
    rule = newrule;
    if(initRandom)
    {
      randomizeLine();
    }
    else
    {
      for(int x=0;x<width;x++)
      {
        grid[x][currline]=0;
      }
      grid[columns/2][currline]= 1;
    }
  }
  int getRule()
  {
    return rule;
  }
  void setZoom(int zoomf)
  {
    zoom = zoomf; //<>//
    columns = (int)width/zoom;
    rows = (int)height/zoom;
  }
  void animatePalette()
  {
    for (int i = 0; i < height; i++)
    {
      int r = (int)Math.floor((Math.sin(i * cstep1+phaseR) + 1) * 127);
      int g = (int)Math.floor((Math.sin(i * cstep2+phaseG) + 1) * 127);
      int b = (int)Math.floor((Math.sin(i * cstep3+phaseB) + 1) * 127);
      colors[i] = color(r,g,b,255);
      
    }
  }
  boolean isBlack()
  {
    
    for(int x=0;x<columns;x++)
    {
      if(grid[x][currline]==1)
      return false;
    }
    return true;
  }
  boolean isWhite()
  {
    for(int x=0;x<columns;x++)
    {
      if(grid[x][currline]==0)
      return false;
    }
    return true;
    
  }
  void calcCALine()
  {
    int nextline = currline+1;
    int b0,b1,b2;
    if(nextline>rows-1)
    {
      nextline = 0;
    }
    for(int x = 0 ; x<columns; x++)
    {
      if(x==0)
      {
        if(!wraparound)
        {
          b2 = 0;
        }
        else
        {
          b2 = grid[columns-1][currline];
        }
      }
      else
      {
        b2 = grid[x-1][currline];
      }
      b1 = grid[x][currline];
      if(x==columns-1)
      {
        if(!wraparound)
        {
          b0 = 0;
        }
        else
        {
          b0 = grid[0][currline];
        }
      }
      else
      {
        b0 = grid[x+1][currline];
      }
      int idx = b2*4+b1*2+b0;
      grid[x][nextline] = (1<<idx & rule)>0?1:0;
    }
    currline = nextline;
  }
  
  void display()
  {
      int py = rows - 1;
      for(int y=currline;y>=0;y--)
      {
        for(int x=0;x<columns;x++)
        {
          if(grid[x][y]==0)
          {
            fill(0,0,0,255);
            stroke(0,0,0,255);
            //ctx.fillRect (x*zoom,py*zoom,zoom,zoom);
          }
          else
          {
            fill(colors[y%height]);
            rect(x*zoom, py*zoom, zoom, zoom);
          }
          
        }
        py--;
      }
      for(int y=rows-1;y>currline;y--)
      {
        for (int x = 0; x < columns; x++)
        {
          if (grid[x][y] == 0) {
            fill(0,0,0,255);
            stroke(0,0,0,255);
        }
        else {
          fill(colors[y % height]);
          stroke(0,0,0,255);
          rect(x*zoom, py*zoom, zoom, zoom);
        }
        
      }
      py--;
    }
  }
  String getLabel(int label)
  {
    return labels[label%labels.length];
  }
  String[] getLabels()
  {
    return labels;
  }
}