int redLed = 9;
int greenLed = 10;
int blueLed = 11;
String text = "";
char character;

int ctr = 0;

// the setup routine runs once when you press reset:
void setup()  { 
  // declare pin 9 to be an output:
  pinMode(redLed, OUTPUT);
  pinMode(greenLed, OUTPUT);
  pinMode(blueLed, OUTPUT);
  
  Serial.begin(9600);
  ctr = 0;
} 

// the loop routine runs over and over again forever:
void loop()  {
  while (Serial.available()) {
    character = Serial.read();
    if (character == 'r') {
      ctr = 9;
    } else if (character == 'g') {
      ctr = 10;
    } else if (character == 'b') {
      ctr = 11;
    } else {
//      analogWrite(9, 0);
//      analogWrite(10, 0);
//      analogWrite(11, 0);
      analogWrite(ctr, character);
    }
  }
}

