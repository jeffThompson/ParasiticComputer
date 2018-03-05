
void drawCone(float dia, float len, float detail) {
  beginShape(TRIANGLE_STRIP);
  float angle = 0;
  float angleIncrement = TWO_PI / detail;
  for (int i=0; i<detail+1; ++i) {
    vertex(dia*cos(angle), 0, dia*sin(angle));
    vertex(0,len,0);
    angle += angleIncrement;
  }
  endShape();
}


void drawCylinder(float topRadius, float bottomRadius, float tall, int sides) {
  float angle = 0;
  float angleIncrement = TWO_PI / sides;
  beginShape(QUAD_STRIP);
  for (int i=0; i<sides+1; ++i) {
    vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
    vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
    angle += angleIncrement;
  }
  endShape();

  // top cap
  angle = 0;
  beginShape(TRIANGLE_FAN);
  vertex(0, 0, 0);
  for (int i=0; i<sides+1; i++) {
    vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
    angle += angleIncrement;
  }
  endShape();

  // bottom cap
  angle = 0;
  beginShape(TRIANGLE_FAN);
  vertex(0, tall, 0);
  for (int i=0; i<sides+1; i++) {
    vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
    angle += angleIncrement;
  }
  endShape();
}


void draw3DRing(float outerRadius, float innerRadius, float h, float detail) {
  
  float angleInc = TWO_PI / detail;
  
  // top
  beginShape(TRIANGLE_STRIP);
  for (float a=0; a<TWO_PI; a+=angleInc) {
    float x = cos(a) * outerRadius;
    float y = sin(a) * outerRadius;
    vertex(x, y, -h/2);
    
    x = cos(a+angleInc/2) * innerRadius;
    y = sin(a+angleInc/2) * innerRadius;
    vertex(x, y, -h/2);
  }
  endShape();
  
  // bottom
  beginShape(TRIANGLE_STRIP);
  for (float a=0; a<TWO_PI; a+=angleInc) {
    float x = cos(a) * outerRadius;
    float y = sin(a) * outerRadius;
    vertex(x, y, h/2);
    
    x = cos(a+angleInc/2) * innerRadius;
    y = sin(a+angleInc/2) * innerRadius;
    vertex(x, y, h/2);
  }
  endShape();
  
  // outer edge
  beginShape(QUAD_STRIP);
  for (float a=0; a<TWO_PI; a+=angleInc) {
    float x = cos(a) * outerRadius;
    float y = sin(a) * outerRadius;
    vertex(x, y, -h/2);
    vertex(x, y, h/2);
  }
  endShape();
  
  // inner edge
  beginShape(QUAD_STRIP);
  for (float a=0; a<TWO_PI; a+=angleInc) {
    float x = cos(a+angleInc/2) * innerRadius;
    float y = sin(a+angleInc/2) * innerRadius;
    vertex(x, y, -h/2);
    vertex(x, y, h/2);
  }
  endShape();
}