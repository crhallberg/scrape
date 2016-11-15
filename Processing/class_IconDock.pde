//class_IconDock


class IconDock {
  boolean draggingWidth = false; //am I being dragged to change my width?
  boolean lockWidth = false; //when set to true, I won't change my width whether or not the mouse is over me
  float x,y;
  float Width,Height;
  float transparency;
  float scrollY; //so we can scroll down and up to see all the fileIcons!
  float scrollYVel; //so we can scroll down and up to see all the fileIcons!
  float sBX; //scrollButtonX (applies to both)
  float sBUpY,sBDownY; //scrollButtonUpY, scrollButtonDownY
  float sBWidth,sBHeight; //scrollButtonWidth, scrollButtonHeight
  float lBWidth = 42; //lockButtonWidth
  float lBHeight = 16; //lockButtonHeight
  float lockedWidth = 240; //my Width target when I'm locked (this can be changed by the user)
  float clickXOffset; //used in resizing my width
  int elbowRoomIndex = -1; //when I drag a fileIcon over the iconDock, this index shifts down the lower fileIcons

  ArrayList myFileIcon;

  IconDock() {
    reset();
  }

  void draw() {
    //Math.
    if((iconSet.size()==0) || mouseX<x+Width || lockWidth)
      Width += (lockedWidth-Width)/4;
    else
      Width += (120-Width)/4;
    //if(myFileIcon!=null)
    //  Height = (fileIconHeight+fileIconPaddingY)*myFileIcon.size();
    if((keyPressed && keyCode==DOWN)   || (mousePressed && mouseOver_box(sBX,sBDownY, sBWidth,sBHeight))) scrollYVel -= 3;
    if((keyPressed && keyCode==UP) || (mousePressed && mouseOver_box(sBX,sBUpY,   sBWidth,sBHeight))) scrollYVel += 3;
    scrollY += scrollYVel;
    scrollYVel *= 0.7;
    /*SEMI-HACK. present because my Height is used in many other places and I don't want to risk messing those up right now, so I'll create this temporary fix--> */
    float scrollApplicableHeight = Height;
    if(myFileIcon!=null)
      scrollApplicableHeight = (fileIconHeight+fileIconPaddingY)*myFileIcon.size() + fileIconPaddingY;
    //<--
    if(scrollY>0) scrollY += (0-scrollY)/6;
    if(scrollY<height-scrollApplicableHeight-40) scrollY += (height-scrollApplicableHeight-scrollY-40)/6; //the 40 is an arbitrary buffer
    sBX = x+Width;

    if(fileIconBeingDragged!=null && mouseOver_box(x,y, Width,Height)) {
      elbowRoomIndex = int((fileIconBeingDragged.y-scrollY)/(fileIconHeight+fileIconPaddingY)+0.5);
    }
    else if(iconSetBeingDragged!=null && mouseOver_box(iconDock.x,iconDock.y, iconDock.Width,iconDock.Height)) {
      elbowRoomIndex = int((iconSetBeingDragged.y-scrollY)/(fileIconHeight+fileIconPaddingY)-0.5);
    }
    //lock button!
    if(mousePressed && fFWTMHBHD<2 && mouseOver_box(x,y, lBWidth,lBHeight))
      lockWidth = !lockWidth;
    //drag to change width!
    if(!mousePressed) draggingWidth = false; //let go of me!
    if(draggingWidth || (lockWidth && mouseOver_box(x+Width-3,y, 6,height))) cursorType = "W_RESIZE";
    if(draggingWidth) lockedWidth = mouseX-clickXOffset; //being re-widthed
    else if(lockWidth && mousePressed && fFWTMHBHD<2 && mouseOver_box(x+Width-3,y, 6,height)) { //grab me by my lovehandles
      draggingWidth = true;
      clickXOffset = x+Width - mouseX;
    }
    if(lockedWidth<80) lockedWidth = 80;
    else if(lockedWidth>width) lockedWidth = width;

    //Draw.
    //base rectangle
    fill(54,120,240, 0.5*transparency);
    if(lockWidth)
      stroke(64, transparency);
    else
      stroke(64, transparency*0.2);
    strokeWeight(2);
    rect(x-3,-3, Width+3,height+6); //NOTE: I'm not drawing based on my y or Height. After all, I don't want to scroll the whole dock, do I?
    //'header' and 'footer' rectangles
    fill(54,220,80, 0.2*transparency);
    noStroke();
    for(int i=0; i<1; i++) {
      rect(x-3,-3, Width+3,scrollY-i*3);
      rect(x-3,scrollY+scrollApplicableHeight+i*3, Width+3,height);
    }
    //lockButton!
    stroke(0, 220);
    strokeWeight(1);
    textAlign(CENTER, CENTER);
    textSize(lBHeight-2);
    if(lockWidth) {
      fill(50, 200);
      rect(x,y, lBWidth,lBHeight);
      fill(245);
      text("unlock", lBWidth/2,lBHeight/2);
      text("unlock", lBWidth/2,lBHeight/2); //repeated for ease of reading
    }
    else {
      fill(200, 200);
      rect(x,y, lBWidth,lBHeight);
      fill(16);
      text("lock", lBWidth/2,lBHeight/2);
      text("lock", lBWidth/2,lBHeight/2); //repeated for ease of reading
    }
    //mouse-over highlight
    if(mouseOver_box(x,y, lBWidth,lBHeight)) {
      fill(255, 64);
      noStroke();
      rect(x,y, lBWidth,lBHeight);
    }
    //scrollButtons!
    noStroke();
    if(mouseOver_box(sBX,sBUpY,   sBWidth,sBHeight)) {
      fill(0, 16);
      stroke(0, 90);
      strokeWeight(1);
      rect(sBX,sBUpY, sBWidth,sBHeight);
      fill(0, 72);
      triangle(sBX+sBWidth*0.2,sBUpY+sBHeight*0.8, sBX+sBWidth*0.8,sBUpY+sBHeight*0.8, sBX+sBWidth*0.5,sBUpY+sBHeight*0.2);
    }
    else {
      noStroke();
      fill(0, 80);
      triangle(sBX+sBWidth*0.2,sBUpY+sBHeight*0.8, sBX+sBWidth*0.8,sBUpY+sBHeight*0.8, sBX+sBWidth*0.5,sBUpY+sBHeight*0.2);
    }
    if(mouseOver_box(sBX,sBDownY, sBWidth,sBHeight)) {
      fill(0, 16);
      stroke(0, 90);
      strokeWeight(1);
      rect(sBX,sBDownY, sBWidth,sBHeight);
      fill(0, 72);
      triangle(sBX+sBWidth*0.2,sBDownY+sBHeight*0.2, sBX+sBWidth*0.8,sBDownY+sBHeight*0.2, sBX+sBWidth*0.5,sBDownY+sBHeight*0.8);
    }
    else {
      noStroke();
      fill(0, 80);
      triangle(sBX+sBWidth*0.2,sBDownY+sBHeight*0.2, sBX+sBWidth*0.8,sBDownY+sBHeight*0.2, sBX+sBWidth*0.5,sBDownY+sBHeight*0.8);
    }
    //fileIcons!
    for(int i=0; i<myFileIcon.size(); i++) {
      FileIcon tempFileIcon = (FileIcon) myFileIcon.get(i);
      tempFileIcon.idInIconDock = i; //...here??
      if(tempFileIcon!=fileIconBeingDragged) {
        tempFileIcon.math(); //don't math fileIconBeingDragged-- it's drawing after, over everything else
        tempFileIcon.draw(); //don't draw fileIconBeingDragged-- it's drawing after, over everything else
      }
    }
  }

  void reset() {
    x = 0;
    y = 0;
    Width = 180;
    Height = height;
    transparency = 255;
    scrollY = 0;
    sBWidth  = 48;
    sBHeight = 24;
    sBUpY = 0;
    sBDownY = height-sBHeight;
    myFileIcon = new ArrayList();
    for(int i=0; i<fileIcon.size(); i++) {
      myFileIcon.add(fileIcon.get(i));
    }
  }
}

