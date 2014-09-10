
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
    int lengthEachScreen=5; //length of each of the images in secs
    int lengthBlend=1;
    int blendAbout=0;
    ofImage  create, title;
    
    int videoIntroCounter=0;
    ofVideoPlayer video;

    About(){
        title.loadImage("intro/intro_Title.png"); //title
        create.loadImage("intro/intro_createAlphabet.png"); //the short description with link
        video.loadMovie("intro/Suse Intro.mp4");
        video.setLoopState(OF_LOOP_NONE);

        reset();
    }
    void update(){
        if(video.getCurrentFrame()==0){
            video.play();
        }
        if(video.getIsMovieDone()==false){
            video.update();
        } else{
            counter++;
        }
    }
    void draw(){
        ofSetColor(255);
        if(video.getIsMovieDone()==false){
            video.draw(0, 0);
        } else{
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
            } else if(counter<lengthEachScreen*FRAME_RATE*2){
                //blend in
                if(counter<lengthEachScreen*FRAME_RATE+lengthBlend*FRAME_RATE){
                    blendAbout+=10;
                    ofSetColor(255,255,255,blendAbout);
                }
                //blend out
                if(counter>lengthEachScreen*FRAME_RATE+lengthEachScreen*FRAME_RATE-lengthBlend*FRAME_RATE){
                    blendAbout-=10;
                    ofSetColor(255,255,255,blendAbout);
                }
                create.draw(0,0);
            } else if (counter>lengthEachScreen*FRAME_RATE*2){
                over=true;
            };
            ofDisableAlphaBlending();
        }
    }
    void reset(){
        counter=0;
        over=false;
        videoIntroCounter++;
        if(videoIntroCounter==13){
            //videoIntroCounter=0;
            //video.setFrame(0);
        }
    }
};


#endif