
void createPCB() {
  // (1 in the constructor = only one segment vert, since it's straight)  
  pcb = new Tube(this, 1, baseDetail);
  pcb.setSize(topRadius, topRadius, topRadius, topRadius, pcbThickness);
  pcb.fill(pcbColor);
  pcb.drawMode(Shape3D.SOLID);
  pcb.fill(pcbColor, BezTube.BOTH_CAP);
  pcb.drawMode(Shape3D.SOLID, BezTube.BOTH_CAP);
}


// draw the PCB holding ring, and the PCB too
void drawPCB() {
  pushMatrix();
  translate(0, -overallHeight+pcbRingThickness/2-tubeDia-0.1, 0);
  rotateX(HALF_PI);
  shininess(pcbShine);
  fill(tubeColor);
  
  // draw the ring slightly bigger, to grab weird lil bits in the tubes
  draw3DRing(topRadius+0.2, topRadius-pcbRingWidth, pcbRingThickness, 64);
  
  if (showPCB) {
    rotateX(-HALF_PI);
    translate(0,-pcbRingThickness/2-pcbThickness/2,0);
    pcb.draw();
    if (showAntenna) {
      translate(topRadius/2,-48-pcbThickness,0);    // black antenna body
      fill(0);
      sphere(3.9);
      drawCylinder(3.9,3.9,40.5, 24);
      translate(0,40.5,0);                            // copper antenna connector
      fill(184,115,51);
      shininess(copperShine);
      drawCylinder(4.5,4.5,8.5, 6);
    }
  }
  popMatrix();
}