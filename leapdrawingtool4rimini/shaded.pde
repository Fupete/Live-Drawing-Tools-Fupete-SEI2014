class shaded implements brush {
  ArrayList hist;
  float joinDist;
  int hlimit;

  shaded() {
    hist = new ArrayList();
    joinDist = 200;
    hlimit = 1500;
  }

  void theBrush (PVector d) {
    trasp=10;
    hist.add(0, d);
    for (int p = 0; p < hist.size(); p++) {
      PVector v = (PVector) hist.get(p);
      float joinChance = 1;  
      if (hist.size() != 0 && joinDist != 0) {
        joinChance = p/hist.size() +
          d.dist(v)/joinDist;
      }
      if (joinChance < random(0.2))
        line(d.x, d.y, v.x, v.y);
    }
    histLimit();
  }


  void clear() {
    hist.clear();
  }

  void mouseDragged() {
    PVector d = new PVector(mouseX, mouseY, 0);
    theBrush(d);
  }

  void leapDrawing(float a, float b) {
    PVector d = new PVector(a, b, 0);
    theBrush(d);
  }

  void histLimit() {
    if (hist.size() >= hlimit) clear();
  }
}

