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
    
    void update();
    void draw();
};

#endif 
