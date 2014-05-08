//
// DRAWING ORIGAMI 02
// © Daniele @ Fupete for the course SEI2014 @ UnirSM
// github.com/fupete — github.com/sei2014-unirsm
// Made for educational purposes, MIT License, March 2014, San Marino
// —

/*
* DRAWING A TAIL OF TRIANGLES
* ARRAY OF OBJECTS CLASS TRIANGLE
* CONTROL P5 TO PARAMETRIZE A LITTLE
*
* MOUSE
* drag : drawing
* release : clear
* 
* KEYS
* 1/2 : save/load settings of ControlP5 Interface...
*
* TO DO (too much :-)
*
*/

import controlP5.*;

ControlP5 interfaccia;
Triangle[] tail = new Triangle[10];
int corrente = 0;
boolean isFirst = true;
boolean cancella = true;
PVector P1, P2, P3, Pc;
float d1, d2, d3;
float TriangleMinSize = 250;


void setup() {
  size(1200, 720);
  background(255);
  stroke(255);
  fill(0);

  interfaccia = new ControlP5(this);

  // create a group for all the gui element called ADMIN
  Group ADMIN = interfaccia.addGroup("ADMIN")
    .setPosition(10, 20)
    .setWidth(200)
    .setBackgroundHeight(70)
    .setBackgroundColor(color(150))
    ;

  // create a slider for the TriangleMinSize parameter
  // name, minValue, maxValue, defaultValue, x, y, width, height
  interfaccia.addSlider("TriangleMinSize", 1, 500, 250, 10, 10, 100, 14)
  .setGroup(ADMIN)
   ;

  // create a toggle button to control "delete screen" or not
  interfaccia.addToggle("cancella")
    .setSize(14, 14)
    .setGroup(ADMIN)
    ;
} // setup()


void draw() {
  background(255);
  if (mousePressed) {
    if (isFirst) {
      P1 = new PVector(mouseX, mouseY);
      P2 = new PVector(mouseX, mouseY);
      P3 = new PVector(mouseX, mouseY);
      P2.x+=random(-25, 25)+150;
      P3.y+=random(-25, 25)+150;
    }
    else {
      // CURRENT POTENTIAL NEW VERTEX
      Pc = new PVector(mouseX, mouseY);
      // PREVIOUS TRIANGLE ARRAY INDEX
      int quale;
      if (corrente>0) {
        quale = corrente-1;
      }
      else {
        quale=tail.length-1;
      }
      // DISTANCE FROM PREVIOUS VERTEXES
      d1 = Pc.dist(tail[quale].V1);
      d2 = Pc.dist(tail[quale].V2);
      d3 = Pc.dist(tail[quale].V3);
      // FIND THE MOST FAR
      // CHOOSE THE OTHERS
      if (d1>=d2 && d1>=d3) {
        P1 = Pc.get();
        P2 = tail[quale].V2.get();
        P3 = tail[quale].V3.get();
      }
      else if (d2>=d1 && d2>=d3) {
        P2 = Pc.get();
        P1 = tail[quale].V1.get();
        P3 = tail[quale].V3.get();
      }
      else if (d3>=d1 && d3>=d2) {
        P3 = Pc.get();
        P1 = tail[quale].V1.get();
        P2 = tail[quale].V2.get();
      }
    }
    // ADD A TRIANGLE IF IT IS THE FIRST
    // OR IT IS "BIG/FAR" ENOUGH (linear distance...)
    if (isFirst || (d1> TriangleMinSize && d2> TriangleMinSize && d3> TriangleMinSize )) {
      tail[corrente] = new Triangle(P1, P2, P3);
      corrente+=1;
      if (corrente > tail.length-1) corrente = 0;
    }
    isFirst = false;
  }

  // DRAW THE TAIL
  for (int i=tail.length-1; i>=0; i--) {
    if (tail[i] != null && tail[i].exist) {
      tail[i].display();
    }
  }
} // draw()


void keyPressed() {
  // ControlP5 default properties load/save key combinations are 
  // alt+shift+l to load properties
  // alt+shift+s to save properties
  // we use 1 to save setup and 2 to load setup
  if(key=='1') {
    interfaccia.saveProperties(("current_setup.ser"));
  } else if(key=='2') {
    interfaccia.loadProperties(("current_setup.ser"));
  }
} //interfaccia()


void mouseReleased() {

  if (cancella) {
     // CLEAR THE TAIL
     for (int i=0; i <tail.length; i++) {
      if (tail[i] != null && tail[i].exist)
        tail[i].exist = false;
     }
     background(255);
     isFirst=true;
  }
} // mouseReleased()


class Triangle {
  PVector V1, V2, V3;
  boolean exist;
  //PVector Vr = new PVector(50, 50);

  Triangle (PVector Va, PVector Vb, PVector Vc) {
    V1 = Va.get();
    V2 = Vb.get();
    V3 = Vc.get();
    exist = true;
    //Vr.add(V1);
  } // Triangle()

  void display() {
    //fill(255,0,0);
    //triangle(Vr.x, Vr.y, V2.x, V2.y, V3.x, V3.y);
    fill(0);
    triangle(V1.x, V1.y, V2.x, V2.y, V3.x, V3.y);
  } // display()
} // class Triangle


