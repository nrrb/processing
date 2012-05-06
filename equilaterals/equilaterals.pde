float OPACITY = 0.2;
boolean PAUSED = false;

void setup() {
  size(1366, 768, P2D);
  colorMode(HSB, 1.0);
  background(color(1.0, 0.0, 0.0, 1.0));
}

void draw() {
  if(!PAUSED) {
    noStroke();
//    float tri_size = 60 * int(random(1.0, 3.0));
    float tri_size = 120;
    float x;
    float y;
    if(random(1.0) > 0.5) {
      x = int(random(width / tri_size)) * tri_size;
      y = sqrt(3) * tri_size * int(random(width / tri_size));
    }
    else {
      x = int(random(width / tri_size)) * tri_size + (tri_size / 2);
      y = sqrt(3) * tri_size * int(random(width / tri_size)) + (sqrt(3) / 2) * tri_size;
    }
    x += (tri_size / 4) * int(random(4.0));
    y += (sqrt(3) / 4) * tri_size * int(random(2.0));
    float rotation = (PI / 3) * int(random(3.0));
    boolean clockwise = (random(1.0) > 0.5 ? true : false);
    
    fill(color(map(x+y, 0, width+height, 0, 1.0), 1.0, 0.8, OPACITY));
    equilateral(x, y, tri_size, rotation, clockwise);
  }
}

void keyPressed() {
  PAUSED = !PAUSED;
}

void mouseClicked() {
  saveFrame("equilaterals-####.png");
}

void equilateral(float x, float y, float side, float theta, boolean clockwise) {
/*
   (x,y) - one corner of the equilateral triangle (x1, y1)
   
   side - the length of the triangle's sides
   
   theta (radians) - if we consider (x,y) to be the origin of a coordinate system and 
     side to represent the radius of a circle centered at the origin, theta
     is the angle of a point at (side, 0) rotated counter-clockwise as in 
     the typical direction of the unit circle rotation. In this way we calculate
     (x2, y2)=(side*cos(theta), side*sin(theta)) 
     
   clockwise - (x3, y3) will also be on the circle's circumference of radius side,
     just PI/3 relative to the side represented by (x1,y1)-(x2,y2). Clockwise indicates
     that this angle is theta+PI/3, and counter-clockwise (clockwise=false) indicates
     angle is theta-PI/3
*/
  float x1 = x;
  float y1 = y;
  float x2 = x + side * cos(theta);
  float y2 = y + side * sin(theta);
  float tri_angle;
  if(clockwise) {
    tri_angle = PI/3;
  }
  else {
    tri_angle = -PI/3;
  }
  float x3 = x + side * cos(theta + tri_angle);
  float y3 = y + side * sin(theta + tri_angle);
  triangle(x1, y1, x2, y2, x3, y3);
}
