class web implements brush {
  ArrayList hist;
  float joinDist;

  web() {
    hist = new ArrayList();
    joinDist = 90;
  }
  
  void theBrush(PVector d) {
    joinDist = register;
    hist.add(0, d);
    for (int p = 0; p < hist.size(); p++) {
      PVector v = (PVector) hist.get(p);
      float joinChance = p/hist.size() +
        d.dist(v)/joinDist;
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
    if (hist.size() >= limit) clear();
  }
}
