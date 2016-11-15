//class_IconSet
//OPTIMIZED BY CHRIS HALLBERG, 11/15/10

class IconSet {
  //*********************************************
  //void_setBlockArrayValues
  //Totals.
  int[] totals = new int[11];
  int sprites;
  int stacks;
  int unique_costumes;
  int unique_sounds;
  int times_saved;
  int times_shared;
  int previous_versions;
  int variables_public;
  int variables_private;
  int lists_public;
  int lists_private;
  int[] nest;
  int codeBlockTypeOffsetHACK; //allows for multiple files to stuff their block data in codeBlockType.
  int[] codeBlockType;

  //Blocks
  int maximumBlockCount;
  int totalBlocks;
  int[] totalBlockType = new int[8];
  int[] anyBlock = new int[0];
  String[] blockType = new String[8];
  //Motion    - blue
  int[] motionBlock = new int[15];  
  //Control   - yellow-orange
  int[] controlBlock = new int[16];  
  //Looks     - purple
  int[] looksBlock = new int[20];
  //Sensing   - teal
  int[] sensingBlock = new int[17];
  //Sound     - pink
  int[] soundBlock = new int[13];
  //Operators   - lime green
  int[] operatorsBlock = new int[28];
  //Pen       - hunter green
  int[] penBlock = new int[11];
  //Variables and Lists - light orange and dark red
  int[] variableBlock = new int[11];

  void setBlockArrayValues() {
    //Totals!
    totals[0] += sprites;
    totals[1] += stacks;
    totals[2] += unique_costumes;
    totals[3] += unique_sounds;
    totals[4] += times_saved;
    totals[5] += times_shared;
    totals[6] += previous_versions;
    totals[7] += variables_public;
    totals[8] += variables_private;
    totals[9] += lists_public;
    totals[10] += lists_private;

    //blockType!
    blockType[0] = "Motion";
    blockType[1] = "Control";
    blockType[2] = "Looks";
    blockType[3] = "Sensing";
    blockType[4] = "Sound";
    blockType[5] = "Operators";
    blockType[6] = "Pen";
    blockType[7] = "Variables";

    //setTotalBlockType(); //REPETIVELY REDUNDANT -<3 CHRIS

    infoPanel.pieChart.reset();
  }

  void setTotalBlockType() {
    maximumBlockCount = 0;   
    totalBlockType = new int[8];  //SAME AS tB[0] = 0;tB[1] = 0;etc - CHRIS
    //Notion!
    for(int i=0; i<motionBlock.length; i++) {
      totalBlockType[0] += motionBlock[i];
      if(motionBlock[i]>maximumBlockCount)
        maximumBlockCount = motionBlock[i];
    }

    //Control!
    for(int i=0; i<controlBlock.length; i++) {
      totalBlockType[1] += controlBlock[i];
      if(controlBlock[i]>maximumBlockCount)
        maximumBlockCount = controlBlock[i];
    }

    //Looks!
    for(int i=0; i<looksBlock.length; i++) {
      totalBlockType[2] += looksBlock[i];
      if(looksBlock[i]>maximumBlockCount)
        maximumBlockCount = looksBlock[i];
    }

    //Sensing!
    for(int i=0; i<sensingBlock.length; i++) {
      totalBlockType[3] += sensingBlock[i];
      if(sensingBlock[i]>maximumBlockCount)
        maximumBlockCount = sensingBlock[i];
    }

    //Sound!
    for(int i=0; i<soundBlock.length; i++) {
      totalBlockType[4] += soundBlock[i];
      if(soundBlock[i]>maximumBlockCount)
        maximumBlockCount = soundBlock[i];
    }

    //Operators!
    for(int i=0; i<operatorsBlock.length; i++) {
      totalBlockType[5] += operatorsBlock[i];
      if(operatorsBlock[i]>maximumBlockCount)
        maximumBlockCount = operatorsBlock[i];
    }

    //Pen!
    for(int i=0; i<penBlock.length; i++) {
      totalBlockType[6] += penBlock[i];
      if(penBlock[i]>maximumBlockCount)
        maximumBlockCount = penBlock[i];
    }

    //Variable!
    for(int i=0; i<variableBlock.length; i++) {
      totalBlockType[7] += variableBlock[i];
      if(variableBlock[i]>maximumBlockCount)
        maximumBlockCount = variableBlock[i];
    }
  }


  //*********************************************


  boolean mousedOverByFileIcon; //useful for drawing and mathing my correct Height
  boolean mousedOverByIconSet;  //useful for drawing and mathing my correct Height
  boolean closeEnoughToGhostIcon; //somewhat redundant, but enables dynamic transparency feedback (when adding an iconSet to another iconSet)
  boolean expanded = true; //specific only to the fileIcon basket
  boolean mouthOpen; //bizarre name, but easy for me to remember.
  boolean HACK_alreadyPerformedMath; //biggest hack ever. (when we make me goToFront, I might math a second time, which causes problems)
  boolean HACK_alreadyPerformedDraw; //biggest hack ever. (when we make me goToFront, I might draw a second time, which causes problems)
  float x,y;
  float Width,Height;
  float headerWidth,headerHeight;
  float clickX,clickY; //where I clicked the mouse on the first frame it was pressed down.
  float transparency;
  float roundedRectTransparency; //green rounded rectangle indicating our elligibility to accept the incoming iconSet
  ArrayList myFileIcon;
  Object blockBeingDragged;
  InfoPanel infoPanel;
  int id;
  ExpandButton expandButton;

  IconSet(float X,float Y, int Id) {
    x = X;
    y = Y;
    id = Id;
    expandButton = new ExpandButton(this);
    reset();
  }

  void math() {
    if(!HACK_alreadyPerformedMath) {
      //Math.
      //transparency!
      if(iconSetBeingDragged==this) {
        closeEnoughToGhostIcon = false;
        for(int i=0; i<iconSet.size(); i++) {
          IconSet tIS = (IconSet) iconSet.get(i); //tempIconSet
          if(tIS!=this) { //don't want to check if we're over ourselves or anything
            /*if(sqrt((x-tIS.x)*(x-tIS.x)+(y-tIS.y)*(y-tIS.y))<12) closeEnoughToGhostIcon = true; afterthought: don't think I really need this, too*/
            if(mouseOver_box(tIS.x,tIS.y, tIS.Width,tIS.Height) && mouseOver_box(x,y-headerHeight, Width,headerHeight)) closeEnoughToGhostIcon = true; //NOTE: only if we've dragged me by the header
          }
        }
      }
      else closeEnoughToGhostIcon = false; //if we're not being dragged, our transparency is definitely 255
      if(closeEnoughToGhostIcon || (iconSetBeingDragged==this && mouseOver_box(iconDock.x,0, iconDock.Width,height)) )
        transparency += (0-transparency)/3;
      else
        transparency += (255-transparency)/10;

      if(iconSetBeingDragged==this && !mousePressed && !keyDown_CONTROL) { //if I've been dropped off somewhere
        if(mouseOver_box(iconDock.x,0, iconDock.Width,height)) { //if I've been dropped into the iconDock
          //for each of my fileIcons...
          for(int i=myFileIcon.size()-1; i>=0; i--) { //note that this is done backwards so the fileIcons add in the same order they were in in the iconSet
            FileIcon tempFileIcon = (FileIcon) myFileIcon.get(i);
            //determine where in the iconDock's ArrayList I'm being placed
            int dropIndex;
            dropIndex = int((y-iconDock.scrollY)/(fileIconHeight+fileIconPaddingY)+0.5); //semi-hacked; tweaked values for a nice fit
            if(dropIndex<0) dropIndex = 0; //Don't let dropIndex be less than 0
            if(dropIndex>iconDock.myFileIcon.size()) dropIndex = iconDock.myFileIcon.size(); //Don't let dropIndex exceed this value; if it does, we can't add to the iconDock
            //give the iconDock each fileIcon
            iconDock.myFileIcon.add(dropIndex, tempFileIcon);
            //tell each fileIcon I've passed them into the iconDock
            tempFileIcon.myIconSet = null;
          }
          //self-destruct!!!
          //myFileIcon = new ArrayList(0);
          iconSet.remove(this);
        }
      }
      if(iconSetBeingDragged!=null && iconSetBeingDragged!=this) { //if I'm holding an iconSet that isn't me
        float tempHeight = Height; //make a temporary Height
        if(mousedOverByIconSet && mouseOver_box(iconSetBeingDragged.x,iconSetBeingDragged.y-iconSetBeingDragged.headerHeight, iconSetBeingDragged.Width,iconSetBeingDragged.headerHeight)) { //if the iconSetBeingDragged is straddling its legs over me
          tempHeight += iconSetBeingDragged.Height; //so if we're properly moused-over by a dragging iconSet, increase this temporary Height
          if(!mousePressed) { //if I just dropped off an iconSet that isn't me
            if(iconSetBeingDragged.closeEnoughToGhostIcon) {
              bringToFront(); //Bring me to the front! This should prevent crashing, too? Maybe?
              //add each of that iconSet's myFileIcon ArrayList items to mine.
              for(int i=0; i<iconSetBeingDragged.myFileIcon.size(); i++) {
                FileIcon tempFileIcon = (FileIcon) iconSetBeingDragged.myFileIcon.get(i); //for each of the iconSet's fileIcons...
                //tell them who their NEW daddy is.
                tempFileIcon.myIconSet = this;
                //make sure the new fileIcons know where in my basket they are.
                tempFileIcon.idInIconSet = myFileIcon.size();
                //and now, of course, I'll take all of the iconSet's fileIcons.
                myFileIcon.add(tempFileIcon);
              }
              //knock down the id of every iconSet that was above the about-to-be-deleted iconSet by 1.
              for(int i=iconSetBeingDragged.id; i<iconSet.size(); i++) {
                IconSet tempIconSet2 = (IconSet) iconSet.get(i);
                tempIconSet2.id --;
              }
              //delete the old iconSet! I just absorbed it.
              iconSet.remove(iconSetBeingDragged); /*...note: we're not removing this iconSet's fileIcons. We're just skipping that entirely and removing the iconSet from the whole iconSet ArrayList.*/
              analyzeSelectedFiles(myFileIcon);
            }
          }
        }
      }
      if(mousePressed) {
        if(mouseButton==LEFT) {
          if(iconSetBeingDragged==null && frontmostIconSetOverWhichMyMouseIs==this && fFWTMHBHD<2 && (mouseOver_box(x,y-headerHeight, Width,headerHeight)
            || (!mouseOver_circle(infoPanel.x+infoPanel.Width-6,infoPanel.y+infoPanel.Height-6, 12)
            && mouseOver_box(infoPanel.x,infoPanel.y+infoPanel.graphTab[0].Height, infoPanel.Width,infoPanel.Height-infoPanel.graphTab[0].Height))
            && !mouseOver_box(iconDock.x,0, iconDock.Width,height)
            && !mouseOver_box(infoPanel.scaleSlider.x,infoPanel.scaleSlider.y, infoPanel.scaleSlider.Width,infoPanel.scaleSlider.Height))) {
            clickX = mouseX-x;
            clickY = mouseY-y;
            iconSetBeingDragged = this;
            bringToFront();
          }
          //clicking on any part of the iconSet brings the iconSet to the front, as does clicking on any part of the infoPanel if it's expanded
          if(fFWTMHBHD<2 && (
          (mouseOver_box(x,y, Width,Height)) ||
            (iconSetBeingDragged==null && infoPanel.expanded && mouseOver_box(infoPanel.x,infoPanel.y, infoPanel.Width,infoPanel.Height)) )) {//!mouseOver_box(iconSetBeingDragged.x,iconSetBeingDragged.y, iconSetBeingDragged.Width,iconSetBeingDragged.Height) && 
            //bringToFront();
          }
        }
        else if(mouseButton==RIGHT && iconSetBeingDragged==null && fFWTMHBHD<2 && mouseOver_box(x,y-headerHeight, Width,headerHeight)) {
          expanded = !expanded;
        }
      }
      maybeRemoveMyself(); //this will remove me from the ArrayList if I've got no fileIcons.
      setWidthAndHeight();
      if(frontmostIconSetOverWhichMyMouseIs==this) { //if I'm the frontmost graph that's MOUSED-OVER...
        if(mousePressed && fFWTMHBHD<2) bringToFront(); //click on me somewhere? bring me to the front.
      }
      if(iconSetBeingDragged==this) {
        x = mouseX-clickX;
        y = mouseY-clickY;
      }
      //HACK - PLEASE PUT THE BELOW IN A BETTER PLACE.
      if(frontmostIconSetOverWhichMyMouseIs==this && ((mousedOverByIconSet&&mouseOver_box(iconSetBeingDragged.x,iconSetBeingDragged.y-iconSetBeingDragged.headerHeight, iconSetBeingDragged.Width,iconSetBeingDragged.headerHeight)) || mousedOverByFileIcon)) mouthOpen = true;
      else mouthOpen = false;
    }
    HACK_alreadyPerformedMath = true;
  }

  void draw() {
    if(!HACK_alreadyPerformedDraw) {
      //Draw.
      //shadow effect!
      //INSERT: IF I'M THE FRONTMOST, MAKE MY SHADOW DARKER
      if(infoPanel.x!=0) { //HACK. prevents a one-frame flash of shadow at top-left corner of screen.
        fill(0, 0.04*transparency);
        noStroke();
        if(infoPanel.expanded) {
          for(int i=-2; i<4; i++) {
            translate( i*3, i*3); //pushMatrix()
            beginShape();
            vertex(infoPanel.x,infoPanel.y);
            vertex(infoPanel.x+infoPanel.Width,infoPanel.y);
            vertex(infoPanel.x+infoPanel.Width,infoPanel.y+infoPanel.Height);
            vertex(infoPanel.x+infoPanel.optionsPanel.Width,infoPanel.y+infoPanel.Height);
            vertex(infoPanel.x+infoPanel.optionsPanel.Width,infoPanel.y+infoPanel.Height+infoPanel.optionsPanel.Height);
            vertex(infoPanel.x,infoPanel.y+infoPanel.Height+infoPanel.optionsPanel.Height);
            vertex(infoPanel.x,infoPanel.y);
            endShape();
            translate(-i*3,-i*3); //popMatrix();
          }
        }
      }
      //for(int i=0; i<6; i++)
      //  rect(x-i,y-i*0.6, Width+i*4,Height+i*3);
      //rounded rectangle (for iconSet adding)!
      if(mouthOpen) {
        roundedRectTransparency += (1-roundedRectTransparency)/4;
      }
      else {
        roundedRectTransparency += (0-roundedRectTransparency)/8;
      }
      if(roundedRectTransparency>0.01) {
        fill(54,255,255, transparency*0.3*roundedRectTransparency);
        stroke(54,255,140, transparency*0.5*roundedRectTransparency);
        strokeWeight(2);
        roundRect(x,y-headerHeight, Width,Height+headerHeight, 32);
        fill(54,255,255, transparency*0.3*roundedRectTransparency);
        noStroke();
        rect(x+headerWidth,y-headerHeight, Width-headerWidth,headerHeight); //an extra rectangle to fill in some empty white space beside the dragging tab
      }
      //header
      tint(255, 0.8*transparency);
      if(Width>headerWidth) image(grabTab_img, x,y-headerHeight+1, headerWidth,headerHeight); //normal-sized
      else image(grabTab_img, x,y-headerHeight+1, Width,headerHeight); //shrunk by necessity
      noTint();
      //body rectangle
      fill(54,80,255, 0.72*transparency);
      if((mouseOver_box(x,y-headerHeight, Width,headerHeight) && frontmostIconSetOverWhichMyMouseIs==this) || iconSetBeingDragged==this) cursorType = "MOVE";
      stroke(128, transparency);
      strokeWeight(2);
      rect(x,y, Width,Height);
      //"pipe" line
      if(expanded) {
        stroke(0, 0.8*transparency);
        line(x+fileIconPaddingXLeft/2,y+fileIconPaddingY+fileIconHeight/2, x+fileIconPaddingXLeft/2,y+Height);
      }
      //infoPanel!
      infoPanel.draw();
      //expandButton!
      expandButton.draw();
      //background iconSets drawn kind of grayed out
      if(id!=iconSet.size()-1 && !mouthOpen) {
        fill(0, 0.2*transparency);
        rect(x,y,Width,Height);
      }
      //fileIcons!
      for(int i=0; i<myFileIcon.size(); i++) {
        FileIcon tempFileIcon = (FileIcon) myFileIcon.get(i);
        if(tempFileIcon!=fileIconBeingDragged) {
          tempFileIcon.draw(); //don't draw fileIconBeingDragged-- it's being drawn after, on top of everything else
          tempFileIcon.math(); //don't draw fileIconBeingDragged-- it's being drawn after, on top of everything else
        }
        //lines that connect all the file icons (purely aesthetic)
        if(expanded) {
          if(fileIconBeingDragged!=null && (tempFileIcon==fileIconBeingDragged && tempFileIcon.myIconSet.myFileIcon.size()>1 && !mouseOver_box(x,y, Width,Height))  ||  (tempFileIcon==fileIconBeingDragged && mouseOver_box(iconDock.x,0, iconDock.Width,height))) stroke(0, 0.1*transparency);
          else stroke(0, 0.8*transparency);
          strokeWeight(2);
          line(x+fileIconPaddingXLeft/2,y+(fileIconPaddingY+fileIconHeight)*i+fileIconHeight/2+fileIconPaddingY, tempFileIcon.x,tempFileIcon.y+tempFileIcon.Height/2);
        }
      }
    }
    HACK_alreadyPerformedDraw = true;
  }

  Boolean mouseOver_wholeIconSet() {
    if(mouseOver_box(x,y-headerHeight, Width,Height+headerHeight) ||
      (infoPanel.expanded && mouseOver_box(infoPanel.x,infoPanel.y, infoPanel.Width,infoPanel.Height)) ||
      mouseOver_box(expandButton.x,expandButton.y, expandButton.Width,expandButton.Height) ||
      mouseOver_box(infoPanel.expandX,infoPanel.expandY, infoPanel.expandWidth,infoPanel.expandHeight) ||
      //mouseOver_box(x,y, Width,Height) ||
    mouseOver_box(infoPanel.optionsPanel.x,infoPanel.optionsPanel.y, infoPanel.optionsPanel.Width,infoPanel.optionsPanel.Height))
      return true;
    return false;
  }

  void roundRect(float x,float y, float w,float h, float r) {
    rectMode(CORNER);

    float ax, ay, hr;

    ax = x + w-1;
    ay = y + h-1;
    hr = r/2;

    arc(x,y, r,r, radians(180), radians(270));
    arc(ax,y, r,r, radians(270), radians(360));
    arc(x,ay, r,r, radians(90), radians(180));
    arc(ax,ay, r,r, radians(0), radians(90));
    line(x,y-hr, x+w,y-hr);
    line(x-hr,y, x-hr,y+h);
    line(x,y+h+hr, x+w,y+h+hr);
    line(x+w+hr,y, x+w+hr,y+h);
    noStroke();
    rect(x,y-hr, w,hr);
    rect(x-hr,y, hr,h);
    rect(x,y+h, w,hr);
    rect(x+w,y, hr,h);
    fill(255);
    //rect(x,y, w,h);
  } 

  void bringToFront() {
    iconSet.remove(this);
    iconSet.add(this);
  }

  void maybeRemoveMyself() { //this will remove me from the ArrayList if I've got no fileIcons.
    if(myFileIcon.size()==0) {
      for(int i=id+1; i<iconSet.size(); i++) {
        IconSet tempIconSet = (IconSet) iconSet.get(i);
        tempIconSet.id -= 1;
      }
      iconSet.remove(id);
    }
  }

  void setWidthAndHeight() {
    if(!mousePressed) mousedOverByIconSet = false; //I never really say this, so I'll just say it here
    if(expanded) {
      //WIDTH
      Width += ((fileIconWidth+fileIconPaddingXLeft+fileIconPaddingXRight)-Width)/4;
      //HEIGHT
      Height=0;
      for(int i=0; i<myFileIcon.size(); i++) {
        FileIcon tempFileIcon = (FileIcon) myFileIcon.get(i);
        Height+=tempFileIcon.Height+fileIconPaddingY;
      }
      Height += fileIconPaddingY;

      if(mousePressed && iconSetBeingDragged!=null && iconSetBeingDragged!=this) { //if we're dragging another iconSet
        IconSet tempIconSet = iconSetBeingDragged;

        //mousedOverByIconSet
        if(!mousedOverByIconSet) {
          if(mouseOver_box(x,y, Width,Height)) {
            mousedOverByIconSet = true;
            //SUPER HACK HACK HACKY HACKITY HACKVILLE. This prevents excessive glitching when adding an iconSet to an iconSet.
            iconSet.remove(this);
            iconSet.add(iconSet.size()-1, this);
            resetIconSetIds();
          }
        }
        else if(!mouseOver_box(x,y, Width,Height+tempIconSet.Height)) mousedOverByIconSet = false;

        if(mouthOpen) { //if we're over me with this iconSet, make my actual Height bigger.
          Height += tempIconSet.Height-fileIconPaddingY; //HACK-- THIS *4 REALLY DOESN'T BELONG HERE. IT'S JUST THERE JUST BECAUSE.
        }
      }
    }
    else {
      //WIDTH
      Width += ((fileIconMinimizedPaddingX+(fileIconMinimizedWidth+fileIconMinimizedPaddingX)*myFileIcon.size())-Width) / 4;
      //HEIGHT
      Height += (fileIconMinimizedHeight+16-Height)/4;
    }
    //mousedOverByFileIcon! (It's okay it's here, right?)
    mousedOverByFileIcon = false; //I'll say otherwise shortly
    if(fileIconBeingDragged!=null && fileIconBeingDragged.myIconSet!=this) { //if we're dragging a file icon, let's see if it's over me.
      if(mouseOver_box(x,y, Width,Height+fileIconBeingDragged.Height) && frontmostIconSetOverWhichMyMouseIs==this) { //and make sure I'm the frontmost iconSet. don't add to some guy BEHIND me.
        if(expanded) Height += fileIconBeingDragged.Height + fileIconPaddingY;
        mousedOverByFileIcon = true;
      }
    }
    //HACK - improper placement. This is an extra check that could be incorporated somewhere better.
    if(mousePressed && iconSetBeingDragged!=null && iconSetBeingDragged!=this) {
      if(mouseOver_box(x,y, Width,Height)) mousedOverByIconSet = true;
      else mousedOverByIconSet = false;
    }
  }

  void screenBoundaries() { //a little random and somewhat pointless...
    if(x<0) x=0;
    if(x>width) x=width-Width;
    if(y<0) y=0;
    if(y>height) y=height-Height;
  }

  void reset() {
    Width = fileIconWidth+fileIconPaddingXLeft+fileIconPaddingXRight;
    headerWidth  = 86;
    headerHeight = 22;
    transparency = 255;
    myFileIcon = new ArrayList();
    infoPanel = new InfoPanel(this);
  }


  class ExpandButton {
    float x,y;
    float xOffset,yOffset;
    float Width,Height;
    IconSet myIconSet;
    ExpandButton(IconSet MyIconSet) {
      myIconSet = MyIconSet;
      Width = 14;
      Height = 14;
      xOffset = -Width;
      yOffset = 0;
    }
    void draw() {
      //Math.
      x = myIconSet.x+xOffset;
      y = myIconSet.y+yOffset;
      if(mousePressed && fFWTMHBHD<2 && mouseOver_box(x,y, Width,Height) && frontmostIconSetOverWhichMyMouseIs==myIconSet) {
        myIconSet.expanded = !myIconSet.expanded;
        //myIconSet.bringToFront();
      }

      //Draw.
      if(mouseOver_box(x,y, Width,Height) && frontmostIconSetOverWhichMyMouseIs==myIconSet)
        fill(200, transparency);
      else
        fill(245, transparency);
      stroke(128, transparency);
      strokeWeight(1);
      rect(x,y, Width,Height);
      //plus or minus button
      fill(100, transparency);
      textAlign(CENTER, CENTER);
      textSize(Width);
      if(myIconSet.expanded) text("-", x,y, Width+1,Height+1);
      else text("+", x,y, Width+1,Height+1);
    }
  }



  class InfoPanel {
    boolean evenTabs;
    boolean expanded;
    boolean resizing;
    boolean HACKresetOnCreation = true;
    float x,y;
    float xOffset,yOffset;
    float Width,Height;
    float expandX,expandY;
    float expandWidth,expandHeight;
    float clickX,clickY; //where I clicked the mouse
    float graphScale; //How long the graph bars are.
    float savedGraphWidth,savedGraphHeight; //my Width and Height before I added another fileIcon; this is so I can put my Width and Height back to those values
    float transparency;
    GraphTab[] graphTab;
    Graph[] graph;
    SummaryPage summaryPage;
    BlockPieChart pieChart;
    TotalsList totalsList;
    IconSet myIconSet;
    int activeTab; //0 is Motion, 1 is Control, etc.
    int graphTabOver = -1; //-1 = over no graph tab
    OptionsPanel optionsPanel;
    ScaleSlider scaleSlider;
    InfoPanel(IconSet MyIconSet) {
      myIconSet = MyIconSet;
      Width = 680; //only do this here
      Height = 500;
      reset();
      //optionsPanel!
      optionsPanel = new OptionsPanel(this);
      //scaleSlider!
      scaleSlider = new ScaleSlider(this);
      //expand that sh8t!
      expanded = true;
    }
    void draw() {
      //Hack.
      if(HACKresetOnCreation) { //Yes. Hacktastic.
        analyzeSelectedFiles(myFileIcon); //if we're going to have expanded be true by default, we must analyze the data now
        HACKresetOnCreation = false;
      }

      //Math.
      if(activeTab>=graphTab.length) activeTab = 0;
      if(activeTab<0) activeTab = graphTab.length-1;
      transparency = myIconSet.transparency;
      x = myIconSet.x+xOffset;
      y = myIconSet.y+yOffset;
      expandX = x-expandWidth;
      if(myIconSet.expanded) expandY = myIconSet.y+myIconSet.Height-expandHeight;
      else expandY = myIconSet.y+myIconSet.Height;
      //resize!
      if(resizing || (expanded && mouseOver_circle(x+Width-6,y+Height-6, 12)) && (frontmostIconSetOverWhichMyMouseIs==null || frontmostIconSetOverWhichMyMouseIs==myIconSet)) {
        cursorType = "NW_RESIZE";
        if(mousePressed && fFWTMHBHD<2) {
          clickX = x-mouseX+Width;
          clickY = y-mouseY+Height;
          resizing = true;
        }
      }
      if(resizing) {
        Width  = mouseX-x+clickX;
        Height = mouseY-y+clickY;
        if(Width <optionsPanel.Width) Width = optionsPanel.Width;
        if(Height<100) Height = 100;
      }
      if(!mousePressed) resizing = false;
      if(mousePressed && fFWTMHBHD<2) {
        //ANALYZE EVERYTHING I HAVE (really? here?)
        if(mouseOver_box(expandX,expandY, expandWidth,expandHeight) && frontmostIconSetOverWhichMyMouseIs==myIconSet) {
          if(!expanded) {
            analyzeSelectedFiles(myFileIcon); //this is done both here and when we merge iconSets together
          }
          expanded = !expanded;
        }
      }
      xOffset = 0;
      yOffset = myIconSet.Height;

      //Draw.
      //note: I used to draw a Width/Height rectangle here. But the graphs kind of take care of that for me.
      //expand button
      if(mouseOver_box(expandX,expandY, expandWidth,expandHeight) && frontmostIconSetOverWhichMyMouseIs==myIconSet)
        fill(200, transparency);
      else
        fill(245, transparency);
      stroke(128, transparency);
      strokeWeight(1);
      rect(expandX,expandY, expandWidth,expandHeight);
      //plus or minus button
      fill(100, transparency);
      textAlign(CENTER, CENTER);
      textSize(expandWidth);
      if(expanded) text("-", expandX,expandY, expandWidth+1,expandHeight+1);
      else text("+", expandX,expandY, expandWidth+1,expandHeight+1);

      if(expanded) {
        if(graphTab[activeTab].id==summaryPageTab) {
          //summaryPage!
          summaryPage.draw();
        }
        else if(activeTab==pieChartTab) {
          //pieChart!
          pieChart.draw();
        }
        else if(graphTab[activeTab].id==totalsListTab) {
          //totalsList!
          totalsList.draw();
        }
        if(true) {//else
          //optionsPanel!
          optionsPanel.draw();
        }
        //graphs!
        for(int i=0; i<graph.length; i++) //note: only one graph will actually draw; it knows which one it is
          graph[i].draw();
        //graphTabs!
        for(int i=0; i<graphTab.length; i++)
          graphTab[i].draw();
        //scaleSlider!
        if(graphTab[activeTab].id!=summaryPageTab
          && graphTab[activeTab].id!=pieChartTab
          && graphTab[activeTab].id!=totalsListTab) scaleSlider.draw();
        //resize lines!
        stroke(0, 0.9*transparency);
        strokeWeight(0.6);
        line(x+Width-9,y+Height-3, x+Width-3,y+Height-9);
        line(x+Width-14,y+Height-3, x+Width-3,y+Height-14);
      }
    }
    void resetGraphs() {
      //graphs!
      graph = new Graph[0];
      if(totalBlockType[0]>0) {
        graph = (Graph[]) append(graph, new Graph(this, motionBlock,    motionBlock_img,    0, graph.length));
      }
      if(totalBlockType[1]>0) {
        graph = (Graph[]) append(graph, new Graph(this, controlBlock,   controlBlock_img,   1, graph.length));
      }
      if(totalBlockType[2]>0) {
        graph = (Graph[]) append(graph, new Graph(this, looksBlock,     looksBlock_img,     2, graph.length));
      }
      if(totalBlockType[3]>0) {
        graph = (Graph[]) append(graph, new Graph(this, sensingBlock,   sensingBlock_img,   3, graph.length));
      }
      if(totalBlockType[4]>0) {
        graph = (Graph[]) append(graph, new Graph(this, soundBlock,     soundBlock_img,     4, graph.length));
      }
      if(totalBlockType[5]>0) {
        graph = (Graph[]) append(graph, new Graph(this, operatorsBlock, operatorsBlock_img, 5, graph.length));
      }
      if(totalBlockType[6]>0) {
        graph = (Graph[]) append(graph, new Graph(this, penBlock,       penBlock_img,       6, graph.length));
      }
      if(totalBlockType[7]>0) {
        graph = (Graph[]) append(graph, new Graph(this, variableBlock, variableBlock_img,   7, graph.length));
      }
      if(graph.length==0) graph = (Graph[]) append(graph, new Graph(this, null,       null,       1, 1));
    }
    void reset() {
      expandWidth = 14;
      expandHeight = 14;
      //graphs!
      resetGraphs();
      //graphTabs!
      graphTab = new GraphTab[0];
      graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, summaryPageTab, graphTab.length)); //summary page tab!
      graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, pieChartTab, graphTab.length)); //pie-chart tab!
      if(totalBlockType[0]>0) {
        graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, 2, graphTab.length));
      }
      if(totalBlockType[1]>0) {
        graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, 3, graphTab.length));
      }
      if(totalBlockType[2]>0) {
        graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, 4, graphTab.length));
      }
      if(totalBlockType[3]>0) {
        graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, 5, graphTab.length));
      }
      if(totalBlockType[4]>0) {
        graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, 6, graphTab.length));
      }
      if(totalBlockType[5]>0) {
        graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, 7, graphTab.length));
      }
      if(totalBlockType[6]>0) {
        graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, 8, graphTab.length));
      }
      if(totalBlockType[7]>0) {
        graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, 9, graphTab.length));
      }
      graphTab = (GraphTab[]) append(graphTab, new GraphTab(this, totalsListTab, graphTab.length)); //totals tab!
      //summaryPage!
      summaryPage = new SummaryPage(this);
      //pieChart!
      pieChart = new BlockPieChart(this);
      //totalsList!
      totalsList = new TotalsList(this);
    }


    class SummaryPage {
      float x,y;
      float Width,Height;
      float allBlocksScrollX;
      float allBlocksScrollXLimit; //kind of a hack to make this into a variable
      float aBIX,aBIY, aBIWidth,aBIHeight; //allBlocksImageSomething
      PGraphics pg;
      PImage summaryPageImage; //the summaryPage is actually an image I save; it's less expensive and actually easier than drawing all that text every frame
      PImage allBlocksImage; //a separate image. this prevents the blocks spilling to the right by allowing scrolling.
      InfoPanel myInfoPanel;
      SummaryPage(InfoPanel MyInfoPanel) {
        myInfoPanel = MyInfoPanel;
        reset();
      }
      void draw() {
        if(myInfoPanel.expanded) {
          //Math.
          x = myInfoPanel.x;
          y = myInfoPanel.y+graphTab[0].Height;
          Width = myInfoPanel.Width;
          Height = myInfoPanel.Height-graphTab[0].Height;
          aBIX = x+Width*0.02;
          aBIY = y+Height*0.1;
          aBIWidth = Width*0.46;
          aBIHeight = Height*0.88;
          //DELETE
          if(mousePressed && mouseButton==RIGHT) allBlocksScrollX = mouseX;
          if(myIconSet==iconSet.get(0) && keyPressed) {
            if(keyCode==LEFT) allBlocksScrollX -= 6;
            if(keyCode==RIGHT) allBlocksScrollX += 6;
          }
          if(allBlocksScrollX>allBlocksScrollXLimit) allBlocksScrollX = allBlocksScrollXLimit;
          if(allBlocksScrollX<0) allBlocksScrollX = 0;

          //Draw.
          //placemat!
          fill(245, transparency);
          stroke(128, transparency);
          strokeWeight(1.5);
          rect(x,y, Width,Height);
          //summaryPageImage!
          if(summaryPageImage!=null) {
            tint(255, transparency);
            image(summaryPageImage, x,y, Width,Height);
            noTint();
          }
          //allBlocksImage!
          if(allBlocksImage!=null) {
            noFill();
            stroke(32, transparency*0.8);
            strokeWeight(2);
            rect(aBIX,aBIY, aBIWidth,aBIHeight);
            tint(255, transparency);
            //image(allBlocksImage.get(int(allBlocksScrollX),0, int(aBIWidth),int(aBIHeight)), aBIX,aBIY, aBIWidth,aBIHeight);
            image(allBlocksImage, aBIX,aBIY, aBIWidth,aBIHeight);
            noTint();
          }
        }
      }

      void reset() { //this is where we create the image that has all the totals in it and stuff
        pg = createGraphics(800,600, P2D);
        pg.colorMode(HSB); //<----WTF. SOMEONE PLEASE EXPLAIN TO ME WHY THIS DOES NOT DO THE WORKING THING DOESN'T WORK SAD FACE.  =(
        pg.beginDraw();
        pg.background(240);
        pg.textFont(myFont);
        //"Summary"
        pg.fill(0, 200);
        pg.textAlign(CENTER, TOP);
        pg.textSize(42);
        pg.text("Summary", 400,8);

        //everything else!
        int index = 0; //makes code involving text placement more flexible and easier to make changes to
        float hO = 12; //horizontalOffset
        float vO = 84; //verticalOffset
        float vS = 40; //verticalSpacing
        pg.fill(0, 160);
        pg.textAlign(LEFT, CENTER);
        pg.textSize(32);

        index = 0;
        hO = pg.width/2;
        pg.fill(0, 140);
        //variables
        if(variables!=null) pg.text("variables - "+variables.size(),  hO, vO+vS*index);
        index++;
        //lists
        if(lists!=null) pg.text("lists - "+lists.size(),  hO, vO+vS*index);
        index++;
        //sprites
        pg.text("sprites - "+sprites,  hO, vO+vS*index);
        index++;
        if(sprites!=0) {
          //unique costumes
          pg.text("avg. costumes - "+nf(float(unique_costumes)/float(sprites), 1,2),  hO, vO+vS*index);
          index++;
          //unique sounds
          pg.text("avg. sounds - "+nf(float(unique_sounds)/float(sprites), 1,2),  hO, vO+vS*index);
          index++;
        }

        //index = 0;
        //hO += 200;
        index++;
        //blocks
        pg.text("blocks - "+totalBlocks,  hO, vO+vS*index);
        index++;
        //stacks
        pg.text("stacks - "+stacks,  hO, vO+vS*index);
        index++;
        //avg. blocks per stack
        if(stacks!=0) pg.text("avg. blocks per stack - "+nf(float(totalBlocks)/float(stacks), 1,2),  hO, vO+vS*index);
        index++;
        pg.endDraw();
        summaryPageImage = pg;

        //allBlocksImage
        pg = createGraphics(8000,600, P2D); //HACK. We can't make the image bigger than 8000....
        pg.beginDraw();
        pg.background(250);
        if(nest!=null) {
          pg.stroke(255, 200);
          pg.strokeWeight(1);
          index = 0;
          hO = 10;
          vO = 10;
          float rHSc = 18; //rectangleHorizontalScale
          float rVS = 6; //rectangleVerticleSpacing
          float wBIPC = 1; //widestBlockInPreviousColumn
          for(int i=0; i<nest.length; i++) {
            if(codeBlockType[i]==15 || codeBlockType[i]==16 || codeBlockType[i]==17 || codeBlockType[i]==23) index++; //hat blocks = leave a gap.
            /*
            if(nest[i]==0) pg.fill(0, 200);
             else if(nest[i]==1)  pg.fill(50,150,200, 128);
             else if(nest[i]==2)  pg.fill(0,220,180, 128);
             else if(nest[i]==3)  pg.fill(120,255,0, 128);
             else if(nest[i]==4)  pg.fill(170,230,0, 128);
             else if(nest[i]==5)  pg.fill(230,220,0, 128);
             else if(nest[i]==6)  pg.fill(230,120,0, 128);
             else if(nest[i]==7)  pg.fill(230,40, 0, 128);
             else if(nest[i]==8)  pg.fill(255,0,  0, 128);
             else if(nest[i]==9)  pg.fill(255,0, 50, 128);
             else if(nest[i]==10) pg.fill(255,0,120, 128);
             else if(nest[i]==11) pg.fill(255,0,200, 128);
             else if(nest[i]==12) pg.fill(255,0,255, 128);
             */
            if(codeBlockType[i] <=14) pg.fill(blockColor[0]);
            else if(codeBlockType[i] <=30) pg.fill(blockColor[1]);
            else if(codeBlockType[i] <=50) pg.fill(blockColor[2]);
            else if(codeBlockType[i] <=67) pg.fill(blockColor[3]);
            else if(codeBlockType[i] <=80) pg.fill(blockColor[4]);
            else if(codeBlockType[i] <=108) pg.fill(blockColor[5]);
            else if(codeBlockType[i] <=119) pg.fill(blockColor[6]);
            else if(codeBlockType[i] <=130) pg.fill(blockColor[7]);
            else pg.fill(0);
            pg.rect(hO,vO+index*rVS, nest[i]*rHSc+rHSc,rVS);
            if(wBIPC<nest[i]) {
              wBIPC = nest[i];
            }
            if(vO+index*rVS>pg.height-vO/2-rVS*4) { //go back up to the top and scoot over to the right if I've ran out of room
              index = 0;
              hO += wBIPC*rHSc + 32;
              wBIPC = 0; //reset this one, too
            }
            index++;
          }
          allBlocksScrollXLimit = hO;
        }
        allBlocksImage = pg.get(0,0, int(hO)+100,pg.height);
      }
    }


    class TotalsList { /*NOTE: EVERYTHING IN THIS CLASS IS PRETTY MUCH TOTALLY HACKED. YOU HAVE BEEN WARNED.*/
      float x,y;
      float Width,Height;
      float varBoxX,varBoxY;
      float varBoxWidth,varBoxHeight;
      float varBoxXr = 0.5;
      float varBoxYr = 0.5; //where it says "variables", there will be this box behind it. Mousing over the box will showcase all the variable names.
      float varBoxWidthr,varBoxHeightr;
      float listBoxX,listBoxY;
      float listBoxWidth,listBoxHeight;
      float listBoxXr = 0.8;
      float listBoxYr = 0.5; //where it says "lists", there will be this box behind it. Mousing over the box will showcase all the list names.
      float listBoxWidthr,listBoxHeightr;
      PImage totalsListImage; //the totalsList is actually an image I save; it's less expensive and actually easier than drawing all that text every frame
      PImage varImage,listImage; //the images that list all the variable/list names.
      InfoPanel myInfoPanel;
      TotalsList(InfoPanel MyInfoPanel) {
        myInfoPanel = MyInfoPanel;
        Width = myInfoPanel.Width; //need to say these here first so we can accurately get values for varBox
        Height = myInfoPanel.Height-graphTab[0].Height;
        reset();
      }
      void draw() {
        if(myInfoPanel.expanded) {
          //Math.
          x = myInfoPanel.x;
          y = myInfoPanel.y+graphTab[0].Height;
          Width = myInfoPanel.Width;
          Height = myInfoPanel.Height-graphTab[0].Height;
          varBoxX = x + varBoxXr*Width;
          varBoxY = y + varBoxYr*Height;
          varBoxWidth  = varBoxWidthr  * Width;
          varBoxHeight = varBoxHeightr * Height;
          listBoxX = x + listBoxXr*Width;
          listBoxY = y + listBoxYr*Height;
          listBoxWidth  = listBoxWidthr  * Width;
          listBoxHeight = listBoxHeightr * Height;

          //Draw.
          //placemat!
          fill(245, transparency);
          stroke(128, transparency);
          strokeWeight(1.5);
          rect(x,y, Width,Height);

          tint(255, transparency);
          //totalsListImage!
          if(totalsListImage!=null) {
            image(totalsListImage, x,y, Width,Height);
          }
          //varImage!
          tint(255, 0.8*transparency);
          if(frontmostIconSetOverWhichMyMouseIs==myIconSet && !mousePressed && varImage!=null && mouseOver_box(varBoxX,varBoxY, varBoxWidth,varBoxHeight)) {
            image(varImage, varBoxX,varBoxY);
          }
          //listImage!
          tint(255, 0.8*transparency);
          if(frontmostIconSetOverWhichMyMouseIs==myIconSet && !mousePressed && listImage!=null && mouseOver_box(listBoxX,listBoxY, listBoxWidth,listBoxHeight)) {
            image(listImage, listBoxX,listBoxY);
          }
          noTint();
        }
      }

      void reset() { //this is where we create the image that has all the totals in it and stuff
        PGraphics pg = createGraphics(800,600, P2D);
        pg.beginDraw();
        pg.background(240);
        pg.textFont(myFont);
        //"Totals"
        pg.fill(0, 200);
        pg.textAlign(CENTER, TOP);
        pg.textSize(42);
        pg.text("Totals", 400,8);

        //everything else!
        int index = 0; //makes code involving text placement more flexible and easier to make changes to
        float hO = 12; //horizontalOffset
        float vO = 84; //verticalOffset
        float vS = 40; //verticalSpacing
        pg.fill(0, 160);
        pg.textAlign(LEFT, CENTER);
        pg.textSize(32);

        //author
        pg.text("author - "+author,  hO, vO+vS*index);
        index++;
        //version
        pg.text("version - "+version,  hO, vO+vS*index);
        index++;
        //times_saved
        pg.text("times saved - "+times_saved,  hO, vO+vS*index);
        index++;
        //times_shared
        pg.text("times shared - "+times_shared,  hO, vO+vS*index);
        index++;
        //previous_versions
        pg.text("previous versions - "+previous_versions,  hO, vO+vS*index);
        index++;
        //unique costumes
        pg.text("costumes - "+unique_costumes,  hO, vO+vS*index);
        index++;
        //unique sounds
        pg.text("sounds - "+unique_sounds,  hO, vO+vS*index);
        index++;

        index = 0;
        hO = 400;
        //sprites
        pg.text("sprites - "+sprites,  hO, vO+vS*index);
        index++;
        //blocks
        pg.text("blocks - "+totalBlocks,  hO, vO+vS*index);
        index++;
        //stacks
        pg.text("stacks - "+stacks,  hO, vO+vS*index);
        index++;
        //avg. blocks per stack
        if(stacks!=0) pg.text("avg. blocks per stack - "+nf(float(totalBlocks)/float(stacks), 1,2),  hO, vO+vS*index);
        index++;

        float vIdk = vO+vS*(index+1);
        //variables
        if(variables!=null) { //This is null when an iconSet is initially created because I reset one time before we set all the program's values.
          varBoxWidthr  = pg.textWidth("variables ("+variables.size()+")")+12;
          varBoxHeightr = 42;
          varBoxWidthr  /= pg.width;
          varBoxHeightr /= pg.height;
          if(variables.size()>0) {
            pg.fill(255, 220);
            pg.stroke(0, 200);
            pg.strokeWeight(1);
            pg.rectMode(CORNER);
            pg.rect(varBoxXr*pg.width,varBoxYr*pg.height, varBoxWidthr*pg.width,varBoxHeightr*pg.height);
          }
          pg.fill(0, 160);
          pg.text("variables ("+variables.size()+")",  varBoxXr*pg.width+8,varBoxYr*pg.height+16);

          String[] vars = new String[variables.size()];
          vars =(String[]) variables.keySet().toArray(vars);
          vars = sort(vars); //ALPHABETIZE
          int unitsHorz = 0;
          int unitsVert = 0;
          int maxVertVars = 20;
          do {
            if(unitsVert<maxVertVars)
              unitsVert++;
            else
              unitsHorz++;
          }
          while(unitsHorz*unitsVert<vars.length);
          //hack? check? I hardly know anymore.
          if(unitsVert>vars.length) unitsVert = vars.length;
          PGraphics ph = createGraphics(unitsHorz*200,unitsVert*24+12, P2D);
          ph.beginDraw();
          ph.background(250);
          ph.fill(0, 160);
          ph.textFont(myFont);
          ph.textSize(20);
          for(int i=0; i<unitsHorz; i++) {
            for(int j=0; j<unitsVert; j++) {
              if(i*maxVertVars+j<vars.length) {
                ph.text(vars[i*maxVertVars+j],  i*200+8,j*24+22);
              }
            }
          }
          index++;
          ph.noFill();
          ph.stroke(120,200,0, 160);
          ph.strokeWeight(4);
          ph.rect(0,0, ph.width,ph.height);
          ph.endDraw();
          varImage = ph;
        }
        pg.textSize(32);
        //lists!
        if(lists!=null) { //This is null when an iconSet is initially created because I reset one time before we set all the program's values.
          listBoxWidthr  = pg.textWidth("lists ("+lists.size()+")")+12;
          listBoxHeightr = 42;
          listBoxWidthr  /= pg.width;
          listBoxHeightr /= pg.height;
          if(lists.size()>0) {
            pg.fill(255, 220);
            pg.stroke(0, 200);
            pg.strokeWeight(1);
            pg.rectMode(CORNER);
            pg.rect(listBoxXr*pg.width,listBoxYr*pg.height, listBoxWidthr*pg.width,listBoxHeightr*pg.height);
          }
          pg.fill(0, 160);
          pg.text("lists ("+lists.size()+")",  listBoxXr*pg.width+8,listBoxYr*pg.height+16);

          String[] vars = new String[lists.size()];
          vars =(String[]) lists.keySet().toArray(vars);
          vars = sort(vars); //ALPHABETIZE
          int unitsHorz = 0;
          int unitsVert = 0;
          int maxVertVars = 20;
          do {
            if(unitsVert<maxVertVars)
              unitsVert++;
            else
              unitsHorz++;
          }
          while(unitsHorz*unitsVert<vars.length);
          //hack? check? I hardly know anymore.
          if(unitsVert>vars.length) unitsVert = vars.length;
          PGraphics ph = createGraphics(unitsHorz*200,unitsVert*24+12, P2D);
          ph.beginDraw();
          ph.background(250);
          ph.fill(0, 160);
          ph.textFont(myFont);
          ph.textSize(20);
          for(int i=0; i<unitsHorz; i++) {
            for(int j=0; j<unitsVert; j++) {
              if(i*maxVertVars+j<vars.length) {
                ph.text(vars[i*maxVertVars+j],  i*200+8,j*24+22);
              }
            }
          }
          index++;
          ph.noFill();
          ph.stroke(120,200,0, 160);
          ph.strokeWeight(4);
          ph.rect(0,0, ph.width,ph.height);
          ph.endDraw();
          listImage = ph;
        }
        pg.fill(0, 160);

        pg.endDraw();
        totalsListImage = pg;
      }
    }


    class OptionsPanel {
      float x,y;
      float xOffset,yOffset;
      float Width,Height;
      float TextSize = 16;
      boolean[] toggleBoxToggled = new boolean[3]; //toggleBoxes
      float[] toggleBoxX = new float[3]; //toggleBoxes
      float[] toggleBoxY = new float[3]; //toggleBoxes
      float[] toggleBoxWidth = new float[3]; //toggleBoxes
      float toggleBoxHeight; //toggleBoxes
      float toggleBoxBoxDiameter = 12; //the size of the physical toggle BOXES. Like, the checkboxes-boxes.
      float spacing = 8; //how much spacing between each toggleBox and the next one
      String[] toggleBoxText = {
        "Scale Snap", "Only Used Blocks", "Even Tabs",
      };
      InfoPanel myInfoPanel;
      OptionsPanel(InfoPanel MyInfoPanel) {
        myInfoPanel = MyInfoPanel;
        reset();
      }
      void draw() {
        //Math.
        x = myInfoPanel.x;
        y = myInfoPanel.y+myInfoPanel.Height;
        //TOGGLEBOXES
        for(int i=0; i<toggleBoxX.length; i++) {
          if(i==0) toggleBoxX[i] = x+spacing; //set each toggleBox's x
          else toggleBoxX[i] = toggleBoxX[i-1]+toggleBoxWidth[i-1]+spacing; //set each toggleBox's x
          toggleBoxY[i] = y+(Height-toggleBoxHeight)/2; //set each toggleBox's y
          if(mousePressed && fFWTMHBHD<2 && expanded && myInfoPanel.expanded && mouseOver_box(toggleBoxX[i],toggleBoxY[i], toggleBoxWidth[i],toggleBoxHeight) && frontmostIconSetOverWhichMyMouseIs==myInfoPanel.myIconSet) { //clicking on a toggleBox will toggle it
            toggleBoxToggled[i] = !toggleBoxToggled[i];
            //Special case-- 'Only Used Blocks' toggleBox does this graph-reset operation once, when it's toggled
            if(i==1) {
              infoPanel.resetGraphs();
            }
          }
        }
        //toggleBox's effects
        //Scale Snap
        if(toggleBoxToggled[0])
          myInfoPanel.graphScale = int(myInfoPanel.graphScale/scaleSlider.snapAmount)*scaleSlider.snapAmount;
        if(myInfoPanel.graphScale<1)
          myInfoPanel.graphScale = 1;
        //Even Tabs
        myInfoPanel.evenTabs = toggleBoxToggled[2];

        //Draw.
        //HACK - Note: a lot of the positioning, spacing, etc. for all of this is less flexible than you might expect. Mostly for aesthetics.
        if(myInfoPanel.expanded) {
          rectMode(CORNER);
          //placemat
          fill(245, transparency);
          stroke(128, transparency);
          strokeWeight(1);
          rect(x,y, Width,Height);
          //TOGGLEBOXES
          for(int i=0; i<toggleBoxX.length; i++) {
            //toggleBoxBox
            if(toggleBoxToggled[i]) { //toggled
              //base
              fill(64,80,120, transparency);
              noStroke();
              rect(toggleBoxX[i]+1,toggleBoxY[i]+1, toggleBoxBoxDiameter+0,toggleBoxBoxDiameter+0);
              //top
              fill(64,100,220, transparency);
              noStroke();
              rect(toggleBoxX[i]+3.5,toggleBoxY[i]+3.5, toggleBoxBoxDiameter-1.5,toggleBoxBoxDiameter-1.5);
              //outline again
              noFill();
              stroke(128, transparency);
              strokeWeight(1);
              rect(toggleBoxX[i]+1,toggleBoxY[i]+1, toggleBoxBoxDiameter+0,toggleBoxBoxDiameter+0);
            }
            else { //un-toggled
              //base
              fill(120, transparency);
              noStroke();
              rect(toggleBoxX[i]+1,toggleBoxY[i]+1, toggleBoxBoxDiameter+1,toggleBoxBoxDiameter+1);
              //top
              fill(230, transparency);
              stroke(80, transparency);
              strokeWeight(1);
              rect(toggleBoxX[i]+0,toggleBoxY[i]+0, toggleBoxBoxDiameter,toggleBoxBoxDiameter);
            }
            //text
            fill(64, transparency*0.8);
            textAlign(LEFT, CENTER);
            textSize(TextSize);
            text(toggleBoxText[i], toggleBoxX[i]+toggleBoxBoxDiameter+6,toggleBoxY[i], toggleBoxWidth[i],toggleBoxHeight);
            //moused-over a toggleBox gives it a highlight
            if(!mousePressed && mouseOver_box(toggleBoxX[i],toggleBoxY[i], toggleBoxWidth[i],toggleBoxHeight) && frontmostIconSetOverWhichMyMouseIs==myInfoPanel.myIconSet) {
              //text and box-box
              fill(255, 0.2*transparency);
              noStroke();
              //rect(toggleBoxX[i],toggleBoxY[i], toggleBoxWidth[i],toggleBoxHeight);
              //box-box
              fill(255, 0.5*transparency);
              stroke(64,120,255, 0.8*transparency);
              strokeWeight(1.5);
              noStroke();
              rect(toggleBoxX[i],toggleBoxY[i], toggleBoxBoxDiameter+3,toggleBoxBoxDiameter+3);
            }
          }
        }
      }
      void reset() {
        Height = 20;
        textSize(TextSize);
        for(int i=0; i<toggleBoxWidth.length; i++) toggleBoxWidth[i] = textWidth(toggleBoxText[i]) + toggleBoxBoxDiameter+spacing;
        toggleBoxHeight = 16;
        Width=0;
        toggleBoxToggled[1] = true; //yes. we would only like to see the blocks that were used (by default)
        for(int i=0; i<toggleBoxWidth.length; i++) Width += toggleBoxWidth[i] + toggleBoxBoxDiameter;
      }
    }


    class ScaleSlider {
      boolean sliding;
      float x,y;
      float xOffset,yOffset;
      float sliderX;
      float scaleSliderScale = 5;
      float Width,Height;
      float snapAmount = 4;
      InfoPanel myInfoPanel;
      ScaleSlider(InfoPanel MyInfoPanel) {
        myInfoPanel = MyInfoPanel;
        reset();
      }
      void draw() {
        //Math.
        x = myInfoPanel.x+xOffset;
        y = myInfoPanel.y+myInfoPanel.Height+yOffset;
        if(mouseOver_box(x,y, Width,Height) && frontmostIconSetOverWhichMyMouseIs==myIconSet) {
          if(mousePressed && fFWTMHBHD<2) {
            sliding = true;
          }
        }
        if(sliding) {
          if(myInfoPanel.optionsPanel.toggleBoxToggled[0])
            myInfoPanel.graphScale = (mouseX+snapAmount/2*scaleSliderScale-x)/scaleSliderScale;
          else
            myInfoPanel.graphScale = (mouseX-x)/scaleSliderScale;
        }
        if(!mousePressed) sliding = false;
        //set some limits, eh?
        if(myInfoPanel.graphScale<1)  myInfoPanel.graphScale = 1;
        if(myInfoPanel.graphScale>26) myInfoPanel.graphScale = 26;
        //quantize the scale slider if Scale Snap is toggled
        if(myInfoPanel.optionsPanel.toggleBoxToggled[0])
          sliderX = x + int(myInfoPanel.graphScale/snapAmount)*snapAmount*scaleSliderScale;
        else
          sliderX = x + myInfoPanel.graphScale*scaleSliderScale;

        //Draw.
        //border box
        fill(240, transparency);
        stroke(0, transparency);
        strokeWeight(1);
        rect(x,y, Width,Height);
        //triangle behind slider!
        fill(128, transparency);
        stroke(150, transparency);
        strokeWeight(1);
        triangle(x+4,y+Height-3, x+Width-10,y+Height-3, x+Width-10,y+3);
        //scale snap lines!
        if(myInfoPanel.optionsPanel.toggleBoxToggled[0]) stroke(0, 160);
        else stroke(0, 0.1*transparency);
        strokeWeight(1);
        for(int i=0; i<8; i++)
          line(x+scaleSliderScale*i*snapAmount,y+Height, x+scaleSliderScale*i*snapAmount,y+4);
        //slider!
        if(sliding || mouseOver_box(x,y, Width,Height))
          fill(120,80,220, transparency*0.8);
        else
          fill(80, transparency*0.5);
        stroke(0, transparency*0.5);
        beginShape();
        vertex(sliderX, y+3);
        vertex(sliderX-6, y+Height*0.5);
        vertex(sliderX-6, y+Height-3);
        vertex(sliderX+6, y+Height-3);
        vertex(sliderX+6, y+Height*0.5);
        vertex(sliderX, y+3);
        endShape();
      }
      void reset() {
        Width = 140;
        Height = 14;
        xOffset = 20;
        if(myInfoPanel.graph.length>0)
          yOffset = -myInfoPanel.graph[0].yPaddingBottom+(myInfoPanel.graph[0].yPaddingBottom-Height)/2;
      }
    }



    class BlockPieChart { //>>BlockPieChart
      color[] sliceFill = new color[8];
      color[] sliceStroke = new color[8];
      float x,y;
      float diameter;
      float motionSliceEnd,controlSliceEnd,looksSliceEnd,sensingSliceEnd,soundSliceEnd,operatorsSliceEnd,penSliceEnd,variablesSliceEnd;
      float[] sliceEnd = new float[8];
      String[] sliceText = new String[8];
      int mouseOverSlice = -1; //Which slice the mouse is over. If the mouse is not over the pie chart, this is -1.
      InfoPanel myInfoPanel;

      BlockPieChart(InfoPanel MyInfoPanel) {
        myInfoPanel = MyInfoPanel;
        for(int i=0; i<blockColor.length-1; i++) {
          sliceFill[i] = blockColor[i];
        }
        sliceStroke[0] = color(159,166,106);
        sliceStroke[1] = color( 29,217,115);
        sliceStroke[2] = color(187,158,114);
        sliceStroke[3] = color(142,250,110);
        sliceStroke[4] = color(210,168,109);
        sliceStroke[5] = color( 66,230,97);
        sliceStroke[6] = color(117,255,80);
        sliceStroke[7] = color(20, 214,122);
        sliceText[0] = "motion";
        sliceText[1] = "control";
        sliceText[2] = "looks";
        sliceText[3] = "sensing";
        sliceText[4] = "sound";
        sliceText[5] = "operators";
        sliceText[6] = "pen";
        sliceText[7] = "variables";

        reset();
      }

      void draw() {
        //Math.
        x = myInfoPanel.x+ Width/2;
        y = myInfoPanel.y+Height/2 + graphTab[0].Height/2;
        if(Width<Height) diameter = Width*0.9;
        else diameter = Height*0.9;
        if(frontmostIconSetOverWhichMyMouseIs==myIconSet && sqrt((x-mouseX)*(x-mouseX)+(y-mouseY)*(y-mouseY))<diameter/2) {
          float angle = atan2(y-mouseY,x-mouseX)+PI;
          if(     angle<sliceEnd[0]) mouseOverSlice = 0;
          else if(angle<sliceEnd[1]) mouseOverSlice = 1;
          else if(angle<sliceEnd[2]) mouseOverSlice = 2;
          else if(angle<sliceEnd[3]) mouseOverSlice = 3;
          else if(angle<sliceEnd[4]) mouseOverSlice = 4;
          else if(angle<sliceEnd[5]) mouseOverSlice = 5;
          else if(angle<sliceEnd[6]) mouseOverSlice = 6;
          else if(angle<sliceEnd[7]) mouseOverSlice = 7;
        }
        else
          mouseOverSlice = -1;
        //Clicking on a pie slice will take you to its corresponding graph tab.
        if(mouseOverSlice>=0 && mousePressed && fFWTMHBHD<2) {
          //myInfoPanel.activeTab = mouseOverSlice + 2; //NOTE/HACK: This +something must change depending on how many tabs are before the first block category tab.
        }

        //Draw.
        //placemat!
        fill(245, transparency);
        stroke(128, transparency);
        strokeWeight(1.5);
        rect(myInfoPanel.x,myInfoPanel.y+graphTab[0].Height, Width,Height-graphTab[0].Height);
        if(sliceEnd[0]==0&&sliceEnd[1]==0&&sliceEnd[2]==0&&sliceEnd[3]==0&&sliceEnd[4]==0&&sliceEnd[5]==0&&sliceEnd[6]==0&&sliceEnd[7]==0) { //If there are no blocks.
          noFill();
          stroke(0, 200);
          strokeWeight(2);
          ellipseMode(CENTER);
          ellipse(x,y, diameter,diameter);
        }
        else {
          //Slices!
          for(int i=0; i<sliceFill.length; i++) {
            float arcBegin = 0;
            if(i!=0) arcBegin = sliceEnd[i-1];
            if(mouseOverSlice==i) {
            }
            else {
              nonSelectedArc(sliceFill[i],sliceStroke[i], arcBegin,sliceEnd[i]);
            }
          }
          //selected slice is drawn after the others, okay?
          float arcBegin = 0;
          if(mouseOverSlice>0) arcBegin = sliceEnd[mouseOverSlice-1];
          //if(mousePressed && fFWTMHBHD<2) activeGraph = mouseOverSlice;
          if(mouseOverSlice>=0 && mouseOverSlice<8)
            selectedArc(   sliceFill[mouseOverSlice],sliceStroke[mouseOverSlice], arcBegin,sliceEnd[mouseOverSlice]);

          //Text on the pie slices!
          textAlign(RIGHT, BOTTOM);
          translate( x, y); //pushMatrix
          for(int i=0; i<sliceFill.length; i++) {
            rotate( sliceEnd[i]); //pushMatrix
            //make sure the text will fit in the slice
            float TextSize = diameter * 0.1;
            if(i==0) {
              if(sliceEnd[i]              <0.28)
                TextSize = (sliceEnd[i]              )*diameter*0.3 + 7;
            }
            else {
              if(sliceEnd[i]-sliceEnd[i-1]<0.28)
                TextSize = (sliceEnd[i]-sliceEnd[i-1])*diameter*0.3 + 7;
            }
            if(TextSize>diameter*0.04 && diameter>100) { //if it's too small, don't draw any text
              //PERCENT SIGN
              fill(255, 142);
              textSize(TextSize*0.6);
              text("%", diameter/2-6,0);
              text("%", diameter/2-6,0);
              float tempOffset1 = diameter/2-6 - textWidth("%");
              //PERCENT NUMBER
              fill(255, 200);
              String percString = float((int)(totalBlockType[i]/float(totalBlocks)*1000))/10 + "";
              textSize(TextSize);
              text(percString, tempOffset1,0);
              text(percString, tempOffset1,0);
              float tempOffset2 = tempOffset1-12 - textWidth(percString);
              //NAME
              fill(255, 80);
              textSize(TextSize*0.5);
              text(sliceText[i], tempOffset2,0);
              text(sliceText[i], tempOffset2,0);
            }
            rotate(-sliceEnd[i]); //popMatrix
          }
          translate(-x,-y); //popMatrix
          //VIGNETTE
          noFill();
          strokeWeight(1);
          ellipseMode(CENTER);
          for(int i=int(diameter*0.84); i<int(diameter); i++) {
            stroke(0, (i-diameter*0.84)/4 * transparency / 255);
            ellipse(x,y, i,i); //x+(i-diameter*0.8)/8-diameter*0.025,y+(i-diameter*0.8)/8-diameter*0.025
          }
        }
      }

      void selectedArc(color Fill,color Stroke, float sliceBegin,float sliceEnd) {
        //Slice shadow
        fill(0, transparency*0.1);
        noStroke();
        arc(x+6,y+4, diameter*1.02,diameter*1.02, sliceBegin-0.01,sliceEnd+0.01);
        //Regular slice
        fill(Fill, transparency);
        stroke(Stroke, transparency);
        arc(x,y, diameter*1.02,diameter*1.02, sliceBegin,sliceEnd);
        //Slice highlight
        fill(255, 32);
        //arc(x,y, diameter*1.02,diameter*1.02, sliceBegin,sliceEnd);
      }
      void nonSelectedArc(color Fill,color Stroke, float sliceBegin,float sliceEnd) {
        //Regular slice
        fill(Fill, transparency);
        stroke(Stroke, transparency);
        arc(x,y, diameter,diameter, sliceBegin,sliceEnd);
      }


      //HACK?? RIDICULOUS REPETITION OF CODE. TOTALLY UNNECCESSARY.
      PImage pgPie() {
        PGraphics pg = createGraphics(200,200, P2D);
        x = 100;
        y = 100;
        diameter = 200;
        pg.beginDraw();
        pg.smooth();
        //Pie slices!
        pg.background(color(0));
        pg.ellipseMode(CENTER);
        pg.noStroke();

        pg.fill(blockColor[0]);
        pg.arc(x,y, diameter,diameter, 0,sliceEnd[0]);
        pg.fill(blockColor[1]);
        pg.arc(x,y, diameter,diameter, sliceEnd[0],sliceEnd[1]);
        pg.fill(blockColor[2]);
        pg.arc(x,y, diameter,diameter, sliceEnd[1],sliceEnd[2]);
        pg.fill(blockColor[3]);
        pg.arc(x,y, diameter,diameter, sliceEnd[2],sliceEnd[3]);
        pg.fill(blockColor[4]);
        pg.arc(x,y, diameter,diameter, sliceEnd[3],sliceEnd[4]);
        pg.fill(blockColor[5]);
        pg.arc(x,y, diameter,diameter, sliceEnd[4],sliceEnd[5]);
        pg.fill(blockColor[6]);
        pg.arc(x,y, diameter,diameter, sliceEnd[5],sliceEnd[6]);
        pg.fill(blockColor[7]);
        pg.arc(x,y, diameter,diameter, sliceEnd[6],sliceEnd[7]);
        if(sliceEnd[0]==0&&sliceEnd[1]==0&&sliceEnd[2]==0&&sliceEnd[3]==0&&sliceEnd[4]==0&&sliceEnd[5]==0&&sliceEnd[6]==0&&sliceEnd[7]==0) { //If there are no blocks.
          pg.background(0);
          pg.fill(255, 160);
          pg.textAlign(CENTER, CENTER);
          pg.textSize(float(pg.width)*0.4);
          //pg.text("N/A", pg.width/2,pg.height/2);
        }
        pg.endDraw();
        return pg.get(0,0, pg.width,pg.height);
      }
      PImage pgMask() {
        PGraphics pg = createGraphics(200,200, P2D);
        pg.beginDraw();
        pg.smooth();
        pg.background(0);
        pg.fill(255);
        pg.noStroke();
        pg.ellipse(100,100, 200,200);
        if(sliceEnd[0]==0&&sliceEnd[1]==0&&sliceEnd[2]==0&&sliceEnd[3]==0&&sliceEnd[4]==0&&sliceEnd[5]==0&&sliceEnd[6]==0&&sliceEnd[7]==0) { //If there are no blocks.
          pg.fill(0);
          pg.ellipse(100,100, 194,194);
        }
        pg.endDraw();
        return pg.get(0,0, pg.width,pg.height);
      }

      void reset() {
        int tempTotalBlocks = 0; //HACK. for WHATEVER REASON, using totalBlocks here actually messes that value up hardcore
        for(int i=0; i<totalBlockType.length; i++) tempTotalBlocks += totalBlockType[i];
        if(tempTotalBlocks!=0) {
          sliceEnd[0] =               float(totalBlockType[0])/float(tempTotalBlocks)*TWO_PI;
          sliceEnd[1] = sliceEnd[0] + float(totalBlockType[1])/float(tempTotalBlocks)*TWO_PI;
          sliceEnd[2] = sliceEnd[1] + float(totalBlockType[2])/float(tempTotalBlocks)*TWO_PI;
          sliceEnd[3] = sliceEnd[2] + float(totalBlockType[3])/float(tempTotalBlocks)*TWO_PI;
          sliceEnd[4] = sliceEnd[3] + float(totalBlockType[4])/float(tempTotalBlocks)*TWO_PI;
          sliceEnd[5] = sliceEnd[4] + float(totalBlockType[5])/float(tempTotalBlocks)*TWO_PI;
          sliceEnd[6] = sliceEnd[5] + float(totalBlockType[6])/float(tempTotalBlocks)*TWO_PI;
          sliceEnd[7] = sliceEnd[6] + float(totalBlockType[7])/float(tempTotalBlocks)*TWO_PI;
        }
      }
    } //<<BlockPieChart


    class GraphTab {
      float x,y;
      float Width,Height;
      InfoPanel myInfoPanel;
      int id;
      int indexInTabArray; //this determines where the tab draws itself
      GraphTab(InfoPanel MyInfoPanel, int Id, int IndexInTabArray) {
        myInfoPanel = MyInfoPanel;
        id = Id;
        indexInTabArray = IndexInTabArray;
      }
      void draw() {
        //Math.
        //FIND A WAY NOT TO SET THESE 4 VALUES EVERY FRAME.
        if(indexInTabArray==0)
          x = myInfoPanel.x;
        else
          x = graphTab[indexInTabArray-1].x + graphTab[indexInTabArray-1].Width;
        //x = myInfoPanel.x;
        //for(int i=indexInTabArray; i>0; i--) x+=graphTab[i].Width; //set my x as the sum of the width's of every graph tab that precedes me
        y = myInfoPanel.y;
        float tWidth; //targetWidth. totally aesthetic.
        if(myInfoPanel.evenTabs || (myInfoPanel.graphTab.length==3)) {
          tWidth = myInfoPanel.Width/float(myInfoPanel.graphTab.length);
        }
        else {
          float tempWidth = myInfoPanel.Width * 3/float(myInfoPanel.graphTab.length);// //HACK (the 3)
          //PERSONALIZED HACKS FOR EVERYONE!!!! (YAYYYYYY CANDY)
          //if(myInfoPanel.graphTab.length==3) tempWidth -= 100;// SUPER HACK
          if(myInfoPanel.graphTab.length==4) tempWidth -= myInfoPanel.Width/2;// SUPER HACK
          else if(myInfoPanel.graphTab.length==5) tempWidth -= myInfoPanel.Width/5;// SUPER HACK
          else if(myInfoPanel.graphTab.length==6) tempWidth += myInfoPanel.Width*0;// SUPER HACK
          else if(myInfoPanel.graphTab.length==7) tempWidth += myInfoPanel.Width/float(7);// SUPER HACK
          else if(myInfoPanel.graphTab.length==8) tempWidth += myInfoPanel.Width/float(4);// SUPER HACK
          else if(myInfoPanel.graphTab.length==9) tempWidth += myInfoPanel.Width/float(3);// SUPER HACK
          else if(myInfoPanel.graphTab.length==10) tempWidth += myInfoPanel.Width/(2.5);// SUPER HACK
          else if(myInfoPanel.graphTab.length==11) tempWidth += myInfoPanel.Width/(2.2);// SUPER HACK
          tempWidth -= 5*myInfoPanel.graphTab.length; /*  communism step #1 of 2  */
          if(id==summaryPageTab || id==pieChartTab || id==totalsListTab) tWidth = myInfoPanel.Width/float(myInfoPanel.graphTab.length);
          else tWidth = float(totalBlockType[id-2])/float(totalBlocks) * tempWidth; //-2 = HACK; FIX!!!!!
          tWidth += 5; /*  communism step #2 of 2  */
          if(tWidth<8) tWidth = 8; //okay, let's just set that limit here. it's not the best way, but it's a decent insurance.
        }
        if(myInfoPanel.resizing)
          Width = tWidth;
        else
          Width += (tWidth-Width)/4; //....ah. so that's why we had targetWidth. (Really? Ehh, I'll allow it...)
        Height = 16;
        if(mousePressed && fFWTMHBHD<2 && mouseOver_box(x,y, Width,Height) && frontmostIconSetOverWhichMyMouseIs==myIconSet) {
          myInfoPanel.activeTab = indexInTabArray;
        }

        //Draw.
        float tG = 4; //tabGap //the extra spacing between tabs
        noStroke();
        if(id==summaryPageTab) { //summary page ONLY
          if(myInfoPanel.activeTab==indexInTabArray) //active tab fill
            fill(200, transparency);
          else //normal fill
          fill(200, transparency*1);
          if(myInfoPanel.activeTab==indexInTabArray)
            rect(x+tG/2,y, Width-tG,Height+11);
          else
            rect(x+tG/2,y, Width-tG,Height);
          //text!
          fill(64, transparency*0.8);
          textAlign(CENTER, CENTER);
          textSize(12);
          text("SUMMARY", x+Width/2,y+Height/2);
        }
        else if(id==pieChartTab) { //pie chart ONLY
          if(myInfoPanel.activeTab==indexInTabArray) //active tab fill
            fill(200, transparency);
          else //normal fill
          fill(200, transparency*1);
          if(myInfoPanel.activeTab==indexInTabArray)
            rect(x+tG/2,y, Width-tG,Height+11);
          else
            rect(x+tG/2,y, Width-tG,Height);
          //pieChartThumbnail!
          tint(255, transparency);
          image(pieChartThumbnail_img, x+Width/2-7,y+Height/2-7, 14,14);
          noTint();
        }
        else if(id==totalsListTab) { //totalsList ONLY
          if(myInfoPanel.activeTab==indexInTabArray) //active tab fill
            fill(200, transparency);
          else //normal fill
          fill(200, transparency*1);
          if(myInfoPanel.activeTab==indexInTabArray)
            rect(x+tG/2,y, Width-tG,Height+11);
          else
            rect(x+tG/2,y, Width-tG,Height);
          //text!
          fill(64, transparency*0.8);
          textAlign(CENTER, CENTER);
          textSize(12);
          text("TOTALS", x+Width/2,y+Height/2);
        }
        else { //for every tab that ISN'T the summaryPage, pieChart, or totalsList
          if(myInfoPanel.activeTab==indexInTabArray) //active tab fill
            fill(blockColor[id-2], transparency);
          else //normal fill
          fill(blockColor[id-2], transparency*1);
          if(myInfoPanel.activeTab==indexInTabArray)
            rect(x+tG/2,y, Width-tG,Height+11);
          else
            rect(x+tG/2,y, Width-tG,Height);
          if(myInfoPanel.evenTabs) {
            //text!
            fill(255, transparency);
            textAlign(CENTER, CENTER);
            textSize(12);
            text(totalBlockType[id-2], x+Width/2,y+Height/2);
          }
        }
        //tab border thingy!
        stroke(0, transparency*0.6);
        strokeWeight(1.2);
        line(x+tG/2,y+Height, x+tG/2,y);
        line(x+tG/2,y, x+Width-tG/2,y);
        line(x+Width-tG/2,y, x+Width-tG/2,y+Height);
        //mouseOver highlight
        if(mouseOver_box(x,y, Width,Height) && frontmostIconSetOverWhichMyMouseIs==myIconSet) {
          fill(255, transparency*0.4);
          noStroke();
          rect(x+tG/2,y, Width-tG,Height+11);
        }
      }
    }


    //***************************************
    class Graph {
      float x,y;
      float Width,Height;
      float bBW; //biggestBlockWidth. //In a perfect world, we wouldn't be setting this manually... but it's not a perfect world.
      float xPadding; //The gap between where the blocks are drawn and my actual x position.
      float yPaddingTop,yPaddingBottom;  //The gap between where the blocks are drawn and my actual y position.
      int graphType; //so we can tell the color of the graph bars and stuff
      int id;
      InfoPanel myInfoPanel;
      ArrayList row;
      Graph(InfoPanel MyInfoPanel, int[] BlockCount, PImage[] Block_img, int GraphType, int Id) {
        myInfoPanel = MyInfoPanel;
        graphType = GraphType;
        id = Id;
        if(BlockCount!=null && Block_img!=null) {
          row = new ArrayList();
          for(int i=0; i<BlockCount.length; i++) {
            if(infoPanel.optionsPanel.toggleBoxToggled[1]) {
              if(BlockCount[i]!=0) row.add(new Row(0,0, BlockCount[i],Block_img[i], blockColor[graphType], row.size(), this)); //HACK color correct? blockGraph.size()
            }
            else {
              row.add(new Row(0,0, BlockCount[i],Block_img[i], blockColor[graphType], row.size(), this)); //HACK color correct? blockGraph.size()
            }
          } //HACK PUT BACK IN
        }
        //one-time only reset
        bBW = 176;
        xPadding = 12;
        yPaddingTop = 12;
        yPaddingBottom = 20;
        Width = 600;
        Height = 480;
        x = 150;
        y = (height-Height)/2;
        //now the rest of reset
        reset();
      }

      void draw() {
        if(myInfoPanel.activeTab==id+2) {
          //Math.
          x = myInfoPanel.x;
          y = myInfoPanel.y+myInfoPanel.graphTab[id].Height;
          Width  = myInfoPanel.Width;
          Height = myInfoPanel.Height-myInfoPanel.graphTab[id].Height;

          //Draw.
          pushMatrix();
          translate(x,y);
          //Placemats.
          fill(245, transparency);
          stroke(128, transparency);
          strokeWeight(1.5);
          rect(0,0, Width,Height);
          fill(220, transparency);
          stroke(128, transparency);
          strokeWeight(1.5);
          rect(xPadding,yPaddingTop, Width-xPadding*2,Height-yPaddingTop-yPaddingBottom);

          //Graph elements!!
          //if(id==iconSet.size()-1) println(row.size());
          if(row==null) { //if we've got an empty graph...
            fill(0);
            textAlign(CENTER, CENTER);
            textSize(32);
            text("This program doesn't have any blocks. (Hint: try making a program that HAS blocks. Just a thought.)", x+Width/2,y+Height/2);
            rect(0,0, 200,200);
          }
          else {
            for(int i=0; i<row.size(); i++) {
              Row tempRow = (Row) row.get(i);
              tempRow.id = i;
              tempRow.draw();
            }
          }
          //Lines
          stroke(0, transparency);
          strokeWeight(1);
          for(int i=0; i<row.size()+1; i++) {
            float ypos = float(i)/row.size()*(Height-yPaddingTop-yPaddingBottom)+yPaddingTop; //just because we use this value more than once.
            line(xPadding,ypos, Width-xPadding,ypos); //horizontal lines
          }
          int horzLines = int((Width-xPadding*2-bBW)/graphScale) + 1;
          //pre-emptive fill for the numbers!
          fill(0, transparency*0.25);
          textAlign(CENTER, TOP);
          textSize(16);
          for(int i=0; i<horzLines; i++) {
            if(i%20==0) {
              text(i, xPadding+bBW+float(i)*graphScale,Height-yPaddingBottom+2);
              stroke(0, transparency*0.5);
              strokeWeight(3);
              line(xPadding+bBW+float(i)*graphScale,yPaddingTop, xPadding+bBW+float(i)*graphScale,Height-yPaddingBottom); //vertical lines
            }
            else if(i%10==0) {
              if(graphScale>3.2) {
                text(i, xPadding+bBW+float(i)*graphScale,Height-yPaddingBottom+2);
              }
              stroke(0, transparency*0.25);
              strokeWeight(2);
              line(xPadding+bBW+float(i)*graphScale,yPaddingTop, xPadding+bBW+float(i)*graphScale,Height-yPaddingBottom); //vertical lines
            }
            else if(i%5==0) {
              if(graphScale>6) {
                text(i, xPadding+bBW+float(i)*graphScale,Height-yPaddingBottom+2);
              }
              stroke(0, transparency*0.25);
              strokeWeight(2);
              line(xPadding+bBW+float(i)*graphScale,yPaddingTop, xPadding+bBW+float(i)*graphScale,Height-yPaddingBottom); //vertical lines
            }
            else if(horzLines<40 || i%5==0) {
              stroke(0, transparency*0.12);
              strokeWeight(1);
              line(xPadding+bBW+float(i)*graphScale,yPaddingTop, xPadding+bBW+float(i)*graphScale,Height-yPaddingBottom); //vertical lines
            }
            //if(horzLines<40 || i%10==0)
          }
          //Right-side-of-the-graph shadow effect!
          fill(0, transparency*0.075);
          noStroke();
          for(int i=0; i<8; i++) {
            rect(Width-xPadding,yPaddingTop, -i*i/2,Height-yPaddingBottom-yPaddingTop);
            //rect(xPadding,Height-yPadding, Width-xPadding*2,-i*4);
          }
          popMatrix();
        }
      }
      Boolean mouseOver_me() {
        if(mouseOver_box(x,y, Width,Height))
          return true;
        return false;
      }
      void reset() {
        graphScale =(float) (Width-xPadding-bBW)/maximumBlockCount;
        //println(graphScale);
        if(graphScale>100) graphScale = 100; //Set a limit to graphScale. So having 1 of each block doesn't look like a million.
      }


      class Row {
        boolean loose; //This indicates whether this row will appear where it exists. (As opposed to me dragging it somewhere)
        boolean returningToOriginalGraph; //self-explanatory
        color myColor;
        float x,y;
        float xDisp,yDisp;
        float Height;
        float imageWidth,imageHeight;
        float clickOffsetX,clickOffsetY;
        int myBlockCount;
        int id;
        PImage myBlockImage;
        Graph myGraph;

        Row(float X,float Y, int MyBlockCount, PImage MyBlockImage, color MyColor, int Id, Graph MyGraph) {
          x = X;
          y = Y;
          myBlockCount = MyBlockCount;
          myBlockImage = MyBlockImage;
          myColor = MyColor;
          //id = Id; //Damn it! These have to be set dynamically in the program. (Ugh!)
          myGraph = MyGraph;
        }

        void draw() {
          //Math
          x = myGraph.xPadding;
          y = float(id)/myGraph.row.size()*(myGraph.Height-yPaddingBottom-yPaddingTop)+yPaddingTop; //just because we use this value more than once.
          Height = (myGraph.Height-yPaddingBottom-yPaddingTop)/myGraph.row.size();
          if(loose) {
            if((mousePressed && mouseOver_me()) || blockBeingDragged==this) {
              xDisp = mouseX-myGraph.x+clickOffsetX;
              yDisp = mouseY-myGraph.y+clickOffsetY;
              //blockBeingDragged = this;
              returningToOriginalGraph = false;
            }
            else if(graphTabOver==-1 || myGraph.mouseOver_me() || returningToOriginalGraph) { //(see note on next line)
              /*NOTE: the returningToOriginalGraph element of this else-if statement isn't perfect. It just kind of works. The only 'glitch' is that you can let go of a block, and if you immediately
               mouse-over another graph, even though you're not holding the block, it will get added to that graph. It's like a one- or two-frame difference, so I don't really mind it..*/
              returningToOriginalGraph = true;
              xDisp += (x-xDisp)/4;
              yDisp += (y-yDisp)/4;
              if(abs(xDisp-x)<0.5 && abs(yDisp-y)<0.5) loose = false;
            }
            else if(!returningToOriginalGraph) { //as long as I didn't let it go NOT on a graph
              //Add this block to that graph!
              loose = false;
              myInfoPanel.graph[graphTabOver].row.add(new Row(x,y, myBlockCount, myBlockImage, myColor, id, graph[graphTabOver]));
              if(!keyPressed && keyCode!=CONTROL) myGraph.row.remove(id);
            }
          }
          else {
            xDisp = x;
            yDisp = y;
            returningToOriginalGraph = false;
          }

          //Draw
          //THIS IS REALLY POORLY DONE; I JUST COPIED AND PASTED IT FROM WHERE IT USED TO BE. FIX IT UP/STREAMLINE IT. THANKS.
          //"I'm being dragged/am addable to something! Draw that green ellipse thing."
          if(blockBeingDragged==this && !myGraph.mouseOver_me()/* && graph[graphTabOver]==-1*/) { //if I'm dragging a block somewhere AND over a graph it DIDN'T come from...
            fill(54,255,255, transparency*0.25);
            stroke(54,255,180, transparency*0.25);
            strokeWeight(2);
            ellipseMode(CORNER);
            ellipse(xDisp-16,yDisp-16, myBlockImage.width+32,myBlockImage.height+32);
            ellipseMode(CENTER); //put back down the toilet seat
          }
          //Images
          if((mouseOver_me() && blockBeingDragged==null)  ||  (blockBeingDragged==this)) {
            if(mousePressed && fFWTMHBHD<2) {
              //loose = true;
              clickOffsetX = (myGraph.x+x)-mouseX;
              clickOffsetY = (myGraph.y+y)-mouseY;
            }
            //tint(255, 200);
            //cursorType = "HAND";
          }
          if(myBlockImage!=null) {
            if(Height<myBlockImage.height) {
              imageHeight = Height;
              imageWidth = myBlockImage.width*imageHeight/myBlockImage.height;
            }
            else {
              imageHeight = myBlockImage.height;
              imageWidth = myBlockImage.width;
            }
            tint(255, transparency);
            image(myBlockImage, xDisp,yDisp-(imageHeight)/2 + Height/2, imageWidth,imageHeight);
            noTint();
          }
          //Rectangles
          rectMode(CORNER);
          fill(myColor, transparency*0.9);
          noStroke();
          float rectWidth = float(myBlockCount)*graphScale;
          if(rectWidth>myGraph.Width-bBW-myGraph.xPadding*2) rectWidth = myGraph.Width-bBW-myGraph.xPadding*2;
          rect(x+bBW,y+2, rectWidth,Height-3);
          //Text
          fill(0, transparency*0.8);
          textAlign(LEFT, CENTER);
          textSize(24);
          if(myBlockCount!=0 && rectWidth<myGraph.Width-bBW-myGraph.xPadding*2)
            text(myBlockCount, xPadding+bBW+float(myBlockCount)*graphScale,y+Height/2);
        }
        Boolean mouseOver_me() {
          if(mouseOver_box(myGraph.x+x,myGraph.y+y, myBlockImage.width,Height))
            return true;
          return false;
        }
      }
    }
    //***************************************
  } //<<  InfoPanel  <<



  //void_addToAllValues
  import java.util.regex.*;


  /*NOTE: THIS ISN'T THE MOST PROCESSING-EFFICIENT WAY. HOWEVER, IT IS THE MOST FLEXIBLE: THE TEXT FILE MAY CHANGE IN SLIGHT DEGREES AND MY EXCESSIVE REPETITION OF FOR-LOOPS WILL COMPENSATE.*/
  void addToAllValues(File myFile) {
    if(true) {
      //NOT tidied with Chris's filter
      String[] wholeFile = loadStrings(myFile);

      //author
      for(int i=0; i<wholeFile.length; i++) {
        if(wholeFile[i].indexOf("Author:")>=0) { //Look through until we find "Author:".
          author = wholeFile[i].substring(7);
        }
      }

      //version
      for(int i=0; i<wholeFile.length; i++) {
        if(wholeFile[i].indexOf("Version:")>=0 || wholeFile[i].indexOf("Scratch:")>=0) { //Look through until we find "Version:" OR "Scratch:".
          version = wholeFile[i].substring(8);
          if(version.indexOf("(")>=0)
            version = version.substring(0,version.indexOf("(")); //cut out the crap after the number
        }
      }

      //previous_versions.
      for(int i=2; i<wholeFile.length; i++) {
        if(wholeFile[i].indexOf("History:")>=0) { //Look through until we find "History:".
          String previousVersion = ""; //start it off empty
          for(int j=i; j<wholeFile.length; j++) {
            if(wholeFile[j].indexOf("save")>=0 && match(previousVersion, wholeFile[j].substring(wholeFile[j].indexOf("save")))==null) { //find "save"
              previousVersion = wholeFile[j].substring(wholeFile[j].indexOf("save")); /*if this version name is different than our String previousVersion-- which is the previous version-- update previousVersion and increment previous_versions.*/
              previous_versions ++;
            }
            if(wholeFile[j].indexOf("Totals:")>=0) { //...until we see "Totals:".
              break;
            }
          }
          break;
        }
      }

      //times_saved and times_shared.
      for(int i=2; i<wholeFile.length; i++) {
        if(wholeFile[i].indexOf("History:")>=0) { //Look through until we find "History:".
          for(int j=i; j<wholeFile.length; j++) {
            if(wholeFile[j].indexOf("save")>=0) //Add to times_saved every time we see "save"...
              times_saved ++;
            if(wholeFile[j].indexOf("share")>=0) //Add to times_shared every time we see "share"...
              times_shared ++;
            if(wholeFile[j].indexOf("Totals:")>=0) { //...until we see "Totals:".
              //Totals = j;
              break;
            }
          }
          break;
        }
      }
      Totals = 0; //SUPER HACK. I honestly have no idea why Totals affects everything else's count.

      for(int i=0; i<wholeFile.length; i++) { //note: we're starting this search at where we've deduced the line "Totals:" is.
        //sprites
        if(wholeFile[i].indexOf("Sprites: ")>=0) { //Search through until we find "Sprites: ".
          String myString = wholeFile[i].substring(wholeFile[i].indexOf("Sprites: ") + 9);
          sprites += int(myString);
        }
        //stacks
        if(wholeFile[i].indexOf("Stacks: ")>=0) { //Search through until we find "Stacks: ".
          String myString = wholeFile[i].substring(wholeFile[i].indexOf("Stacks: ") + 8);
          stacks += int(myString);
        }
        //unique_costumes
        if(wholeFile[i].indexOf("Unique costumes: ")>=0) { //Search through until we find "Unique costumes: ".
          String myString = wholeFile[i].substring(wholeFile[i].indexOf("Unique costumes: ") + 17);
          unique_costumes += int(myString);
        }
        //unique_sounds
        if(wholeFile[i].indexOf("Unique sounds: ")>=0) { //Search through until we find "Unique sounds: ".
          String myString = wholeFile[i].substring(wholeFile[i].indexOf("Unique sounds: ") + 15);
          unique_sounds += int(myString);
        }
      }
    }

    //TIDIED with Chris's filter
    String fileString = join(loadStrings(myFile),"\n");
    String [] wholeFile = new String[0];
    try {
      wholeFile = split(fileString.replaceAll("turn  ","turn ").replaceAll("[ ]*\n","").replaceAll("(Project:(.)*Unique[^-]*)|(--------Sprite:[^:]*:[^:]*:([^:]*:[0-9][0-9]:[^:]*)*?[^:]*((Stacks[^:]*:)|(No stacks.)))|([ ]+end)","").replaceAll("--------","").replaceAll("\\b  ","&  ").replaceAll("%  ","%&  ").replaceAll("\\)  ","\\)&  ").replaceAll("\\]  ","\\]&  ").replaceAll("\"  ","\"&  ").replaceAll("    "," ").replaceAll("&","\n").replaceAll("\n ","\n").substring(1),"\n");
      //println(wholeFile);
    }
    catch(Exception e) {
      println("There aren't any blocks in the program " + myFile + ".");
    }
    if(match(version, "1.4")!=null) {
    }
    else {
      //println("This file is the wrong version and might not be analyzed accurately. To analyze this program properly, you must make its text file with Scratch 1.4.");
    }

    //GARBAGE CLEANING (thanks, Chris)
    wholeFile = removeGarbageCode(wholeFile);

    //NESTING
    for(int i=0; i<wholeFile.length; i++) {
      if(match(wholeFile[i], "[\\s]*")!=null) {
        String tempString = match(wholeFile[i], "[\\s]*")[0];
        //println(tempString.length() + "    " + wholeFile[i]);
        nest = (int[]) append(nest, tempString.length());
      }
    }
    /*
      for(int i=0; i<nest.length; i++) {
     println();
     for(int j=0; j<nest[i].length; j++)
     println(nest[i][j]);
     }
     */

    //NEW
    codeBlockType = (int[]) expand(codeBlockType, wholeFile.length+codeBlockTypeOffsetHACK); //HACK - why does adding codeBlockTypeOffsetHACK *here* work?...

    //BLOCKS
    int bt = 0; //block type (...that's what "bt" means... right?)
    //Motion    - blue
    motionBlock[0]  += specialCount(" move [\\S\\s]* steps", wholeFile, bt++);
    motionBlock[1]  += specialCount(" turn[\\S\\s]*degrees", wholeFile, bt++);
    motionBlock[2]  += basicCount(" point in direction", wholeFile, bt++);
    motionBlock[3]  += basicCount(" point towards ", wholeFile, bt++);
    motionBlock[4]  += basicCount(" go to x:", wholeFile, bt++);
    motionBlock[5]  += basicCount(" go to s", wholeFile, bt) + basicCount(" go to mouse", wholeFile, bt++);
    motionBlock[6]  += basicCount(" glide", wholeFile, bt++);
    motionBlock[7]  += basicCount(" change x by ", wholeFile, bt++);
    motionBlock[8]  += basicCount(" set x to ", wholeFile, bt++);
    motionBlock[9]  += basicCount(" change y by ", wholeFile, bt++);
    motionBlock[10] += basicCount(" set y to ", wholeFile, bt++);
    int if_edge = basicCount(" if on edge, bounce", wholeFile, bt++);
    motionBlock[11] += if_edge;
    motionBlock[12] += basicCount("(x position", wholeFile, bt++); //FIX
    motionBlock[13] += basicCount("(y position", wholeFile, bt++); //FIX
    motionBlock[14] += basicCount("(direction", wholeFile, bt++);

    //Control
    controlBlock[0]  +=  basicCount("when green flag clicked", wholeFile, bt++);
    controlBlock[1]  +=  specialCount("when [\\S\\s]* key pressed", wholeFile, bt++);
    controlBlock[2]  +=  selectiveCount("when [\\S\\s]* clicked", "green flag", wholeFile, bt++);
    controlBlock[3]  +=  specialCount(" wait [\\S\\s]* secs", wholeFile, bt++);
    controlBlock[4]  +=  basicCount(" forever", wholeFile, bt++);
    controlBlock[5]  +=  specialCount(" repeat [^u]", wholeFile, bt++);
    controlBlock[6]  +=  specialCount(" broadcast \"[^\"]*\"$", wholeFile, bt++);
    controlBlock[7]  +=  specialCount(" broadcast \"[\\S\\s]*\" and wait", wholeFile, bt++);
    controlBlock[8]  +=  basicCount("when I receive ", wholeFile, bt++);
    int forever_if = basicCount(" forever if", wholeFile, bt++);
    controlBlock[9]  += forever_if;
    controlBlock[10] += basicCount(" if", wholeFile, bt++);
    int if_else = specialCount(" if [\\S\\s]* else", wholeFile, bt++);
    controlBlock[11] += if_else;
    controlBlock[12] += basicCount(" wait until", wholeFile, bt++);
    controlBlock[13] += basicCount(" repeat until", wholeFile, bt++);
    controlBlock[14] += basicCount(" stop script", wholeFile, bt++);
    controlBlock[15] += specialCount(" stop all$", wholeFile, bt++);
    //**RECOVERY**
    controlBlock[4]  -= forever_if;  //forever -= forever_if; 
    /*Because we don't search for "if else" blocks but must search for "if[\\S\\s]else" alone, we will receive EVERY "if", not just the ones without the "else". Thus, subtract "if"s by how many "else"s we found. ALSO APPLIES TO "FOREVER IF".*/
    controlBlock[10] -= if_else + forever_if + if_edge;  //If -= if_else + forever_if + if_on_edge_bounce; //Be careful. Make sure we're subtracting only and everything of what we need.

    //Looks     - purple
    looksBlock[0]  += basicCount(" switch to background", wholeFile, bt++);
    looksBlock[1]  += basicCount(" next background", wholeFile, bt++);
    looksBlock[2]  += basicCount("(background #", wholeFile, bt++);
    looksBlock[3]  += basicCount(" switch to costume", wholeFile, bt++);
    looksBlock[4]  += basicCount(" next costume", wholeFile, bt++);
    looksBlock[5]  += basicCount("(costume #", wholeFile, bt++);
    looksBlock[6]  += specialCount(" say [\\S\\s]* for [\\S\\s]* secs", wholeFile, bt++);
    //variableException += append(variableException, //PLEASE ADD THINGS THAT ARE SAID TO THE LIST OF VARIABLE EXCEPTIONS.
    looksBlock[7]  += specialCount(" say [\\S\\s]* [^f][^o][^r]", wholeFile, bt++);
    looksBlock[8]  += specialCount(" think [\\S\\s]* for [\\S\\s]* secs", wholeFile, bt++);
    looksBlock[9]  += specialCount(" think [\\S\\s]* [^f][^o][^r]", wholeFile, bt++);
    looksBlock[10] += specialCount(" change [\\S\\s]* effect by ", wholeFile, bt++);
    looksBlock[11] += specialCount(" set [\\S\\s]* effect to ", wholeFile, bt++);
    int clear_graphics = basicCount(" clear graphic effects", wholeFile, bt++);
    looksBlock[12] += clear_graphics;
    looksBlock[13] += basicCount(" change size by", wholeFile, bt++);
    looksBlock[14] += basicCount(" set size to", wholeFile, bt++);
    looksBlock[15] += basicCount("(size", wholeFile, bt++);
    //Size is recovered after pen.
    //show and hide are recovered after Variables
    looksBlock[16] += basicCount(" show", wholeFile, bt++);
    looksBlock[17] += basicCount(" hide", wholeFile, bt++);
    looksBlock[18] += basicCount(" go to front", wholeFile, bt++);
    looksBlock[19] += specialCount(" go back [\\S\\s]* layers", wholeFile, bt++);

    //Sensing   - teal
    sensingBlock[0]  += basicCount("(touching s", wholeFile, bt) + basicCount("(touching mouse", wholeFile, bt++);
    sensingBlock[1]  += basicCount("(touching color c[", wholeFile, bt++);
    sensingBlock[2]  += specialCount("\\(color [\\S\\s]* is touching c", wholeFile, bt++); //\\[[\\S\\s]*\\]
    sensingBlock[3]  += specialCount(" ask [\\S\\s]* and wait", wholeFile, bt++);
    sensingBlock[4]  += basicCount("(answer", wholeFile, bt++);
    sensingBlock[5]  += basicCount("(mouse x", wholeFile, bt++);
    sensingBlock[6]  += basicCount("(mouse y", wholeFile, bt++);
    sensingBlock[7]  += basicCount("(mouse down", wholeFile, bt++);
    sensingBlock[8]  += specialCount("\\(key [\\S\\s]* pressed", wholeFile, bt++);
    sensingBlock[9]  += basicCount("(distance to s[", wholeFile, bt) + basicCount("(distance to mouse", wholeFile, bt++);
    sensingBlock[10] += basicCount(" reset timer", wholeFile, bt++);
    sensingBlock[11] += basicCount("(timer", wholeFile, bt++);
    sensingBlock[12] += specialCount("\"[\\S\\s]*\" of s", wholeFile, bt) + specialCount("\"[\\S\\s]*\" of mouse", wholeFile, bt++);
    sensingBlock[13] += basicCount("(loudness", wholeFile, bt++);
    sensingBlock[14] += basicCount("(loud?", wholeFile, bt++);
    sensingBlock[15] += specialCount("\"[\\S\\s]*\" sensor value", wholeFile, bt++);
    sensingBlock[16] += specialCount("\\(sensor \"[\\S\\s]*\"?", wholeFile, bt++);

    //Sound     - pink
    soundBlock[0]  += specialCount(" play sound \"[\\S\\s]*\"", wholeFile, bt++);
    int play_done = specialCount(" play sound \"[\\S\\s]*\" until done", wholeFile, bt++);
    soundBlock[1]  += play_done;
    soundBlock[2]  += basicCount(" stop all sounds", wholeFile, bt++);
    soundBlock[3]  += specialCount(" play drum [\\S\\s]* for [\\S\\s]*", wholeFile, bt++);
    soundBlock[4]  += specialCount(" rest for [\\S\\s]* beats", wholeFile, bt++);
    soundBlock[5]  += specialCount(" play note [\\S\\s]* for [\\S\\s]* beats", wholeFile, bt++);
    soundBlock[6]  += basicCount(" set instrument to ", wholeFile, bt++);
    soundBlock[7]  += basicCount(" change volume by ", wholeFile, bt++);
    soundBlock[8]  += specialCount(" set volume to [\\S\\s]*%", wholeFile, bt++);
    soundBlock[9]  += basicCount("(volume", wholeFile, bt++);
    soundBlock[10] += basicCount(" change tempo by ", wholeFile, bt++);
    soundBlock[11] += specialCount(" set tempo to [\\S\\s]* bpm", wholeFile, bt++);
    soundBlock[12] += basicCount("(tempo", wholeFile, bt++);
    //**Recovery.**
    soundBlock[0] -= play_done;  //play_sound_X -= play_sound_X_until_done;

    //Operators   - lime-green
    operatorsBlock[0]  += basicCount(" + ", wholeFile, bt++);
    operatorsBlock[1]  += basicCount(" - ", wholeFile, bt++);
    operatorsBlock[2]  += basicCount(" * ", wholeFile, bt++);
    operatorsBlock[3]  += basicCount(" / ", wholeFile, bt++);
    operatorsBlock[4]  += specialCount("\\(pick random [\\S\\s]* to [\\S\\s]*", wholeFile, bt++);
    operatorsBlock[5]  += basicCount(" < ", wholeFile, bt++);
    operatorsBlock[6]  += basicCount(" = ", wholeFile, bt++);
    operatorsBlock[7]  += basicCount(" > ", wholeFile, bt++);
    operatorsBlock[8]  += basicCount(") and (", wholeFile, bt++);
    operatorsBlock[9]  += basicCount(") or (", wholeFile, bt++);
    operatorsBlock[10] += basicCount("(not (", wholeFile, bt++);
    operatorsBlock[11] += basicCount("(join ", wholeFile, bt++);
    operatorsBlock[12] += specialCount("\\(letter [\\S\\s]* of [\\S\\s]*", wholeFile, bt++);
    operatorsBlock[13] += basicCount("(length of", wholeFile, bt++);
    operatorsBlock[14] += basicCount(") mod (", wholeFile, bt++);
    operatorsBlock[15] += basicCount("(round ", wholeFile, bt++);
    operatorsBlock[16] += basicCount("\"abs\"", wholeFile, bt++);
    operatorsBlock[17] += basicCount("\"sqrt\"", wholeFile, bt++);
    operatorsBlock[18] += basicCount("\"sin\"", wholeFile, bt++);
    operatorsBlock[19] += basicCount("\"cos\"", wholeFile, bt++);
    operatorsBlock[20] += basicCount("\"tan\"", wholeFile, bt++);
    operatorsBlock[21] += basicCount("\"asin\"", wholeFile, bt++);
    operatorsBlock[22] += basicCount("\"acos\"", wholeFile, bt++);
    operatorsBlock[23] += basicCount("\"atan\"", wholeFile, bt++);
    operatorsBlock[24] += basicCount("\"ln\"", wholeFile, bt++);
    operatorsBlock[25] += basicCount("\"log\"", wholeFile, bt++);
    operatorsBlock[26] += basicCount("\"e ^\"", wholeFile, bt++);
    operatorsBlock[27] += basicCount("\"10 ^\"", wholeFile, bt++);

    //Pen       - hunter green
    penBlock[0]  += basicCount(" clear", wholeFile, bt++);
    penBlock[1]  += basicCount(" pen down", wholeFile, bt++);
    penBlock[2]  += basicCount(" pen up", wholeFile, bt++);
    int set_pen = basicCount(" set pen color to c", wholeFile, bt++);
    penBlock[3]  += set_pen;
    penBlock[4]  += basicCount(" change pen color by ", wholeFile, bt++);
    penBlock[5]  += specialCount(" set pen color to ", wholeFile, bt++);
    penBlock[6]  += basicCount(" change pen shade by ", wholeFile, bt++);
    penBlock[7]  += basicCount(" set pen shade to ", wholeFile, bt++);
    penBlock[8]  += basicCount(" change pen size by ", wholeFile, bt++);
    penBlock[9]  += basicCount(" set pen size to ", wholeFile, bt++);
    penBlock[10] += basicCount(" stamp", wholeFile, bt++);
    //**Recovery.**
    penBlock[5] -= set_pen;  //set_pen_color_to_X -= set_pen_color_to_COLOR;
    penBlock[0] -= clear_graphics;  //clear -= clear_graphic_effects;

    //Variables and Lists - bright orange and dark red
    variableBlock[0]  += specialCount(" set \"[\\S\\s]*\" to ", wholeFile, bt++);
    variableBlock[1]  += specialCount(" change \"[\\S\\s]*\" by ", wholeFile, bt++);
    int show_var = basicCount(" show variable \"", wholeFile, bt++);
    variableBlock[2]  += show_var;
    int hide_var = basicCount(" hide variable \"", wholeFile, bt++);
    variableBlock[3]  += hide_var;
    variableBlock[4]  += specialCount(" add \"[\\S\\s]*\" to \"", wholeFile, bt++);
    variableBlock[5]  += specialCount(" delete [\\S\\s]* of \"", wholeFile, bt++);
    variableBlock[6]  += specialCount(" insert [\\S\\s]* at [\\S\\s]* of \"", wholeFile, bt++);
    variableBlock[7]  += basicCount(" replace item ", wholeFile, bt++);
    variableBlock[8]  += specialCount("\\(item [\\S\\s]* of \"", wholeFile, bt++);
    variableBlock[9]  += specialCount("\\(length of \"[\\S\\s]*\" \\)", wholeFile, bt++);
    variableBlock[10] += basicCount("\" contains ", wholeFile, bt++);

    //**Recovery.**
    //wait until after Variables
    looksBlock[16] -= show_var;  //show -= show_variable_X;
    looksBlock[17] -= hide_var;  //hide -= hide_variable_X;


    //Variables - bright orange
    //Credit for this code goes to Chris Hallberg!
    for(int i=0; i<wholeFile.length; i++) {
      //variables
      if(wholeFile[i].contains("\"") && (wholeFile[i].contains("set") || wholeFile[i].contains("change"))
        && !wholeFile[i].contains(" receive ") && !wholeFile[i].contains(" broadcast ") && !wholeFile[i].contains(" say ")
        ) {
        try {
          String var = match(wholeFile[i],"\"[^\"]+\"")[0].replaceAll("\"","");
          String val = match(wholeFile[i],"((by )|(to ))(.)+")[0].replaceAll("to ","");    
          //println(wholeFile[i]);println("\t"+var);println("\t"+val);
          if(!variables.containsKey(var))
            variables.put(var,new ArrayList());
          if(!((ArrayList)variables.get(var)).contains(val+""))
            ((ArrayList)variables.get(var)).add(val+"");
        }
        catch(Exception e) {
          println("CHRISTOPHER, PLEASE FIX THIS REGULAR EXPRESSION YOU WROTE (for variables). - "+ wholeFile[i]);
        }
      }
      //lists
      if(wholeFile[i].contains("\"") && (wholeFile[i].contains(" add ") || wholeFile[i].contains(" delete ") || wholeFile[i].contains(" insert ") || wholeFile[i].contains(" replace ")) && !wholeFile[i].contains(" say ")) {
        try {
          String List = match(wholeFile[i],"((of)|(to)) [^\"]*\"[^\"]*\"")[0].replaceAll("(of )|(to )|(\")","");
          String val = match(wholeFile[i],"[^ ]+ ((of)|(to))")[0].replaceAll("( of)|( to)","");
          //println(wholeFile[i]);println("\t"+ List +" : "+ val);
          if(!lists.containsKey(List))
            lists.put(List,new ArrayList());
          if(!((ArrayList)lists.get(List)).contains(val+""))
            ((ArrayList)lists.get(List)).add(val+"");
        }
        catch(Exception e) {
          println("CHRIS, PLEASE FIX THIS REGULAR EXPRESSION YOU WROTE (for lists). - "+ wholeFile[i]);
        }
      }
    }
    for(int i=0;i<variableException.length;i++)
      if(variables.containsKey(variableException[i]))
        variables.remove(variableException[i]);

    codeBlockTypeOffsetHACK += wholeFile.length;


    //setBlockArrayValues();
  }//void_resetAllValues


  //int_basicCount
  int basicCount(String searchItem, String[] wholeFile, int BlockType) {
    int count = 0;
    for(int i=Totals; i<wholeFile.length; i++) { //note: we're starting this search at where we've deduced the line "Totals:" is.
      String myString = wholeFile[i]; //Make this line from the text file into a string so I can dice it up.
      while(myString.length()>1) { //If myString still has any characters left...
        if(myString.indexOf(searchItem)>=0) { //If we find this term I'm looking for in the string...
          myString = myString.substring(myString.indexOf(searchItem) + 2); /*Cut everything up to said term out, plus 2! By shortening myString every time we find what we're looking for, we can find the same term multiple times in the same line.*/
          count ++; //Add to the counter. That is what we are here for.
          //NEW!
          codeBlockType[i+codeBlockTypeOffsetHACK] = BlockType;
          //NEWERR!
          totalBlocks ++;
        }
        else  myString = ""; //Doesn't have what we're looking for? Toss this string; we're done here.
      }
    }
    return count;
  }
  int specialCount(String searchItem, String[] wholeFile, int BlockType) {
    int count = 0;
    for(int i=Totals; i<wholeFile.length; i++) { //note: we're starting this search at where we've deduced the line "Totals:" is.
      String myString = wholeFile[i]; //Make this line from the text file into a string so I can dice it up.
      while(myString.length()>1) { //If myString still has any characters left...
        if(match(myString, searchItem) != null) { //If we find this term I'm looking for in the string...
          String whatWeFound = match(myString, searchItem)[0];
          myString = myString.substring(myString.indexOf(whatWeFound) + 2); /*Cut everything up to said term out, plus 2! By shortening myString every time we find what we're looking for, we can find the same term multiple times in the same line.*/
          count ++; //Add to the counter. That is what we are here for.
          //NEW!
          codeBlockType[i+codeBlockTypeOffsetHACK] = BlockType;
          totalBlocks ++;
        }
        else  myString = ""; //Doesn't have what we're looking for? Toss this string; we're done here.
      }
    }
    return count;
  }
  int selectiveCount(String searchItem, String searchExclusion, String[] wholeFile, int BlockType) {
    int count = 0;
    for(int i=Totals; i<wholeFile.length; i++) { //note: we're starting this search at where we've deduced the line "Totals:" is.
      String myString = wholeFile[i]; //Make this line from the text file into a string so I can dice it up.
      while(myString.length()>1) { //If myString still has any characters left...
        if(match(myString, searchItem) != null) { //If we find this term I'm looking for in the string...
          String whatWeFound = match(myString, searchItem)[0];
          myString = myString.substring(myString.indexOf(whatWeFound) + 2); /*Cut everything up to said term out, plus 2! By shortening myString every time we find what we're looking for, we can find the same term multiple times in the same line.*/
          if(match(whatWeFound, searchExclusion) == null) { //"green flag" doesn't count.
            count ++; //Add to the counter. That is what we are here for.
            //NEW!
            codeBlockType[i+codeBlockTypeOffsetHACK] = BlockType;
            totalBlocks ++;
          }
        }
        else  myString = ""; //Doesn't have what we're looking for? Toss this string; we're done here.
      }
    }
    return count;
  }




  String[] removeGarbageCode(String[] dirty) {
    String[] clean = new String[0];
    for(int i=0; i<dirty.length; i++) {
      if(match(dirty[i], "[\\s]*")[0].length()==0) {
        if(dirty[i].substring(0,4).equals("when")) {
          clean = append(clean,dirty[i]);
        }
        else {
          //println(dirty[i]);
          //*
          i++;
          while(i<dirty.length && match(dirty[i], "[\\s]*")[0].length()!=0) {
            //println(dirty[i]);
            i++;
          }//*/
          i--;
        }
      }
      else
        clean = append(clean,dirty[i]);
    }
    return clean;
  }


  void resetAllValues() {
    //resetAllNonArrayValues();
    author = "";
    version = "";
    maximumBlockCount = 0;

    //Blocks
    totalBlocks = 0;
    for(int i=0; i<totalBlockType.length; i++) {
      totalBlockType[i] = 0;
    }
    codeBlockTypeOffsetHACK = 0;
    codeBlockType = new int[0];

    //RESET BLOCK COUNTS - CHRIS
    motionBlock = new int[motionBlock.length];
    controlBlock = new int[controlBlock.length];
    looksBlock = new int[looksBlock.length];
    sensingBlock = new int[sensingBlock.length];
    soundBlock = new int[soundBlock.length];
    operatorsBlock = new int[operatorsBlock.length];
    penBlock = new int[penBlock.length];
    variableBlock = new int[variableBlock.length];

    //Variables and Lists - light orange and dark red
    variables = new HashMap();
    lists = new HashMap();

    //Totals.
    Totals = 0; //Funny that this is here... but we *should* be resetting it, too.
    sprites = 0;
    stacks = 0;
    unique_costumes = 0;
    unique_sounds = 0;
    times_saved = 0;
    times_shared = 0;
    previous_versions = 0;
    variables_public = 0;
    variables_private = 0;
    lists_public = 0;
    lists_private = 0;
    //Nesting
    nest = new int[0];
  }

  void analyzeSelectedFiles(ArrayList fileIcons) {
    //Set them values!!
    resetAllValues();
    for(int i=0; i<myFileIcon.size(); i++) {
      //println(sprites);
      FileIcon tempFileIcon = (FileIcon) myFileIcon.get(i);
      //Reset non-array
      author = "";
      version = "";
      maximumBlockCount = 0;

      int timecheckChris = millis();
      addToAllValues(tempFileIcon.myFile);
      //println("Analysis Time () : "+(millis()-timecheckChris));
      //println(sprites);
      //println("----");
    }
    setBlockArrayValues();
    setTotalBlockType();
    //infoPanel.savedGraphWidth  = infoPanel.Width;  //save the width and height
    //infoPanel.savedGraphHeight = infoPanel.Height; //save the width and height
    if(infoPanel!=null) infoPanel.reset(); //NOTE: VERY IMPORTANT THAT THE RESET IS HERE //the null check is only useful when the infoPanel expands immediately after creation
    //infoPanel.Width  = infoPanel.savedGraphWidth;  //recover the width and height
    //infoPanel.Height = infoPanel.savedGraphHeight; //recover the width and height
  }
}

