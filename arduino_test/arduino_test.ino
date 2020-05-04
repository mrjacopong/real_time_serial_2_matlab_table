
int i = 0;
char stringa_da_stampare[1000];

// The setup routine runs once when you press reset:
void setup() {
  // Initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  Serial.print("tempo;dato1;dato2");
  Serial.write(13);
  Serial.write(10);
}

// The loop routine runs over and over again forever:
void loop() {
  // Write the data "millis();i;i/2", followed by the terminator "Carriage Return" and "Linefeed".

  sprintf(stringa_da_stampare,"%lu;%d;%d",millis(),i,i/2);
  Serial.print(stringa_da_stampare);
  Serial.write(13);
  Serial.write(10);
  delay(100);
  i++;
  if (i==10)
    i -= 100;
}
