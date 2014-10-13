
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
    ofImage  title, contribute, moreInfo, titleLiverpool;
    
    About(){
        title.loadImage("intro/intro_Title.png"); //title
        contribute.loadImage("intro/intro_createAlphabet.png"); //contribute
        moreInfo.loadImage("intro/intro_more info.png"); //intro link
        titleLiverpool.loadImage("intro/intro_currentAlphabet.png");// liverpool alphabet title
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
            title.draw(0,0);
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
            contribute.draw(0,0);
        }else if(counter<lengthEachScreen*FRAME_RATE*3){
            //blend in
            if(counter<lengthBlend*FRAME_RATE*3){
                blendAbout+=10;
                ofSetColor(255,255,255,blendAbout);
            }
            //blend out
            if(counter>lengthEachScreen*FRAME_RATE*3-lengthBlend*FRAME_RATE){
                blendAbout-=10;
                ofSetColor(255,255,255,blendAbout);
            }
            moreInfo.draw(0,0);
        }else if(counter<lengthEachScreen*FRAME_RATE*4){
            //blend in
            if(counter<lengthBlend*FRAME_RATE*4){
                blendAbout+=10;
                ofSetColor(255,255,255,blendAbout);
            }
            //blend out
            if(counter>lengthEachScreen*FRAME_RATE*4-lengthBlend*FRAME_RATE){
                blendAbout-=10;
                ofSetColor(255,255,255,blendAbout);
            }
            titleLiverpool.draw(0,0);
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