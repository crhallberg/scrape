// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } 
  else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } 
  else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list ofall files in a directory and all subdirectories
ArrayList listFilesRecursive(String dir) {
  ArrayList fileList = new ArrayList(); 
  recurseDir(fileList,dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    // a.add(file);                           // DOES NOT WANT
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a,subfiles[i].getAbsolutePath());
    }
  } 
  else {
    a.add(file);
  }
}


//_____________________________________________
import java.io.OutputStream;
import java.io.InputStream;
import java.net.URLConnection;
import java.net.URL;
import java.net.Socket;

// FUNCTION!
// above url returns # we need here ------ V
int getLocalFileId(String fileName) {
  println("COMPARING "+fileName.toUpperCase());
  // MAKE SURE THE FILE EXITS
  File f = new File(dataPath(fileName));
  if (!f.exists()) {
    println("\t-File does not exist");
    return -1;
  }

  String id = "-1";    // -1 IS OUR ERROR CODE
  String CrLf = "\r\n";  // END OF LINE SHORTCUT
  URLConnection conn = null;
  OutputStream os = null;
  InputStream is = null;
  String boundary = "4546891219";  // CAN BE ANYTHING!

  try {
    // WHERE IS OUR pHp MAGIC?
    URL url = new URL("http://www.happyanalyzing.com/main/php/compare.php");
    conn = url.openConnection();
    conn.setDoOutput(true);

    // GET DATA FROM FILE
    InputStream summaryFile = createInput(fileName);
    byte[] summaryData = new byte[summaryFile.available()];
    summaryFile.read(summaryData);

    // HEADER INFO FOR THE FILE
    String message1 = "";
    message1 += "--" + boundary + CrLf;
    message1 += "Content-Disposition: form-data; name=\"file\";filename=\""+fileName+"\"" + CrLf;
    message1 += "Content-Type: plain/text" + CrLf;
    message1 += CrLf;

    // STRUCTURE TO SEND AUTHOR ID (for Authorization)
    String message2 = "";
    message2 += "--" + boundary + CrLf;
    message2 += "Content-Disposition: form-data; name=\"authorid\";" + CrLf;
    message2 += CrLf;
    message2 += userId+"";

    // PREPARE THE pHp FOR WHAT'S COMING
    conn.setRequestProperty("Content-Type", "multipart/form-data;boundary="+boundary);

    //println("open os");
    os = conn.getOutputStream(); // OPEN ROAD OUT

    print("-\tSending File");
    os.write(message1.getBytes());

    // SEND THE FILE
    int index = 0,size = 1024;
    do {
      print(".");
      if((index+size)>summaryData.length) {
        size = summaryData.length - index;
      }
      os.write(summaryData, index, size);
      index+=size;
    }
    while(index<summaryData.length);
    println(" SENT! (" + index + ")");

    // SEND THE AUTHOR ID
    println("-\tAuthenticating");
    //println(message2);
    os.write(message2.getBytes());
    os.flush();

    print("-\tReceiving ID: ");
    //println("open is");
    is = conn.getInputStream();  // OPEN ROAD IN

    // RECEIVE ID
    int len,buff = 512;
    int limit = 0;
    byte[] data = new byte[buff];
    do {
      len = is.read(data);
      if(len > 0 && limit++ < 45) {
        id = new String(data, 0, len);
        //print(new String(data, 0, len));
      }
    }
    while(len>0);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  finally {
    // CLOSE THE ROADS
    //println("Close connection");
    try {
      os.close();
    }
    catch(Exception e) {
    }
    try {
      is.close();
    }
    catch(Exception e) {
    }

    println(id+"\n");    // ANNOUNCE ACHIEVEMENT
    return int(id);      // RETURN ID
  }
}

