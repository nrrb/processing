PGraphics pg;
float tickmark_length = 10;

void setup() {
  size(600, 400);
  pg = createGraphics(1800, 1200, P2D);
  noLoop();
}

void draw() {
  pg.beginDraw();
  pg.background(255);
  pg.stroke(0);
  pg.strokeWeight(5);
//  float xstep = pg.width / 4;
//  float ystep = pg.height / 4;
  float xstep = 25;
  float ystep = 25;
//  float xtickstep = (float)pg.width / 16.0;
//  float ytickstep = (float)pg.height / 16.0;
  for(float x = 0; x <= pg.width; x += xstep) {
    pg.line(x, 0, x, pg.height);
//    for(float y = 0; y <= pg.height; y += ytickstep) {
//      pg.line(x - tickmark_length, y, x + tickmark_length, y);
//    }
  }
  for(float y = 0; y <= pg.height; y += ystep) {
    pg.line(0, y, pg.width, y);
//    for(float x = 0; x <= pg.width; x += xtickstep) {
//      pg.line(x, y - tickmark_length, x, y + tickmark_length);
//    }
  }
  pg.stroke(color(255, 0, 0));
  pg.line(0.5*pg.width, 0, 0.5*pg.width, pg.height);
  pg.line(0, 0.5*pg.height, pg.width, 0.5*pg.height);
  pg.stroke(color(0, 255, 0));
  pg.line(0.25*pg.width, 0, 0.25*pg.width, pg.height);
  pg.line(0.75*pg.width, 0, 0.75*pg.width, pg.height);
  pg.line(0, 0.25*pg.height, pg.width, 0.25*pg.height);
  pg.line(0, 0.75*pg.height, pg.width, 0.75*pg.height);
  pg.stroke(color(0, 0, 255));
  pg.line(0, 100, pg.width, 100);
  pg.line(100, 0, 100, pg.height);
  pg.line(0, pg.height-100, pg.width, pg.height-100);
  pg.line(pg.width-100, 0, pg.width-100, pg.height);
  pg.endDraw();
  image(pg, 0, 0, width, height);
  pg.save("calibration_grid4.png");
}
