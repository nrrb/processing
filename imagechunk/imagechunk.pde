PImage img;

void setup() {
  String path = selectInput();
  img = loadImage(path);
  size(400, 400);
  noLoop();
}

void draw() {
  PImage chunk = ImgChunk(img, 0, 0, 200, 200);
  PImage resized = new PImage(width, height);
  resized.copy(chunk, 0, 0, chunk.width, chunk.height, 0, 0, resized.width, resized.height);
  
  image(resized, 0, 0);
}

PImage ImgChunk(PImage img, int cornerx, int cornery, int chunkwidth, int chunkheight) {
  PImage imgchunk = createImage(chunkwidth, chunkheight, RGB);
  img.loadPixels();
  imgchunk.loadPixels();
  for(int x = 0; x < chunkwidth; x++) {
    for(int y = 0; y < chunkheight; y++) {
      int imgoffsetx = x + cornerx;
      int imgoffsety = y + cornery;
      // We want to make sure that we're not trying to get pixels off the edge of the supplied image
      if(imgoffsetx >= img.width) imgoffsetx = img.width-1;
      if(imgoffsety >= img.height) imgoffsety = img.height-1;
      imgchunk.pixels[y*imgchunk.width + x] = img.pixels[imgoffsety*img.width + imgoffsetx];
    }
  }
  imgchunk.updatePixels();
  return imgchunk;
}
