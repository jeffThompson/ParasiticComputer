
void mouseReleased() {
  println("new PVector(" + angleX + ", 0, " + angleZ + ")");
}


void keyPressed() {
  if (key == CODED) {
    
    // L/R arrow keys to toggle through preset views
    if (keyCode == RIGHT) {
      whichPreset += 1;
      if (whichPreset == presets.length) whichPreset = 0;
      angleX = presets[whichPreset].x;
      angleZ = presets[whichPreset].z;
    }
    else if (keyCode == LEFT) {
      whichPreset -= 1;
      if (whichPreset == -1) whichPreset = presets.length-1;
      angleX = presets[whichPreset].x;
      angleZ = presets[whichPreset].z;
    }
    
    // U/D zooms in and out
    if (keyCode == UP) {
      zoom *= 1.1;
      println("zoom: " + zoom);
    }
    else if (keyCode == DOWN) {
      zoom *= 0.9;
      println("zoom: " + zoom);
    }    
  }
  
  // other keys toggle diff modes
  if (key == 'o')      showOrigin = !showOrigin;
  else if (key == 'b') showBottom = !showBottom;
  else if (key == 'p') showPCB = !showPCB;
  else if (key == 'g') showTEG = !showTEG;
  else if (key == 'i') drawInitialTubes = !drawInitialTubes;
  else if (key == 'k') showSpikes = !showSpikes;
  else if (key == 'a') showAntenna = !showAntenna;
  
  // reset with new seed
  else if (key == 'r') {
    randomSeed += 1;
    println("new random seed: " + randomSeed);
    setup();
  }
  
  // save the model to OBJ
  else if (key == 'm') saveModel = true;
  
  // take a screenshot
  else if (key == 's') {
    String path = screenshotDir + year() + "-" + nf(month(),2) + "-" + nf(day(),2) + "_" + nf(hour(),2) + "-" + nf(minute(),2) + "-" + nf(second(),2) + ".jpg";  
    save(path);
  }
}