
import shapes3d.*;              // bezier tube generation
import shapes3d.utils.*;
import nervoussystem.obj.*;     // OBJ export

/*
HEATSINK GENERATOR
Jeff Thompson | 2018 | jeffreythompson.org

Creates a heatsink form as an interactive model and OBJ
export for 3D printing.

KEY COMMANDS
r   = reset with new random seed
o   = show/hide origin
b   = show/hide bottom
t   = show/hide top
g   = show/hide the TEG module
i   = draw initial smooth tubes
m   = save obj model file (activate any time)
s   = save timestamped screenshot
L/R = toggle through view presets
U/D = zoom in and out

REQUIRES
+ Shapes3D library from Peter Lager
+ OBJ Export library from Nervous System

CLEANUP AFTER EXPORT
1. clean up obj mesh...
   1a. unify normals
   1b. SplitDisjointedMesh to separate into pieces
2. create rect at 0,0 that is 41x41mm, then extrude up 5mm
   2a. draw circles for tubes that stick into the rect
       (except the ones that are only a little bit)
3. explode that extrusion and delete bottom-most face
4. MeshTrim using the sides and top face of mesh as the cutting objects
5. select each tube, mesh > close holes
n. clean up in netfabb

TO DO
+ 

*/

boolean saveModel =     false;                      // save to OBJ file?
String modelFilename =  "_Heatsink.obj";            // OBJ filename
String screenshotDir =  "../../Documentation/";     // directory to save screenshots to

boolean useConcentric = true;        // false = spiral

// overall dimensions
float bottomRadius =  40;//90;            // radius of bottom base
float topRadius =     12.8;//38;//23;            // ditto top
float overallHeight = 20;        // half the overall height

// tube settings
float mutAmt =        10;//11.25;         // max amount for mutation (+/-)
float tubeDia =       1.5;           // diameter of the tube
int numSegments =     20;            // segments along the tube
int tubeDetail =      8;             // facets around tube
float ctlPtMin =      0.5;
float ctlPtMax =      4;

boolean extendBelow = false;         // extend below the surface at the base?
float extensionLen =  22.5;          // by how much?

// spikes
int chanceSpike =     30;             // 0–100
float minSpikeLen =   tubeDia*3;
float maxSpikeLen =   tubeDia*5;

// bottom pads
float minPadRadius =  1.5;           // min/max radius of base pads
float maxPadRadius =  4;
float baseThickness = 5;             // thickness of the bases

int baseDetail =      64;            // # facets around bases

// concentric circle settings
float concentricSpacing = 4.5;

// spiral settings
int initialDir =      DOWN;        // which direction the spiral should face
float spiralSpacing = 6;           // how far apart the tubes will be
float numTurns =      8;           // overall num of turns of spiral

// PCB + ring
// (radius of pcb should be same as topRadius, and vv)
float pcbThickness =     0.8;      // thickness of FR4 board (OSH Park 2-layer thickness)
float pcbRingWidth =     3;        // width of ring (for tapping M2 bolts into)
float pcbRingThickness = 3;        // ditto thickness

// TEG settings
float tegBaseSize =  43;
float tegSize =      41;           // a loose fit, to accommodate shrink in casting
float tegThickness = 5;            // should protrude slightly for good contact w/ skin
float tegOffset =    0.5;          // slight amount down to get good pressure on skin

// colors and rendering
color tubeColor =   color(154,153,151);//color(184,115,51);  // nice, shiny copper
color baseColor =   color(154,153,151);//color(184,115,51);
color tegColor =    color(80);          // lead gray of TEG
color initColor =   color(255);         // initial tubes, if shown
color bgColor =     color(30,28,26);    // warm background for renderings
color pcbColor =    color(50);
float copperShine = 1;
float tegShine =    1;
float pcbShine =    4;

// display settings
boolean showOrigin =       false;   // show the origin lines?
boolean showBottom =       false;   // show the bottom pads?
boolean showPCB =          false;   // show the PCB?
boolean showAntenna =      true;    
boolean showTEG =          false;   // show the TEG module?
boolean drawInitialTubes = false;   // show original, smooth tubes?
boolean showSpikes =       false;   // show the spikes?

// view presets
float zoomAmt = 5;
PVector[] presets = {
  new PVector(1.0053096,  0, -1.154535),
  new PVector(-0.5026548, 0, 0.62831855),
  new PVector(0.12566376, 0, -0.13351774),
  new PVector(-0.37699103, 0, 1.4137167),
  new PVector(-0.42411494, 0, 0.12566376)
};
int whichPreset = 2;       // start with a good overall view
float zoom =      10.3;    // init zoom, since model is small

ArrayList<Sink> tubes = new ArrayList<Sink>();   // heatsink tubes
Tube pcb;                                        // circuit board on top
float angleY = 0;                                // GUI rotation angles
float angleX = presets[whichPreset].x;
float angleZ = presets[whichPreset].z;
int randomSeed = 0;
//PShader flat;


void setup() {
  size(800, 800, P3D);
  sphereDetail(24);
  noStroke();
  
  // reset for new random seed
  tubes.clear();
  randomSeed(randomSeed);

  // create all bezier tubes from the base to the top
  if (useConcentric) createConcentricTubes();
  else               createSpiralTubes();

  // create PCB plates
  createPCB();
  
  // flat shading, please
  //flat = new PShader(this, new String[] {
  //  "#version 150"
  //  ,"in vec4 position,normal;"
  //  +"uniform mat4 projectionMatrix,modelviewMatrix;"
  //  // the key here is flat default is smooth interpolation 
  //  +"flat out vec3 vN;"
  //  +"void main() {"
  //  // normal matrix
  //  +"mat4 nrm_mtrx = transpose(inverse(modelviewMatrix));"
  //  // vertex normal
  //  +"vN = normalize(vec3(nrm_mtrx*vec4(normal.xyz,0.)).xyz);"
  //  +"gl_Position = projectionMatrix*modelviewMatrix*position;"
  //  +"}"
  //  }, new String[] {"#version 150"
  //    ,"flat in vec3 vN;"
  //    +"uniform vec3 LDir;"
  //    +"uniform vec3 surfaceColor;"
  //    +"out vec4 fragColor;"
  //    +"void main() {"
  //    // simple diffuse
  //    +"float brightness = clamp( max(0., dot(vN, normalize(LDir) ) ) ,0.,1.);"
  //    +"fragColor.rgb = brightness * surfaceColor;" 
  //    +"fragColor.a=1.0;"
  //    +"}"
  //  });
  //  shader(flat);
}


void draw() {
  background(bgColor);  
  runTransformations();

  // show the origin and directions
  if (showOrigin && !saveModel) {
    stroke(255, 0, 0);
    line(-bottomRadius, 0, 0, bottomRadius, 0, 0);            // red = x
    stroke(0, 255, 0);
    line(0, -overallHeight*1.5, 0, 0, overallHeight*1.5, 0);  // green = y
    stroke(0, 0, 255);
    line(0, 0, -bottomRadius, 0, 0, bottomRadius);            // blue = z
    noStroke();
  }

  // draw the tubes
  for (Sink t : tubes) {
    t.display();
  }

  // pcb and teg
  drawPCB();
  drawTEG();
  
  // done recording, save and turn off
  if (saveModel) {
    println("- saving model file...");
    endRecord();
    saveModel = false;
    println("- done");
  }
}