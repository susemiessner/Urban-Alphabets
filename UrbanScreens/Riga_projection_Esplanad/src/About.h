//
//  About.h
//  Riga01
//
//  Created by Suse on 10/05/14.
//
//

#ifndef Riga01_About_h
#define Riga01_About_h
#include "testApp.h"
#define FRAME_RATE 70

class About{
public:    
    int counter=0;
    bool over;
    int lengthEachScreen=3; //length of each of the images in secs
    int lengthBlend=1;
    int blendAbout=0;
    int barHeight=96;
    ofImage credits, link, contribute, collective;
    
    About(){
    
        credits.loadImage("intro/intro_Credits.png"); //produced by mcult
        link.loadImage("intro/intro_link.png"); //find link at
        contribute.loadImage("intro/intro_Contribute.png"); //contribute
        collective.loadImage("intro/intro_Collective.png"); //collectively
        
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
            collective.draw(0,barHeight);
        } else if(counter>lengthEachScreen*FRAME_RATE && counter<lengthEachScreen*2*FRAME_RATE){
            //blend in
            if(counter<lengthEachScreen*FRAME_RATE+lengthBlend*FRAME_RATE){
                blendAbout+=10;
                ofSetColor(255,255,255,blendAbout);
            }
            //blend out
            if(counter>2*lengthEachScreen*FRAME_RATE-lengthBlend*FRAME_RATE){
                blendAbout-=10;
                ofSetColor(255,255,255,blendAbout);
            }
            
            contribute.draw(0,barHeight);
        }
        
        else if( counter>lengthEachScreen*2*FRAME_RATE && counter<lengthEachScreen*4*FRAME_RATE){ //it's double the length of the other screens
            //blend in
            if(counter<lengthEachScreen*2*FRAME_RATE+lengthBlend*FRAME_RATE){
                blendAbout+=10;
                ofSetColor(255,255,255,blendAbout);
            }
            //blend out
            if(counter>4*lengthEachScreen*FRAME_RATE-lengthBlend*FRAME_RATE){
                blendAbout-=10;
                ofSetColor(255,255,255,blendAbout);
            }
            link.draw(0,barHeight);
        } else if(counter>lengthEachScreen*4*FRAME_RATE && counter<lengthEachScreen*5*FRAME_RATE){
            //blend in
            if(counter<4*lengthEachScreen*FRAME_RATE+lengthBlend*FRAME_RATE){
                blendAbout+=10;
                ofSetColor(255,255,255,blendAbout);
            }
            //blend out
            if(counter>5*lengthEachScreen*FRAME_RATE-lengthBlend*FRAME_RATE){
                blendAbout-=10;
                ofSetColor(255,255,255,blendAbout);
            }
            
            credits.draw(0,barHeight);
        } else if (counter>lengthEachScreen*5*FRAME_RATE){
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
