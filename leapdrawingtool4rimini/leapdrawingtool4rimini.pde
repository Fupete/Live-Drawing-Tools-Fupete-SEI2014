// -
// LEAP DRAWING TOOL 4 RIMINI [SONIFIED MOD]
// © Daniele @ Fupete for the course SEI2014 @ UnirSM  
// github.com/fupete — github.com/sei2014-unirsm
// Made for educational purposes, MIT License, july 2014, San Marino
// —

// -
// Performed live at "Drawing(a)live – CODE e Disegni", Biennale Disegno Rimini, Spazio Duomo, Rimini, IT, july 2014.
// Report on http://www.fupete.com/blog/08/12/generative-design-drawing-unirsm-iuav/
// —

/*
 * 1ST QUICK EXPERIMENT WITH A LEAP MOTION CONTROLLER
 * Procedural drawing tool, various brushes, up to 10 fingers
 * Generative music with minim connected to color, speed, positions, ...
 *
 * MOUSE
 * drag                : draw
 * 
 * KEYS
 * SPACE               : clear
 * 2..5                : brushes
 * 1                   : special "base" brush
 * C                   : change color
 * B/N                 : white/black color
 * 
 * LEAP
 * fingers & tools     : draw
 * key-tap gesture     : change color
 * screen-tap gesture  : change brush
 * swipe gesture       : clear
 *
 * Note: play sounds just with the leap mode...
 *
 * TO DO (messy code, structure, ... too much :-)
 *
 */

/*
 * Credits:
 * - procedural drawing original concept from "The Scribbler":
 * http://www.zefrank.com/scribbler/about.html
 * - inspired to "Harmony" and a couple of remakes:
 * http://www.mrdoob.com/projects/harmony/
 * http://www.openprocessing.org/sketch/12323 (classes and interface code structure)
 * http://www.openprocessing.org/sketch/8168
 * - music synth concept inspired to
 * http://openprocessing.org/sketch/67904
 */

import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.*;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import geomerative.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

LeapMotionP5 leap; 

Minim minim;
AudioOutput out;
Waveform disWave;

// defaults for minim
String notesLow[], notesHigh[];
int pitchLow = 1;
int pitchHigh = 3;
float[][] vals;
int nn = 22;
String notes[]= {
  "A", "F", "E", "D", "C"
};
int period = 150;
float amp = 0.2;
int num = 7;
float dur = 3;

// magicPoints trick, just press P 
RShape grp;
RPoint[][] pointPaths;
int svgTotal = 14; // total numbers of svg in the folder 'data'

// an array of classes 'brush'
ArrayList<brush> brushes = new ArrayList<brush>();

// defaults
int selected_brush = 1; // 0..5
float trasp; 
float register; 
float R = 255;
float G = 255;
float B = 255;
color c = color(R, G, B);
boolean del = true;

public void setup() {
  noCursor();
  noFill();
  smooth(16);
  size(displayWidth, displayHeight);
  background(0);

  // fill the brushes array 
  brushes.add(new base());
  brushes.add(new sketch());
  brushes.add(new chrome());
  brushes.add(new web());
  brushes.add(new shaded());
  brushes.add(new crudo());
  brushes.add(new sofia());
  brushes.add(new eugenio1());
  brushes.add(new eugenio2());

  // enable the leap motion and its gestures
  leap = new LeapMotionP5(this);
  leap.enableGesture(Type.TYPE_SWIPE);
  leap.enableGesture(Type.TYPE_SCREEN_TAP);
  leap.enableGesture(Type.TYPE_KEY_TAP);

  // minim
  minim = new Minim( this );
  out = minim.getLineOut( Minim.STEREO, 512 );
  vals = new float[nn][out.bufferSize()];
}

public void draw() {

  if (del) delete(); 

  // color and alpha
  stroke(c, trasp);

  // for each 'pointable' above the Leap area:
  for (Pointable pointable : leap.getPointableList()) {

    // - create a Brush 
    PVector pointablePos = leap.getTip(pointable);
    PVector pointableVel = leap.getVelocity(pointable);
    brushes.get(selected_brush).leapDrawing(pointablePos.x, pointablePos.y);

    // - create a note sequence each 4 seconds
    if (frameCount%200 == 0) {
      addNotesNow(pointablePos.x, pointableVel.x, pointablePos.y, pointableVel.y);
    }
  }
} // draw()

void mouseDragged() {
  // draw also with the mouse, debug purpose, just one line at a time
  brushes.get(selected_brush).mouseDragged();
} // mouseDragged

void delete() {
  background(0);
  R=255;
  G=255;
  B=255;
  c=color(R, G, B);
  for (brush b : brushes) {
    b.clear();
  }
  del = false;
}

void keyPressed() {
  if (key == ' ') { //clear
    del = true;
  } 
  else if (key == '1') { // BASE BRUSH
    selected_brush = 0;
  } 
  else if (key == '2') { // SKETCH BRUSH
    selected_brush = 1;
  } 
  else if (key == '3') { // CHROME BRUSH
    selected_brush = 2;
  } 
  else if (key == '4') { // WEB BRUSH
    selected_brush = 3;
  } 
  else if (key == '5') { // SHADED BRUSH
    selected_brush = 4;
  }
  else if (key == '6') { // CRUDO BRUSH
    selected_brush = 5;
  }
  else if (key == '7') { // SOFIA BRUSH
    selected_brush = 6;
  }
  else if (key == 'c' || key == 'C') { // RANDOM COLOR
    R = random(0, 255);
    G = random(0, 255);
    B = random(0, 255);
    c=color(R, G, B);
  } 
  else if (key == 'b' || key == 'B') { // WHITE COLOR
    R=255;
    G=255;
    B=255;
    c=color(R, G, B);
  }
  else if (key == 'n' || key == 'N') { // BLACK NOIR COLOR
    R=0;
    G=0;
    B=0;
    c=color(R, G, B);
  }
  else if (key == 'p' || key == 'P') { // MAGIC POINTS TRICK
    magicPoints();
    mPshow();
  }
} // keypressed

public void swipeGestureRecognized(SwipeGesture gesture) { // CLEAR WITH A SWIPE
  if (gesture.state() == State.STATE_STOP) {
    if (gesture.durationSeconds() < .03) { 
      del = true;
    }
  }
} // swipeGestureRecognized

public void screenTapGestureRecognized(ScreenTapGesture gesture) { // CHANGE BRUSH WITH A SCREENTAP
  if (gesture.state() == State.STATE_STOP) {
    if (selected_brush == 0) {
      selected_brush = 1;
    } 
    else if (selected_brush == 1) {
      selected_brush = 2;
    } 
    else if (selected_brush == 2) {
      selected_brush = 3;
    } 
    else if (selected_brush == 3) {
      selected_brush = 4;
    } 
    else if (selected_brush == 4) {
      selected_brush = 5;
    }
    else if (selected_brush == 5) {
      selected_brush = 6;
    }
    else if (selected_brush == 6) {
      selected_brush = 1;
    }
  }
} // screenTapGestureRecognized

public void keyTapGestureRecognized(KeyTapGesture gesture) { // CHANGE COLOR WITH A KEYTAP
  if (gesture.state() == State.STATE_STOP) {
    R=random(0, 255);
    G=random(0, 255);
    B=random(0, 255);
    c=color(R, G, B);
  }
} // keyTapGestureRecognized

void magicPoints() { // MAGIC POINTS TRICK, CALCULATE
  RG.init(this);
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(100+random(400));
  String svgName = (1+( (int) random(svgTotal) )) + ".svg";
  grp = RG.loadShape(svgName);
  grp.centerIn(g, 100, 1, 1);
  pointPaths = grp.getPointsInPaths();
} // magicPoints

void mPshow() { // SHOW THE MAGIC POINTS
  translate(width/2, height/2);
  background(0);
  noStroke();//(255);
  fill(255);
  int conta = 0;
  for (int i = 0; i<pointPaths.length; i++) {
    if (pointPaths[i] != null) {
      for (int j = 0; j<pointPaths[i].length; j++) {
        conta++;
        ellipse(pointPaths[i][j].x, pointPaths[i][j].y, 5, 5);
        text(conta, pointPaths[i][j].x+10+random(-20, 20), pointPaths[i][j].y+10+random(-20, 20));
      }
    }
  }
} //mpShow

public void makeScale() { // BUILD A SCALE OF NOTES
  if (random(50)<35) {
    disWave = Waves.SINE;
  }
  else {
    disWave = Waves.TRIANGLE;
  }
  notesLow = new String[notes.length];
  notesHigh = new String[notes.length];
  for (int i = 0 ; i < notes.length;i++) {
    notesLow[i] = notes[i]+""+pitchLow;
    notesHigh[i] = notes[i]+""+pitchHigh;
  }
} //makescale

public void addNotesNow(float Px, float PVx, float Py, float PVy) { // ADD A NOTE SEQUENCE
  int velC = (int) map (abs(PVx+PVy), 0, 3000, 1, 22);
  //int velC2 = (int) map (velC, 22, 1, 1, 15);
  int velC2 = (int) map (velC, 22, 1, 10, 2);
  int velC2i = (int) map (velC2, 1, 15, 5, 2);
  pitchLow = (int) map ( Px, 0, width, 2, 2+velC2i);
  pitchHigh = (int) map ( Py, 0, height, 5, 5+velC2i);
  makeScale();
  amp= map(R+G+B, 0, 765, 0.25, 0.15);
  num = 3+velC;
  dur = 2+velC2;
  for (int i = 0 ; i < num ; i++ ) {
    out.playNote( i*(dur/(num+0.0)), (dur/(num+0.0)+random(0.0, 1.0)), new ToneInstrument( notesLow[(int)random(notesLow.length)]+" ", amp, disWave, out ) );
    out.playNote( i*(dur/(num+0.0)), (dur/(num+0.0)+random(0.0, 1.0)), new ToneInstrument( notesHigh[(int)random(notesHigh.length)]+" ", amp, disWave, out ) );
  }
} // addnotesnow


public void stop() { // STOP
  leap.stop();
  out.close();
  minim.stop();
  super.stop();
} // stop

