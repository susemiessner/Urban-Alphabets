//
//  About.h
//  Riga01
//
//  Created by Suse on 10/05/14.
//
//

#ifndef Riga01_About_h
#define Riga01_About_h
class About{
public:    
    float drawInfoYPos1;
    float drawInfoYPos2;
    float drawInfoYPos3;
    float drawInfoYPos4;
    float drawInfoYPos5;

    bool over;
    
    ofImage image1, image2, image3, image4, image5;
    
    About(){
    
        image1.loadImage("intro/credits-14.png"); //produced by mcult
        image2.loadImage("intro/intros-08.png"); //find link at
        image3.loadImage("intro/intros-10.png"); //link
        image4.loadImage("intro/intros-07.png"); //contribute
        image5.loadImage("intro/credits-13.png"); //CCN event
        
        reset();
    }
    void update(){
        if(drawInfoYPos5>-image5.height){
            //printf("now\n");
            drawInfoYPos1-=1;
            drawInfoYPos5-=1;
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
    void draw(){
        int xPos=0;
        ofSetColor(255);
        if(drawInfoYPos5>-image5.height){
            image1.draw(xPos, drawInfoYPos1);
            image5.draw(xPos, drawInfoYPos5);
        } else if(drawInfoYPos4>-image4.height){
            image4.draw(xPos, drawInfoYPos4);
        }
        else if (drawInfoYPos2>-image2.height-40){
            image2.draw(xPos, drawInfoYPos2);
            image3.draw(xPos, drawInfoYPos3);
        }
    }
    void reset(){
        drawInfoYPos1=125+32;
        drawInfoYPos2=125+32;
        drawInfoYPos3=drawInfoYPos2+image2.height+5;
        drawInfoYPos4=125+32;
        drawInfoYPos5=drawInfoYPos1+image1.height+30;
        
        over=false;

    }
};


#endif
