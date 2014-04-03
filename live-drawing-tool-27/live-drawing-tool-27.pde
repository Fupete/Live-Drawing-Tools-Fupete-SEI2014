//
// LIVE DRAWING TOOL 27
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
 * R                   : show/hide replay
 *
 * TO DO (too much :-)
 * Added a maximum number of scores to increase the flow
 * Added a simple weight management during replay, inverse proportional to drawing speed
 * Exploring a continuos vertical scroll and "wave"
 * It seems to have potential to be a music/tone loop maker instrument... to remember/study: yellow tail, ...
 *
 */

int maxS = 11;
int currentS, clearS = 0;
int last = 0;
PVector point;
boolean showPoint = false;
boolean showReplay = true;

ArrayList <Score> scores = new ArrayList <Score>();



void setup() {
  size(displayWidth, displayHeight);
  //size(1200, 720);
  smooth();
  colorMode(HSB);
  background(0);
  stroke(50);
  strokeWeight(4);
  //frameRate(30);
  textSize(18);
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
      if (showReplay) scores.get(i).replay();
    } // if last
  } // for i
  if (mousePressed) {
  } // if mousePressed
} // draw()


void mouseDragged() {
  for (int i = scores.get(currentS).notes.size()-1;i>0;i--) {
    //scores.get(currentS).notes.get(i-1).V.x += cos(radians( frameCount ));
    //scores.get(currentS).notes.get(i-1).V.y += sin(radians( frameCount ));
    scores.get(currentS).notes.get(i).copy(scores.get(currentS).notes.get(i-1));
  }
  PVector Vc = new PVector (mouseX, mouseY);
  PVector Vp = new PVector (pmouseX, pmouseY);
  float distance = Vc.dist(Vp);
  //float distance = sqrt((Vc.x-Vp.x)*(Vc.x-Vp.x)+(Vc.y-Vp.y)*(Vc.y-Vp.y));
  if (distance > 1) scores.get(currentS).notes.add(0, new Note(Vc, distance));

  last = scores.get(currentS).notes.size();
  if (last>0) {
    stroke(255);
    beginShape();
    for (int j=0; j<last; j++) {
      point = scores.get(currentS).notes.get(j).V.get();
      vertex(point.x, point.y);
      if (showPoint) rect(point.x, point.y, 10, 10);
    } // for j
    endShape();
    stroke(50);
    fill(255, 255, 255);
    text(currentS+1 + " / " + last, point.x+20, point.y+20);
    noFill();
  }
} // mouseDragged()


void mousePressed() {
  scores.add(currentS, new Score());
  if (currentS > maxS) {
    scores.get(clearS).notes.clear();
    clearS++;
  }
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
  if (key == 'r' || key == 'R') showReplay = !showReplay;
}


// A SCORE IS MADE OF A SERIE OF CONNECTED NOTES

class Score {
  // float velY = random(2,6);
  float velY = 2;
  int rIndx = 0;
  float dCurr = 0;
  PVector pIndx;
  ArrayList <Note> notes = new ArrayList <Note>();

  Score() {
  } //   for (int i=0; i==2; i++) dCurr += dAver[i]; constructor Score

    void anim() {
    //PVector A = new PVector(random(-2, 2), random(-1, 1) + velY);
    PVector A = new PVector(0, velY);
    for (int i=0; i<=notes.size()-1; i++) {
      notes.get(i).V.add(A);
      if (notes.get(i).V.y > height + 300) {
        for (int j=0; j<=notes.size()-1; j++) {
          notes.get(j).V.y -= height+300;
        }
      }
      notes.get(i).V.x += cos(radians( frameCount ));
      notes.get(i).V.y += sin(radians( frameCount ));
    }
  } // anim()

  void replay() {
    if (notes.size()>4) {
      pIndx = notes.get(notes.size()-1-rIndx).V.get();
      dCurr = notes.get( notes.size()-1 ).d;
      dCurr += notes.get( notes.size()-1-rIndx-1 ).d;
      dCurr += notes.get( notes.size()-1-rIndx-2 ).d;
      dCurr /= 3;
      dCurr = 4/dCurr;
      dCurr = map(dCurr, 0, 1, 1, 30);
      stroke(255);
      fill(255);
      ellipse( pIndx.x, pIndx.y, dCurr, dCurr );
      //line(pIndx.x, pIndx.y, pIndx.x+dCurr, pIndx.y+dCurr);
      noFill();
      stroke(50);
      rIndx++;
    }
    if (rIndx > notes.size()-3 ) rIndx=0;
  } // replay()
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
