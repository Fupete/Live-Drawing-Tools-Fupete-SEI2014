class chrome implements brush {
  ArrayList hist;
  float joinThresh;
  int hlimit;

  chrome() {
    hist = new ArrayList();
    joinThresh = 280;
    hlimit=3500;
  }

  void theBrush (PVector d) {
    trasp=20;
    hist.add(0, d);
    for (int p = 0; p < hist.size(); p++) {
      PVector v = (PVector) hist.get(p);
      float joinChance = 1;  
      if (hist.size() != 0 && joinThresh != 0) {
        joinChance = p/hist.size() +
          d.dist(v)/joinThresh;
      } 
      if (joinChance < random(0.4)) {
        float dx = d.x - v.x;
        float dy = d.y - v.y;
        float angle = atan2(dy, dx);
        float pad = d.dist(v)/4;
        line(d.x - (pad * cos(angle)), 
        d.y - (pad * sin(angle)), 
        v.x + (pad * cos(angle)), 
        v.y + (pad * sin(angle)) );
      }
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

