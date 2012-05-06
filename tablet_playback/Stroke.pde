class StrokePoint {
  float x=0;
  float y=0;
  // The position of the point relative to the frame
  float x_ratio=0;
  float y_ratio=0;
  float pressure=0;
  // Milliseconds since the applet started
  float time_millis=0;
  
  StrokePoint(float x, float y, float x_r, float y_r, float p) {
    this.x=x;
    this.y=y;
    this.x_ratio=x_r;
    this.y_ratio=y_r;
    this.pressure=p;
    this.time_millis = millis();
  }
  
  StrokePoint(StrokePoint another_point) {
    this.x=another_point.x;
    this.y=another_point.y;
    this.x_ratio=another_point.x_ratio;
    this.y_ratio=another_point.y_ratio;
    this.pressure=another_point.pressure;
    this.time_millis=another_point.time_millis;
  }
}

class TabletStroke {
  StrokePoint[] stroke_points;
  int current_point = 0;
  
  TabletStroke() {
    stroke_points = new StrokePoint[1024];
  }
  
  void add(float x, float y, float x_r, float y_r, float p) {
    stroke_points[current_point] = new StrokePoint(x,y,x_r,y_r,p);
    current_point++;
    if(current_point == stroke_points.length) {
      stroke_points = (StrokePoint[])expand(stroke_points);
    }
  }
  
  void add(StrokePoint newpoint) {
    stroke_points[current_point] = new StrokePoint(newpoint);
    current_point++;
    if(current_point == stroke_points.length) {
      stroke_points = (StrokePoint[])expand(stroke_points);
    }
  }  
  
  int numpoints() {
    return stroke_points.length;
  }
  
  float duration() {
    if(current_point > 0) {
      return stroke_points[current_point-1].time_millis-stroke_points[0].time_millis;
    }
    return 0;
  }
  
  float pathlength() {
    float len = 0;
    if(current_point == 0) { 
      return -1; 
    }
    if(current_point == 1) {
      return 0;
    }
    for(int i = 0; i < current_point-1; i++) {
      float dx = stroke_points[i].x-stroke_points[i+1].x;
      float dy = stroke_points[i].y-stroke_points[i+1].y;
      float stroke_length = sqrt(pow(dx,2)+pow(dy,2));
      len += stroke_length;
    }
    return len;
  }
}
