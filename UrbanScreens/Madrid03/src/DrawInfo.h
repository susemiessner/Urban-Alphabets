//
//  DrawInfo.h
//  openFrameworksLib
//
//  Created by Suse on 07/02/14.
//
//

#ifndef _DrawInfo__
#define _DrawInfo__


#include "ofMain.h"

class ofDrawInfo{
public:
    ofDrawInfo(); //constructor
   
    ofTrueTypeFont text14;

    float drawInfoYPos1;
    float drawInfoYPos2;
    float drawInfoYPos3;
    bool over;
    
    void update();
    void draw();
    void reset();
    
    ofImage image1, image2, image3;
};

#endif 
