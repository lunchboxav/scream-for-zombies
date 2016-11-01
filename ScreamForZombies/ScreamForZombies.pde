/** 
 * Made as a demo purpose for Kelas Inspirasi, to teach elementary
 * school students about interaction design
 * Based on Simple Particle System by Daniel Shiffman
 * SVG image as pointed by Processing PShape Reference
 */


import java.util.Iterator;
import ddf.minim.*;

PShape s;
PImage zombie;
PImage zombieLose;
PFont font;

Minim minim;
AudioInput in;

int scaledAudioInput;

float sum;
float averageAudioInput;

ParticleSystem ps;

Timer timer;

int winCount;
int health = 1000;
int winTextFill = 0;

boolean win;
boolean play;

void setup() {
  size(1280, 720, OPENGL);
  ellipseMode (CENTER);
  //colorMode(HSB);
  smooth();
  ps = new ParticleSystem(new PVector(width/2, height/2, 30));
  minim = new Minim(this);

  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);

  s = loadShape ("bot.svg");
  zombie = loadImage ("zombieFace.gif");
  zombieLose = loadImage ("zombieFaceLose.gif");

  font = loadFont("ZombieA-48.vlw");
  textFont(font, 96);

  winCount = 0;

  timer = new Timer(500);
  timer.start();

  win = false;
  play = true;
  
  
}

void draw() {
  background(0);
  
  if (!win) {
    drawScreamPower();
  }

  sum=0;

  if (winCount < 7 && health > 0 && timer.isFinished()) {
    for (int i = 0; i < in.bufferSize() - 1; i++) {
      sum=sum+abs(in.right.get(i));
    }

    // get average value of all samples
    averageAudioInput= sum/in.bufferSize();
    // scale this higher and clamp no higher than 255, also turn to integer which anaologWrite requires
    scaledAudioInput=int(constrain(averageAudioInput*2555, 0, 2000));

    if (scaledAudioInput > 700) {
      ps.removeParticle();
      winCount++;
      drawWinTexts();
      timer.start();
    } 
    else {
      ps.addParticle();
      ps.run();
      health-=0.1;
    }
  }

  else if (health == 0) {
    drawDeathMessage();
  }

  else if (winCount >= 7) {
    win = true;
    drawWinMessage();
  }
  drawMeter();
  println(scaledAudioInput);
}

void drawMeter() {
  pushMatrix();
  //fill (0);
  //rect(0,0,width,70);
  translate (0, 0, 2);
  fill (200, 0, 0);
  textAlign(LEFT);
  textSize (30);
  text ("darah", 5, 30);

  textSize (30);
  text ("menang", 5, 65);

  fill (2, 160, 92);
  stroke(255);
  rect (140, 5, map(health, 0, 1000, 0, width-190), 25);

  //fill (22, 150, 245);
  fill (0, 114, 188);
  stroke(255);
  rect (140, 40, map(winCount, 0, 7, 0, width-190), 25);
  popMatrix();
}

void drawWinMessage() {
  pushMatrix();
  translate(0, 0, 3);
  fill (200, 0, 0);
  textSize (50);
  textAlign(CENTER);
  text ("fiuh! kamu selamat dari serangan zombie", width/2, height/2);
  image(zombieLose, width/2-100, height/2+50, 150, 239);
  popMatrix();
}

void drawDeathMessage() {
  pushMatrix();
  translate(0, 0, 3);
  fill (200, 0, 0);
  textAlign(CENTER);
  textSize (50);
  text ("nyam! kamu dimakan segerombolan zombie", width/2, height/2);
  image(zombie, width/2-100, height/2+50, 150, 239);
  popMatrix();
}

void drawWinTexts() {
  //translate (0, 0, 1);
  fill (200, 0, 0, scaledAudioInput);
  textSize(90);
  textAlign(CENTER);
  text("AAAAA!", width/2, height/2);
}

void drawScreamPower() {
  pushMatrix();
  drawWinTexts();
  popMatrix();
  //pushMatrix();
  for (int i = 0; i < scaledAudioInput; i+=10) {
    ellipseMode (CENTER);
    noFill();
    //stroke(0, 120, 120, i);
    stroke (0, 114, 188, i);
    strokeWeight (3);
    ellipse (width/2, height/2, 20+2*i, 20+2*i);
    //winTextFill = i;
  }
  //popMatrix(); 
}

void mousePressed() {
  //for debugging purpose only
  ps.removeParticle();
  winCount++;
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();

  super.stop();
}

void keyPressed() {
  /* try {
   saveFrame("screenshot.png");
   } 
   catch (Exception e) {
   } */
  winCount = 0;
  health = 1000;
  play = true;
  timer.start();
}

