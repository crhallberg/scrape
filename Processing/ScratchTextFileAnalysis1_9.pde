//Automated Scratch Text File Reader Thingo
//      by Brett Taylor


import processing.opengl.*;
import javax.swing.JFileChooser;
import java.awt.*;
import java.awt.event.*;
import sojamo.drop.*;
//MouseWheelEventDemo wheel;


//-------------------------------INFO GATHERED FROM THE INPUT FILE-------------------------------
String author;
String version;


int Totals = 0; //The line on which "Totals:" is first stated. //We have to say this here so basicCount can access it.

//Variables - red-orange
HashMap variables;
HashMap lists;

/*
 //Nests.
 int minimum_nests;
 int maximum_nests;
 int average_nests;
 */
//-------------------------------INFO GATHERED FROM THE INPUT FILE-------------------------------


//User name and id!
String userEmail = "";
String userPassword = "";
String userName = "";
int userId = -1;


//Booleans!
boolean keyDown_SHIFT;
boolean keyDown_CONTROL;
boolean loggedIn = false;

//FileIcons!
ArrayList fileIcon;
FileIcon fIOWIMBDC = null; //fileIconOnWhichIMayBeDoubleClicking
FileIcon fileIconBeingDragged = null;

//Floats!
float fileIconWidth  = 260;
float fileIconHeight = 40;
float fileIconMinimizedWidth  = 32;
float fileIconMinimizedHeight = 32;
float fileIconPaddingXLeft  = 18;
float fileIconPaddingXRight = 6;
float fileIconPaddingY = 10;
float fileIconPaddingDockX = 16;
float fileIconMinimizedPaddingX = 6;
float fileIconMinimizedPaddingY = 8;
float flashTransparency = 0; //when we take a screenshot, we're going to show a flash

//IconDock!
IconDock iconDock;

//IconSets!
ArrayList iconSet;
IconSet iconSetBeingDragged = null;
IconSet frontmostIconSetOverWhichMyMouseIs = null;

//Ints!
int fFWTMHBHD; //framesForWhichTheMouseHasBeenHeldDown
int fFWTSBHBHD; //framesForWhichTheSpacebarHasBeenHeldDown
int fSLC; //framesSinceLastClick
int doubleClickFrames = 10; //how many frames until a second click won't be registered as a double-click
int[] iconSetDrawOrder;
int summaryPageTab = 0; //which tab in the tab array the summaryPage *identifies* itself as
int pieChartTab = 1; //which tab in the tab array the pieChart *identifies* itself as
int totalsListTab = 10; //which tab in the tab array the totalsList *identifies* itself as

//Menubar!
Menubar menubar;

//PFonts!
PFont myFont;
PFont verdanaBold;

//PImages!
PImage pieChartThumbnail_img;
PImage grabTab_img;
PImage screenGrab;
int screenGrabX,screenGrabY = -1;
PImage publishScreenshot; //this is the thumbnail we associate with the publication of this workspace

//SDrop!
SDrop drop;

//Strings!
String[] fileToAnalyze = new String[0]; //Note that if this array has no elements, I will assume and act as if we haven't yet selected a file.
String cursorType = "ARROW"; //The type of cursor as a string. This variable is used to treat SCS. (Spazztastic Cursor Syndrome)


LoadFast loadThread = new LoadFast();
void setup() {
  size(screen.width-240,screen.height-180);//, OPENGL);
  //hint(ENABLE_OPENGL_4X_SMOOTH);
  colorMode(HSB);
  //smooth();
  //frameRate(50);
  strokeCap(SQUARE);
  //wheel = new MouseWheelEventDemo();
  drop = new SDrop(this);

  //menubar!
  menubar = new Menubar();

  //PFonts!
  myFont = loadFont("Calibri-48.vlw");//Corbel-48.vlw");
  verdanaBold = loadFont("Verdana-Bold-48.vlw");
  textFont(myFont);

  //PImages!
  pieChartThumbnail_img = loadImage("pieChartThumbnail.png");
  grabTab_img = loadImage("grabTab4.png");
  setBlockImages();

  //stuff that used to be in here but was moved into a function so it could be replicated!
  resetWorkspace();

  // ACCOUNT INFO
  try {
    String[] userInfo = loadStrings("conf.ig");
    userEmail = userInfo[0];
    userPassword = userInfo[1];
    userName = userInfo[2];
    userId = int(userInfo[3]);
    loggedIn = true;
  } 
  catch(Exception e)
  {
  } //*/

  /* REFERENCE
   int i = getLocalFileId("input/Non-IJIMS/Alfred O-summary.txt");
   println("RETURNED ID: "+ i); //*/
  //println(loadStrings("http://www.happyanalyzing.com/api/f/72")); // TEXT ONLY
  //println(loadStrings("http://www.happyanalyzing.com/api/fd/72")); // DOWNLOAD
}


void draw() {
  //cursor stuff part I!
  cursorType = "ARROW";

  //fFWTMHBHD! and fSLC!
  if(mousePressed) {
    fFWTMHBHD++;
    fSLC=0;
  }
  else {
    fFWTMHBHD=0;
    fSLC++;
  }
  //fIWIMBDC!
  if(fSLC>doubleClickFrames) fIOWIMBDC = null;

  //fFWTSBHBHD!
  if(keyPressed && key==' ') {
    fFWTSBHBHD++;
  }
  else {
    fFWTSBHBHD=0;
  }

  background(255);

  //iconDock!
  iconDock.draw();

  //iconSets!
  resetIconSetIds();

  //frontmostIconSetOverWhichMyMouseIs! (here? I can't see any alternative)
  frontmostIconSetOverWhichMyMouseIs = null;
  for(int i=0; i<iconSet.size(); i++) {
    IconSet tempIconSet = (IconSet) iconSet.get(i);
    if(iconSetBeingDragged!=tempIconSet && tempIconSet.mouseOver_wholeIconSet()) frontmostIconSetOverWhichMyMouseIs = tempIconSet; //we do NOT count the iconSet being dragged. NOTE THIS!
    tempIconSet.HACK_alreadyPerformedMath = false; /*TERRIBLE PLACE TO PUT THIS. But this is where it works the best. (It's just so RANDOM to put it here--it only really needs to be before the math loop.)*/
    tempIconSet.HACK_alreadyPerformedDraw = false; /*TERRIBLE PLACE TO PUT THIS. But this is where it works the best. (It's just so RANDOM to put it here--it only really needs to be before the math loop.)*/
  }

  for(int i=0; i<iconSet.size(); i++) {
    try {
      IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-i-1); //math in anti-chronological order
      if(tempIconSet!=null) {
        if(!loginScreen.open&&!publishScreen.open) tempIconSet.math();
      }
      tempIconSet = (IconSet) iconSet.get(i); //draw in chronological order
      if(tempIconSet!=null) {
        tempIconSet.draw();
      }//*
    }
    catch(Exception e) {
      println("Hmm, there seems to be an issue with iconSet " + i + ".");
    }
    //*/
  }

  //fileIconBeingDragged! (draw on top of everything else)
  if(fileIconBeingDragged!=null) {
    fileIconBeingDragged.draw();
    if(!loginScreen.open&&!publishScreen.open) fileIconBeingDragged.math();
  }

  //miniMenus!
  for(int i=0; i<fileIcon.size(); i++) { //I'm drawing these after all the fileIcons so none show behind another fileIcon.
    FileIcon tempFileIcon = (FileIcon) fileIcon.get(i);
    if(tempFileIcon.miniMenu!=null) tempFileIcon.miniMenu.draw();
  }
  //menubar!
  menubar.draw();

  //"Welcome, You!"
  fill(0, 128);
  textAlign(RIGHT, TOP);
  textSize(16);
  if(userName!="") {
    text("Welcome, " + userName + "!", width-6,menubar.Height+6);
  }
  else {
    text("Not logged in", width-6,menubar.Height+6);
  }
  text(workspaceTitle,width-menubar.Width-6,6);

  if(!mousePressed) {
    fileIconBeingDragged = null; //the only time we set this to null
    if(!keyDown_CONTROL) //mind that we could be 'CONTROL-dragging' an iconSet
      iconSetBeingDragged = null; //the only time we set this to null
  }
  else if(mouseButton!=LEFT && mouseButton!=RIGHT && screenGrab==null) { //screenGrab stuff!
    noFill();
    stroke(128);
    strokeWeight(5);
    rect(screenGrabX,screenGrabY, mouseX-screenGrabX,mouseY-screenGrabY);
  }
  if(flashTransparency>0) {
    //flash rect
    fill(255, flashTransparency*0.7);
    noStroke();
    rect(0,0, width,height);
    //text placemat
    fill(255, flashTransparency);
    stroke(0, flashTransparency);
    rect(0,height/2-40, width,80);
    //text
    textAlign(CENTER, CENTER);
    textFont(myFont, 72);
    fill(0, flashTransparency);
    text("SCREENSHOT SAVED  =)", width/2,height/2);
    flashTransparency -= 300/frameRate;
  }

  //cursor stuff part II!
  if(match(cursorType,"NW_RESIZE")!=null) cursor(6);
  if(match(cursorType,"W_RESIZE")!=null) cursor(10);
  if(match(cursorType,"ARROW")!=null) cursor(ARROW);
  if(match(cursorType,"CROSS")!=null) cursor(CROSS);
  if(match(cursorType,"HAND") !=null) cursor(HAND);
  if(match(cursorType,"MOVE") !=null) cursor(MOVE);
  if(match(cursorType,"TEXT") !=null) cursor(TEXT);
  if(match(cursorType,"WAIT") !=null) cursor(WAIT);
}


void resetIconSetIds() {
  for(int i=0; i<iconSet.size(); i++) {
    IconSet tempIconSet = (IconSet) iconSet.get(i);
    tempIconSet.id = i;
  }
}


void resetWorkspace() {
  //fileIcons!
  fileIcon = new ArrayList();

  loadThread.start();

  //iconDock!
  iconDock = new IconDock();

  //iconSets!
  iconSet = new ArrayList();
  /*
   for(int i=0; i<fileIcon.size()-1; i++) {
   iconSet.add(new IconSet(10+(i*160)%(width-fileIconWidth),140, i)); /*random(0,width-fileIconWidth),random(140,height-fileIconHeight), i));///
   IconSet tempIconSet = (IconSet) iconSet.get(i);
   tempIconSet.myFileIcon.add(tempFileIcon);
   if(tempFileIcon!=null)
   tempFileIcon.myIconSet = tempIconSet;
   tempIconSet.x = 10+i*(fileIconWidth+40);
   do {
   if(tempIconSet.x>width-tempIconSet.Width) {
   tempIconSet.x -= width-tempIconSet.Width;
   tempIconSet.y += 200;
   }
   }
   while(tempIconSet.x>width-tempIconSet.Width);
   }
   
   iconSetDrawOrder = new int[iconSet.size()]; //NOTE: THIS IS A LITTLE BULLSHIT. iconSet changes size, but iconSetDrawOrder stays at the 'maximum' size iconSet can be.
   for(int i=0; i<iconSetDrawOrder.length; i++) {
   iconSetDrawOrder[i] = i;
   }
   */
}


void dropEvent(DropEvent theDropEvent) {
  if(theDropEvent.isFile()) {
    // for further information see
    // http://java.sun.com/j2se/1.4.2/docs/api/java/io/File.html
    File myFile = theDropEvent.file();
    println("\nisDirectory ? "+myFile.isDirectory()+"  /  isFile ? "+myFile.isFile());
    if(myFile.isDirectory()) { //if it's a folder!
      println("listing the directory");

      // list the directory, not recursive, with the File api. returns File[].
      println("\n\n### listFiles #############################\n");
      println(myFile.listFiles());


      // list the directory recursively with listFilesAsArray. returns File[]
      println("\n\n### listFilesAsArray recursive #############################\n");
      println(theDropEvent.listFilesAsArray(myFile,true));


      // list the directory and control the depth of the search. returns File[]
      println("\n\n### listFilesAsArray depth #############################\n");
      println(theDropEvent.listFilesAsArray(myFile,2));
    }
    else if(myFile.getName().endsWith(".txt")) { //if it's a text file!
      //Save the file as a text file in our input folder!
      PrintWriter output = createWriter(sketchPath + "/data/input/" + myFile.getName());
      for(int i=0; i<loadStrings(myFile).length; i++)
        output.println(loadStrings(myFile)[i]);
      output.flush();
      output.close();
      //Add this file to our workspace and iconDock!
      FileIcon newIcon = new FileIcon(myFile, "",myFile.getName(),fileIcon.size());
      fileIcon.add(newIcon);
      iconDock.myFileIcon.add(newIcon);
    }
  }
}


void keyPressed() {
  if(loginScreen.open) {
    if(loginScreen.emailEnteringText) {
      if(keyCode==BACKSPACE && userEmail.length()>0) userEmail = userEmail.substring(0,userEmail.length()-1);
      else if(keyCode!=ENTER&&keyCode!=RETURN&&keyCode!=SHIFT&&keyCode!=TAB&&keyCode!=BACKSPACE) userEmail += key+"";
      if(keyCode==TAB) {
        loginScreen.emailEnteringText = false;
        loginScreen.pswrdEnteringText = true;
      }
    }
    else if(loginScreen.pswrdEnteringText) {
      if(keyCode==BACKSPACE && userPassword.length()>0) userPassword = userPassword.substring(0,userPassword.length()-1);
      else if(keyCode!=ENTER&&keyCode!=RETURN&&keyCode!=SHIFT&&keyCode!=TAB&&keyCode!=BACKSPACE) userPassword += key+"";
      if(keyCode==TAB) {
        loginScreen.emailEnteringText = true;
        loginScreen.pswrdEnteringText = false;
      }
    }
    if(keyCode==ENTER || keyCode==RETURN) {
      loginScreen.submitLogin();
    }
  }
  if(publishScreen.open) {
    if(publishScreen.titleEnteringText) {
      if(keyCode==BACKSPACE && workspaceTitle.length()>0) workspaceTitle = workspaceTitle.substring(0,workspaceTitle.length()-1);
      else if(keyCode!=ENTER&&keyCode!=RETURN&&keyCode!=SHIFT&&keyCode!=TAB&&keyCode!=BACKSPACE) workspaceTitle += key+"";
      if(keyCode==TAB) {
        publishScreen.titleEnteringText = false;
        publishScreen.dscrptnEnteringText = true;
      }
    }
    else if(publishScreen.dscrptnEnteringText) {
      if(keyCode==BACKSPACE && workspaceDesc.length()>0) workspaceDesc = workspaceDesc.substring(0,workspaceDesc.length()-1);
      else if(keyCode!=ENTER&&keyCode!=RETURN&&keyCode!=SHIFT&&keyCode!=TAB&&keyCode!=BACKSPACE) workspaceDesc += key+"";
      if(keyCode==TAB) {
        publishScreen.titleEnteringText = true;
        publishScreen.dscrptnEnteringText = false;
      }
    }
  }

  if(keyCode==SHIFT) keyDown_SHIFT = true;
  if(keyCode==CONTROL) {
    keyDown_CONTROL = true;
    if(!mousePressed && frontmostIconSetOverWhichMyMouseIs!=null) { //if the mouse isn't pressed already, allow me to drag the frontmostIconSet
      IconSet tempIconSet = frontmostIconSetOverWhichMyMouseIs;//(IconSet) iconSet.get(iconSet.size()-1);
      tempIconSet.clickX = mouseX-tempIconSet.x;
      tempIconSet.clickY = mouseY-tempIconSet.y;
      iconSetBeingDragged = tempIconSet;
    }
  }
  if(keyCode==TAB) { //Tab changes tabs (hehehe)
    if(iconSet.size()>0) {
      IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-1);
      if(keyDown_SHIFT)
        tempIconSet.infoPanel.activeTab--;
      else
        tempIconSet.infoPanel.activeTab++;
    }
  }

  //toggleBoxes!
  /*
  if(iconSet.size()>0) {
   if(key=='S' || key=='s') {
   IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-1);
   tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[0] = !tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[0];
   }
   if(key=='U' || key=='u') {
   IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-1);
   tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[1] = !tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[1];
   tempIconSet.infoPanel.resetGraphs();
   }
   if(key==' ' || key=='T' || key=='t') {
   IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-1);
   tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[2] = !tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[2];
   }
   }*/

  //screenshot!
  if(!loginScreen.open&&!publishScreen.open && (key==' ' || key=='s' || key=='S')) {
    save("screenshot " + month() + "-" + day() + " " + year() + ", " + hour() + ";" + minute() + "." + second() + ".jpg");
    flashTransparency = 350;
    println("Screenshot saved!");
  }
}
void keyReleased() {
  if(keyCode==SHIFT) keyDown_SHIFT = false;
  if(keyCode==CONTROL) keyDown_CONTROL = false;
}


/*
//public class MouseWheelEventDemo implements MouseWheelListener { //mouse scrolling detection
 public MouseWheelEventDemo() {
 addMouseWheelListener(this);
 }
 public void mouseWheelMoved(MouseWheelEvent e) {
 int notches = e.getWheelRotation();
 
 if(iconSet.size()>0) {
 //Scrolling changes tabs in the frontmost iconSet
 IconSet tempIconSet = (IconSet) iconSet.get(iconSet.size()-1);
 tempIconSet.infoPanel.activeTab -= notches/abs(notches); //limit how many notches at a time, eh?
 //enforce a check here. we COULD be in the middle of drawing a tab, using activeTab AFTER the infoPanel has checked its bounds.
 if(tempIconSet.infoPanel.activeTab>=tempIconSet.infoPanel.graphTab.length) tempIconSet.infoPanel.activeTab = 0;
 if(tempIconSet.infoPanel.activeTab<0) tempIconSet.infoPanel.activeTab = tempIconSet.infoPanel.graphTab.length-1;
 }
 }
 }
 */


//SCREEN CAPTURE
void mousePressed() {
  if(mouseButton!=LEFT && mouseButton!=RIGHT) {
    screenGrabX = mouseX;
    screenGrabY = mouseY;
  }
}
void mouseReleased() {
  if(screenGrabX!=-1 && screenGrabY!=-1) {
    //INVERT RECTANGLE
    if(mouseX < screenGrabX) {
      mouseX+=screenGrabX;
      screenGrabX = mouseX-screenGrabX;
      mouseX-=screenGrabX;
    }
    if(mouseY < screenGrabY) {
      mouseY+=screenGrabY;
      screenGrabY = mouseY-screenGrabY;
      mouseY-=screenGrabY;
    }
    //BOUNDS
    if(screenGrabX < 0)
      screenGrabX = 0;
    if(screenGrabY < 0)
      screenGrabX = 0;
    if(mouseX > width)
      mouseX = 0;
    if(mouseY > height)
      mouseY = 0;
    //SAVE
    screenGrab = get(screenGrabX,screenGrabY, mouseX-screenGrabX,mouseY-screenGrabY);
    PGraphics pg = createGraphics(screenGrab.width,screenGrab.height, P2D);
    pg.noTint();
    pg.image(screenGrab, 0,0);
    pg.endDraw();
    pg.save("image"+frameCount+".png");
    screenGrabX = -1;
    screenGrabY = -1;
    screenGrab = null;
  }
}

