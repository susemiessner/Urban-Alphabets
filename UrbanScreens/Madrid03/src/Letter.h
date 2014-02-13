//
//  Letter.h
//  Madrid 02
//
//  Created by Suse on 11/02/14.
//
//

#ifndef Madrid_02_Letter_h
#define Madrid_02_Letter_h

#include <iostream>
#include "ofMain.h"

class Letter{
public:
    int _id;
    ofImage _image;
    string _owner;
    string _letter;
    
    int _xPos=200;
    int _yPos=40;
    int _offset=60;
    int _constNumber;
    
    Letter(string THEID, string LETTER, string OWNER, int constructorNumber){
        _id=ofToInt(THEID);
        _owner=OWNER;
        _letter=LETTER;
        _constNumber=constructorNumber;
        if(constructorNumber<5){
            //printf("constructorNumber %i", _constNumber);
            _xPos=_xPos+(constructorNumber)*_offset;
        }
    }
    void print(){
        printf("id     %i ",_id);
        printf("letter %s ",_letter.c_str());
        printf("owner %s \n",_owner.c_str());
    }
    void loadImage(){
        string URL="http://mlab.taik.fi/UrbanAlphabets/images/75x52/"+ofToString(_id)+".png";
        // printf("%s \n", URL.c_str());
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
    }
    
    void draw(){
        //printf("xPos %i ", _xPos);
        _image.draw(_xPos,_yPos,52, 75);
    }
    void update(){
        _xPos--;
        if(_xPos<-100){
            _xPos=200;
        }
    }
};


#endif
