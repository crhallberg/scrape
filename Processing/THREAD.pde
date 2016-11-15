class LoadFast extends Thread {
  LoadFast()
  {
  }

  void start()
  {
    if(frameCount<1) //a hacky catch
      super.start(); //start the thread that loads in all the files.
    else
      run(); //if the thread's already been started once, just reset all the files at once this time around.
  }

  void run()
  {
    String path = sketchPath + "/data/input/";
    String[] filenames = listFileNames(path);
    File[] files = listFiles(path);
    //    ArrayList allFiles = listFilesRecursive(path);
    FileIcon newIcon = new FileIcon();
    for(int i=0; i<files.length; i++) {
      if(filenames[i].indexOf(".txt")>=0) { //if it's a text file
        newIcon = new FileIcon(files[i],"",filenames[i],-1);
        fileIcon.add(newIcon);
        iconDock.myFileIcon.add(newIcon);
      }
      else { //if it's a folder
        String[] filenames2 = listFileNames(path+filenames[i]);
        File[] files2 = listFiles(path+filenames[i]);
        if(files2!=null) //HACK. why am suddenly I checking for this now? (now = June 17th, 2010)
          for(int j=0; j<files2.length; j++) {
            if(filenames2[j].indexOf(".txt")>=0) { //only if it's a text file
              newIcon = new FileIcon(files2[j], filenames[i],filenames2[j],-1);
              fileIcon.add(newIcon);
              iconDock.myFileIcon.add(newIcon);
            }
          }
      }
    }

    // ICON IDS
    try {
      String[] userInfo = loadStrings("icon.ids");
      for(int i=0;i<userInfo.length;i++) {
        String[] data = userInfo[i].split("-:-:-");
        FileIcon op = findIconByFile(new File(sketchPath+"/data/input/"+data[0]));
        if(op != null) {
          op.id = int(data[1]);
          println("\tID FOUND! "+data[1]);
        }
      }
    } 
    catch(Exception e)
    {
    } //*/
  }
}

