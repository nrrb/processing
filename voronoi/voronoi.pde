/*
 
 <b>Non-interactive <a href="http://en.wikipedia.org/wiki/Voronoi_diagram">Voronoi Diagram</a></b><br />
 <br />
 The points comprising the Voronoi set are randomly placed and essentially do<br />
 random walks independently.<br />

 */
 
 int numPoints = 10;
//float[] pointX = new float[numPoints];
//float[] pointY = new float[numPoints];
int[] pointX = new int[numPoints];
int[] pointY = new int[numPoints];
color[] pointColor = new color[numPoints];
int[] pointMembers = new int[numPoints];

void setup()
{
  size(200, 200);
  background(random(0, 255), random(0, 255), random(0, 255));
  
  frameRate(1);
  
  for(int i = 0;i < numPoints;i++)
  {
//    pointX[i] = random(0, width);
//    pointY[i] = random(0, height);
    pointX[i] = floor(random(0, width));
    pointY[i] = floor(random(0, height));
    pointColor[i] = color(0);
    pointMembers[i] = 0;
  }
//  noLoop();
}

void draw()
{
  for(int y = 0;y < height;y++)
  {
    for(int x = 0;x < width;x++)
    {
      int closestPoint = numPoints;
      int mindist = height * width;
      for(int i = 0;i < numPoints;i++)
      {
//        int distance = floor(
//                        (pointX[i] - (float)x) * (pointX[i] - (float)x) + 
//                        (pointY[i] - (float)y) * (pointY[i] - (float)y));
        int distance = (pointX[i] - x) * (pointX[i] - x) + 
                        (pointY[i] - y) * (pointY[i] - y);
        if(distance < mindist)
        {
          mindist = distance;
          closestPoint = i;
        }
      }
      if(closestPoint < numPoints)
      {
        pointMembers[closestPoint]++;
        stroke(pointColor[closestPoint]);
        point(x, y);
      }
    }
  }
  
  for(int i = 0; i < numPoints; i++) {
    stroke(color(0));
    rectMode(CENTER);
    rect(pointX[i], pointY[i], 5, 5);
  }

  // Find the maximum number of point members so we can
  // scale the color accordingly  
  int maxMembers = 0;
  for(int i = 0;i < numPoints;i++)
  {
    if(pointMembers[i] > maxMembers) 
      maxMembers = pointMembers[i];
  }
  
  for(int i = 0;i < numPoints;i++)
  {
//    pointX[i] += floor(random(0, 3)) - 1;
//    pointY[i] += floor(random(0, 3)) - 1;
//    pointX[i] += random(-1, 1);
//    pointY[i] += random(-1, 1);

    // Setting constraints so we don't lose our points off 
    // the sides of the windows, and the sides wrap
    if(pointX[i] < 0) pointX[i] = width - 1;
    if(pointX[i] >= width) pointX[i] = 0; 
    if(pointY[i] < 0) pointY[i] = height - 1;
    if(pointY[i] >= height) pointY[i] = 0;
    
    // Now reset the color for the next go-around based on
    // the current number of members. This is not completely 
    // accurate coloring because it's based on the last state
    // of the points, but it's the best I can do right now.
    float color_multiplier = (float)pointMembers[i]/(float)maxMembers;
    pointColor[i] = color(255 * color_multiplier, 255 * (1 - color_multiplier), 0);
    // Reset the point members array back to 0 for the next round
    pointMembers[i] = 0;
  }  
}
