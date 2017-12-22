class SlideShow
{
  PImage image = null;
  ArrayList slides;
  XML xml;
  String background="";
  int currentSlide = 0;
  String[] scrolltext;
  int textsize;
  SlideShow(int textsize)
  {
    this.textsize = textsize;
    slides = new ArrayList<Slide>();
    String bgStr = "Σημαντικά πρόσωπα της πληροφορικής";
    for (int i=0; i<bgStr.length(); i++)
    {
      background = background + Integer.toBinaryString(bgStr.charAt(i));
    }
    xml = loadXML("cs_people.txt");
    XML[] slidesXML = xml.getChildren("slide");
    for (int i=0; i<slidesXML.length; i++)
    {
      Slide slide = new Slide();

      XML[] imagesXML = slidesXML[i].getChildren("images");
      if(imagesXML.length ==1)
      {
        XML[] imageXML = imagesXML[0].getChildren("image");
        for (int j=0; j<imageXML.length; j++)
        {
         
          slide.filenames.add(imageXML[j].getChild("file").getContent());
          slide.labels.add(imageXML[j].getChild("label").getContent());
        }
      }
      
      slide.text = slidesXML[i].getChild("text").getContent();
      if (slide.filenames.size()>0)
      {
        slide.currentImage = 0;
      } 
      else
      {

        slide.currentImage = -1;
      }
      slides.add(slide);
    }

    currentSlide = 0;
    createScrollText((int)((float)width/(0.6*(float)textsize)));
  }

  void createScrollText(int maxwidth)
  {
    if(currentSlide==-1)
    {
      return;
    }
    Slide slide = (Slide)(slides.get(currentSlide));
    String t =slide.text;
    t = t.replaceAll("\r","");
    //t = t.replaceAll("\n","");
    ArrayList a = new ArrayList<String>();
    int linestart = 0;
    int i1=0;
    
    for(int i=0;i<t.length();i++)
    {
      if(t.charAt(i)==' '){
        if(i1<i && i1-linestart<maxwidth) {
          i1 = i;
        }
      }
      if(t.charAt(i)=='\n')
      {
        a.add(t.substring(linestart,i));
        linestart = i+1;
        i1 = linestart;
      }
      if(i-linestart>maxwidth){
        
        a.add(t.substring(linestart,i1));
        linestart = i1+1;
        i1=linestart;
      }
    }
    if(linestart<t.length()){
      a.add(t.substring(linestart,t.length()-1));
    }
    a.add("");
    a.add("");
    a.add("");
    a.add("");
    a.add("");
    scrolltext = (String[])a.toArray(new String[a.size()]);
    
  }
  void outlineText(float textSize, color outerColor, color innerColor, String text, int x, int y)
  {
    if(text==null)
    {
      return;
    }
    float w = textWidth(text);

    stroke(outerColor);
    fill(outerColor);
    //rect((float)x,(float)y,(float)x+w,(float)-40);
    textSize(textSize);
    text(text, x-1, y-1);
    text(text, x, y-1);
    text(text, x+1, y-1);
    text(text, x-1, y);
    text(text, x, y); //redundant?
    text(text, x+1, y);
    text(text, x-1, y+1);
    text(text, x, y+1);
    text(text, x+1, y+1);
    fill(innerColor);
    stroke(innerColor);
    text(text, x, y);
  }

  void scrollText(int textSize, int x, int y, String s, float scrollSpeed, long time, color outerColor, color innerColor)
  { 
    int idx = 0;
    outlineText((float)textSize, outerColor, innerColor, s, (int)((x-time*scrollSpeed)%textWidth(s)), y);
  }
  String[] getLabels()
  {
    return scrolltext;
  }
  void displayImage(long timeAcc)
  {
    if(currentSlide==-1)
    {
      return;
    }
    Slide slide = (Slide)(slides.get(currentSlide));
    int imageIdx = (int)(timeAcc/10000)%slide.filenames.size();
    if (image==null || imageIdx!=slide.currentImage)
    {
      slide.currentImage = imageIdx; 
      int slidephotocount = slide.filenames.size();
      image = loadImage(slide.filenames.get(slide.currentImage));
    }
      int iwidth = image.width;
      int iheight = image.height;
      float factor = (float)iwidth/(float)iheight;
      if (iwidth > 2*width/3)
      {
        iwidth = 2*width/3;
        iheight = (int)((float)iwidth/factor);
      }
      if (iheight > 2*height/3)
      {
        iheight = 2*height/3;
        iwidth = (int)((float)iheight*factor);
      }
      image(image, (width-iwidth)/2, 0, iwidth, iheight);
      outlineText(textsize,color(0,0,0,255),color(255,255,255,255),slide.labels.get(slide.currentImage), (width-iwidth)/2,iheight+textsize);
  }
  

  void display(long timeAcc)
  {

    scrollText(height, width, height, background, 0.05, timeAcc, color(20, 20, 40, 30), color(20, 20, 40, 30)); 
    scrollText(height/2, width, height/2, background, 0.07, timeAcc, color(40, 20, 20, 30), color(40, 20, 20, 30));
    scrollText(height/3, width, height/3, background, 0.09, timeAcc, color(20, 40, 20, 30), color(20, 40, 20, 30)); 
    scrollText(height/4, width, height/2, background, 0.11, timeAcc, color(40, 40, 40, 30), color(40, 40, 40, 30)); 
    displayImage(timeAcc);
  }
}