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

ArrayList<brush> brushes = new ArrayList<brush>();

int selected_brush = 1; // 0..5
int limit = 1500; // max length of each mark array
float trasp = 20;
float register = 90;
color c = color(255);

public void setup() {
  noCursor();
  noFill();
  smooth();
  size(1024, 768);
  background(0);
  
  options = new ControlP5(this);
  options.addSlider("limit", 1, 5000, 1500, 10, 10, 150, 11)
  .setSliderMode(Slider.FLEXIBLE)
  .setColorForeground(#ffffff)
  .setColorActive(#ff0000)
  .setColorBackground(#111111)
  .setColorValueLabel(#444444)
  .setHandleSize(2);
  options.addSlider("register", 1, 500, 90, 200, 10, 150, 11)
  .setSliderMode(Slider.FLEXIBLE)
  .setColorForeground(#ffffff)
  .setColorActive(#ff0000)
  .setColorBackground(#111111)
  .setColorValueLabel(#444444)
  .setHandleSize(2);
  options.addSlider("trasp", 1, 250, 20, 390, 10, 150, 11)
  .setSliderMode(Slider.FLEXIBLE)
  .setColorForeground(#ffffff)
  .setColorActive(#ff0000)
  .setColorBackground(#111111)
  .setColorValueLabel(#444444)
  .setHandleSize(2);
  options.getController("limit").setCaptionLabel("");
  options.getController("register").setCaptionLabel("");
  options.getController("trasp").setCaptionLabel("");

  brushes.add(new base());
  brushes.add(new sketch());
  brushes.add(new chrome());
  brushes.add(new web());
  brushes.add(new shaded());

  leap = new LeapMotionP5(this);
  leap.enableGesture(Type.TYPE_SWIPE);
  leap.enableGesture(Type.TYPE_SCREEN_TAP);
  leap.enableGesture(Type.TYPE_KEY_TAP);

}

public void draw() {
  stroke(c, trasp);
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    brushes.get(selected_brush).leapDrawing(fingerPos.x, fingerPos.y);
  }
}

void mouseDragged() {
  brushes.get(selected_brush).mouseDragged();
}

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
}

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
}

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
}

public void keyTapGestureRecognized(KeyTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    println("keytap");
    c=color(random(0, 255), random(0, 255), random(0, 255)); 
  }
}

public void stop() {
  leap.stop();
}
