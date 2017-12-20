class SlideShow
{
  final int TOPIC_BABBAGE = 0;
  final int TOPIC_ADA = 1 ;
  final int TOPIC_TURING = 2 ;
  final int TOPIC_HOPPER = 3;
  final int TOPIC_LAST = 4;
  int currentTopic = TOPIC_BABBAGE;
  PImage[] images;
  SlideShow()
  {
    images = new PImage[babbagePictures.length+adaPictures.length];
    String bgStr = "Σημαντικά πρόσωπα της πληροφορικής";
    for(int i=0;i<bgStr.length();i++)
    {
      background = background + Integer.toBinaryString(bgStr.charAt(i));
    }
    for(int i=0;i<babbagePictures.length;i++)
    {
      PImage img = loadImage(babbagePictures[i]);
        images[i] = img;
    }
    for(int i=0;i<adaPictures.length;i++)
    {
      PImage img = loadImage(adaPictures[i]);
      images[i+babbagePictures.length] = img;
    }
    
  }
  
  String[] getPictures()
  {
      switch(currentTopic)
      {
        case TOPIC_BABBAGE:
        return babbagePictures;
        case TOPIC_ADA:
        return adaPictures;
        
      }
      return null;
  }
  String[] getPictureLabels()
  {
    return null;
  }
  String[] babbagePictures=
  {
    "CharlesBabbage.jpg"
  };
  String[] adaPictures=
  {
    "Ada_Lovelace.jpg"
  };
  String[] babbageLabels = 
  {
     "Ο Τσαρλς Μπάμπατζ (26 Δεκεμβρίου 1791 – 18 Οκτωβρίου 1871)",
     "ήταν Βρετανός μαθηματικός, φιλόσοφος, εφευρέτης και μηχανικός",
     "ο οποίος επινόησε τον προγραμματίσιμο υπολογιστή.",
     "Θεωρείται ο «πατέρας του υπολογιστή». Του αποδίδεται ",
     "η εφεύρεση του πρώτου μηχανικού υπολογιστή, ο οποίος ",
     "σταδιακά οδήγησε σε πιο προχωρημένο σχεδιασμό.",
     "Τμήματα των μη ολοκληρωμένων μηχανών του εκτίθενται",
     "στο Μουσείο Επιστημών του Λονδίνου. To 1991 κατασκευάστηκε",
     "μια πλήρως λειτουργική διαφορική μηχανή από τα αρχικά σχέδια",
     "του Μπάμπατζ, με μεθόδους κατασκευής που αντιστοιχούσαν στον",
     "19ο αιώνα. Η επιτυχής κατασκευή της μηχανής έδειξε ότι η μηχανή",
     "θα μπορούσε να λειτουργήσει. Εννέα χρόνια αργότερα το Μουσείο",
     "Επιστημών ολοκλήρωσε τον εκτυπωτή που ο Μπάμπατζ είχε σχεδιάσει",
     "για την διαφορική μηχανή, μια εξαιρετικά πολύπλοκη συσκευή",
     "για τον 19ο αιώνα." 
  };
  String[] adaLabels = 
  {
    "Η Αυγούστα Άντα Κίνγκ, Κόμισσα του Λάβλεϊς",
    "(πατρικό Αυγούστα Άντα Μπάιρον) είναι γνωστή",
    "για το έργο που άφησε σχετικά με την ",
    "Αναλυτική Μηχανή του Τσαρλς Μπάμπατζ.",
    "Η συνεισφορά της αυτή θεωρείται σήμερα",
    "από τους ιστορικούς ως το πρώτο πρόγραμμα για υπολογιστή",
    "Η Άντα Λάβλεϊς αλληλογραφούσε με τον",
    "Τσάρλς Μπάμπατζ. Σε ένα γράμμα που του έγραψε,",
    "περιγράφει το πως η Αναλυτική Μηχανή θα μπορούσε να",
    "υπολογίζει αριθμούς Μπερνούλι, πράγμα που θεωρείται",
    "το πρώτο πρόγραμμα για υπολογιστή. Προς τιμή της",
    "μια γλώσσα προγραμματισμού, η ADA, πήρε το όνομά της"
  };
  
  String background = "";
  String[] getLabels()
  {
    switch(currentTopic)
    {
      case TOPIC_BABBAGE:
      return babbageLabels;
      
      case TOPIC_ADA:
      return adaLabels;
      
      default:
      return null;
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
  
  void scrollText(int textSize,int x, int y, String s, float scrollSpeed, long time,color outerColor, color innerColor)
  { 
    int idx = 0;
    outlineText((float)textSize,outerColor, innerColor, s,(int)((x-time*scrollSpeed)%textWidth(s)),y);

  }
  void displayImage(long timeAcc)
  {
    PImage img= images[(int)(timeAcc/10000)%images.length];
    int iwidth = img.width;
    int iheight = img.height;
    float factor = (float)iwidth/(float)iheight;
    if(iwidth > 2*width/3)
    {
      iwidth = 2*width/3;
      iheight = (int)((float)iwidth/factor);
    }
    if(iheight > 2*height/3)
    {
      iheight = 2*height/3;
      iwidth = (int)((float)iheight*factor);
    }
    image(img,width/3,0,iwidth,iheight);
  }
  
  void display(long timeAcc)
  {
    
    scrollText(height,width, height,background,0.05,timeAcc, color(20,20,40,30),color(20,20,40,30)); 
    scrollText(height/2,width, height/2,background,0.07,timeAcc, color(40,20,20,30),color(40,20,20,30));
    scrollText(height/3,width, height/3,background,0.09,timeAcc, color(20,40,20,30),color(20,40,20,30)); 
    scrollText(height/4,width, height/2,background,0.11,timeAcc, color(40,40,40,30),color(40,40,40,30)); 
    switch(currentTopic)
    {
      case TOPIC_BABBAGE:
       displayImage(timeAcc);
      break;
      
    }
  }
}