void setup() {
//  size(1366, 768);
  size(800, 600);
  stroke(192);
  strokeWeight(0.5);
  smooth();
//  noLoop();
}

void draw() {
  background(63);
//  triangle_grid(60);
  int k_limit = int(map(mouseY, 0, height, 1, 4));
  for(int k=0;k<k_limit; k++) {
    float j = map(float(k), 0, k_limit, 0, 10.0);
    crooked_lines(10, map(mouseX, 0, width, -j, j));
  }
}

void mouseClicked() {
  saveFrame("vertlines-####.png");
}

void crooked_lines(float top_spacing, float salt) {
  float smidge = 0.0;
  for(float x = -width; x < 2*width; x += top_spacing) {
    float x1 = x;
    float y1 = 0;
    float x2 = x + smidge;
    float y2 = height;
    line(x1, y1, x2, y2);
    smidge += salt;
  }
}

void triangle_grid(float triangle_size) {
  int i = 0;
  for(float y=0; y < height; y += (triangle_size / 2) * sqrt(3)) {
    line(0, y, width, y);
  }
  for(float x=-width;x < 2*width; x += triangle_size) {
    float t = height / sqrt(3);
    line(x, 0, x + t, height);
    line(x, 0, x - t, height);
  }  
}
