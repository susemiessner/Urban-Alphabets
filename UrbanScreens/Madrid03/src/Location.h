//
//  Location.h
//  Madrid_03
//
//  Created by Suse on 13/02/14.
//
//

#ifndef Madrid_03_Location_h
#define Madrid_03_Location_h

class Location{
public:
    int _id;
    
    float _xPos=0;
    float _yPos=0;
    float _scaleFact= 1780;//65/0.104;
    int counter=0;
    
    Location(string THEID, float LONGI, float LATI){
        _xPos=(LONGI-(-3.7278))*_scaleFact;
        _yPos=-(LATI-40.452801)*_scaleFact+18;
        _id=ofToInt(THEID);

    }
    void print(){
        printf("scale  %f ",_scaleFact);
        printf("id     %i ",_id);
        printf("xPos %f ",_xPos);
        printf("yPos %f \n",_yPos);
    }
    
    void draw(){
        //printf("xPos %f ", _xPos);
        ofEnableAlphaBlending();
        ofSetColor(247, 247,30,200);
        ofCircle(_xPos,_yPos,2);
        ofDisableAlphaBlending();
        ofSetColor(255);
        counter++;
    }
    bool stopDrawing(){
        if(counter<10*30){
            return false;
            printf("false\n");
        }else {
            return true;
            printf("true\n");
        }
    }
};


#endif


