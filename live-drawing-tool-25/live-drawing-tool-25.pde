//
// LIVE DRAWING TOOL 25
// © Daniele @ Fupete for the course SEI2014 @ UnirSM  
// github.com/fupete — github.com/sei2014-unirsm
// Made for educational purposes, MIT License, March 2014, San Marino
// —

/*
 * SCORES (MARKS) MADE OF NOTES (POINTS) < NESTED ARRAYLISTS
 * I AM SEARCHING FOR A STRUCTURE/BASEMENT TO BUILD UPON...J
 *
 * MOUSE
 * drag                : add a score (mark)
 * 
 * KEYS
 * DEL/BACKSPACE       : delete all scores (marks)
 * U                   : delete last score (mark)
 * P                   : show/hide notes (points)
 *
 * TO DO (too much :-)
 *
 */

int currentS = 0;
int last = 0;
PVector point;
boolean showPoint = true;

ArrayList <Score> scores = new ArrayList <Score>();



void setup() {
  //size(displayWidth, displayHeight);
  size(1200, 720);
  smooth();
  colorMode(HSB);
  background(0);
  stroke(255);
  strokeWeight(4);
  // frameRate(30);
  textSize(24);
  rectMode(CENTER);
  // noCursor();
} // setup();


void draw() {
  background(0);
  fill(255, 255, 255);
  text("SCORE / NOTES", 20, 20);
  noFill();
  for (int i=0; i<scores.size(); i++) {
    scores.get(i).anim();
    last = scores.get(i).notes.size();
    if (last>0) {
      beginShape();
      for (int j=0; j<last; j++) {
        point = scores.get(i).notes.get(j).V.get();
        vertex(point.x, point.y);
        if (showPoint) rect(point.x, point.y, 10, 10);
      } // for j
      endShape();
      fill(255, 255, 255);
      text(i+1 + " / " + last, point.x+20, point.y+20);
      noFill();
    } // if last
  } // for i
} // draw()


void mouseDragged() {
  for (int i = scores.get(currentS).notes.size()-1;i>0;i--) {
    scores.get(currentS).notes.get(i-1).V.x += cos(radians( frameCount ));
    scores.get(currentS).notes.get(i-1).V.y += sin(radians( frameCount ));
    scores.get(currentS).notes.get(i).copy(scores.get(currentS).notes.get(i-1));
  }
  PVector Vc = new PVector (mouseX, mouseY);
  PVector Vp = new PVector (pmouseX, pmouseY);
  float distance = Vc.dist(Vp);
  scores.get(currentS).notes.add(0, new Note(Vc, distance));
} // mouseDragged()


void mousePressed() {
  scores.add(currentS, new Score());
} // mousePressed()


void mouseReleased() {
  currentS++;
} // mouseReleased()


void keyPressed() {
  if (key == DELETE || key == BACKSPACE) {
    background(0);
    scores.clear();
    currentS = 0;
  }
  if (key == 'U' || key == 'u') {
    if (currentS > 0) {
      scores.get(currentS-1).notes.clear();
      currentS--;
    }
  }  
  if (key == 'p' || key == 'P') showPoint = !showPoint;  
}


  // A SCORE IS MADE OF A SERIE OF CONNECTED NOTES

  class Score {
    ArrayList <Note> notes = new ArrayList <Note>();

    Score() {
    } // constructor Score

      void anim() {
      PVector A = new PVector(random(-2, 2), random(-1, 1) );
      for (int i=0; i<=notes.size()-1; i++) {
        notes.get(i).V.add(A);
        //notes.get(i).V.x += cos(radians( frameCount ));
        //notes.get(i).V.y += sin(radians( frameCount ));
      }
    } // anim()
  } // class Score


  // A NOTE IS A POINT WITH X, Y VECTOR COORDINATES 
  // AND A DISTANCE/DELTA FROM THE PREVIOUS ONE

  class Note {
    PVector V;
    float d;

    void copy(Note toCopy) {
      V = toCopy.V.get();
      d = toCopy.d;
    }

    Note(PVector vTemp, float dTemp) {
      V = vTemp.get();
      d = dTemp;
    } // constructor Note
  } // class Note
