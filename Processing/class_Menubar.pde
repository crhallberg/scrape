//class_Menubar


LoginScreen loginScreen;
PublishScreen publishScreen;


class Menubar {
  float x,y;
  float Width,Height;
  LoadButton loadButton;
  SaveButton saveButton;
  ClearButton clearButton;
  PublishButton publishButton;
  LoginButton loginButton;

  Menubar() {
    reset();
  }

  void draw() {
    //Math.

    //Draw.
    //body rectangle
    fill(122,20,255, 200);
    stroke(0, 128);
    strokeWeight(1);
    rect(x-1,y-1, Width+2,Height+2);
    //buttons
    loadButton.math();
    loadButton.draw();
    saveButton.math();
    saveButton.draw();
    clearButton.math();
    clearButton.draw();

    publishButton.math();
    publishButton.draw();
    loginButton.math();
    loginButton.draw();

    //loginScreen
    loginScreen.draw();
    //publishScreen
    publishScreen.draw();
  }

  void reset() {
    x = width - 180;
    y = 0;
    Width = 180;
    Height = 50;
    loadButton = new LoadButton("Load", this);
    saveButton = new SaveButton("Save", this);
    clearButton = new ClearButton("Clear", this);
    publishButton = new PublishButton("Publish", this);
    loginButton = new LoginButton("Log in", this);
    loginScreen = new LoginScreen();
    publishScreen = new PublishScreen();
  }


  class Button {
    float x,y;
    float xOffset,yOffset;
    float Width,Height;
    Menubar myMenubar;
    String myString = "";
    void draw() {
      //Draw.
      //button body
      if(mouseOver_box(x,y, Width,Height))
        fill(128,60,200, 128);
      else
        fill(128,60,200, 220);
      stroke(255, 200);
      strokeWeight(1);
      rectMode(CORNER);
      rect(x,y, Width,Height);
      //text
      fill(0, 200);
      textAlign(CENTER, CENTER);
      textSize(18);
      text(myString, x+Width/2,y+Height/2);
    }
    void basicMath() {
      x = myMenubar.x + xOffset;
      y = myMenubar.y + yOffset;
    }
    void reset() {
      textSize(18);
      Width = textWidth(myString)+8;
      Height = 20;
    }
  }

  class LoadButton extends Button {
    LoadButton(String MyString, Menubar MyMenubar) {
      myMenubar = MyMenubar;
      myString = MyString;
      xOffset = 10;
      yOffset = 3;
      reset();
    }
    void math() {
      //Math.
      basicMath();
      if(mousePressed && mouseOver_box(x,y, Width,Height) && fFWTMHBHD<2) {
        JFileChooser chooser = new JFileChooser(sketchPath+"/data/workspaces/");
        chooser.setFileFilter(chooser.getAcceptAllFileFilter());
        int returnVal = chooser.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION && chooser.getSelectedFile().getName().endsWith("xml")) {
          loadWorkspace(chooser.getSelectedFile());
          println("Loaded workspace " + chooser.getSelectedFile().getName() + ".");
        }
        else {
          println("That's not an XML file, silly!");
        }
      }
    }
  }
  class SaveButton extends Button {
    SaveButton(String MyString, Menubar MyMenubar) {
      myMenubar = MyMenubar;
      myString = MyString;
      xOffset = loadButton.xOffset+loadButton.Width+8;
      yOffset = 3;
      reset();
    }
    void math() {
      //Math.
      basicMath();
      if(mousePressed && mouseOver_box(x,y, Width,Height) && fFWTMHBHD<2) {
        JFileChooser chooser = new JFileChooser(sketchPath+"/data/workspaces/");
        chooser.setFileFilter(chooser.getAcceptAllFileFilter());
        int returnVal = chooser.showSaveDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
          saveWorkspace(chooser.getSelectedFile().getName());
          //println("Saved workspace " + chooser.getSelectedFile().getName() + "."); //this println is done in saveWorkspace
        }
      }
    }
  }
  class ClearButton extends Button {
    ClearButton(String MyString, Menubar MyMenubar) {
      myMenubar = MyMenubar;
      myString = MyString;
      xOffset = saveButton.xOffset+saveButton.Width+12;
      yOffset = 3;
      reset();
    }
    void math() {
      //Math.
      basicMath();
      if(mousePressed && mouseOver_box(x,y, Width,Height) && fFWTMHBHD<2) {
        resetWorkspace();
      }
    }
  }
  class PublishButton extends Button {
    PublishButton(String MyString, Menubar MyMenubar) {
      myMenubar = MyMenubar;
      myString = MyString;
      xOffset = 24;
      yOffset = 26;
      reset();
    }
    void math() {
      //Math.
      basicMath();
      if(mousePressed && mouseOver_box(x,y, Width,Height) && fFWTMHBHD<2) {
        if(!loggedIn) {
          loginScreen.open = !loginScreen.open;
        }
        else {
          publishScreenshot = get();
          publishScreen.open = !publishScreen.open;
        }
      }
    }
  }
  class LoginButton extends Button {
    LoginButton(String MyString, Menubar MyMenubar) {
      myMenubar = MyMenubar;
      myString = MyString;
      xOffset = 104;
      yOffset = 26;
      reset();
    }
    void math() {
      //Math.
      basicMath();
      if(mousePressed && mouseOver_box(x,y, Width,Height) && fFWTMHBHD<2) {
        loginScreen.open = !loginScreen.open;
      }
    }
  }
}



class LoginScreen {
  boolean open;
  boolean emailEnteringText,pswrdEnteringText;
  boolean invalidLogin;
  float x,y;
  float Width,Height;
  float emailX,emailY,emailH,emailW; //email    x, y, Width, and Height
  float pswrdX,pswrdY,pswrdH,pswrdW; //password x, y, Width, and Height
  LoginScreen() {
    x = width/2-400;
    y = height/2-300;
    Width = 800;
    Height = 600;
    emailX = x+160;
    emailY = y+300;
    emailW = 500;
    emailH = 50;
    pswrdX = x+160;
    pswrdY = y+380;
    pswrdW = 500;
    pswrdH = 50;
    open = false;
    invalidLogin = false;
  }
  void draw() {
    //Math.
    if(mousePressed && fFWTMHBHD<2 && (!mouseOver_box(x,y, Width,Height) && !mouseOver_box(menubar.x,menubar.y, menubar.Width,menubar.Height))) {
      open = false;
    }
    if(open) {
      if(mousePressed && fFWTMHBHD<2) {
        if(mouseOver_box(emailX,emailY, emailW,emailH)) emailEnteringText = true;
        else emailEnteringText = false;
        if(mouseOver_box(pswrdX,pswrdY, pswrdW,pswrdH)) pswrdEnteringText = true;
        else pswrdEnteringText = false;
      }

      //Draw.
      // make everything look like a background
      fill(0, 128);
      noStroke();
      rect(0,0, width,height);
      //body
      fill(240);
      stroke(32);
      strokeWeight(2);
      rect(x,y, Width,Height);
      //header text
      fill(0, 200);
      textAlign(CENTER, TOP);
      textSize(42);
      text("Please log in with your Scrape user account and password.", x,y+10, Width,Height);
      //invalid login?
      if(invalidLogin) {
        fill(0,200, 220);
        textAlign(CENTER, TOP);
        textSize(24);
        text("invalid login", pswrdX+pswrdW/2,pswrdY+pswrdH+14);
      }
      //inputs
      if(emailEnteringText) fill(130);
      else fill(80);
      if(emailEnteringText||mouseOver_box(emailX,emailY, emailW,emailH)) stroke(120,120,120, 200);
      else stroke(0, 200);
      rect(emailX,emailY, emailW,emailH);
      if(pswrdEnteringText) fill(130);
      else fill(80);
      if(pswrdEnteringText||mouseOver_box(pswrdX,pswrdY, pswrdW,pswrdH)) stroke(120,120,120, 200);
      else stroke(0, 200);
      rect(pswrdX,pswrdY, pswrdW,pswrdH);
      fill(80);
      textAlign(RIGHT, CENTER);
      textSize(24);
      text("email:", emailX-10,emailY+emailH/2);
      text("password:", pswrdX-10,pswrdY+pswrdH/2);
      //inputted texts
      fill(240);
      textAlign(LEFT, CENTER);
      textSize(24);
      text(userEmail, emailX+8,emailY+emailH/2);
      String hiddenPassword = "";
      for(int c=0; c<userPassword.length(); c++) hiddenPassword += "*"; //This method of making a "hidden password" is kind of hokey, but it's really simple.
      text(hiddenPassword, pswrdX+8,pswrdY+pswrdH/2);
    }
  }
  void submitLogin() {
    println("http://www.happyanalyzing.com/main/php/veteran.php?e="+userEmail+"&p="+userPassword);
    println(loadStrings("http://www.happyanalyzing.com/main/php/veteran.php?e="+userEmail+"&p="+userPassword));//.match("\"\d+\"}$").replace("",""));

    //int(match(match(loadStrings("http://happyanalyzing.com/main/php/veteran.php?e="+userEmail+"&p="+userPassword)[0],"\"\\d+\"}$")[0],"\\d+")[0]);

    String api = loadStrings("http://happyanalyzing.com/main/php/veteran.php?e="+userEmail+"&p="+userPassword)[0];
    if(match(api,"0")!=null) {
      invalidLogin = true;
      println("User name and password are incorrect. Try again lol");
    }
    else {
      String idString = match(api,"\"\\d+\"}$")[0];
      String idOnly = match(idString,"\\d+")[0];
      userId = int(idOnly);
      userName = api.split("\",\"")[0].substring(9);
      if(userId!=-1) { //user id will never be -1. 0 is Code Monkey.
        open = false;
        loggedIn = true;
        invalidLogin = false;
        saveUserLogin();
      }
    }
  }
}

void saveUserLogin() {
  PrintWriter output = createWriter("/data/conf.ig");
  output.println(userEmail);
  output.println(userPassword);
  output.println(userName);
  output.println(userId);
  output.flush();
  output.close();
}


class PublishScreen {
  boolean open;
  boolean titleEnteringText,dscrptnEnteringText;
  float x,y;
  float Width,Height;
  float titleX,titleY,titleH,titleW; //title    x, y, Width, and Height
  float dscrptnX,dscrptnY,dscrptnH,dscrptnW; //description x, y, Width, and Height
  SubmitButton submitButton;
  PublishScreen() {
    x = width/2-400;
    y = height/2-200;
    Width = 800;
    Height = 400;
    titleX = x+180;
    titleY = y+140;
    titleW = 500;
    titleH = 50;
    dscrptnX = x+180;
    dscrptnY = y+220;
    dscrptnW = 500;
    dscrptnH = 50;
    submitButton = new SubmitButton();
  }
  void draw() {
    //Math.
    if(mousePressed && fFWTMHBHD<2 && (!mouseOver_box(x,y, Width,Height) && !mouseOver_box(menubar.x,menubar.y, menubar.Width,menubar.Height))) {
      open = false;
    }

    if(open) {
      if(mousePressed && fFWTMHBHD<2) {
        if(mouseOver_box(titleX,titleY, titleW,titleH)) titleEnteringText = true;
        else titleEnteringText = false;
        if(mouseOver_box(dscrptnX,dscrptnY, dscrptnW,dscrptnH)) dscrptnEnteringText = true;
        else dscrptnEnteringText = false;
      }

      //Draw.
      // make everything look like a background
      fill(0, 128);
      noStroke();
      rect(0,0, width,height);
      //body
      fill(240);
      stroke(32);
      strokeWeight(2);
      rect(x,y, Width,Height);
      //header text
      fill(0, 200);
      textAlign(CENTER, TOP);
      textSize(42);
      text("Publish", x,y+10, Width,Height);
      //publishScreenshot thumbnail
      tint(255, 200);
      image(publishScreenshot, x+18,y+18, 160,100); //note: the dimensions on this aren't going to be correct because of variation in screen resolutions, but it's nbd.
      noTint();
      noFill();
      stroke(128);
      rect(x+18,y+18, 160,100);
      //inputs
      if(titleEnteringText) fill(130);
      else fill(80);
      if(titleEnteringText||mouseOver_box(titleX,titleY, titleW,titleH)) stroke(120,120,120, 200);
      else stroke(0, 200);
      rect(titleX,titleY, titleW,titleH);
      if(dscrptnEnteringText) fill(130);
      else fill(80);
      if(dscrptnEnteringText||mouseOver_box(dscrptnX,dscrptnY, dscrptnW,dscrptnH)) stroke(120,120,120, 200);
      else stroke(0, 200);
      rect(dscrptnX,dscrptnY, dscrptnW,dscrptnH);
      fill(80);
      textAlign(RIGHT, CENTER);
      textSize(24);
      text("workspace title:", titleX-10,titleY+titleH/2);
      text("description:", dscrptnX-10,dscrptnY+dscrptnH/2);
      //inputted texts
      fill(240);
      textAlign(LEFT, CENTER);
      textSize(24);
      text(workspaceTitle, titleX+8,titleY+titleH/2);
      text(workspaceDesc, dscrptnX+8,dscrptnY+dscrptnH/2);
      //submitButton
      submitButton.draw();
    }
  }
  class SubmitButton {
    float x,y;
    float Width,Height;
    SubmitButton() {
      x = width/2-400+800/2-80;
      y = height/2-200+400-80;
      Width = 160;
      Height = 40;
    }
    void draw() {
      //Math.
      if(mousePressed&&fFWTMHBHD<2&&mouseOver_box(x,y, Width,Height)) {
        if(!iconSet.isEmpty())
          publishWorkspace();
        publishScreen.open = false;
      }

      //Draw.
      //body
      if(mouseOver_box(x,y, Width,Height))
        fill(130,100,255, 128);
      else
        fill(130,100,255);
      stroke(130,180,180);
      strokeWeight(1.5);
      rect(x,y, Width,Height);
      //text
      fill(130,180,50);
      textAlign(CENTER, CENTER);
      textSize(24);
      text("publish", x+Width/2,y+Height/2);
    }
  }
}

