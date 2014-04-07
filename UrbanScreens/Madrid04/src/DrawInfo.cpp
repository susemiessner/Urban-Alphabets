//
//  DrawInfo.cpp
//  openFrameworksLib
//
//  Created by Suse on 07/02/14.
//
//

#include "DrawInfo.h"


ofDrawInfo::ofDrawInfo(){
   
    image1.loadImage("intro/credits-14.png"); //produced by mcult
    image2.loadImage("intro/intros-08.png"); //find link at
    image3.loadImage("intro/intros-10.png"); //link
    image4.loadImage("intro/intros-07.png"); //contribute
    image5.loadImage("intro/credits-13.png"); //CCN event
    image6.loadImage("intro/credits-15.png"); //arte 10 students
    
    drawInfoYPos1=125+32;
    drawInfoYPos2=125+32;
    drawInfoYPos3=drawInfoYPos2+image2.height+5;
    drawInfoYPos4=125+32;
    drawInfoYPos5=drawInfoYPos1+image1.height+30;
    drawInfoYPos6=125+32;
    over=false;

}
void ofDrawInfo::update(){
    if(drawInfoYPos5>-image5.height){
        //printf("now\n");
        drawInfoYPos1-=1;
        drawInfoYPos5-=1;
    } else if (drawInfoYPos6>-image6.height){
        drawInfoYPos6-=1;
    } else if(drawInfoYPos4>-image4.height){
        drawInfoYPos4-=1;
    }else if (drawInfoYPos2>-image2.height-40){
        drawInfoYPos2-=1;
        drawInfoYPos3-=1;
    }else{
        printf("Info Screen over\n");
        over=true;
    }
    if (drawInfoYPos3==80){
        drawInfoYPos3+=1;
    }
}
void ofDrawInfo::draw(){
    int xPos=0;
    ofSetColor(255);
    if(drawInfoYPos5>-image5.height){
        image1.draw(xPos, drawInfoYPos1);
        image5.draw(xPos, drawInfoYPos5);
    } else if (drawInfoYPos6>-image6.height){
        image6.draw(xPos, drawInfoYPos6);
    }else if(drawInfoYPos4>-image4.height){
        image4.draw(xPos, drawInfoYPos4);
    }
    else if (drawInfoYPos2>-image2.height-40){
        image2.draw(xPos, drawInfoYPos2);
        image3.draw(xPos, drawInfoYPos3);
    }

}
void ofDrawInfo::reset(){
    drawInfoYPos1=125+32;
    drawInfoYPos2=125+32;
    drawInfoYPos3=drawInfoYPos2+image2.height+5;
    over=false;
}

