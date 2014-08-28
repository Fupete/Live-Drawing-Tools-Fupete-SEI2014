public class eugenio2 implements brush {

  boolean new_p=false;
  ArrayList hist;
  ArrayList tmp_hist;
  float joinThresh;
  int hlimit;
  PGraphics pg_before;
  PGraphics pg;
  long time=0;
  boolean trascritto=false;
  boolean attivato=false;
  int brush_no=-1;
  int n_vertex_pelo=4;
  float ampiezza=25;
  int ampiezza_vel=15;
  int contatore_punti=0;

  eugenio2() {
    hist = new ArrayList();
    tmp_hist = new ArrayList();
    joinThresh = 280;
    hlimit=500;
    app.registerDraw(this);
    pg_before = createGraphics(width, height);
    pg = createGraphics(width, height);
    pg_before.beginDraw();
    pg_before.endDraw();
    pg.beginDraw();
    pg.endDraw(); 
    pg.noFill();
  }


  void trascrivi() {
    println("trascrivi");
    pg_before.loadPixels();
    loadPixels();
    for (int i=0;i<width*height;i++) {
      pg_before.pixels[i]=pixels[i];
    }
    pg_before.updatePixels();
    pg_before.beginDraw();
    pg_before.fill(0, 0, 0, 125);
    pg_before.rect(0, 0, width, height);
    pg_before.endDraw();
    pg.clear();

    pg.beginDraw();
    pg.endDraw();
  }

  void draw() {
    if (selected_brush==brush_no && brush_no>=0) {
      if (!attivato) {
        trascrivi();  
        attivato=true;
        println("draw_init");
      }
    }
    if (selected_brush!=brush_no && attivato) {
      println("end_draw");
      attivato=false;
    }

    if (attivato) {
      background(0);
      image(pg_before, 0, 0);
      pg.loadPixels();
      boolean tutto_fermo=true;
      for (int i=0;i<width*height;i++) {
        if (((pg.pixels[i] >> 24) & 0xFF) > 0) {
          tutto_fermo=false;
          trascritto=false;
          pg.pixels[i]-=  1<<24;
        }
      }
      pg.updatePixels();
      pg.beginDraw();
      for (int i=0;i<hist.size();i++) {
        PVector v = (PVector) hist.get(i);
        pg.pushStyle();
        pg.fill(R, G, B, trasp);
        pg.noStroke();
        //pg.stroke(R,G,B,trasp);
        pg.ellipse(v.x+noise(float(millis()+i*100)/800)*30-15, v.y+noise(1000.0+float(millis()+i*100)/800)*30-15, 5-float(i)/float(hist.size())*5, 5-float(i)/float(hist.size())*5);
        // pg.point(v.x+noise(float(millis()+i*100)/800)*30-15,v.y+noise(1000.0+float(millis()+i*100)/800)*30-15);//,10-float(i)/float(hist.size())*10,10-float(i)/float(hist.size())*10);
        v.x+=noise(float(millis()+i*300)/800)*1-0.45;
        v.y+=noise(float(1000+millis()+i*300)/800)*1-0.45;
        pg.popStyle();
        hist.set(i, v);
      }
      pg.endDraw();
      image(pg, 0, 0);
      if (tutto_fermo && !trascritto) {
        trascrivi();
        trascritto=true;
      }
    }
  }//draw



  void theBrush (PVector d) {
    trasp=20;
    if (hist.size()>hlimit-1)hist.remove(hist.size()-1);
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
        v.x-=pow(d.dist(v)*cos(angle)/5, 2)/100*cos(angle)/abs(cos(angle));//+noise(float(2000+millis()+p*100)/800)*.1-.2;
        v.y-=pow(d.dist(v)*sin(angle)/5, 2)/100*sin(angle)/abs(sin(angle));//+noise(float(3000+millis()+p*100)/800)*.1-.2;
        hist.set(p, v);
      }
    }
    histLimit();
    hist.add(0, d);
  }

  void clear() {
    hist.clear();
    pg_before=createGraphics(width, height);
    pg=createGraphics(width, height);
    pg_before.beginDraw();
    pg_before.endDraw();
    pg.beginDraw();
    pg.endDraw();
  }

  void mouseDragged() {
    if (brush_no==-1) {
      println("sti sti sca sca");
      brush_no = selected_brush;
      trascrivi();
    }
    PVector d = new PVector(mouseX, mouseY, 0);
    theBrush(d);
  }

  void leapDrawing(float a, float b) {
    if (brush_no==-1) {
      println("sti sti sca sca");
      brush_no = selected_brush;
      trascrivi();
    }
    PVector d = new PVector(a, b, 0);
    theBrush(d);
  }

  void histLimit() {
    if (hist.size() >= hlimit) clear();
  }
}

