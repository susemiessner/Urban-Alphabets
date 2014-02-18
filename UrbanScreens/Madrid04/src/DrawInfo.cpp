//
//  DrawInfo.cpp
//  openFrameworksLib
//
//  Created by Suse on 07/02/14.
//
//

#include "DrawInfo.h"


ofDrawInfo::ofDrawInfo(){
   
    image1.loadImage("intro/intros-07.png");
    image2.loadImage("intro/intros-08.png");
    image3.loadImage("intro/intros-10.png");
    
    drawInfoYPos1=125+32+20;
    drawInfoYPos2=125+32+20;
    drawInfoYPos3=drawInfoYPos2+image2.height+5;
    over=false;

}
void ofDrawInfo::update(){
    if(drawInfoYPos1>-image1.height){
        //printf("now\n");
        drawInfoYPos1-=1;
    } else if (drawInfoYPos2>-image2.height-40){
        drawInfoYPos2-=1;
        drawInfoYPos3-=1;
    }else{
        printf("Info Screen over\n");
        over=true;
    }
    if (drawInfoYPos3==60){
        drawInfoYPos3+=1;
    }
}
void ofDrawInfo::draw(){
    int xPos=0;
    ofSetColor(255);
    if(drawInfoYPos1>-image1.height){
        //printf("now\n");
        image1.draw(xPos, drawInfoYPos1);
    } else if (drawInfoYPos2>-image2.height-100){
        image2.draw(xPos, drawInfoYPos2);
        image3.draw(xPos, drawInfoYPos3);
    }

}
void ofDrawInfo::reset(){
    drawInfoYPos1=125+32+20;
    drawInfoYPos2=125+32+20;
    drawInfoYPos3=drawInfoYPos2+image2.height+5;
    over=false;
}

