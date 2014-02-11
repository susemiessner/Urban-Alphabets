//
//  Entries.h
//  emptyExample
//
//  Created by Suse on 08/02/14.
//
//

#ifndef __emptyExample__Entries__
#define __emptyExample__Entries__

#include <iostream>
#include "ofMain.h"

class SingleEntry{
    public:
    int _id;
    string _path;
    float _longi;
    float _lati;
    string _letter;
    ofImage _image;
    
    int _xPos=250;
    int _yPos=40;
    int _offset=60;

    //constructor
    SingleEntry(string THEID, string PATH, string LONGI, string LA, string LETTER, int constructorNumber, int arraySize){
        _id=ofToInt(THEID);
        _path=PATH;
        _longi=ofToFloat(LONGI);
        _lati=ofToFloat(LA);
        _letter=LETTER;
        if(constructorNumber>arraySize-6){
          //  printf("now");
            _xPos=_xPos+(constructorNumber%5)*_offset;
        }
       // printf("inital xpos: %i\n",_xPos);
        
    }
    void print(){
        printf("id     %i ",_id);
        printf("path   %s ",_path.c_str());
        printf("longi  %f ",_longi);
        printf("lati   %f ",_lati);
        printf("letter %s \n",_letter.c_str());

    }
    void loadImage(){
        string URL="http://mlab.taik.fi/UrbanAlphabets/images/75x52/"+ofToString(_id)+".png";
       // printf("%s \n", URL.c_str());
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);

    }
    
    void draw(){
        //printf("xPos %i ", _xPos);
        _image.draw(_xPos,_yPos);
    }
    void update(){
        _xPos--;
    }
    bool nextImage(){
        //printf("___ %i::", _xPos);
        if(_xPos<-50){
            _xPos=250;
            return true;
        } else{
            return false;
        }
    }
    
};




#endif /* defined(__emptyExample__Entries__) */
