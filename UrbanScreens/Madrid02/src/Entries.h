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
    
    int _xPos=200;
    int _yPos=40;
    int _offset=60;

    //constructor
    SingleEntry(string THEID, string PATH, string LONGI, string LA, string LETTER, int constructorNumber){
        _id=ofToInt(THEID);
        _path=PATH;
        _longi=ofToFloat(LONGI);
        _lati=ofToFloat(LA);
        _letter=LETTER;
        if(constructorNumber<5){
          //  printf("now");
            _xPos=_xPos+(constructorNumber)*_offset;
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
        printf("letter: %s \n", _letter.c_str());

    }
    void loadImageDirectory(){
        string path="letters/letter_";
        path+=ofToString(_letter);
        path+=".png";
        printf("path: %s \n", path.c_str());
        _image.loadImage(path);
    }
    
    void draw(){
        //printf("xPos %i ", _xPos);
        _image.draw(_xPos,_yPos, 52, 75);
    }
    void update(){
        _xPos--;
    }
    bool nextImage(){
        //printf("___ %i::", _xPos);
        if(_xPos<-100){
            _xPos=200;
            return true;
        } else{
            return false;
        }
    }
    
};




#endif /* defined(__emptyExample__Entries__) */
