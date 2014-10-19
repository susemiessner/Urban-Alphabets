
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
    ofImage  titleFacade, titleLED2, contributeLED2;
    
    About(){
        titleFacade.loadImage("intro_facade/intro_Title.png"); //title
        titleLED2.loadImage("intro_LED2/intro_Title.png"); //title
        contributeLED2.loadImage("intro_LED2/intro_createAlphabet.png"); //contribute + link

        reset();
    }
    void update(){
        counter++;
    }
    void draw(){
        ofSetColor(255);
        ofEnableAlphaBlending();
        if(counter<lengthEachScreen*FRAME_RATE*2){
            //blend in
            if(counter<lengthBlend*FRAME_RATE){
                blendAbout+=10;
                ofSetColor(255,255,255,blendAbout);
            }
            //blend out
            if(counter>lengthEachScreen*FRAME_RATE*2-lengthBlend*FRAME_RATE){
                blendAbout-=10;
                ofSetColor(255,255,255,blendAbout);
            }
            //facade
            titleFacade.draw(37,259);
            //LED2
            ofPushMatrix();
            ofTranslate(508, 77);
            
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
                titleLED2.draw(0,0);
            }else if(counter<lengthEachScreen*FRAME_RATE*2){
                //blend in
                if(counter<lengthBlend*FRAME_RATE*2){
                    blendAbout+=10;
                    ofSetColor(255,255,255,blendAbout);
                }
                //blend out
                if(counter>lengthEachScreen*FRAME_RATE*2-lengthBlend*FRAME_RATE){
                    blendAbout-=10;
                    ofSetColor(255,255,255,blendAbout);
                }
                contributeLED2.draw(0,0);
            }
            ofPopMatrix();


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