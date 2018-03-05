
class Sink {
  
  PVector bottom, top;            // start/end points
  float angle;                    // angle around origin (for drawing)
  BezTube initialTube, tube;      // smooth and mutated tubes
  float padRadius;
  PApplet sketch;                 // ref to sketch's "this" for BezTube class
  
  ArrayList<Spike> spikes = new ArrayList<Spike>();
  
  Sink (PApplet _sketch, PVector _bottom, PVector _top, float _angle, float _tubeDia, int _numSeg, int _tubeDetail, boolean hasSpikes) {
    sketch =      _sketch;
    bottom =      _bottom;
    top =         _top;
    angle =       _angle;
    tubeDia =     _tubeDia;
    numSegments = _numSeg;
    tubeDetail =  _tubeDetail;
    
    // create initial tube (smooth) and mutated one
    generateInitialTube();
    mutateTube();    
    
    // set cap color
    initialTube.fill(initColor, BezTube.BOTH_CAP);
    initialTube.drawMode(Shape3D.SOLID, BezTube.BOTH_CAP);
    tube.fill(tubeColor, BezTube.BOTH_CAP);
    tube.drawMode(Shape3D.SOLID, BezTube.BOTH_CAP);
  
    // set color of the sides too
    initialTube.fill(initColor);
    initialTube.drawMode(Shape3D.SOLID);
    tube.fill(tubeColor);
    tube.drawMode(Shape3D.SOLID);
    
    // if spikes specified for this tube, add them
    if (hasSpikes) addSpikes();
    
    // set diameter of bottom pad based on dist from center
    padRadius = map(bottom.x, 0,bottomRadius, maxPadRadius,minPadRadius);
  }
  
  void generateInitialTube() {
    // bottom control point right in the middle vertically
    PVector controlB = new PVector(bottom.x, 0, bottom.z);
    
    // top control point halfway b/w the top and bottom radii
    //float xOffset = (bottomRadius-topRadius)/2;
    
    // top control point changes depending on dist tube travels
    float d = bottom.x - top.x;
    //float xOffset = map(d, -topRadius,bottomRadius-topRadius, topRadius,(bottomRadius-topRadius)/2);
    float xOffset = map(d, -topRadius,bottomRadius-topRadius, ctlPtMin, ctlPtMax);
    PVector controlT = new PVector(top.x*xOffset, top.y, top.z);
  
    // create an initial tube from the start/end and control points
    // (if specified, add points below the bottom)
    PVector[] initialPoints;
    if (!extendBelow) {
      initialPoints = new PVector[] {
        bottom, controlB, controlT, top
      };
    }
    else {
      initialPoints = new PVector[] {
        PVector.add(bottom, new PVector(0,extensionLen,0)), bottom, controlB, controlT, top
      };
    }
    initialTube = new BezTube(
      sketch, 
      new P_Bezier3D(initialPoints, initialPoints.length), 
      tubeDia/2,
      numSegments, 
      tubeDetail
    );
  }
  
  void mutateTube() {
    // get all points from the temp tube, mutate and
    // create a new tube with them
    PVector[] outPoints = new PVector[numSegments];
    for (int step=0; step<numSegments; step++) {
      PVector pt = initialTube.getPoint(step / float(numSegments-1));
  
      // mutate all points except first and last two
      // (mutate points in the middle more than the ends)
      if (step > 2 && step < numSegments-4) {
        float m;
        if (step <= numSegments/2) {
          m = map(step, 2,numSegments/2, 0,mutAmt);
        }
        else {
          m = map(step, numSegments/2+1,numSegments-4, mutAmt,0);
        }
        pt.x += random(-m,m);
        pt.z += random(-m,m);
      }
      outPoints[step] = new PVector(pt.x, pt.y, pt.z);
    }
    tube = new BezTube(
      sketch, 
      new P_Bezier3D(outPoints, outPoints.length), 
      tubeDia, 
      numSegments, 
      tubeDetail
    );
  }
  
  void addSpikes() {
    
    // no spikes 5% up from bottom and 25% from top
    int startOffset = floor(numSegments * 0.05);
    int endOffset =   floor(numSegments * 0.25);
    
    // generate them
    for (int i=startOffset; i<numSegments-endOffset; i++) {
      if (random(100) < chanceSpike) {
        float pos = i / float(numSegments-1);
        PVector pt = tube.getPoint(pos);
        PVector direction = tube.getTangent(pos);    
        float len = random(minSpikeLen, maxSpikeLen);
        Spike s = new Spike(sketch, pt, direction, len);
        spikes.add(s);
      }
    }
  }
  
  void display() {
    pushMatrix();
    rotateY(angle);
    
    shininess(copperShine);
    tube.draw();
    
    if (showSpikes) {
      for (Spike s : spikes) {
        s.display();
      }
    }
    
    if (drawInitialTubes) {
      initialTube.draw();
    }
    
    // add a tiny offset down to avoid conflicting triangles with tubes
    if (showBottom) {
      pushMatrix();
      translate(bottom.x, bottom.y-baseThickness+0.1, bottom.z);
      fill(tubeColor);
      drawCylinder(padRadius,padRadius, baseThickness, tubeDetail*2);
      popMatrix();
    }
    popMatrix();
  }  
}



  