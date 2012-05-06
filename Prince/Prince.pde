// pw - print width in inches
// ph - print height in inches
// dpi - dots per inch in the print
// npw - number of prints wide (the assembled mosaic representing the photo) - this must be an integer
// nph - number of prints high (not neil patrick harris) 
float pw = 6;
float ph = 4;
float dpi = 300;

// tw - target width of the photo in inches
// th - target height of the photo in inches
// Set them independently or set one and set the other to 
// 0 to have it autocorrected to retain the photo's aspect
// ratio in the target
float tw = 0; 
float th = 3*12; 

int npw, nph;
PImage img;

void setup() {
  // User picks the image to load
  String loadPath = selectInput();
  String savePath = selectFolder();
  println("Saving print images to " + savePath);
  if(loadPath == null) {
    println("No path loaded!");
    exit();
  }
  if(!isImageFilename(loadPath)) {
    println("This doesn't look like an image file!");
    exit();
  }
  img = loadImage(loadPath);
  if(img == null) {
    println("Unable to load image!");
    exit();
  }
  String[] pathchunks = split(loadPath, '\\');
  String filename = pathchunks[pathchunks.length - 1];
  println(filename);
    
  // Calculate the target width or height, depending on which one is specified
  float aspectRatio = (float)img.width / (float)img.height;
  if(tw <= 0) {
    if(th <= 0) {
      // Can't very well calculate one value without the other being set!
      println("Target width and height values not initialized.");
      exit();
    }
    else {
      tw = aspectRatio * th;
    }
  }
  if(th <= 0) {
    // Assuming tw is greater than 0
    th = (1.0 / aspectRatio) * tw; // To be clear how this is calculated
  }
  // Print the target width and height calculated to retain the photo's aspect ratio
  
  println("Target width = " + str(tw) + " inches");
  println("Target height = " + str(th) + " inches");
  // Print how many photos will be required, wait for confirmation to proceed
  npw = ceil(tw/pw);
  nph = ceil(th/ph);
  println("This will require " + str(npw) + " prints wide and " + str(nph) + " prints tall.");
  println("(Each print is " + str(pw) + "\" wide and " + str(ph) + "\" tall)");
  float whitespacew = pw*((float)ceil(tw/pw)-(tw/pw));
  float whitespaceh = ph*((float)ceil(th/ph)-(th/ph));
  println("There will be " + str(whitespacew) + " inches of whitespace at either side.");
  println("There will be " + str(whitespaceh) + " inches of whitespace at top or bottom.");
  // With prints with physical width pw and physical height ph, with dots per inch dpi, 
  // the resolution dimensions of each print will be (dpi*pw) x (dpi*ph)
  // 
  // Start splitting the image into chunks and individually blowing up to print resolution and save to file
  float imgstepx = (pw/tw)*(float)img.width;
  float imgstepy = (ph/th)*(float)img.height;
  int row, column;
  column = 0;
  for(float x = 0; x < (float)img.width; x += imgstepx) {
    row = 0;
    for(float y = 0; y < (float)img.height; y += imgstepy) {
      // Now we've found our origin/corner for the subrectangle of the image, we copy the pixels out
      // to a new image object we'll blow up into the print dimensions
      PImage imgchunk = ImgChunk(img, floor(x), floor(y), floor(imgstepx), floor(imgstepy));
      PImage printimage = createImage(ceil(dpi*pw), ceil(dpi*ph), RGB);
      printimage.copy(imgchunk, 0, 0, imgchunk.width, imgchunk.height, 0, 0, printimage.width, printimage.height);
      String printfilename = filename + "-" + str(npw) + "x" + str(nph) + "-" + str(column) + "x" + str(row) + ".png";
      String savePathFull = savePath + "\\" + printfilename;
//      println("Full save file path: " + savePathFull);
      printimage.save(savePathFull);
      row += 1;
    }
    column += 1;
  }

  // Display the image as a preview
  size(ceil(400*aspectRatio), 400);
}

void draw() {
  image(img, 0, 0, width, height);
}

// o_O  O__o   o__O  O_o   o__O  O_o o__O O__o  o_O O__o   o_O     O__o 
PImage ImgChunk(PImage img, int cornerx, int cornery, int chunkwidth, int chunkheight) {
  PImage imgchunk = createImage(chunkwidth, chunkheight, RGB);
  img.loadPixels();
  imgchunk.loadPixels();
  for(int x = 0; x < chunkwidth; x++) {
    for(int y = 0; y < chunkheight; y++) {
      int imgoffsetx = x + cornerx;
      int imgoffsety = y + cornery;
      if((imgoffsetx < img.width) && (imgoffsety < img.height)) {
        imgchunk.pixels[y*imgchunk.width + x] = img.pixels[(y + cornery)*img.width + (x+cornerx)];
      }
      else {
        imgchunk.pixels[y*imgchunk.width + x] = color(255);
      }
    }
  }
  imgchunk.updatePixels();
  return imgchunk;
}

boolean isImageFilename(String filePath) {
  filePath = filePath.toLowerCase();
  
  if(filePath.indexOf(".jpg") >= 0) {
    return true;
  }
  if(filePath.indexOf(".png") >= 0) {
    return true;
  }
  if(filePath.indexOf(".gif") >= 0) {
    return true;
  }
  if(filePath.indexOf(".bmp") >= 0) {
    return true;
  }
  return false;
}
