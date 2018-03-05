
class Spike {
  
  PVector start;
  float angleX, angleY;
  float len, dia;
  PApplet sketch;
  
  Spike (PApplet _sketch, PVector _start, PVector direction, float _len) {
    sketch = _sketch;
    start = _start;
    len = _len;
    dia = tubeDia * 0.8;    // if equal, sticks out the sides a bit
    
    // convert direction into angles
    // 3D angle can be created through just X/Y angles
    angleX = acos(PVector.dot(direction, new PVector(0,1,0)) / (direction.mag() * 1));
    angleY = acos(PVector.dot(direction, new PVector(1,0,0)) / (direction.mag() * 1));
  }
  
  void display() {
    fill(tubeColor);
    
    pushMatrix();
    translate(start.x, start.y, start.z);
    rotateX(angleX);
    rotateY(angleY);
    rotateX(HALF_PI + QUARTER_PI);     // face outward
    
    //sphere(random(tubeDia*1.5, tubeDia*2.5));
    drawCone(dia, len, tubeDetail);
    
    popMatrix();
  }
}