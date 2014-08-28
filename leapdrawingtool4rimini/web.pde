class web implements brush {
  ArrayList hist;
  float joinDistWeb;
  int hlimit;

  web() {
    hist = new ArrayList();
    joinDistWeb = 200;
    hlimit = 4000;
  }

  void theBrush(PVector d) {
    trasp=10;
    hist.add(0, d);
    for (int p = 0; p < hist.size(); p++) {
      PVector v = (PVector) hist.get(p);
      float joinChance = 1;  
      if (hist.size() != 0 && joinDistWeb != 0) {
        joinChance = p/hist.size() +
          d.dist(v)/joinDistWeb;
      }
      if (joinChance < random(0.7))
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

