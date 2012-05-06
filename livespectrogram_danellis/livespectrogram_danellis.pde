/**
 * LiveSpectrogram
 * Takes successive FFTs and renders them onto the screen as grayscale, scrolling left.
 *
 * Dan Ellis dpwe@ee.columbia.edu 2010-01-15
 */
 
import ddf.minim.analysis.*;
import ddf.minim.*;
 
Minim minim;
AudioInput in;
FFT fft;
int colmax = 500;
int rowmax = 256;
int[][] sgram = new int[rowmax][colmax];
int col;
int leftedge;


void setup()
{
  size(512, 256, P3D);
  textMode(SCREEN);
 
  minim = new Minim(this);
   
  in = minim.getLineIn(Minim.STEREO,2048);
 
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.window(FFT.HAMMING);
}
 
void draw()
{
  background(0);
  stroke(255);
  // perform a forward FFT on the samples in the input buffer
  fft.forward(in.mix);

  for(int i = 0; i < rowmax /* fft.specSize() */; i++)
  {
    // fill in the new column of spectral values
    sgram[i][col] = (int)Math.round(Math.max(0,2*20*Math.log10(1000*fft.getBand(i))));
  }
  // next time will be the next column
  col = col + 1; 
  // wrap back to the first column when we get to the end
  if (col == colmax) { col = 0; }
  
  // Draw points.  
  // leftedge is the column in the ring-filled array that is drawn at the extreme left
  // start from there, and draw to the end of the array
  for (int i = 0; i < colmax-leftedge; i++) {
    for (int j = 0; j < rowmax; j++) {
      stroke(sgram[j][i+leftedge]);
      point(i,height-j);
    }
  }
  // Draw the rest of the image as the beginning of the array (up to leftedge)
  for (int i = 0; i < leftedge; i++) {
    for (int j = 0; j < rowmax; j++) {
      stroke(sgram[j][i]);
      point(i+colmax-leftedge,height-j);
    }
  }
  // Next time around, we move the left edge over by one, to have the whole thing
  // scroll left
  leftedge = leftedge + 1; 
  // Make sure it wraps around
  if (leftedge == colmax) { leftedge = 0; }
}
 
 
void stop()
{
  // always close Minim audio classes when you finish with them
  in.close();
  minim.stop();
 
  super.stop();
}
 
