class DepthMap {
  int width;
  int height;
  int[][] depth_array;
  int max_depth=128;
  
  DepthMap(PImage src_img) {
    this.width = src_img.width;
    this.height = src_img.height;
    depth_array = new int[this.width][this.height];
    for(int y = 0; y < src_img.height; y++) {
      for(int x = 0; x < src_img.width; x++) {
        depth_array[x][y] = int(brightness(src_img.pixels[y*src_img.width + x]));
        depth_array[x][y] = (depth_array[x][y] * max_depth) / 255;
      }
    }
  }
  
  int depth(int x, int y) {
    return this.depth_array[x][y];
  }
}
