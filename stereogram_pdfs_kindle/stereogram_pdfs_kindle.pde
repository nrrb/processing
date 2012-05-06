// Stereoscopic "magic eye" images in grayscale, output
// to PDF file for use on an Amazon Kindle e-paper reading 
// device. 
// v0.1 - Implement rendering of text to image as black and white
//        for a simple source of a stereogram with only one 
//        level
// v0.2 - Implement the stereoscope algorithm/function, that 
//        takes as input a source image and outputs the 
//        stereoscopic image
//     
int kindle_render_width = 800;
int kindle_render_height = 600;
int kindle_ppi = 72;
// How many shades of grey the Kindle 3 display supports
int kindle_color_depth = 2;

int[] look_left;
int[] pixel_line;

int observer_distance = 12 * kindle_ppi;
int eye_separation = int(2.5 * float(kindle_ppi));

int feature_z, sep;

DepthMap depth_map;

void setup() {
  look_left = new int[kindle_render_width];
  pixel_line = new int[kindle_render_width];
  
  size(kindle_render_width, kindle_render_height);
  PImage src_img = loadImage("data/shark.png");
  depth_map = new DepthMap(src_img);
  noLoop();
}

void draw() {
  for(int y = 0; y < height; y++) {
    // Set up the default positions for the look-left reference array
    for(int x = 0; x < width; x++) {
      look_left[x] = x;
    }
    // Modifying the look-left references based on the depth map
    for(int x = 0; x < width; x++) {
      int feature_z = depth_map.depth(x, y);
      int sep = (eye_separation * feature_z) / (feature_z + observer_distance);
      int left = x - sep/2;
      int right = left + sep;
      if((left >= 0) && (right < width)) look_left[right] = left;
    }
    // 
    for(int x = 0; x < width; x++) {
      if(look_left[x]==x) {
        pixel_line[x] = random_color();
      }
      else {
        pixel_line[x] = pixel_line[look_left[x]];
      }
    }
    for(int x = 0; x < width; x++) {
      set(x, y, pixel_line[x]);
    }
  }  
}

color random_color() {
  int grey_scale = int(map(random(kindle_color_depth), 0, kindle_color_depth, 0, 255));
  return color(grey_scale);
//  return color(random(255), random(255), random(255));
}
