// CHRIS HALLBERG
// Created  :  JUNE 28th, 2011
// Updated  :  

// THIS FUNCTION COMPARES ALL THE USED FILES AGAINST WHATS ON THE DATABASE, GETTING THE ID FOR EACH
// THE FUNCTION THEN RETURNS THE ID FOR WHERE THIS WORKSPACE IS STORED ONLINE
// THE PhP WILL STORE THE DATA AND ATTRIBUTE IT TO THE AUTHOR

String workspaceTitle = "";
String workspaceDesc = "";
int workspaceID = -1;

void publishWorkspace()
{
  String hashData = "";  // THIS STRING WILL CONTAIN THE DATA NEEDED TO RECREATE THE WORKSPACE

  // FOR EACH ICON SET
  for(int i=0;i<iconSet.size();i++)
  {
    IconSet temp =(IconSet) iconSet.get(i);
    hashData += "iconSet"+temp.id;

    hashData += ":";  // DIVIDER

    // PHYSICAL PROPERTIES
    hashData += temp.x+",";
    hashData += temp.y+",";
    hashData += temp.id+",";
    hashData += temp.infoPanel.Width+",";
    hashData += temp.infoPanel.Height+",";
    hashData += temp.expanded+",";
    hashData += temp.infoPanel.optionsPanel.toggleBoxToggled[0]+",";
    hashData += temp.infoPanel.optionsPanel.toggleBoxToggled[1]+",";
    hashData += temp.infoPanel.optionsPanel.toggleBoxToggled[2]+",";
    hashData += temp.infoPanel.expanded+",";
    hashData += temp.infoPanel.activeTab+",";
    hashData += temp.infoPanel.graphScale;

    hashData += ":";  // DIVIDER

    // COMPARE EACH FILE
    for(int j=0; j<temp.myFileIcon.size(); j++) {
      FileIcon icon = ((FileIcon)temp.myFileIcon.get(j));
      int id;
      if(icon.id == -1) {
        id = getLocalFileId(icon.myFile.getPath());
        icon.id = id;
      } 
      else id = icon.id;
      hashData += id;
      if(j+1 < temp.myFileIcon.size())
        hashData += ",";
    }

    if(i+1 < iconSet.size())
      hashData += ";";  // END OF DEFINITION
  }
  println(hashData);

  //println(userId);
  //println(workspaceTitle);
  println("pre-id: "+workspaceID);
  String re = "http://www.happyanalyzing.com/api/upws.php?id="+workspaceID+"&a="+userId+"&n="+workspaceTitle.split("\\s*\\[.*\\]$")[0]+"&l="+hashData+"&d="+workspaceDesc;
  //println(re);
  println(loadStrings(re));
  workspaceID = int(loadStrings(re)[0]);
  println("post-id: "+workspaceID);

  saveWorkspace(workspaceTitle.split("\\s*\\[.*\\]$")[0]);  // SAVE TO GET MORE INFO IN THE XML  
  updateIDList();
}

// THIS FUNCTION IS USED TO LOAD A WORKSPACE DOWNLOADED FROM THE COMMUNITY, DISTINGUISHED BY THE downloaded="1" ATTRIBUTE
// IF THIS WORKSPACE HAS NOT BEEN OPENED YET, IT WILL DOWNLOAD ALL THE NECESSARY FILES INTO A SUBFOLDER
// IF THESE FILES ARE ALREADY LOCAL, IT WILL LOAD LIKE ANY OTHER WORKSPACE

void downloadWorkspace(File workspaceFile) {
  workspaceTitle = workspaceFile.getName();
  if(workspaceTitle.indexOf(".xml")>=0) workspaceTitle = workspaceTitle.substring(0,workspaceTitle.length()-4); //chop off the ".xml" if it's already there.

  // SEE IF WE HAVE TO DOWNLOAD ALL THE FILES AGAIN
  File exists = new File(sketchPath+"/data/input/"+workspaceTitle);
  boolean local = exists.isDirectory();

  if(local)
    print("LOADING WORKSPACE");
  else
    print("DOWNLOADING WORKSPACE");
  println(": '"+workspaceTitle+"'");

  try {
    XMLElement xml = new XMLElement(this,workspaceFile.getPath());

    //prepare for future update
    workspaceID = xml.getIntAttribute("id");
    println("NEW WORKSPACE ID: "+workspaceID);

    //make sure all fileIcons are in the dock first! I'll pull them out if I need them in an iconSet in the code after this.
    for(int i=0; i<fileIcon.size(); i++) {
      FileIcon tempFileIcon = (FileIcon) fileIcon.get(i);
      tempFileIcon.myIconSet = null;
    }

    //iconSets!
    iconSet = new ArrayList();
    for(int i=0; i<xml.getChildCount(); i++) {
      XMLElement iconSet_xml = xml.getChild(i);
      for(int j=0; j<iconSet_xml.getChildCount(); j++) {
        XMLElement fileIcon_xml = iconSet_xml.getChild(j);
        int id = int(fileIcon_xml.getContent());
      }
      //Make a new iconSet with these starting attributes.
      IconSet newIconSet = new IconSet(iconSet_xml.getFloatAttribute("x"),iconSet_xml.getFloatAttribute("y"), iconSet_xml.getIntAttribute("id"));
      //Set the additional saved attributes.
      newIconSet.infoPanel.Width = iconSet_xml.getFloatAttribute("infoPanel.Width");
      newIconSet.infoPanel.Height = iconSet_xml.getFloatAttribute("infoPanel.Height");
      newIconSet.expanded = boolean(iconSet_xml.getStringAttribute("expanded"));
      newIconSet.infoPanel.expanded = boolean(iconSet_xml.getStringAttribute("infoPanel.expanded"));
      newIconSet.infoPanel.optionsPanel.toggleBoxToggled[0] = boolean(iconSet_xml.getStringAttribute("infoPanel.optionsPanel.toggleBoxToggled0"));
      newIconSet.infoPanel.optionsPanel.toggleBoxToggled[1] = boolean(iconSet_xml.getStringAttribute("infoPanel.optionsPanel.toggleBoxToggled1"));
      newIconSet.infoPanel.optionsPanel.toggleBoxToggled[2] = boolean(iconSet_xml.getStringAttribute("infoPanel.optionsPanel.toggleBoxToggled2"));
      newIconSet.infoPanel.activeTab = iconSet_xml.getIntAttribute("infoPanel.activeTab");
      newIconSet.infoPanel.graphScale = iconSet_xml.getFloatAttribute("infoPanel.graphScale");
      //Add fileIcons to this iconSet's myFileIcon basket.
      newIconSet.myFileIcon = new ArrayList();

      // FileIcons
      int idInIconDockINDEX = 0;
      for(int j=0; j<iconSet_xml.getChildCount(); j++) {
        String iconFileName = iconSet_xml.getChild(j).getStringAttribute("name");  //GET NAME
        int oid = int(iconSet_xml.getChild(j).getContent());
        FileIcon newIcon;
        if(!local) {  // if we haven't downloaded it yet, do it
          println("-\tPulling file: "+iconFileName);
          saveBytes("data/input/"+workspaceTitle+"/"+iconFileName,loadBytes("http://www.happyanalyzing.com/api/fd/"+oid));
          newIcon = new FileIcon(new File(sketchPath+"/data/input/"+workspaceTitle+"/"+iconFileName),workspaceTitle,iconFileName,oid);
          fileIcon.add(newIcon);
        } 
        else {
          print("-\tAssigning file: ");
          newIcon = findIconByFile(new File(sketchPath+"/data/input/"+workspaceTitle+"/"+iconFileName));
          newIcon.id = oid;
          println(newIcon.myString);
        }
        newIconSet.myFileIcon.add(newIcon);
        //Set myFileIcon's myIconSets.
        newIcon.myIconSet = newIconSet;
        newIcon.idInIconSet = j; //Set the idInIconSets //This method is not technically a hack...
        if(newIcon.myIconSet!=null) idInIconDockINDEX++;
        newIcon.idInIconDock = idInIconDockINDEX; //Set the idInIconDocks //This method is not technically a hack...
      }
      iconSet.add(newIconSet);
      //println(i);
    }

    //iconDock!
    iconDock = new IconDock();
    iconDock.myFileIcon = new ArrayList(); //Clean slate!
    //Add each fileIcon that doesn't have a myIconSet.
    for(int i=0; i<fileIcon.size(); i++) {
      FileIcon tempFileIcon = (FileIcon) fileIcon.get(i);
      if(tempFileIcon.myIconSet==null) {
        iconDock.myFileIcon.add(tempFileIcon);
      }
      background(255);
    }
    //println("Loaded workspace " + workspaceTitle + ".");
  }
  catch(Exception e) {
    println("Sorry, but I couldn't load that workspace: there are more fileIcons in it than in my data folder.");
    resetWorkspace(); //reset the workspace-- we just messed up some fileIcons before aborting this function
  }//*/
  //println("asdf  " + iconSet.size());

  updateIDList();
}

// USED TO FIND FILES THAT DO NOT HAVE A LOCAL ID
// FILES DOWNLOADED MAINTAIN THEIR ONLINE ID
FileIcon findIconByFile(File test) {    
  for(int i=0; i<fileIcon.size(); i++) {
    FileIcon curr = ((FileIcon)fileIcon.get(i));
    if(test.equals(curr.myFile))
      return curr;
  }
  //println("NULL FIND BY FILE");
  //println(test.getPath());
  return null;
}

void updateIDList() {
  PrintWriter out = createWriter("data/icon.ids");
  for(int i=0; i<fileIcon.size(); i++) {
    FileIcon curr = ((FileIcon)fileIcon.get(i));
    if(curr.id > -1)
      out.println(curr.myFile.getPath().substring(sketchPath.length()+12)+"-:-:-"+curr.id);
  }
  out.flush();
  out.close();
  println("IDs Saved ("+fileIcon.size()+")");
}

