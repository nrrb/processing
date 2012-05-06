/**
 * Basic Drawing
 * by Andres Colubri. 
 * 
 * This program illustrates how to use the graphic tablet with the protablet library.
 */
 
import codeanticode.protablet.*;

Tablet tablet;
TabletStroke mystroke;

void setup() {
  size(640, 480);
  mystroke = new TabletStroke();
  tablet = new Tablet(this); 
  
  background(0);
  stroke(255);  
}

void draw() {
  float p = tablet.getPressure();
  if (mousePressed) {
    strokeWeight(30 * p);
    mystroke.add(mouseX, mouseY, mouseX/width, mouseY/height, p);
    // The tablet getPen methods can be used to retrieve the pen current and saved position
    // (requires calling tablet.saveState() at the end of draw())...
    //line(tablet.getSavedPenX(), tablet.getSavedPenY(), tablet.getPenX(), tablet.getPenY());
    
    // ...but it is equivalent to use built-in Processing's mouse variables.
    line(pmouseX, pmouseY, mouseX, mouseY);
  }
  println("Stroke length==" + mystroke.pathlength() + " stroke duration==" + mystroke.duration() + " stroke points==" + mystroke.numpoints());
  // The current values (pressure, tilt, etc.) can be saved using the saveState() method
  // and latter retrieved with getSavedxxx() methods:
  //tablet.saveState();
  //tablet.getSavedPressure();
}
