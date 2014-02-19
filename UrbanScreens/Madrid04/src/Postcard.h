//
//  Postcard.h
//  Madrid 02
//
//  Created by Suse on 11/02/14.
//
//

#ifndef Madrid_02_Postcard_h
#define Madrid_02_Postcard_h

#include <iostream>
#include "ofMain.h"

class Postcard{
public:
    int _id;
    ofImage _image;
    float _longi;
    float _lati;
    string _text;
    string _owner;
    
    int _xPos=200;
    int _yPos=42;
    int _offset=120;
    int _constNumber;
    
    Postcard(string THEID, string LONGI, string LA, string TEXT, string OWNER, int constructorNumber){
        _id=ofToInt(THEID);
        _longi=ofToFloat( LONGI);
        _lati=ofToFloat(LA);
        _text=TEXT;
        _owner=OWNER;
        _constNumber=constructorNumber;
        if(constructorNumber<5){
             //printf("constructorNumber %i", _constNumber);
            _xPos=_xPos+(constructorNumber)*_offset;
        }
    }
    void print(){
        printf("id     %i ",_id);
        printf("longi  %f ",_longi);
        printf("lati   %f ",_lati);
        printf("letter %s ",_text.c_str());
        printf("owner %s \n",_owner.c_str());

    }
    void loadImage(){
        string URL="http://mlab.taik.fi/UrbanAlphabets/images/244x200/"+ofToString(_id)+".png";
        // printf("%s \n", URL.c_str());
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
        _image.crop(0,0,200, 140);
    }
    
    void draw(){
        //printf("xPos %i ", _xPos);
       //_image.draw(_xPos,_yPos,81.4, 75);
        _image.draw(_xPos,_yPos,114, 105);

    }
    void update(){
        _xPos--;
        /*if(_xPos<-245){
            _xPos=200;
        }*/
    }
};


#endif
