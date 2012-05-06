float xmin = -2.5; 
float ymin = -2; 
float wh = 4;
float xmax = xmin + wh;
float ymax = ymin + wh;
int print_width_inches = 6;
int print_height_inches = 4;
int print_dpi = 300;
int print_width_pixels = print_dpi * print_width_inches;
int print_height_pixels = print_dpi * print_height_inches;
int canvas_size_inches = 96; // 8 feet! floor to ceiling canvas; we're using a square window on the fractal
int canvas_size_pixels = print_dpi * canvas_size_inches;
int canvas_width_prints = canvas_size_pixels / print_width_pixels;  // how many prints we'll need to fill a row
int canvas_height_prints = canvas_size_pixels / print_height_pixels;  // how many prints we'll need to fill a column
int num_prints = canvas_width_prints * canvas_height_prints; // how many actual prints we'll need
// the window for each print, on the complex plane, is defined by (x, y) -> (x + print_x_window, y + print_y_window) 
// for some (x, y)
float print_x_window = wh / float(canvas_width_prints); 
float print_y_window = wh / float(canvas_height_prints);

PGraphics fractal_full_preview;
PGraphics fractal_piece;

PFont pf;

void setup() {
  pf = loadFont("Shruti-48.vlw");
  textFont(pf, 48);
  size(600, 600, P2D);            
  fractal_full_preview = createGraphics(600, 600, P2D);
  fractal_piece = createGraphics(print_width_pixels, print_height_pixels, P2D);
//  noLoop();
  background(255);
  fractal_full_preview = DrawMandel(fractal_full_preview, xmin, ymin, xmax, ymax);
//  CalculatePrints();
}

void draw() {
  image(fractal_full_preview, 0, 0, width, height);
  // Draw a grid of lines on the fractal to show how it would be broken down into prints
  stroke(color(255, 0, 0, 31));
  for(int column = 1; column < canvas_width_prints; column++) {
    float x = map(column, 0, canvas_width_prints, 0, width);
    line(x, 0, x, height);
  }
  for(int row = 1; row < canvas_height_prints; row++) {
    float y = map(row, 0, canvas_height_prints, 0, height);
    line(0, y, width, y);
  }
  // Fancy highlighting rectangle that follows the mouse, showing the row and column coordinates for the corresponding print
  fill(color(255, 0, 0, 127));
  rectMode(CORNERS);
  int column_mouse_hovering = (int)map(mouseX, 0, width, 0, canvas_width_prints);
  int row_mouse_hovering = (int)map(mouseY, 0, height, 0, canvas_height_prints);
  int rect_min_x = (int)map(column_mouse_hovering, 0, canvas_width_prints, 0, width);
  int rect_min_y = (int)map(row_mouse_hovering, 0, canvas_height_prints, 0, height);
  int rect_max_x = (int)map(1+column_mouse_hovering, 0, canvas_width_prints, 0, width);
  int rect_max_y = (int)map(1+row_mouse_hovering, 0, canvas_height_prints, 0, height);
  rect(rect_min_x, rect_min_y, rect_max_x, rect_max_y);
  // Print in the corner the (column, row) of the selected rectangle
  String coordinates = "(" + str(column_mouse_hovering+1) + ", " + str(row_mouse_hovering+1) + ")";
  text(coordinates, 48, 48);
}

void CalculatePrints() {
  int row = 1;
  for(float y = ymin; y < ymax; y+= print_y_window) {
    int column = 1;
    for(float x = xmin; x < xmax; x += print_x_window) {
      float x2 = x + print_x_window;
      float y2 = y + print_y_window;
//      println("(" + x + "," + y + "," + x2 + "," + y2 + ")");
      fractal_piece = DrawMandel(fractal_piece, x, y, x2, y2);
      fractal_piece.save("row" + str(row) + "-column" + str(column) +  "("+str(xmin)+","+str(ymin)+","+str(xmax)+","+str(ymax)+").png");
      column += 1;
    }
    row += 1;
  }
}

PGraphics DrawMandel(PGraphics pg, float xmin, float ymin, float xmax, float ymax) {
  // The core of this routine was written by Daniel Shiffman, taken from his Mandelbrot Set example for Processing
  /**
  * The Mandelbrot Set
  * by Daniel Shiffman.  
  * 
  * Simple rendering of the Mandelbrot set.
  */
  pg.beginDraw();
  pg.loadPixels();
  pg.background(255);
  // Maximum number of iterations for each point on the complex plane
  int maxiterations = 400;

  
  // Calculate amount we increment x,y for each pixel
  float dx = (xmax - xmin) / (pg.width);
  float dy = (ymax - ymin) / (pg.height);

  // Start y
  double y = (double)ymin;
  for (int j = 0; j < pg.height; j++) {
    // Start x
    double x = (double)xmin;
    for (int i = 0;  i < pg.width; i++) {
      
      // Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
      double a = (double)x;
      double b = (double)y;
      int n = 0;
      while (n < maxiterations) {
        double aa = a * a;
        double bb = b * b;
        double twoab = 2.0 * a * b;
        a = aa - bb + x;
        b = twoab + y;
        // Infinty in our finite world is simple, let's just consider it 16
        if(aa + bb > 16.0) {
          break;  // Bail
        }
        n++;
      }
      
      // We color each pixel based on how long it takes to get to infinity
      // If we never got there, let's pick the color black
      if (n == maxiterations) {
        pg.pixels[i+j*pg.width] = color(0);
      } else {
        // Gosh, we could make fancy colors here if we wanted
        if(a*b>0) {
          pg.pixels[i+j*pg.width] = color(0);
        } else {
          pg.pixels[i+j*pg.width] = color(255);
        }
      }
      x += (double)dx;
    }
    y += (double)dy;
  }
  pg.updatePixels();
  pg.endDraw();
  return pg;
}

