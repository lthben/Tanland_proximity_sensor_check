/**
 * Author: Benjamin Low (benjamin.low@digimagic.com.sg)
 * Date: Aug 2015
 * Description: Diagnostic program for the proximity sensor by visualising
 * the output of the proximity sensor reading from Arduino.
 * Keeps count of the number of balls detected. Press spacebar to reset
 * ballcount. This program assumes that Arduino constantly updates with
 * "valxxx" where xxx is the sensor value of 0 - 255. Arduino also updates
 * with "btnx" where x is 0 or 1 for button press. 
 */


import processing.serial.*;

//For reading settings file
String[] lines;
int a = 0; //index of serial port
int b = 1; //index of baud rate
int index = 0;

//settings
String portname = "COM1";
Serial myPort;  // Create object from Serial class
int BR = 9600;

//for incoming serial data
String in_string;

//Other 
int ball_count;

void setup() 
{
    size(400, 400);

    lines = loadStrings("settings.txt");
    if (index < lines.length) {
        String[] comport = split(lines[a], '=');
        portname = comport[1];
        print("COMPORT=");
        println(comport[1]);
        String[] br = split(lines[b], '=');
        BR = int(br[1]);
        print("BR=");
        println(br[1]);
    }    

    //     printArray(Serial.list());

    myPort = new Serial(this, portname, 9600);

}

void draw()
{
    background(0);

    textAlign(LEFT, CENTER);
    textSize(18);
    text("Diagnostic check for proximity sensor", 20, 20);
    textSize(14);
    text("Port name: " + portname, 20, 60);
    text("baud rate: " + BR, 20, 80);
    text("Note: ", 20, 340);
    text("- ball count is not accurate", 20, 360);
    text("- press spacebar to reset ball count", 20, 380);

    while (myPort.available () > 0) { 
      
        in_string = myPort.readStringUntil(10);   //linefeed, not CR which is 13
                
        if (in_string != null) {         
            if (in_string.contains("val")) { //and not "btn"
                
                in_string = in_string.substring(3);
                in_string = trim(in_string);
                
                //text(int(in_string), 200, 200);
                
                int my_int = int(in_string);
                
                if (my_int > 100 && my_int < 170) {
                    ball_count++;
                }
            }
        }
    }
     
    textSize(18);
    textAlign(CENTER, CENTER);
    text("balls detected: ", width/2, 150); 
    textSize(96);
    text(ball_count, width/2, height/2 + 24);
}

void keyPressed() {
    if (key == ' ') {
        ball_count = 0;
    }
}
