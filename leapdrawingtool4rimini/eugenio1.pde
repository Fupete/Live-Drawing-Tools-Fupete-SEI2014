PApplet app = this;

public class eugenio1 implements brush {
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

  eugenio1() {
    hist = new ArrayList();
    tmp_hist = new ArrayList();
    joinThresh = 380;
    hlimit=100;
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
        if (((pg.pixels[i] >> 24) & 0xFF) > trasp) {
          tutto_fermo=false;
          trascritto=false;
          pg.pixels[i]-=  1<<24;
        }
      }
      pg.updatePixels();
      pg.beginDraw();
      pg.endDraw();
      image(pg, 0, 0);
      if (tutto_fermo && !trascritto) {
        trascrivi();
        trascritto=true;
      }
    }
  }//draw

  void theBrush (PVector d) {
    trasp=100;
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
        float pad = d.dist(v)/4;
        v.x+=random(ampiezza_vel)-ampiezza_vel/2;
        v.y+=random(ampiezza_vel)-ampiezza_vel/2;
        float x0=d.x;// - (pad * cos(angle));
        float y0=d.y;// - (pad * sin(angle));
        float x1=v.x;// + (pad * cos(angle));
        float y1=v.y;// + (pad * sin(angle));
        int noise_start=int(d.x*d.y);
        float t=1; //(millis()-start_pelo)/vita_pelo;   //istante di vita da 0 a 1
        int pos_pelo= floor(t * n_vertex_pelo);
        //     ellipse(d.x,d.y,20,20);
        pg.stroke(R, G, B, map(joinThresh-d.dist(v), 0, joinThresh, 0, trasp));
        pg.beginShape();
        pg.curveVertex(x0, y0);
        pg.curveVertex(x0, y0);
        for (int i=1;i<n_vertex_pelo;i++) {
          float riccio=noise(float(noise_start)+float(i)/float(n_vertex_pelo))*ampiezza*2-ampiezza;
          riccio=d.dist(v)>10 ? riccio : riccio/10;
          pg.curveVertex(lerp(x0, x1, float(i)/float(n_vertex_pelo))+riccio*cos(angle+PI/2), 
          lerp(y0, y1, float(i)/float(n_vertex_pelo))+riccio*sin(angle+PI/2));
        }
        pg.curveVertex(x1, y1);
        pg.curveVertex(x1, y1);
        pg.endShape();
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
    pg.noFill();
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
        if (brush_no==-1) {
      println("sti sti sca sca");
      brush_no = selected_brush;
      trascrivi();
    }
    if (hist.size() >= hlimit) clear();
  }
}

