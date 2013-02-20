// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float size;

  Particle(PVector l) {
    acceleration = new PVector(0,0.05,1);
    velocity = new PVector(random(-6,6),random (-8,4),random(1,-2));
    location = l.get();
    lifespan = 255.0;
    size = 1.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.3;
    size += 1.0;
  }

  // Method to display
  void display() {
    stroke(140, 140, 255,255-lifespan);
    fill(140, 140, 255,255-lifespan);
    /* ellipse(location.x,location.y,size,size);
    fill (0);
    ellipse(location.x-30, location.y-20,size*0.2,size*0.2);
    fill (0);
    ellipse(location.x+30, location.y-20,size*0.2,size*0.2);
    fill (240);
    ellipse(location.x, location.y+40,size*0.3,size*0.7); */
    shape (s, location.x, location.y, size, size);
  }
  
  // particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

