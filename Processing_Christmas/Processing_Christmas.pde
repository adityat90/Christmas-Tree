import processing.serial.*;

import ddf.minim.analysis.*;
import ddf.minim.*;
import mqtt.*;

Minim minim;
AudioInput in;
FFT fft;

int w;

//Serial myPort;

float maxRed = 0, maxGreen = 0, maxBlue = 0;

MQTTClient client;

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
  
  //String portName = Serial.list()[9];
  //myPort = new Serial(this, portName, 9600);
  client = new MQTTClient(this);
  client.connect("mqtt://mqttmum.adityatalpade.com:1883", "processing");
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
  
  //avgRed = avgRed > 1 ? 1 : avgRed;
  //avgGreen = avgGreen > 1 ? 1 : avgGreen;
  //avgBlue = avgBlue > 1 ? 1 : avgBlue;
  maxRed = maxRed > avgRed ? maxRed : avgRed;
  maxGreen = maxGreen > avgGreen ? maxGreen : avgGreen;
  maxBlue = maxBlue > avgBlue ? maxBlue : avgBlue;
  
  println("RED: " + avgRed + " GREEN: " + avgGreen + " BLUE: " + avgBlue);
  println("MAXRED: " + maxRed + " MAXGREEN: " + maxGreen + " MAXBLUE: " + maxBlue);
  
  avgRed = avgRed > 60 ? 60 : avgRed;
  avgGreen = avgGreen > 100 ? 100 : avgGreen;
  avgBlue = avgBlue > 150 ? 150 : avgBlue;
  
  avgRed = map(avgRed, 0, 60, 0.0, 1.0);
  avgGreen = map(avgGreen, 0, 100, 0.0, 1.0);
  avgBlue = map(avgBlue, 0, 150, 0.0, 1.0);
  
  avgRed = avgRed > 1 ? 1 : avgRed;
  avgGreen = avgGreen >1 ? 1 : avgGreen;
  avgBlue = avgBlue > 1 ? 1 : avgBlue;
  
  
  client.publish("admik/04c760ef/light-bar/data/set", "{redBrightness:"+nf(avgRed, 1, 3)+", blueBrightness:"+nf(avgBlue, 1, 3)+", greenBrightness:"+nf(avgGreen, 1, 3)+"}");
  //delay(50);
 //myPort.write("Red: " + avgRed + " Green: " + avgGreen + " Blue: " + avgBlue);
  //myPort.write('r');
  //myPort.write((char)avgRed);
  //myPort.write('g');
  //myPort.write((int)avgGreen);
  //myPort.write('b');
  //myPort.write((int)avgBlue);
}

float mapfloat(float x, float in_min, float in_max, float out_min, float out_max)
{
 return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
