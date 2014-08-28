// -
// LEAP DRAWING TOOL 1
// © Daniele @ Fupete for the course SEI2014 @ UnirSM  
// github.com/fupete — github.com/sei2014-unirsm
// Made for educational purposes, MIT License, May 2014, San Marino
// —

/*
 * 1ST QUICK EXPERIMENT WITH A LEAP MOTION CONTROLLER
 * Procedural drawing tool, various brushes, up to 10 fingers
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
 * finger/s            : draw
 * key-tap gesture     : change color
 * screen-tap gesture  : change brush
 * swipe gesture       : clear
 *
 * TOP SCREEN SLIDERS (LEFT TO RIGHT)
 * left                : limit max length of each mark arrayList
 * register            : distance/threshold, or both, to calculate brush 'connections'
 * alpha               : alpha
 *
 * TO DO (too much :-)
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
 *
 */

import controlP5.*;
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.*;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;

ControlP5 options;
LeapMotionP5 leap; 

// an array of classes 'brush'
ArrayList<brush> brushes = new ArrayList<brush>();

// defaults
int selected_brush = 1; // 0..5
int limit = 1500; // max length of each 'hist' array inside a brush
float trasp = 20; 
float register = 90; 
color c = color(255);

public void setup() {
  noCursor();
  noFill();
  smooth();
  size(1024, 768);
  background(0);
  
  // define and style the three sliders top screen
  options = new ControlP5(this);
  options
  .setColorForeground(#ffffff)
  .setColorActive(#ff0000)
  .setColorBackground(#111111)
  .setColorValueLabel(#444444);
  options.addSlider("limit", 1, 5000, 1500, 10, 10, 150, 11)
  .setSliderMode(Slider.FLEXIBLE)
  .setHandleSize(2);
  options.addSlider("register", 1, 500, 90, 200, 10, 150, 11)
  .setSliderMode(Slider.FLEXIBLE)
  .setHandleSize(2);
  options.addSlider("trasp", 1, 250, 20, 390, 10, 150, 11)
  .setSliderMode(Slider.FLEXIBLE)
  .setHandleSize(2);
  options.getController("limit").setCaptionLabel("");
  options.getController("register").setCaptionLabel("");
  options.getController("trasp").setCaptionLabel("");

  // fill the brushes array 
  brushes.add(new base());
  brushes.add(new sketch());
  brushes.add(new chrome());
  brushes.add(new web());
  brushes.add(new shaded());

  // enable the leap motion and its gestures
  leap = new LeapMotionP5(this);
  leap.enableGesture(Type.TYPE_SWIPE);
  leap.enableGesture(Type.TYPE_SCREEN_TAP);
  leap.enableGesture(Type.TYPE_KEY_TAP);

}

public void draw() {
  stroke(c, trasp);
  // for each leap finger instance a brush with its position
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    brushes.get(selected_brush).leapDrawing(fingerPos.x, fingerPos.y);
  }
} // draw()

void mouseDragged() {
  // draw also with the mouse, debug purpose
  brushes.get(selected_brush).mouseDragged();
} // mouseDragged

void keyPressed() {
  if (key == ' ') {
    background(0);
    c=color(255);
    for (brush b : brushes) {
      b.clear();
    }
  } 
  else if (key == '1') {
    selected_brush = 0;
    println("0 BASE");
  } 
  else if (key == '2') {
    selected_brush = 1;
    println("1 SKETCH");
  } 
  else if (key == '3') {
    selected_brush = 2;
    println("2 CHROME");
  } 
  else if (key == '4') {
    selected_brush = 3;
    println("3 WEB");
  } 
  else if (key == '5') {
    selected_brush = 4;
    println("4 SHADED");
  }
  else if (key == 'c' || key == 'C') {
    c=color(random(0, 255), random(0, 255), random(0, 255)); 
  } 
  else if (key == 'b' || key == 'B') {
    c=color(255); 
  }
  else if (key == 'n' || key == 'N') {
    c=color(0); 
  }
  else if (key == 'p' || key == 'P') {
    magicPoints();
  }
} // keypressed

public void swipeGestureRecognized(SwipeGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    if (gesture.durationSeconds() < .02) { 
      background(0);
      for (brush b : brushes) {
        b.clear();
      }
      c=color(255);
      println("swipe");
    }
  }
} // swipeGestureRecognized

public void screenTapGestureRecognized(ScreenTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    if (selected_brush<4) { 
      selected_brush++;
    } 
    else { 
      selected_brush=1;
    }
    println(selected_brush);
    println("screentap");
  }
} // screenTapGestureRecognized

public void keyTapGestureRecognized(KeyTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    println("keytap");
    c=color(random(0, 255), random(0, 255), random(0, 255)); 
  }
} // keyTapGestureRecognized

void magicPoints() {
  background(0);
  noStroke();
  fill(255);
  for (int i=1; i<random(1,44); i++) {
    float px=random(50, width-50);
    float py=random(50, height-50);
    ellipse(px, py, 5, 5);
    text(i,px-10,py-10);
  } 
  noFill();
} // magicPoints

public void stop() {
  leap.stop();
} // stop