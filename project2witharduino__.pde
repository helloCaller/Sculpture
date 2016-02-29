/*
  I've been pursuing an interest in forces in Processing, so here is a first stab at applying
 velocity to an angle.
 
 Hold down any key and watch as the image spins faster and faster, let the key go and the image winds down to a stop.
 
 Created by Luke Garwood
 with adaptations from The Nature of Code by Daniel Shiffman
 http://natureofcode.com/book/chapter-3-oscillation/2
 
 
 http://www.openprocessing.org/sketch/155442
 https://learn.sparkfun.com/tutorials/connecting-arduino-to-processing
 
 */

import controlP5.*;
import processing.serial.*;

String val;

PFont myfont;

//---Global variables
boolean bang1ClickHasHappened;
boolean bang2ClickHasHappened;
boolean bang3ClickHasHappened;
String ClockDirection = "Counter Clockwise ";

float particleMove;
float random = random(10,100);
int squareID;
float velocity = 0;// set initial force of turn to 0
float acceleration = 0.1; //set initial acceleration to 0.001 for a gradual application
boolean clickForSlider = false;
boolean clickForBang = false;
boolean firstContact = false;

String processingHIGHLOW;

Square square1;
Square square2;
Square square3;

RealWheel wheel1;
RealWheel wheel2;
RealWheel wheel3;

int count;
ControlP5 rotationSpeedSlider;
ControlP5 highLowBang;
Serial myPort;


void setup() { //everything we need to setup once
  size(640, 640); //set up the size of the project
  //fullScreen();
  stroke(100, 110, 0);
  rectMode(CENTER);
 
  
  rotationSpeedSlider = new ControlP5(this);
  highLowBang = new ControlP5(this);
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.bufferUntil('\n'); 
  
  PFont myfont = createFont("Futura-Medium",20);
  ControlFont font = new ControlFont(myfont,241);

//xpos,ypos,size,r,g,b,rotation, rotationSpeed, id,
  square1 = new Square(width/4, height/2, 100, 200, 255, 255, 100, 0);
  square2 = new Square(width/2, height - 100, 100, 200, 200, 40,100,1);
  square3 = new Square(width/2, height/4, 100, 200, 200, 200, 100,2);
  
  wheel1 = new RealWheel(500.00, true, " ");
  wheel2 = new RealWheel(500.00, true, "HIGH");
  wheel3 = new RealWheel(500.00, true, "HIGH");

  
  for (int i =1; i <=3; i++){
    rotationSpeedSlider.addSlider("Rotation Speed Wheel " + i)
       .setPosition(width/2,height/2 +i*40)
       .setSize(200,20)
       .setRange(0,200)
       .setValue(100)
       .setId(i)
     //.setBroadcast(false)
     ;
     rotationSpeedSlider.hide();
     rotationSpeedSlider.getController("Rotation Speed Wheel " + i).getCaptionLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    
     rotationSpeedSlider.getController("Rotation Speed Wheel " + i)
       .getCaptionLabel()
       .setFont(font)
       .toUpperCase(false)
       .setSize(14)
     ;
}

 for(int b=1;b<=3;b++) {
   highLowBang.addBang("Bang Control "+b)
      .setPosition(width/3 + b*100, height/2 + b*30)
      .setSize(40, 40)
      .setId(3+b)
      .setLabel(ClockDirection+b)
      ;
      //highLowBang.hide();
       highLowBang.getController("Bang Control " + b)
       .getCaptionLabel()
       .setFont(font)
       .toUpperCase(false)
       .setSize(14)
     ;
     highLowBang.getController("Bang Control " + b).getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0);
     highLowBang.hide();
 }
  
 
    
  


}

void draw() {// draw is like our void Loop friend from arduino
  background(5); 
  strokeWeight(0);//no border
  fill(255,255,255,30);

   //--randomish particles
   for(int i = 0; i < 360; i++){
    float angle = cos(radians(i* random + particleMove))*width/3;
    float x = width/2+sin(radians(i))*angle;
    float y = height/2+cos(radians(i))*angle;
    ellipse(x, y, 3, 3);
  }
  particleMove += 0.11; //speed at which particles move
  //----
  square1.drawsquare();
  square2.drawsquare();
  square3.drawsquare();
 
  
  //---serial message
if(wheel1.HIGHLOW == "HIGH"){
  
myPort.write('1');

}


  


//println("square 1 " + square1.rotationSpeed);
   //float rotation = rotationSpeedSlider.getController("Rotation Speed").getValue();
   // println(rotation);
}//---end of draw()


class Square {
  int xPosition;
  int yPosition;
  int size;
  int r;
  int g;
  int b;
  float rot;
 
  int ID;
  Square(int _xPosition, int _yPosition, int _size, int _r, int _g, int _b, float _rot, int _ID) {
    xPosition = _xPosition;
    yPosition =_yPosition;
    size = _size;
    r = _r;
    g = _g;
    b = _b;
    rot = _rot;
    ID = _ID;
  }

  void drawsquare() {
    pushMatrix(); 
    translate(xPosition, yPosition);

    float distance = dist(mouseX, mouseY, xPosition, yPosition);
    
    for (int i = size; i > 0; i -= 7) {
      stroke(r, g, b);
      if (i<=7) {
        fill(255, 255, 255);
      } else {
        fill(r, g - i, b - i, 36);
      }
      if (distance < size*1.5) {
        rotate((mouseX + mouseY) / rot);
        
        stroke(r-40, g-20, b-40);
      }
      rect(0, 0, i, i);
    }
    popMatrix();
  }
  
    
  
} //--end of square class

 class RealWheel{
   float rotationSpeed;
   boolean spinning;
   String HIGHLOW;
     RealWheel(float _rotationSpeed, boolean _spinning, String _HIGHLOW){
       rotationSpeed =_rotationSpeed;
       spinning = _spinning;
       HIGHLOW = _HIGHLOW;
     }
 
 }//--end of RealWheel class

public void controlEvent(ControlEvent theEvent) {
  switch(theEvent.getId()) {
    case(1): // numberboxA is registered with id 1
     wheel1.rotationSpeed =(int) (theEvent.getController().getValue());
     
    break;
    case(2):  // numberboxB is registered with id 2
    wheel2.rotationSpeed =(int) (theEvent.getController().getValue());
   
    break;
    
    case(3):  // numberboxB is registered with id 2
    wheel3.rotationSpeed =(int) (theEvent.getController().getValue());
    break;
    
    case(4): if(bang1ClickHasHappened == false){  // numberboxB is registered with id 2
             wheel1.HIGHLOW = "LOW";
             ClockDirection = "Clockwise ";
             bang1ClickHasHappened = true;
          } else {
            wheel1.HIGHLOW = "HIGH";
             ClockDirection = "Counter Clockwise ";
             bang1ClickHasHappened = false;
          }
            
    break;
    
    case(5): if(bang2ClickHasHappened == false){  // numberboxB is registered with id 2
             wheel2.HIGHLOW = "LOW";
             ClockDirection = "Clockwise ";
             bang2ClickHasHappened = true;
          } else {
            wheel2.HIGHLOW = "HIGH";
             ClockDirection = "Counter Clockwise ";
             bang2ClickHasHappened = false;
          }
    break;
    
    case(6): if(bang3ClickHasHappened == false){
             wheel3.HIGHLOW = "LOW";
             ClockDirection = "Clockwise ";
             bang3ClickHasHappened = true;
          } else {
            wheel3.HIGHLOW = "HIGH";
             ClockDirection = "Counter Clockwise ";
             bang3ClickHasHappened = false;
          }
    break;
  }
  
  
}
public void bang() {
  
}

void mouseClicked(){  
  
     if(mouseX>square1.xPosition && mouseX <square1.xPosition + square1.size && mouseY>square1.yPosition && mouseY <square1.yPosition + square1.size && clickForSlider==false){
    clickForSlider = true;
      } else if(mouseX>square1.xPosition && mouseX <square1.xPosition + square1.size && mouseY>square1.yPosition && mouseY <square1.yPosition + square1.size && clickForSlider==true) {
      clickForSlider = false;
      }
  
  if(clickForSlider && clickForBang == false){
    rotationSpeedSlider.show();
  }else {
    rotationSpeedSlider.hide();
   }
   
   
   if(mouseX>square2.xPosition && mouseX <square2.xPosition + square1.size && mouseY>square2.yPosition && mouseY <square2.yPosition + square2.size && clickForBang==false){
    clickForBang = true;
      } else if(mouseX>square2.xPosition && mouseX <square2.xPosition + square2.size && mouseY>square2.yPosition && mouseY <square2.yPosition + square2.size && clickForBang==true) {
      clickForBang = false;
      }
    if(clickForBang && clickForSlider == false){
      highLowBang.show();
      }else {
      highLowBang.hide();
     }
 }
 //void serialEvent( Serial myPort) {
////put the incoming data into a String - 
////the '\n' is our end delimiter indicating the end of a complete packet
//val = myPort.readStringUntil('\n');
////make sure our data isn't empty before continuing
//if (val != null) {
 ////trim whitespace and formatting characters (like carriage return)
 //val = trim(val);
 //println(val);

 ////look for our 'A' string to start the handshake
 ////if it's there, clear the buffer, and send a request for data
 //if (firstContact == false) {
 //  if (val.equals("A")) {
 //    myPort.clear();
 //    firstContact = true;
 //    //myPort.write("A");
 //    println("contact");
 //  }
 //}
 //else { //if we've already established contact, keep getting and parsing data
 //  println(val);

 //  if (wheel1.HIGHLOW == "HIGH") {                           //if we clicked in the window
 //    myPort.write(1);        //send a 1
 //    println("1");
 //  } 

 //  // when you've parsed the data you have, ask for more:
 // myPort.write("A");
 //  }
 //}
//}////