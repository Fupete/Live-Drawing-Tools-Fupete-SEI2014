class base implements brush {
  ArrayList hist;
  float joinDistBase;
  int hlimit;

  base() {
    hist = new ArrayList();
    joinDistBase = 140;
    hlimit = 2500;
  }

  void theBrush (PVector d) {
    trasp = 15;
    hist.add(0, d);
    for (int p = 0; p < hist.size()-1; p++) {
      PVector v = (PVector) hist.get(p);    
      float joinChance = 1;  
      if (hist.size() != 0 && joinDistBase != 0) {
        joinChance = p/hist.size() +
          d.dist(v)/joinDistBase;
      } 
      if (joinChance < random(0.5)) {
        line(v.x, v.y, d.x, d.y);
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
    if (hist.size() >= hlimit) clear();
  }
}
