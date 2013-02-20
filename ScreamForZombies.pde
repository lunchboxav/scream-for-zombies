/** 
* Made as a demo purpose for Kelas Inspirasi, to teach elementary
* school students about interaction design
* Based on Simple Particle System by Daniel Shiffman
* SVG image as pointed by Processing PShape Reference
*/


import java.util.Iterator;
import ddf.minim.*;

PShape s;
PFont font;

Minim minim;
AudioInput in;

int scaledAudioInput;

float sum;
float averageAudioInput;

ParticleSystem ps;

void setup() {
  size(1280, 720, OPENGL);
  ellipseMode (CENTER);
  colorMode(HSB);
  smooth();
  ps = new ParticleSystem(new PVector(width/2, height/2, 30));
  minim = new Minim(this);
  
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);

  s = loadShape ("bot.svg");
  
  //textFont(createFont("HappySans", 48));
  //loadFont
  font = loadFont("HappySans-96.vlw");
  textFont(font, 96);
}

void draw() {
  background(0);


  sum=0;

  for (int i = 0; i < in.bufferSize() - 1; i++) {
    //line(i, height/2 + in.left.get(i)*height/2, i+1, height/2 + in.right.get(i+1)*height/2);

    sum=sum+abs(in.right.get(i));
  }

  // get average value of all samples
  averageAudioInput= sum/in.bufferSize();
  // scale this higher and clamp no higher than 255, also turn to integer which anaologWrite requires
  scaledAudioInput=int(constrain(averageAudioInput*2555, 0, 1000));

  if (scaledAudioInput > 980) {

    ps.removeParticle();
  } 
  else {
    ps.addParticle();
    ps.run();
    println (scaledAudioInput);
  }
}

void mousePressed() {
  ps.removeParticle();
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();

  super.stop();
}

