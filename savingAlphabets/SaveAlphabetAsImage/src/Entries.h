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
    
    int _xPos=200;
    int _yPos=60;
    int _offset=54;
    int _constNo;


    //constructor
    SingleEntry(string THEID, string LETTER, int constructorNumber){
        _id=ofToInt(THEID);
        _letter=LETTER;
        _constNo=constructorNumber;
        
    }
    void print(){
        printf("id     %i ",_id);
        printf("letter %s \n",_letter.c_str());

    }
    void loadImage(){
        string folderName=ofToString(_id);
        if(_id>999){
            char folderNameChar1=folderName.at(0);
            char folderNameChar2=folderName.at(1);
            folderName=folderNameChar1;
            string folderName2;
            folderName2=folderNameChar2;
            folderName.append(folderName2);
        }else{
            char folderNameChar1=folderName.at(0);
            folderName=folderNameChar1;
        }
        //printf("foldername: %c + %c \n", folderNameChar1, folderNameChar2);
        //printf("id= %i, foldername: %s \n", _id, folderName.c_str());
        string URL="http://www.ualphabets.com/images/244x200/"+folderName+"/"+ofToString(_id)+".png";
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
        float width=115;
        float height=138;
        int spacing=4;
        int noOfColumns=6;
        int column=_constNo % noOfColumns;
        //printf("no: %i ", _constNo);
        //printf("col: %i ",column);
        int myXPos=2+column*(width+spacing);
        
        int myYPos=2+(_constNo-column)/noOfColumns*(height+spacing);
        /*printf("id %i ", _id);
        printf("xPos %i ", myXPos);
        printf("yPos %i\n ", myYPos);*/
        _image.draw(myXPos,myYPos,width ,height);

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
