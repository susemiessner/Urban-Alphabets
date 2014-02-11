//
//  DrawInfo.cpp
//  openFrameworksLib
//
//  Created by Suse on 07/02/14.
//
//

#include "DrawInfo.h"


ofDrawInfo::ofDrawInfo(){
    text14.loadFont("HelveticaNeueDeskUI.ttc", 14, true, true);
    text14.setLineHeight(18.0f);
    //text14.setLetterSpacing(0.9f);
    //bold14.loadFont
    drawInfoYPos1=ofGetHeight()+20;
    drawInfoYPos2=ofGetHeight()+20;
    drawInfoYPos3=ofGetHeight()+20;
}
void ofDrawInfo::update(){
    if(drawInfoYPos1>-120){
        //printf("now\n");
        drawInfoYPos1-=1;
    } else if (drawInfoYPos2>-110){
        drawInfoYPos2-=1;
    }else if (drawInfoYPos3>-110){
        drawInfoYPos3-=1;
    } else{
        //printf("Info Screen over\n");
    }
   
    
}
void ofDrawInfo::draw(){
    int xPos=7;
    
    ofSetColor(255);
    text14.drawString("To contribute to \nthis project \ndownload \n'Urban Alphabets'\nfrom the App Store.", xPos, drawInfoYPos1);
    
    text14.drawString("Letters taken using\nthe App and Urban \nPostcards \n(messages written\nin the App) will\n appear on\nthis screen soon\nafter you\nuploaded them.", xPos, drawInfoYPos2);
    text14.drawString("more info and\ndownload link at: \nwww.ualphabets.com", xPos, drawInfoYPos3);
}
