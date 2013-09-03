#pragma once

class Notification{
    
public:
    //string message;
    int duration=20;
    ofColor background;
    ofTrueTypeFont font2;
    int counter;
    


    
    void setup(){
        //font2.loadFont("Papyrus.ttc", 20);
        font2.loadFont("Helvetica.dfont", 20);

        counter=0;
        //background (200,200,200);
    }
    void update(){
    
    }
    
    void draw(string message){
        if (counter<duration) {
            ofSetColor(255, 147, 30);
            int x1=10;
            int y1=100;
            int widthRect=ofGetWidth()-2*x1;
            int heightRect=ofGetHeight()-2*y1;
            ofRect(x1,y1, widthRect,heightRect);
            
            
            //center the text on button vertically
            ofRectangle boundingMsg=font2.getStringBoundingBox(message, 0, 0);
            int msgPosY= int((heightRect-boundingMsg.height)/2);
            int msgPosX=int((widthRect-boundingMsg.width)/2);
            //ofSetColor(200, 200, 200);
            //font1.drawString(msg,posX+msgPosX, posY+35);
            
            
            ofSetColor(0,0,0,255);
            font2.drawString(message, x1+msgPosX,y1+msgPosY);
        }
        counter++;
        ofSetColor(255, 255, 255,255);
    }
};