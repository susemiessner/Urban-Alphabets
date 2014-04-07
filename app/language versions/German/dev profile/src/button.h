#pragma once

class Button{

public:
    float posX,posY,radius;
    bool isPressed; //returns for diff looks depending on button is pressed or not
    ofTrueTypeFont font1;

    //these foats represents the bounds of the button: left, right, top, bottom
    float l,r,t,b;
    
    void setup(){
        
        //font1.loadFont("Papyrus.ttc", 20);
       // font1.loadFont("Helvetica.dfont", 20);
        //loadFont(string filename, int fontsize, bool _bAntiAliased, bool _bFullCharacterSet, bool makeContours)
        font1.loadFont("Helvetica.dfont", 20,true, true,false);
        isPressed=false;
    
    }
    void update(){
    }
    
    void draw(float posX,float posY, float sizex, float sizey, string msg){
        //ofEnableAlphaBlending();
        //calculate bounding box
        l=posX;
        r=posX+sizex;
        t=posY;
        b=posY+sizey;
        //draw button rect
        // with color change if pressed
        if (isPressed) {
            ofSetColor(255, 147, 30);
        } else {
            ofSetColor(220,220,220,150);
        }
        ofRect(posX, posY, sizex, sizey);
        //text
        ofSetColor(0, 0, 0,255);
        //center the text on the button
        ofRectangle boundingMsg=font1.getStringBoundingBox(msg, 0, 0);
        int msgPosX=int((sizex-boundingMsg.width)/2);
        ofSetColor(0, 0, 0);
        font1.drawString(msg,posX+msgPosX, posY+35);
        
        //change color back
        ofSetColor(255, 255, 255,255);
        //ofDisableAlphaBlending();
    }
    
    void checkTouched(float touchX, float touchY){
        if (touchX>l && touchX<r && touchY>t && touchY<b) {
            isPressed=true;
        } else isPressed=false;
        
    }
};