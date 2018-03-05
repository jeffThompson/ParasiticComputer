
void runTransformations() {
 
  // start OBJ export, if specified
  if (saveModel) {
    println("Starting OBJ export...");
    beginRecord("nervoussystem.obj.OBJExport", modelFilename);
    
    // translate to TEG, so we can do boolean stuff at origin later
    translate(0,overallHeight+tegOffset,0);
    rotateZ(PI);
  }
  
  // camera, lights, and transformations (don't do these if recording, 
  // so model is at 0,0,0)
  if (!saveModel) {
    camera(1000,-200,500, width/2,height/2,0, 0,1,0);
    ambientLight(102,102,102);
    lightSpecular(204,204,204);
    directionalLight(102,102,102, 0, 0, -1);
    specular(100);
    
    translate(width/2, height/2, 0);
    scale(zoom);
    if (mousePressed) {
      angleX = map(mouseY, 0,height, PI,-PI);
      angleZ = map(mouseX, 0,width, PI,-PI);
    }
    if (!saveModel) {
      rotateX(angleX);
      rotateZ(angleZ);
      rotateY(angleY);
    }
    angleY += 0.005;
    
    //flat.set("LDir", (mouseX / float(width) - 0.5) * 2, 1f, 3f );
    //flat.set("surfaceColor",.5f,.5f,1.f);
  }
}