class base implements brush {
  ArrayList hist;
  float joinDist;

  base() {
    hist = new ArrayList();
    joinDist = 70;
  }
  
  void theBrush (PVector d) {
    joinDist = register;
    hist.add(0, d);
    for (int p = 0; p < hist.size()-1; p++) {
      PVector v = (PVector) hist.get(p);      
      //ellipse(v.x, v.y, 1, 1);
      float joinChance = p/hist.size() +
        d.dist(v)/joinDist;
      if (joinChance < random(0.9)) {
      line(v.x,v.y,d.x,d.y);
      ellipse(v.x, v.y, 5, 5);
      }
    }
    ellipse(d.x, d.y, 10, 10);
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
