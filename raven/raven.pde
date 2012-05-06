PShape raven;

void setup() {
  raven = loadShape("raven.svg");
  size(400, 400);
//  shapeMode(CENTER);
}

void draw() {
  background(255);
//  raven.scale(map(mouseX, 0, width, 0.99, 1.0/0.99));
//  translate(mouseX, mouseY);
  shape(raven);
}
