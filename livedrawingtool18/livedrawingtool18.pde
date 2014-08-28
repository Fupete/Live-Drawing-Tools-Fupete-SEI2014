// 
// LIVE DRAWING TOOL 18
// © Daniele @ Fupete for the course SEI2014 @ UnirSM  
// github.com/fupete — github.com/sei2014-unirsm
// Made for educational purposes, MIT License, March 2014, San Marino
// —

/**
 * (BASE) 
 * USING ARRAYLIST TO DEFINE/DRAW/ANIM A TRACK OF POINTS/FORCE VECTORS > BRUSH...
 *
 * MOUSE
 * drag                : add points/tracks
 * 
 * KEYS
 * del/backspace       : delete, clear arrays
 * 0                   : redraw background each draw() loop, OR not
 * 1                   : show/hide points
 * 2                   : show/hide vectors forces proportional to speed
 *
 * S                   : Record a sequence of images (.tga) | Start(red) / Stop(Black) recording tgas
 * p                   : Record a PDF from next Draw() cycle
 *
 * TO DO (too much :-)
 *
 */



// IMPORTS AND GLOBAL VARIABLES DECLARATION


// pdf library
import processing.pdf.*;

// boolean switches on/off for the keyboard interface
boolean saveF, showPoint, savePDF, showForce = false;
boolean reDraw = true;

// start draw values
int sWeight = 5;
int sAlpha = 200;

// ArrayLists of objects, class Point and class Force
ArrayList <Point> points = new ArrayList <Point>();
ArrayList <Force> forces = new ArrayList <Force>();



// SETUP


void setup() {

  //size(displayWidth, displayHeight);     // fullScreen
  size(1200, 720);  // better setting for video sequence of frames export...
  smooth();
  colorMode(HSB);
  background(255);
  frameRate(30);
  //noCursor();   
  noFill();

} // setup()



// DRAW LOOP


void draw() {

  if (savePDF) beginRecord(PDF, "frame-#######.pdf");

  strokeWeight(sWeight);

  if (reDraw) background(255);

  for (int i=2;i<points.size();i++) {

    if (showPoint)   points.get(i).display();        // show the current point

    // get the color of the point if defined...
    stroke(points.get(i).c, sAlpha);

    // MAIN DRAWING BRUSH

    if (!points.get(i).isEndPoint) {

    // draw a line between the current and the previous point if it's not an end point
    line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);

    // show each recorded point perpendicular force vectors proportional to drawing speed
      if (showForce && i<forces.size()) {
        line (forces.get(i).A.x, forces.get(i).A.y, forces.get(i).B.x, forces.get(i).B.y);
        ellipse (forces.get(i).A.x, forces.get(i).A.y, 5, 5);
        ellipse (forces.get(i).B.x, forces.get(i).B.y, 5, 5);
      }

    } // MAIN DRAWING BRUSH

  } // for()

  if (savePDF) {
    endRecord();
    savePDF = false;
  }

  if (saveF) {
    saveFrame("frame-#######.tga");
  }
}  // draw()



// THE REAL DRAWING TOOL
// when you click and drag around you draw a trail of Points/Forces


void mouseDragged() {

  // shift the array by one, and do mods during the shifting if you want
  for (int i = points.size()-1;i>0;i--) {

    // shift the array by one to free place zero for next point to record
    points.get(i).copy(points.get(i-1));

    // real time animation mods of the trail/s

    //  deformate the track in real time, polar...
    /* if (livePolar) {
      points.get(i).x+= cos(radians(frameCount+i))*3.6;
      points.get(i).y-= sin(radians(frameCount+i))*3.6;
    } */

    // end real time animation mods

  }

  // shift also the array of Forces by one
  for (int j = forces.size()-1; j>0; j--) {
    forces.get(j).copy(forces.get(j-1));
  }

  // THE RECORDER OF CURRENT POINT
  // add the current Point to the ArrayList at position 0
  points.add(0, new Point(mouseX, mouseY, false));

  // THE RECORDER OF CURRENT FORCES
  if (points.size() > 2) {

    //  perpendicolar forces proportional to the speed, make by Vectors, usefull to make thickness of a brush with a curvevertex/quad shape, ... too complex the structure... i have to create some inheritance between Force and Point. Maybe just one class? or the Force created/called from the Point? Or just use the Force and express points also by vectors? Mumble mumble...
    PVector currentVect = new PVector (points.get(0).x, points.get(0).y);
    PVector currentVect1 = new PVector (points.get(0).x, points.get(0).y);
    // Vector distance between last two points
    PVector deltacurrentVect = new PVector (points.get(0).x-points.get(1).x, points.get(0).y-points.get(1).y);
    //float deltacurrentAngle = currentVect.heading(); // direction angle if needed just uncomment...
    deltacurrentVect.div(2); // half on one side, half on the other side...
    deltacurrentVect.rotate(HALF_PI); // one side
    currentVect.add(deltacurrentVect);
    deltacurrentVect.rotate(PI); //  the other side
    currentVect1.add(deltacurrentVect);
    // record current Forces
    // to do a better handle of last points/different marks. A parent class MARK just made made of Vectors? Mumble Mumble, maybe **
    if (!points.get(1).isEndPoint) forces.add(0, new Force(currentVect, currentVect1));

  }
} // mouseDragged()


void mouseReleased() {
  // sign the last point object of a mark/trail **
  points.add(0, new Point(mouseX, mouseY, true));
}


// KEYBOARD INTERFACE


void keyPressed() {
  if (key == DELETE || key == BACKSPACE) {
    background(255);
    points.clear();
  }
  if (key == '0') reDraw = !reDraw;            // redraw background each draw() loop
  if (key == '1') showPoint = !showPoint;      // show all the points on the track
  if (key == '2') showForce = !showForce;    // show perpendicolar force proportional to speed    
  if (key == 'S' || key == 's') {
    saveF = !saveF;
    if (saveF) {
      background(255, 255, 255); // red screen flash
    } 
    else { 
      background(0); // black screen flash
    }
  }
  if (key == 'p' || key == 'P') savePDF = !savePDF;
}  // keypressed()




// FORCES
// class Force to be moved in another file/tab


class Force {

  // def var
  PVector A, B;

  void copy(Force toCopy) { // tool to duplicate values from another Force, USED to shift by one
    A = toCopy.A.get();
    B = toCopy.B.get();
  } // copy

  Force(PVector Atemp, PVector Btemp) { // constructor
    A = Atemp.get();
    B = Btemp.get();
  } // constructor Force

} // class Force




// POINTS
// class Point to be moved in another file/tab


class Point {
  
  // def var
  float x, y, r, xp, yp, d;
  color c;
  boolean isEndPoint;

  void copy(Point toCopy) { // tool to duplicate values from another Point, USED to shift the array by one
    xp = x;
    yp = y;
    x = toCopy.x;
    y = toCopy.y;
    r = toCopy.r;
    c = toCopy.c;
    // d = dist(x, y, xp, yp);
    isEndPoint = toCopy.isEndPoint;
  } // copy

  Point(float ax, float ay, boolean end) { // constructor
    x=ax;
    y=ay;
    r=10;
    c = color(255, 255, 255, 200);
    isEndPoint = end;
  } // Point()

  void display() { // behaviour 
    // Draw a little rect/quad on this Point
    noFill();
    rectMode(CENTER);
    rect(x, y, r, r);
  } // display()

} // class Point