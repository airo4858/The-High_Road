/*
  AnalogReadSerial

  Reads an analog input on pin 0, prints the result to the Serial Monitor.
  Graphical representation is available using Serial Plotter (Tools > Serial Plotter menu).
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.

  This example code is in the public domain.

  https://www.arduino.cc/en/Tutorial/BuiltInExamples/AnalogReadSerial
*/

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  //pinMode(sensorValue0, INPUT);
  //pinMode(sensorValue1, INPUT);
  //pinMode(sensorValue2, INPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // print out the value you read:
  int sensorValue0 = analogRead(A0);
  int sensorValue1 = analogRead(A1);
  int sensorValue2 = analogRead(A2);
  Serial.print(sensorValue0);
  Serial.print("|");
  Serial.print(sensorValue1);
  Serial.print("|");
  Serial.println(sensorValue2);
  //delay(1);  // delay in between reads for stability  
}
