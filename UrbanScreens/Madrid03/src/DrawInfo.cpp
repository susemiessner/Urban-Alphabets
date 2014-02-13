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
    over=false;
    
    image1.loadImage("intro/intros-07.png");
    image2.loadImage("intro/intros-08.png");
    image3.loadImage("intro/intros-09.png");

}
void ofDrawInfo::update(){

    if(drawInfoYPos1>-ofGetHeight()){
        //printf("now\n");
        drawInfoYPos1-=1;
    } else if (drawInfoYPos2>-ofGetHeight()){
        drawInfoYPos2-=1;
    /*}else if (drawInfoYPos3>-ofGetHeight()){
        drawInfoYPos3-=1;*/
    } else{
        printf("Info Screen over\n");
        over=true;
    }
   
    
}
void ofDrawInfo::draw(){
    int xPos=0;
    
    ofSetColor(255);
    if(drawInfoYPos1>-ofGetHeight()){
        //printf("now\n");
        image1.draw(xPos, drawInfoYPos1);
    } else if (drawInfoYPos2>-ofGetHeight()){
        image2.draw(xPos, drawInfoYPos2);
    }else if (drawInfoYPos3>-ofGetHeight()){
        image3.draw(xPos, drawInfoYPos3);
    }
    /*
    text14.drawString("To contribute to \nthis project \ndownload \n'Urban Alphabets'\nfrom the App Store.", xPos, drawInfoYPos1);
    
    text14.drawString("Contributions will\nappear on\nthis screen\nafter you\nuploaded them.", xPos, drawInfoYPos2);
    text14.drawString("more info and\ndownload link at: \nwww.ualphabets.com", xPos, drawInfoYPos3);*/

}
void ofDrawInfo::reset(){
    drawInfoYPos1=ofGetHeight()+20;
    drawInfoYPos2=ofGetHeight()+20;
    drawInfoYPos3=ofGetHeight()+20;
    over=false;
}

