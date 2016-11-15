//class_FileIcon


class FileIcon {
  boolean scratchFileAvailable;
  float x,y;
  float Width,Height;
  float clickX,clickY; //where I clicked the mouse on the first frame it was pressed down.
  float cornerRound = 20; //how many pixels rounded our corners are
  float aLRW = 10; //aestheticLeftRectangleWidth

  IconSet myIconSet;
  IconSet iconSetIAmOver; //this is useful to know at all times for changing my appearance

  int id; //This is which file I am by *number*. It's a little easier than re-finding a file under my name. AS OF 28 JUNE 2011, THIS ID IS -1 UNLESS SET TO THIS FILE'S ONLINE ID
  int idInIconSet; //my id within whatever iconSet I'm in. 0 is the top-/first-most.
  int idInIconDock; /*I don't want to have to make a new variable for this function, because I could just use idInIconSet, but I want the redundancy to avoid any potential problems*/
  int totalBlocks; //like my pieChart, this is useful for me to represent, so I'll need this variable

  MiniMenu miniMenu;

  PImage pieChartImage;

  File myFile;
  String mySubfolderString;
  String myString;
  String myTextString;
  String myScratchString; //new. for opening the Scratch file.

  FileIcon()
  {
  }

  FileIcon(File MyFile, String MySubfolderString,String MyString, int Id) {
    myFile = MyFile;
    mySubfolderString = MySubfolderString;
    myTextString = MyString;
    myString = MyString;
    if(myString.length()>12) {
      myString = myTextString.substring(0, myTextString.length()-12); //remove the "-summary.txt" part of the string
      myScratchString = myTextString.substring(0, myTextString.length()-12) + ".sb"; //remove the "-summary.txt" part of the string and add ".sb"
    }
    id = Id;
    textSize(20);
    pieChartImage = setPieChartImage();
    //determine whether or not I have a Scratch file available to open
    String path = sketchPath + "/data/input/"+mySubfolderString;
    String[] filenames = listFileNames(path);
    for(int i=0; i<filenames.length; i++) {
      if(match(filenames[i], myScratchString)!=null) scratchFileAvailable = true;
    }
  }

  void setWidthAndHeight() {
    if(myIconSet!=null) { //if I'm in an iconSet
      if(myIconSet.expanded) {
        Width  += (fileIconWidth -Width )/4;
        Height += (fileIconHeight-Height)/4;
      }
      else {
        Width  += (fileIconMinimizedWidth -Width )/4;
        Height += (fileIconMinimizedHeight-Height)/4;
      }
    }
    else { //if I'm in the iconDock
      if(fileIconBeingDragged!=this) { //if I'm not being dragged
        Width  += (iconDock.Width-fileIconPaddingDockX*2 -Width )/4;
      }
      else {
        Width  += (fileIconWidth -Width )/4;
      }
      Height += (fileIconHeight-Height)/4;
    }
  }

  void draw() {
    //Draw.
    //Box.
    if(fileIconBeingDragged==this) {
      fill(245, 200);
      stroke(90);
      strokeWeight(2);
    }
    else if(!mousePressed && mouseOver_box(x,y, Width,Height) && ((myIconSet!=null&&myIconSet.id==iconSet.size()-1) || (myIconSet==null)) ) { //Moused-over
      fill(240, 245);
      stroke(110);
      strokeWeight(2);
    }
    else { //Normal
      fill(245, 245);
      stroke(190);
      strokeWeight(2);
    }
    //change everything if I'm elligible to be added to something
    if(fileIconBeingDragged==this && (
    (myIconSet!=null && mouseOver_box(iconDock.x,iconDock.y, iconDock.Width,iconDock.Height)) 
    /*|| //not in dock and over dock
     //(myIconSet==null && !mouseOver_box(iconDock.x,iconDock.y, iconDock.Width,iconDock.Height)) || //in dock and not over dock
     //(iconSetIAmOver!=null && iconSetIAmOver!=myIconSet && mouseOver_box(iconSetIAmOver.x,iconSetIAmOver.y, iconSetIAmOver.Width,iconSetIAmOver.Height)) || //over another iconSet
     //(myIconSet!=null && myIconSet.myFileIcon.size()>1 && !mouseOver_box(myIconSet.x,myIconSet.y, myIconSet.Width,myIconSet.Height)) //not over myIconSet
     */
    ) ) {
      //fill(128,40,200, 128);
      //stroke(128,60,160, 128);
      //strokeWeight(1);
    }
    //else {
    //}

    //rectangle with two rounded corners
    //  big rectangle
    beginShape();
    vertex(x+Width-cornerRound,y);
    vertex(x,y);
    vertex(x,y+Height);
    vertex(x+Width-cornerRound,y+Height);
    endShape();
    //  top arc
    ellipseMode(CENTER);
    arc(x+Width-cornerRound,y+cornerRound, cornerRound*2,cornerRound*2, -PI/2,0);
    //  bottom arc
    arc(x+Width-cornerRound,y+Height-cornerRound, cornerRound*2,cornerRound*2, 0,PI/2);
    //  line between arcs
    line(x+Width,y+cornerRound, x+Width,y+Height-cornerRound);
    //  little right rectangle arc-supplement
    noStroke();
    rect(x+Width-1,y+cornerRound, -cornerRound-1,Height-cornerRound*2); //the -1 is so we don't cover up the line just drawn

    //aesthetic left-oriented rectangle
    fill(220, 220);
    stroke(0, 32);
    strokeWeight(1);
    rect(x,y+1, aLRW,Height-2);

    //mini pie chart!
    if(pieChartImage!=null) {
      image(pieChartImage, x+Width-Height+2,y+4, Height-7,Height-7);
    }
    //totalBlockCount!
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(totalBlocks, x+Width-Height/2,y+Height/2);
    //text(totalBlocks, x+Width-Height/2,y+Height/2); //for clarity of reading

    //Texts!
    if(myIconSet==null || myIconSet.expanded) { //KEEP? LEAVE??
      //myString
      fill(0, 220);
      textAlign(CENTER, CENTER);
      textSize(16);
      text(myString, x+aLRW+2,y-2, Width-Height-aLRW-10,Height);
      //mySubfolderString
      fill(0, 128);
      textAlign(LEFT, TOP);
      textSize(14);
      text(mySubfolderString, x+aLRW+4,y+Height-12, Width-aLRW-Height,16);//mySubfolderString
    }
    //mouse-over expansion when minimized
    if(!mousePressed && myIconSet!=null && !myIconSet.expanded && mouseOver_box(x,y, Width,Height)) {
      textSize(18);
      //placemat rectangle
      fill(0, 80);
      noStroke();
      rect(myIconSet.x+myIconSet.Width,myIconSet.y, textWidth(myString)+8,myIconSet.Height);
      //text
      fill(255, 220);
      textAlign(LEFT, CENTER);
      text(myString, myIconSet.x+myIconSet.Width+4,myIconSet.y+myIconSet.Height/2);
    }
    //if I'm in the iconDock, display idInIconDock to my left.
    if(myIconSet==null) {
      fill(0, 220);
      textAlign(LEFT, CENTER);
      textSize(18);
      text(idInIconDock+1, x-fileIconPaddingDockX,y+Height/2);
    }
  }

  void math() {
    //Math.
    if(mousePressed) {
      if(mouseButton==LEFT) {
        //fIOWIMBDC
        if(fIOWIMBDC==this && fFWTMHBHD<2 && false) {
          /*
          //Double-click => Put me in a new iconSet!
           if((myIconSet!=null && myIconSet.myFileIcon.size()>1)) { //if I have an iconSet and I'm not its only fileIcon
           //remove me from the iconSet from which I came.
           myIconSet.myFileIcon.remove(this.idInIconSet);
           //recount the blocks and stuff from the iconSet that I just came from.
           myIconSet.analyzeSelectedFiles(myIconSet.myFileIcon);
           //move down all of the fileIcons in the old iconSet's basket.
           for(int i=idInIconSet; i<myIconSet.myFileIcon.size(); i++) {
           FileIcon tempFileIcon = (FileIcon) myIconSet.myFileIcon.get(i);
           tempFileIcon.idInIconSet -= 1;
           }
           //make a new iconSet!
           iconSet.add(new IconSet(x+180,(y+height/2)/2-200, iconSet.size()));
           //add me into the new iconSet.
           IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-1);
           tempIconSet.myFileIcon.add(this);
           //change myIconSet to the new iconSet.
           myIconSet = (IconSet) iconSet.get(iconSet.size()-1);
           idInIconSet = 0;
          /*SPECIAL!! Grab me by my shoulders and physically thrust me into my new iconSet. If we don't do this, our mouse will still be holding onto me, which can cause problems.*
           x = myIconSet.x;
           y = myIconSet.y;
           }
           else */          if(myIconSet==null) { //if I were in the iconDock
            //make a new iconSet!
            iconSet.add(new IconSet(x+180,(y+height/2)/2-200, iconSet.size()));
            //add me into the new iconSet.
            IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-1);
            tempIconSet.myFileIcon.add(this);
            //change myIconSet to the new iconSet.
            myIconSet = (IconSet) iconSet.get(iconSet.size()-1);
            idInIconSet = 0;
            //remove me from the iconDock's basket-- I'm independent now!
            iconDock.myFileIcon.remove(idInIconDock);
            /*SPECIAL!! Grab me by my shoulders and physically thrust me into my new iconSet. If we don't do this, our mouse will still be holding onto me, which can cause problems.*/
            x = myIconSet.x;
            y = myIconSet.y;
          }
        }
        /*
        if(myIconSet==null && mouseOver_box(iconDock.x,iconDock.y, iconDock.Width,iconDock.Height)) { //if I'm in the iconDock
         idInIconDock = dropIndex();
         }*/
        if(((myIconSet!=null && myIconSet.id==iconSet.size()-1) || (myIconSet==null))  &&  fFWTMHBHD<2 && mouseOver_box(x,y, Width,Height)) {
          clickX = mouseX-x;
          clickY = mouseY-y;
          fileIconBeingDragged = this;
          fIOWIMBDC = this;
        }
        if(fileIconBeingDragged==this) {
          x = mouseX-clickX;
          y = mouseY-clickY;
        }
      }
      else if(mouseButton==RIGHT && mouseOver_box(x,y, Width,Height) && fFWTMHBHD<2) { //Right-clicking on the fileIcon
        miniMenu = new MiniMenu(mouseX,mouseY, this); //make the miniMenu exist so it may draw!
      }
    }
    if(miniMenu!=null && miniMenu.nullMe) miniMenu = null;
    if(myIconSet!=null) { //if I'm in an iconSet
      if(myIconSet.expanded) {
        if(iconSetBeingDragged==myIconSet) {
          x = myIconSet.x+fileIconPaddingXLeft;
          y = myIconSet.y+8 + idInIconSet*(Height+fileIconPaddingY);
        }
        else if(fileIconBeingDragged!=this) {
          x += (myIconSet.x+fileIconPaddingXLeft-x)/6;
          y += (myIconSet.y+8 + idInIconSet*(Height+fileIconPaddingY)-y)/6;
        }
      }
      else {
        if(iconSetBeingDragged==myIconSet) {
          x = myIconSet.x+fileIconMinimizedPaddingX+ idInIconSet*(fileIconMinimizedWidth+fileIconMinimizedPaddingX);
          y = myIconSet.y+fileIconMinimizedPaddingY;
        }
        else if(fileIconBeingDragged!=this) {
          x += ((myIconSet.x+fileIconMinimizedPaddingX+ idInIconSet*(fileIconMinimizedWidth+fileIconMinimizedPaddingX))-x)/4;
          y += ((myIconSet.y+fileIconMinimizedPaddingY)-y)/4;
        }
      }
    }
    else if(fileIconBeingDragged!=this) { //if I'm in the iconDock
      x += (iconDock.x+fileIconPaddingDockX+8-x)/4; //10 is an arbitrary offset
      /*HACK. THE FOLLOWING IS REDUNDANT AND SHOULD BE MERGED WITH THE OTHER IF STATEMENTS. But separating it is a little easier to read and understand.*/
      if(fileIconBeingDragged!=null && fileIconBeingDragged.myIconSet==null) { //if I'm bringing a fileIcon FROM the iconDock INTO the iconDock
        if(y<=fileIconBeingDragged.y && fileIconBeingDragged.idInIconDock<idInIconDock)
          y += (iconDock.y+iconDock.scrollY+fileIconPaddingY+(idInIconDock-1)*(fileIconHeight+fileIconPaddingY)-y)/4; //above potential new fileIcon
        else if(y>=fileIconBeingDragged.y && fileIconBeingDragged.idInIconDock>idInIconDock)
          y += (iconDock.y+iconDock.scrollY+fileIconPaddingY+(idInIconDock+1)*(fileIconHeight+fileIconPaddingY)-y)/4; //below potential new fileIcon
        else
          y += (iconDock.y+iconDock.scrollY+fileIconPaddingY+(idInIconDock+0)*(fileIconHeight+fileIconPaddingY)-y)/4; //below potential new fileIcon
      }
      else { //this else statement is bullshit. it's a mild cover-up for the above redundancy.
        //*/
        //BIG HACK. This should only be an "if" and "if else" statement... two. Not three. Three was just easier to do...
        if(iconSetBeingDragged!=null && mouseOver_box(iconDock.x,iconDock.y, iconDock.Width,iconDock.Height) && iconDock.elbowRoomIndex<idInIconDock)
          y += (iconDock.y+iconDock.scrollY+fileIconPaddingY+(idInIconDock+iconSetBeingDragged.myFileIcon.size())*(fileIconHeight+fileIconPaddingY)-y)/4; //below potential new fileIcons in an iconSet
        else if((fileIconBeingDragged==null || iconDock.elbowRoomIndex>idInIconDock) || (fileIconBeingDragged!=null && fileIconBeingDragged.myIconSet==null) || !mouseOver_box(iconDock.x,iconDock.y, iconDock.Width,iconDock.Height))
          y += (iconDock.y+iconDock.scrollY+fileIconPaddingY+(idInIconDock+0)*(fileIconHeight+fileIconPaddingY)-y)/4; //above potential new fileIcon
        else
          y += (iconDock.y+iconDock.scrollY+fileIconPaddingY+(idInIconDock+1)*(fileIconHeight+fileIconPaddingY)-y)/4; //below potential new fileIcon
      }
    }
    setWidthAndHeight();
    if(!mousePressed && fileIconBeingDragged==this) { //if I'm getting dropped off somewhere...
      //have I been dropped off in the middle of nowhere?
      iconSetIAmOver = null; //I'll say otherwise shortly.
      for(int i=0; i<iconSet.size(); i++) {
        IconSet tempIconSet = (IconSet) iconSet.get(i);
        if(mouseOver_box(tempIconSet.x,tempIconSet.y, tempIconSet.Width,tempIconSet.Height)) {
          iconSetIAmOver = tempIconSet;
        }
      }
      if(iconSetIAmOver==null) { //if I was not dropped off over an iconSet
        if(mouseOver_box(iconDock.x-100,iconDock.y, iconDock.Width+100,0+iconDock.Height)) { //if I were actually dropped off in the iconDock /*note-- the 100 and 200 are for dragging me too far offscreen*/
          //if I weren't already in the dock...
          if(myIconSet!=null) {
            //remove me from the iconSet from which I came.
            myIconSet.myFileIcon.remove(this.idInIconSet);
            //recount the blocks and stuff from the iconSet that I just came from.
            myIconSet.analyzeSelectedFiles(myIconSet.myFileIcon);
            //move down all of the fileIcons in the old iconSet's basket.
            for(int i=idInIconSet; i<myIconSet.myFileIcon.size(); i++) {
              FileIcon tempFileIcon = (FileIcon) myIconSet.myFileIcon.get(i);
              tempFileIcon.idInIconSet -= 1;
            }
            //add me to the iconDock
            iconDock.myFileIcon.add(dropIndex(), this);
            //remove myIconSet from the ArrayList of iconSets. not neccessary, but good to clean up after ourselves
            //iconSet.remove(myIconSet); //note: DON'T do this!
            //clean-slate myIconSet; I have none, as I'm in the dock now
            myIconSet = null;
          }
          else { //if I were dropped off FROM the iconDock INTO the iconDock
            iconDock.myFileIcon.remove(this); //Remove me entirely from the iconDock first.
            iconDock.myFileIcon.add(dropIndex(), this); //Now insert me back into the iconDock in this location.
          }
        }
        else { //if I was dropped off in the middle of nowhere, put me in a new iconSet.
          if((myIconSet==null && !mouseOver_box(iconDock.x,iconDock.y, iconDock.Width,iconDock.Height)) || (myIconSet!=null && myIconSet.myFileIcon.size()>1)) { //as long as I'm not already the only child in an iconSet
            //make a new iconSet!
            iconSet.add(new IconSet(x,y, iconSet.size()));
            //if I weren't in the dock...
            if(myIconSet!=null) {
              //remove me from the iconSet from which I came.
              myIconSet.myFileIcon.remove(this.idInIconSet);
              //recount the blocks and stuff from the iconSet that I just came from.
              myIconSet.analyzeSelectedFiles(myIconSet.myFileIcon);
              //move down all of the fileIcons in the old iconSet's basket.
              for(int i=idInIconSet; i<myIconSet.myFileIcon.size(); i++) {
                FileIcon tempFileIcon = (FileIcon) myIconSet.myFileIcon.get(i);
                tempFileIcon.idInIconSet -= 1;
              }
            }
            //if I were in the dock...
            else {
              //remove me from the iconDock's basket-- I'm independent now!
              iconDock.myFileIcon.remove(idInIconDock);
            }
            //add me into the new iconSet.
            IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-1);
            tempIconSet.myFileIcon.add(this);
            //change myIconSet to the new iconSet.
            myIconSet = (IconSet) iconSet.get(iconSet.size()-1);
            idInIconSet = 0;
          }
        }
      }
      else if(iconSetIAmOver!=myIconSet) { //if I'm being dropped off over an iconSet, and it's not already myIconSet, I'll do a little dance and join it.
        //if I weren't in the dock...
        if(myIconSet!=null) {
          //remove me from the iconSet from which it came.
          myIconSet.myFileIcon.remove(this.idInIconSet);
          //move down all of the fileIcons in the old iconSet's basket.
          for(int i=idInIconSet; i<myIconSet.myFileIcon.size(); i++) {
            FileIcon tempFileIcon = (FileIcon) myIconSet.myFileIcon.get(i);
            tempFileIcon.idInIconSet -= 1;
          }
        }
        //if I were in the dock...
        else {
          //remove me from the iconDock's basket-- I'm independent now!
          iconDock.myFileIcon.remove(idInIconDock);
        }
        //set my idInIconSet.
        idInIconSet = iconSetIAmOver.myFileIcon.size();
        //add me to my new iconSet's basket.
        iconSetIAmOver.myFileIcon.add(this);
        //set my iconSet to the new one.
        myIconSet = iconSetIAmOver;
        //make sure to reset my new iconSet's statistics
        myIconSet.analyzeSelectedFiles(myIconSet.myFileIcon);
      }
    }
  }

  int dropIndex() {
    //determine where in the iconDock's ArrayList I'm being placed
    int dropIndex;
    dropIndex = int((y-iconDock.scrollY)/(fileIconHeight+fileIconPaddingY)+0.5); //semi-hacked; tweaked values for a nice fit
    if(dropIndex<0) dropIndex = 0; //Don't let dropIndex be less than 0
    if(dropIndex>iconDock.myFileIcon.size()) dropIndex = iconDock.myFileIcon.size(); //Don't let dropIndex exceed this value; if it does, we can't add to the iconDock
    return dropIndex;
  }


  PImage setPieChartImage() {
    try {
      IconSet tempIconSet = new IconSet(0,0, 0);
      tempIconSet.myFileIcon.add(this);
      tempIconSet.analyzeSelectedFiles(tempIconSet.myFileIcon);
      totalBlocks = tempIconSet.totalBlocks; /*THIS DOESN'T BELONG HERE. But it should stay. It's totally mooching off of this function. It has to go SOMEwhere, and this is probably the best place for it.*/
      PImage tempImage = tempIconSet.infoPanel.pieChart.pgPie();
      tempImage.mask(tempIconSet.infoPanel.pieChart.pgMask());
      return tempImage;
    }
    catch(Exception e) {
      println(myString + " seems to have an issue with generating its pieChartImage.");
      return null;
    }
  }


  class MiniMenu {
    boolean nullMe; //if this is true, myFileIcon will make me null
    float x,y;
    float Width,Height;
    FileIcon myFileIcon;
    MiniMenu(float X,float Y, FileIcon MyFileIcon) {
      x = X;
      y = Y;
      Width = 160;
      Height = 64;
      myFileIcon = MyFileIcon;
    }
    void draw() {
      //Math.
      if(mousePressed && fFWTMHBHD<2) { //if the mouse is clicked anywhere
        if(!mouseOver_box(x,y, Width,Height)) //if the mouse isn't over me, null me
          nullMe = true;
        else if(mouseButton==LEFT) { //if I'm clicked somewhere on me, do what I was born to do! (open something)
          if(mouseOver_box(x,y, Width,Height*0.333))
            openTextFile();
          else if(mouseOver_box(x,y+Height*0.333, Width,Height*0.333))
            openScratchFile();
          else if(mouseOver_box(x,y+Height*0.667, Width,Height*0.333))
            openFolder();
        }
      }

      //Draw.
      textAlign(CENTER, CENTER);
      textSize(14);
      if(Width<textWidth("Open "+myString+"-summary.txt")+10) Width = textWidth("Open "+myString+"-summary.txt") + 10; //JUST PLAIN HACK. But not a bad one. It makes sense.
      //shadow effect
      fill(0, 16);
      noStroke();
      for(int i=0; i<6; i++)
        rect(x-4-i*1,y-i*1, Width+4+i*3,Height+i*3);
      //ARBITRARY BOX THING (yayy!)
      fill(240, 220);
      stroke(128, 200);
      strokeWeight(1);
      rect(x-4,y, 4,Height);
      //open text file
      if(mouseOver_box(x,y, Width,Height*0.333))
        fill(128,12,230, 250);
      else
        fill(250, 250);
      stroke(128, 200);
      strokeWeight(1);
      rect(x,y, Width,Height*0.333);
      fill(0, 250);
      text("Open " + myString + "-summary.txt", x+Width*0.5,y+Height/6);
      //open Scratch file
      if(mouseOver_box(x,y+Height*0.333, Width,Height*0.333) && scratchFileAvailable)
        fill(128,12,230, 250);
      else
        fill(250, 250);
      if(!scratchFileAvailable)
        fill(200);
      stroke(128, 200);
      strokeWeight(1);
      rect(x,y+Height*0.333, Width,Height*0.333);
      fill(0, 250);
      if(scratchFileAvailable)
        text("Open " + myScratchString, x+Width*0.5,y+Height*0.5);
      else {
        fill(0, 160);
        text("(Scratch file not found)", x+Width*0.5,y+Height*0.5);
      }
      //open folder
      if(mouseOver_box(x,y+Height*0.667, Width,Height*0.333))
        fill(128,12,230, 250);
      else
        fill(250, 250);
      stroke(128, 200);
      strokeWeight(1);
      rect(x,y+Height*0.667, Width,Height*0.333);
      fill(0, 250);
      text("Open folder", x+Width*0.5,y+Height*0.833);
      //darker border
      noFill();
      stroke(0, 128);
      rect(x,y, Width,Height);
    }
    void openTextFile() {
      String fileToOpen = sketchPath + "/" + "data/input/" + mySubfolderString + "/" + myString + "-summary.txt"; //don't forget to add the -summary.txt now
      open(fileToOpen);
      nullMe = true;
    }
    void openScratchFile() {
      String fileToOpen = sketchPath + "/" + "data/input/" + mySubfolderString + "/" + myScratchString;
      open(fileToOpen);
      nullMe = true;
    }
    void openFolder() {
      String fileToOpen = sketchPath + "/" + "data/input/" + mySubfolderString;
      open(fileToOpen);
      nullMe = true;
    }
  }
}
