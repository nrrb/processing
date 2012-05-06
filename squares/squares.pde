int square_size = 10;

void setup() {
  size(1366, 768);
  background(0);
  stroke(color(255, 255, 255, 63));
  strokeWeight(0.5);
  noFill();
}

void draw() {
  int x = int(random(width/square_size))*square_size;
  int y = int(random(height/square_size))*square_size;
  rect(x, y, square_size, square_size);
}

void mouseClicked() {
  saveFrame("squares-####.png");
}
