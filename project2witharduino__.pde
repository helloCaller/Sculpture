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
boolean bang4ClickHasHappened;
boolean bang5ClickHasHappened;
boolean bang6ClickHasHappened;
String ClockDirection = "Counter Clockwise ";

float particleMove;
float random = random(10,100);
int squareID;
float velocity = 0;// set initial force of turn to 0
float acceleration = 0.1; //set initial acceleration to 0.001 for a gradual application
boolean clickForSlider = false;
boolean clickForBang = false;
boolean clickForBang2 = false;
boolean firstContact = false;

boolean sendValue = false;
String processingHIGHLOW;
String previousHIGHLOWvalue;
Square square1;
Square square2;
Square square3;

RealWheel wheel1;
RealWheel wheel2;
RealWheel wheel3;

int count;
ControlP5 rotationSpeedSlider;
ControlP5 highLowBang;
ControlP5 spinning;
Serial myPort;

String [] HIGHLOWarray = new String[1];

void setup() { //everything we need to setup once
  size(640, 640); //set up the size of the project
  //fullScreen();
  stroke(100, 110, 0);
  rectMode(CENTER);
 
  
  rotationSpeedSlider = new ControlP5(this);
  highLowBang = new ControlP5(this);
   spinning = new ControlP5(this);
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.bufferUntil('\n'); 
  
  PFont myfont = createFont("Futura-Medium",20);
  ControlFont font = new ControlFont(myfont,241);

//xpos,ypos,size,r,g,b,rotation, rotationSpeed, id,
  square1 = new Square(width/4, height/2, 100, 200, 255, 255, 100, 0);
  square2 = new Square(width/2, height - 100, 100, 200, 200, 40,100,1);
  square3 = new Square(width/2, height/4, 100, 200, 200, 200, 100,2);
  
  wheel1 = new RealWheel(500, true, " ");
  wheel2 = new RealWheel(500, true, "HIGH");
  wheel3 = new RealWheel(500, true, "HIGH");

  
  
    rotationSpeedSlider.addSlider("Rotation Speed Wheel 1")
       .setPosition(width/2,height/2)
       .setSize(200,20)
       .setRange(300,1000)
       .setValue(500)
       .setId(1)
     //.setBroadcast(false)
     ;
     rotationSpeedSlider.hide();
     rotationSpeedSlider.getController("Rotation Speed Wheel 1").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    
     rotationSpeedSlider.getController("Rotation Speed Wheel 1")
       .getCaptionLabel()
       .setFont(font)
       .toUpperCase(false)
       .setSize(14)
     ;


 for(int b=1;b<=3;b++) {
   highLowBang.addBang("Bang Control "+b)
      .setPosition(width/3 + b*100, height/2 + b*30)
      .setSize(40, 40)
      .setId(b+1)
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
 
  for(int b=1;b<=3;b++) {
   spinning.addBang("Bang Control "+b)
      .setPosition(width/3 + b*100, height/2 + b*30)
      .setSize(40, 40)
      .setId(4+b)
      .setLabel("Wheel " + b + "   Start/Stop")
      ;
      
       spinning.getController("Bang Control " + b)
       .getCaptionLabel()
       .setFont(font)
       .toUpperCase(false)
       .setSize(14)
     ;
     spinning.getController("Bang Control " + b).getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0);
     spinning.hide();
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
  
if((wheel1.HIGHLOW == "HIGH") && (sendValue == true)){
  myPort.write('1');
  sendValue = false;
  println("sent");
} else if(wheel1.HIGHLOW =="LOW" && sendValue == true){
  myPort.write('0');
  sendValue = false;
}
if((wheel1.spinning == false) && (sendValue == true)){
  myPort.write('2');
  sendValue = false;
  println("sent spinning");
} else if((wheel1.spinning == true) && (sendValue == true)){
  myPort.write('3');
  sendValue = false;
}
if((wheel2.spinning == false) && (sendValue == true)){
  myPort.write('4');
  sendValue = false;
  println("sent spinning");
} else if((wheel2.spinning == true) && (sendValue == true)){
  myPort.write('5');
  sendValue = false;
}
if((wheel3.spinning == false) && (sendValue == true)){
  myPort.write('6');
  sendValue = false;
  println("sent spinning");
} else if((wheel3.spinning == true) && (sendValue == true)){
  myPort.write('7');
  sendValue = false;
}
  

 if(keyPressed){
myPort.write('R');
}
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
   int rotationSpeed;
   boolean spinning;
   String HIGHLOW;
     RealWheel(int _rotationSpeed, boolean _spinning, String _HIGHLOW){
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
    case(2): if(bang1ClickHasHappened == false){  // numberboxB is registered with id 2
              sendValue = true;
             previousHIGHLOWvalue = wheel1.HIGHLOW;
             wheel1.HIGHLOW = "LOW";
             ClockDirection = "Clockwise ";
             bang1ClickHasHappened = true;
          } else {
            sendValue = true;
            previousHIGHLOWvalue = wheel1.HIGHLOW;
            wheel1.HIGHLOW = "HIGH";
             ClockDirection = "Counter Clockwise ";
             bang1ClickHasHappened = false;
          }
            
    break;
    
    case(3): if(bang2ClickHasHappened == false){  // numberboxB is registered with id 2
            sendValue = true;
             wheel2.HIGHLOW = "LOW";
             ClockDirection = "Clockwise ";
             bang2ClickHasHappened = true;
          } else {
            sendValue=true;
            wheel2.HIGHLOW = "HIGH";
             ClockDirection = "Counter Clockwise ";
             bang2ClickHasHappened = false;
          }
    break;
    
    case(4): if(bang3ClickHasHappened == false){
              sendValue = true;
             wheel3.HIGHLOW = "LOW";
             ClockDirection = "Clockwise ";
             bang3ClickHasHappened = true;
          } else {
            sendValue = true;
            wheel3.HIGHLOW = "HIGH";
             ClockDirection = "Counter Clockwise ";
             bang3ClickHasHappened = false;
          }
    break;
    case(5): if(bang4ClickHasHappened == false){
            sendValue = true;
           
            wheel1.spinning = false;
            bang4ClickHasHappened = true;
          } else {
             sendValue = true;
             wheel1.spinning = true;
            bang4ClickHasHappened = false;
          }
      break;
      case(6): if(bang5ClickHasHappened == false){
            sendValue = true;
            
            wheel2.spinning = false;
            bang5ClickHasHappened = true;
          } else {
             sendValue = true;
             wheel2.spinning = true;
            bang5ClickHasHappened = false;
                }
      break;
      case(7): if(bang6ClickHasHappened == false){
            sendValue = true;
           
            wheel3.spinning = false;
            bang6ClickHasHappened = true;
          } else {
             sendValue = true;
             wheel3.spinning = true;
            bang6ClickHasHappened = false;
          }
      break;
            
    
  }
  
  
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
     
       if(mouseX>square3.xPosition && mouseX <square3.xPosition + square3.size && mouseY>square3.yPosition && mouseY <square3.yPosition + square3.size && clickForBang2==false){
    clickForBang2 = true;
      } else if(mouseX>square3.xPosition && mouseX <square3.xPosition + square3.size && mouseY>square3.yPosition && mouseY <square3.yPosition + square3.size && clickForBang2==true) {
      clickForBang2 = false;
      }
    if(clickForBang2 && clickForSlider == false  ){
      spinning.show();
      }else {
      spinning.hide();
     }
 }
 
 
 