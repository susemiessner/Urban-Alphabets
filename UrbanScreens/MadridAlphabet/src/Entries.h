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
    string _letter;
    ofImage _image;
    string _date;
    
    int _xPos=200;
    int _yPos=60;
    int _offset=60;
    int _constNo;


    //constructor
    SingleEntry(string THEID, string LETTER, int constructorNumber, string DATE){
        _id=ofToInt(THEID);
        _letter=LETTER;
        _date=DATE;
        _constNo=constructorNumber;
        if (_constNo>31){
            _constNo++;
        }

        
        
    }
    void print(){
        printf("id     %i ",_id);
        printf("letter %s \n",_letter.c_str());

    }
    void loadImage(){
        string URL="http://mlab.taik.fi/UrbanAlphabets/images/75x52/"+ofToString(_id)+".png";
       // printf("%s \n", URL.c_str());
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
        //printf("letter: %s \n", _letter.c_str());
    }
    void loadImageDirectory(){
        string path="letters/letter_";
        path+=ofToString(_letter);
        path+=".png";
       // printf("path: %s \n", path.c_str());
        _image.loadImage(path);
    }
    
    void draw(){
        //printf("xPos %i ", _xPos);
        float scale=6.5;
        float width=17*scale;
        float height=22*scale;
        int spacing=4;
        int noOfColumns=11;
        int column=_constNo % noOfColumns;
        //printf("no: %i ", _constNo);
        //printf("col: %i ",column);
        int myXPos=12+column*(width+spacing);
        
        int myYPos=35+(_constNo-column)/noOfColumns*(height+spacing)+25;
        //printf("xPos %i ", myXPos);
        //printf("yPos %i\n ", myYPos);
        _image.draw(myXPos,myYPos,width ,height);

    }
    
    void drawDate(){
    
    }
    
    void update(){
        _xPos--;
    }
    bool nextImage(){
        //printf("___ %i::", _xPos);
        if(_xPos<-100){
            _xPos=200;
            _yPos=200;
            return true;
        } else{
            return false;
        }
    }
    
};




#endif /* defined(__emptyExample__Entries__) */
