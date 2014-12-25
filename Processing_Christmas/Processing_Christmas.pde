import processing.serial.*;

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fft;

int w;

Serial myPort;

void setup() {
  size(640, 480);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.logAverages(150, 7);
  stroke(255);
  
  w = width / fft.avgSize();
  strokeWeight(w);
  strokeCap(SQUARE);
  
  String portName = Serial.list()[9];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(0);
  
  fft.forward(in.mix);
  float avgRed = 0;
  float avgGreen = 0;
  float avgBlue = 0;
  for(int i = 0; i < fft.avgSize(); i++) {
    line((i * w) + (w / 2), height, (i * w) + (w / 2), height - fft.getAvg(i) * 4);
  }
  
  for(int i = 0; i < fft.avgSize() / 3; i++) {
    avgRed = avgRed + fft.getAvg(i);
  }
  
  for(int i = fft.avgSize() / 3; i < fft.avgSize() / 3 * 2; i++) {
    avgGreen = avgGreen + fft.getAvg(i);
  }
  
  for(int i = fft.avgSize() / 3 * 2; i < fft.avgSize(); i++) {
    avgBlue = avgBlue + fft.getAvg(i);
  }
//  myPort.write("Red: " + avgRed + " Green: " + avgGreen + " Blue: " + avgBlue);
  myPort.write('r');
  myPort.write((char)avgRed);
  myPort.write('g');
  myPort.write((int)avgGreen);
  myPort.write('b');
  myPort.write((int)avgBlue);
}
