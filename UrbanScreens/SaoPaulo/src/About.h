
//
//  About.h
//  Riga01
//
//  Created by Suse on 10/05/14.
//
//

#ifndef Riga01_About_h
#define Riga01_About_h
#include "ofApp.h"
#define FRAME_RATE 70

class About{
public:
    int counter=0;
    bool over;
    int lengthEachScreen=5; //length of each of the images in secs
    int lengthBlend=1;
    int blendAbout=0;
    ofImage  title;
    
    About(){
        title.loadImage("intro/intro_Title.png"); //title
        reset();
    }
    void update(){
        counter++;
    }
    void draw(){
        ofSetColor(255);
        ofEnableAlphaBlending();
        if(counter<lengthEachScreen*FRAME_RATE){
            //blend in
            if(counter<lengthBlend*FRAME_RATE){
                blendAbout+=10;
                ofSetColor(255,255,255,blendAbout);
            }
            //blend out
            if(counter>lengthEachScreen*FRAME_RATE-lengthBlend*FRAME_RATE){
                blendAbout-=10;
                ofSetColor(255,255,255,blendAbout);
            }
            title.draw(37,259);
        } else {
            over=true;
        };
        ofDisableAlphaBlending();
    }
    void reset(){
        counter=0;
        over=false;
    }
};


#endif