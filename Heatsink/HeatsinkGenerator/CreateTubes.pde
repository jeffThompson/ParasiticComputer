
void createConcentricTubes() {
  float outsideRadius = bottomRadius - tubeDia;
  float radius = 0;
  while (radius <= outsideRadius) {
    float angle = 0.01;
    float angleInc = HALF_PI * concentricSpacing / radius;
    while (angle < TWO_PI && angle != 0) {
      PVector t = new PVector(topRadius, -overallHeight, 0);
      PVector b = new PVector(radius, overallHeight, 0);
      
      //float amt = 10;
      //float offset;
      //if (angle <= HALF_PI) {
      //  offset = map(angle, 0,HALF_PI, 0,amt);
      //}
      //else if (angle > HALF_PI && angle < PI) {
      //  offset = map(angle, HALF_PI,PI, amt,0);
      //}
      //else if (angle > PI && angle < PI+HALF_PI) {
      //  offset = map(angle, PI,PI+HALF_PI, 0,amt);
      //}
      //else {
      //  offset = map(angle, PI+HALF_PI,TWO_PI, amt,0);
      //}    
      //PVector b = new PVector(radius, overallHeight+offset, 0);
      
      boolean addSpikes = false;
      if (radius + concentricSpacing >= outsideRadius) {
        addSpikes = true;
      }        
      
      tubes.add( new Sink(this, b, t, angle, tubeDia, numSegments, tubeDetail, addSpikes) );
      angle += angleInc;
    }
    radius += concentricSpacing;
  }
}


void createSpiralTubes() {
  boolean startInCenter = true;                  // first tube in center?
  float outsideRadius = bottomRadius - tubeDia;  // offset for tube dia
  float insideRadius = spiralSpacing;            // < this does weird stuff
  PVector t, b;                                  // top/bottom positions
  float radius = 0;                              // current radius...
  float angle = 0;                               // ...and angle
  float endAngle = numTurns * TWO_PI;            // where to end
  
   // create angle offset based on starting direction
  float angleOffset = 0;
  if (initialDir == UP) {
    angleOffset = -HALF_PI;
  }
  else if (initialDir == DOWN) {
    angleOffset = HALF_PI;
  }
  else if (initialDir == LEFT) {
    angleOffset = PI;
  }
  
  // draw the first point in the center?
  if (startInCenter) {
    t = new PVector(topRadius, -overallHeight, 0);
    b = new PVector(0, overallHeight, 0);
    tubes.add( new Sink(this, b, t, angleOffset, tubeDia, numSegments, tubeDetail, false) );
  }
  
  // create all other points
  while (true) {
    radius = map(angle, 0, endAngle, insideRadius, outsideRadius);
    
    // if past the outside radius, stop
    if (radius >= outsideRadius) {
      return;
    }
    
    // add this new tube
    t = new PVector(topRadius, -overallHeight, 0);
    b = new PVector(radius, overallHeight, 0);
    tubes.add( new Sink(this, b, t, angle+angleOffset, tubeDia, numSegments, tubeDetail, false) );
    
    // update angle
    angle += spiralSpacing / radius;
  }
}