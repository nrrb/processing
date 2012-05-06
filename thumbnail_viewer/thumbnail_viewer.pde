int num_rows = 12;
// How many images we'll actually try to load
int num_images = 200;
String images_source_path = "Z:/porn/pictures/Images/Tumblr 1-77";
String image_extension = ".jpg";

int row_height; // this depends on the height of the window
PImage[] images;
PImage[] thumbnails;
float[] aspect_ratios;
// This is where the first loaded images will be added
int current_row = 0;


boolean IMAGES_LOADED = false;

ArrayList[] row_images;


void setup() {
  size(1280, 1000);
  row_height = height / num_rows;
  row_images = new ArrayList[num_rows];
  images = new PImage[num_images];
  thumbnails = new PImage[num_images];
  aspect_ratios = new float[num_images];
  String[] filenames = listFileNames(images_source_path);
  
  for(int i = 0; i < num_rows; i++) {
    row_images[i] = new ArrayList(0);
  }  

  for(int i = 0; i < num_images; i++) {
    images[i] = requestImage(filenames[i]);
  }
//  frameRate(1);
}

void draw() {
  background(0);
  // This should draw images as they become available
  for(int row = 0; row < row_images.length; row++) {
    int xoffset = 0;
    if(row_images[row] != null) {
      for(int j = 0; j < row_images[row].size(); j++) {
        PImage thumbnail = (PImage) row_images[row].get(j);
        image(thumbnail, xoffset, row*row_height, thumbnail.width, thumbnail.height);
        xoffset += thumbnail.width;
      }
      if(row_images[row].size() > 0) {
//        println("Frame " + frameCount + ": row " + row + " has " + row_images[row].size() + " images.");
      }
    }
  }
  
  // We have one flag variable that, once all the images are loaded, prevents us from having to go 
  // back through the entire array looking for ones that need processing
  if(!IMAGES_LOADED) {
    IMAGES_LOADED = true;
    int num_not_loaded = 0;
    for(int image_num = 0; image_num < num_images; image_num++) {
      if(images[image_num].width <= 0) {
        IMAGES_LOADED = false;
        num_not_loaded++;
      }
      else {
        // We don't want to recreate a thumbnail of we've already done it
        if(thumbnails[image_num] == null) {
          aspect_ratios[image_num] = (float)images[image_num].width / (float)images[image_num].height;
          int thumbnail_height = row_height;
          int thumbnail_width = (int)(aspect_ratios[image_num] * (float)thumbnail_height);
          images[image_num].resize(thumbnail_width, thumbnail_height);
          thumbnails[image_num] = images[image_num];
          // Add this image to the end of the next available row
          for(int row = 0; row < num_rows; row++) {
            int row_width = 0;
            for(int i = 0; i < row_images[row].size(); i++) {
              row_width += ((PImage)row_images[row].get(i)).width;
            }
// This method checks if adding this image will make the row extend beyond the width of the screen
//            if(row_width + thumbnails[image_num].width < width) {
// This method will try to fill the row so no empty space appears, even if the last image draws partially off screen
            if(row_width < width) {
              // This row has enough room to take the next image
              row_images[row].add(thumbnails[image_num]);
              break;
            }
          }
        }
      }
    }
//    println("frames: " + frameCount + " [images that still need to be loaded: " + num_not_loaded + "]");
  }
}

/*
The following directory listing code is borrowed from Daniel Shiffman's Processing example for a Directory Listing
http://processing.org/learning/topics/directorylist.html
*/
// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  FilenameFilter filter_ext = new FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(image_extension);
    }
  };
  
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(filter_ext);
    for(int i = 0; i < names.length; i++) {
      names[i] = dir + "/" + names[i];  // Otherwise it just returns the filename, and I want the full path
    }
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
