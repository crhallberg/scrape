//void_saveWorkspace

PrintWriter output;

void saveWorkspace(String workspaceName) {
  if(workspaceName.indexOf(".xml")>=0) workspaceName = workspaceName.substring(0, workspaceName.length()-4);
  workspaceTitle = workspaceName;
  output = createWriter(sketchPath + "/data/workspaces/" + workspaceName + ".xml"); //create the XML file in this location
  //output = createWriter(workspaceName + ".xml"); //create the XML file in this location

  output.print("<XML");  //Manditory, all-encompassing tag (opening).
  // ----- ADDED BY CHRIS, 28 June 2011 ----- //
  if(workspaceID > -1)
    output.print(" id=\""+workspaceID+"\"");
  if(workspaceName.length() > 0)
    output.print(" name=\""+workspaceName+"\"");
  output.println(" author=\""+userId+"\">");
  // ---------------------------------------- //
  XMLChild("workspaceName", workspaceName);
  XMLChild("timeSaved", year()+","+month()+","+day()+","+hour()+","+minute()+","+second());
  output.println("");

  //iconSets!
  for(int i=0; i<iconSet.size(); i++) {
    IconSet tempIconSet = (IconSet) iconSet.get(i); //make this iconSet into a temporary iconSet
    XMLElement iconSet_xml = new XMLElement();
    iconSet_xml.setName("iconSet"+tempIconSet.id); //set its name
    iconSet_xml.setAttribute("x", tempIconSet.x+"");
    iconSet_xml.setAttribute("y", tempIconSet.y+"");
    iconSet_xml.setAttribute("id", tempIconSet.id+"");
    iconSet_xml.setAttribute("infoPanel.Width", tempIconSet.infoPanel.Width+"");
    iconSet_xml.setAttribute("infoPanel.Height", tempIconSet.infoPanel.Height+"");
    iconSet_xml.setAttribute("expanded", tempIconSet.expanded+"");
    iconSet_xml.setAttribute("infoPanel.optionsPanel.toggleBoxToggled0", tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[0]+"");
    iconSet_xml.setAttribute("infoPanel.optionsPanel.toggleBoxToggled1", tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[1]+"");
    iconSet_xml.setAttribute("infoPanel.optionsPanel.toggleBoxToggled2", tempIconSet.infoPanel.optionsPanel.toggleBoxToggled[2]+"");
    iconSet_xml.setAttribute("infoPanel.expanded", tempIconSet.infoPanel.expanded+"");
    iconSet_xml.setAttribute("infoPanel.activeTab", tempIconSet.infoPanel.activeTab+"");
    iconSet_xml.setAttribute("infoPanel.graphScale", tempIconSet.infoPanel.graphScale+"");
    for(int j=0; j<tempIconSet.myFileIcon.size(); j++) { //for every fileIcon in tempIconSet
      FileIcon tempFileIcon = (FileIcon) tempIconSet.myFileIcon.get(j); //make this fileIcon into a temporary fileIcon
      iconSet_xml.addChild(XMLChild("myFileIcon"+j+".id", tempFileIcon.id+""));//tempFileIcon.id+""));
    }
    output.println(iconSet_xml);
  }

  /*
  //iconDock.myFileIcon
   for(int i=0; i<iconDock.myFileIcon.size(); i++) {
   FileIcon tempFileIcon = (FileIcon) iconDock.myFileIcon.get(i);
   output.println("<iconDock_myFileIcon"+i+">");
   XMLChild("x", tempFileIcon.x+"");
   XMLChild("y", tempFileIcon.y+"");
   XMLChild("Width", tempFileIcon.Width+"");
   XMLChild("Height", tempFileIcon.Height+"");
   
   XMLChild("myIconSet", tempFileIcon.myIconSet+"");
   XMLChild("mySubfolderString", tempFileIcon.mySubfolderString+"");
   XMLChild("myString", tempFileIcon.myString+"");
   XMLChild("myTextString", tempFileIcon.myTextString+"");
   
   XMLChild("id", tempFileIcon.id+"");
   XMLChild("idInIconSet", tempFileIcon.idInIconSet+"");
   XMLChild("idInIconDock", tempFileIcon.idInIconDock+"");
   output.println("</iconDock_myFileIcon"+i+">");
   }
   */


  output.println("</XML>");  //Manditory, all-encompassing tag (closing).



  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  println("Saved workspace " + workspaceName + ".");
}

void loadWorkspace(File workspaceFile) {
  workspaceTitle = workspaceFile.getName();
  try {
    if(workspaceTitle.indexOf(".xml")>=0) workspaceTitle = workspaceTitle.substring(0,workspaceTitle.length()-4); //chop off the ".xml" if it's already there.
    XMLElement xml = new XMLElement(this, workspaceFile.getPath());

    // DOWNLOADED CHECK
    try {
      if(xml.getIntAttribute("downloaded") == 1) {
        downloadWorkspace(workspaceFile);
        return;
      }
    } 
    catch(Exception e) {
    }

    //make sure all fileIcons are in the dock first! I'll pull them out if I need them in an iconSet in the code after this.
    for(int i=0; i<fileIcon.size(); i++) {
      FileIcon tempFileIcon = (FileIcon) fileIcon.get(i);
      tempFileIcon.myIconSet = null;
    }

    //iconSets!
    iconSet = new ArrayList();
    for(int i=0; i<xml.getChildCount(); i++) {
      XMLElement iconSet_xml = xml.getChild(i);
      /*
      for(int j=0; j<iconSet_xml.getChildCount(); j++) {
        XMLElement fileIcon_xml = iconSet_xml.getChild(j);
        int id = int(fileIcon_xml.getContent());
      }*/
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
      int idInIconDockINDEX = 0;
      for(int j=0; j<iconSet_xml.getChildCount(); j++) {
        //println(j);
        FileIcon icon = ((FileIcon)fileIcon.get(int(iconSet_xml.getChild(j).getContent())));
        icon.id = int(iconSet_xml.getChild(j).getContent());
        newIconSet.myFileIcon.add(icon);
        //Set myFileIcon's myIconSets.
        FileIcon tempFileIcon = (FileIcon) newIconSet.myFileIcon.get(j);
        tempFileIcon.myIconSet = newIconSet;
        tempFileIcon.idInIconSet = j; //Set the idInIconSets //This method is not technically a hack...
        if(tempFileIcon.myIconSet!=null) idInIconDockINDEX++;
        tempFileIcon.idInIconDock = idInIconDockINDEX; //Set the idInIconDocks //This method is not technically a hack...
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
      for(int iLoveHacks=0; iLoveHacks<10; iLoveHacks++) //I LOVE HACKS.
        tempFileIcon.math();
      //"Hack? WHAT HACK?!?!?!?"
      background(255);
    }
    println("Loaded workspace " + workspaceTitle + ".");
  }
  catch(Exception e) {
    println("Sorry, but I couldn't load that workspace: there are more fileIcons in it than in my data folder.");
    resetWorkspace(); //reset the workspace-- we just messed up some fileIcons before aborting this function
  }//*/
  //println("asdf  " + iconSet.size());
}


XMLElement XMLChild(String child, String content) { //I made this to make it simpler to write stuff to our XML.
  XMLElement New;
  New = new XMLElement();

  New.setName(child);
  New.setContent(content);
  //output.print(New.toString());
  return New;
}

