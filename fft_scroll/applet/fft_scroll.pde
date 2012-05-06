/**
 * Spectrum wave
 * Based on
 * Forward FFT
 * by Damien Di Fede.
 */

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
FFT fft;

float camera_distance = 2048.0;
int bands_count = 64;
int boxes_count = 32;
int box_width = 48;
int box_depth = 32;
float band_multiplier = 256.0;
int width_gap = 16;
int depth_gap = 32;
float bar_opacity = 0.25;
float min_hue = 0.0;
float max_hue = 0.3;

float center_x = (boxes_count * (box_width + width_gap)) / 2;
float center_y = 0.0;
float center_z = -(bands_count * (box_depth + depth_gap)) / 2;


LinkedList bands;

void setup()
{
  size(512, 512, P3D);

  minim = new Minim(this);
  bands = new LinkedList();
  jingle = minim.loadFile("skrillex.mp3", 2048);
  jingle.loop();
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
//  frameRate(30);
}

void draw()
{
  lights();
  colorMode(HSB, 1.0);
  background(color(0.7, 0.2, 0.2));
//  background(1);
  noStroke();
  noFill();
  fft.forward(jingle.mix);
    float[] band_sizes = new float[boxes_count];
  for(int i = 0; i < boxes_count; i++) {
    band_sizes[i] = fft.getBand(int(map(i, 0, boxes_count, 0, fft.specSize())));
  }
  bands.add(band_sizes);
  if(bands.size() > bands_count) {
    bands.removeFirst();
  }
  
  for(int i = 0; i < bands.size(); i++) {
    translate(0, 0, -(box_depth+depth_gap));
    float[] this_band = (float [])bands.get(i);
    pushMatrix();
    for(int j = 0; j < this_band.length; j++) {
      float percent_x = map(j, 0, this_band.length, 0, 1.0);
//      stroke(0);
//      stroke(color(map(percent_x, 0, 1.0, min_hue, max_hue), 1.0, 1.0, bar_opacity));
//      fill(color(1.0, 1.0, 1.0, bar_opacity));
      stroke(color(1.0, 1.0, 0.8, 0.25));
//      fill(color(1.0, 0.0, 1.0));
      
      translate(box_width+width_gap, 0, 0);
      int box_height = int(band_multiplier*log(this_band[j]));
//      stroke(color(0.0, 0.0, map(float(box_height), 0, 1024, 0.3, 0.9), 0.5));
      if(box_height > 0) {
        pushMatrix();
        translate(0, -box_height/2, 0);
        box(box_width, box_height, box_depth);
        popMatrix();
      }
    }
    popMatrix();
  }
  float theta = map(mouseX, 0, width, 0, 2*PI);
  float x = map(cos(theta), -1.0, 1.0, center_x-camera_distance, center_x+camera_distance);
  float y = map(mouseY, 0, height, -2*camera_distance, 2*camera_distance);
  float z = map(sin(theta), -1.0, 1.0, center_z-camera_distance, center_z+camera_distance);
  camera(x, y, z, 
         center_x, center_y, center_z, 
         0.0, 1.0, 0.0);
}

void stop()
{
  // always close Minim audio classes when you finish with them
  jingle.close();
  minim.stop();
  
  super.stop();
}

void mouseClicked() {
//  saveFrame("frame####.png");
}

