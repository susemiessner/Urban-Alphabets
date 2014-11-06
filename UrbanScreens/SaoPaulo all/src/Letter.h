#//
//  Letter.h
//  Riga01
//
//  Created by Suse on 09/05/14.
//
//

#ifndef Riga01_Letter_h
#define Riga01_Letter_h
#include "ofxContrast.h"


class Letter{
public:
    int _id;
    ofImage _image;
    string _owner;
    string _letter;
    
    //facade
    int _xPos=39;
    int _yPos=280;
    int _offset=342+32;

    //LED1
    int _xPosLED1=15;
    int _yPosLED1=67;
    int _offsetLED1=128+25;
    
    //LED2
    int _xPosLED2=10;
    int _yPosLED2=90;
    int _offsetLED2=81+14;
    
    int _constNumber;
    ofxContrast cont;
    float darkness;

    
    Letter(string THEID, string LETTER, string OWNER, int constructorNumber){
        _id=ofToInt(THEID);
        _owner=OWNER;
        _letter=LETTER;
        _constNumber=constructorNumber;
        if(constructorNumber<5){
            _xPos=_xPos+(constructorNumber)*_offset;
            _xPosLED1=_xPosLED1+(constructorNumber)*_offsetLED1;
            _xPosLED2=_xPosLED2+(constructorNumber)*_offsetLED2;
        }
    }
    void print(){
        printf("id     %i ",_id);
        printf("letter %s ",_letter.c_str());
        printf("owner %s \n",_owner.c_str());
    }
    void loadImage(){
        string identifier=ofToString(_id);
        string folderName=ofToString(identifier.at(0))+ofToString(identifier.at(1));
        if (_id<1000) {
            folderName=ofToString(identifier.at(0));
        }
        string URL="http://www.ualphabets.com/images/244x200/"+folderName+"/"+ofToString(_id)+".png";
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
        
        //trying to get average brightness
        ofPixels pix = _image.getPixelsRef();
        darkness=0.0;
        for (int i=0; i<_image.width; i++) {
            for (int j=0; j<_image.height; j++){
                darkness+=pix.getColor(i,j).getLightness();
                //printf("darkness %f", darkness );
            }
        }
        darkness=darkness/(_image.width*_image.height);
    }
    
    void drawFacade(int number){
        //facade
        if (number==0) {
            _xPos=40;
            _yPos=375;
        } else if (number==1){
            _xPos=127;
            _yPos=275;
        }else if (number==2){
            _xPos=127;
            _yPos=325;
        }else if (number==3){
            _xPos=127;
            _yPos=375;
        }else if (number==4){
            _xPos=251-3-37;
            _yPos=375;
        }
        ofRect(_xPos-1, _yPos-1, 39, 46);
        
        if(darkness<100 && darkness!=0.0){
            cont.setBrightnessAndContrast(_image, 80,  60 ).draw(_xPos,_yPos,37, 44);
        }else {
            cont.setBrightnessAndContrast(_image, 10,  60 ).draw(_xPos,_yPos,37, 44);
        }
    }
    void drawLED2(int number){
        ofRect(_xPosLED2-1, _yPosLED2-1, 83, 98);
        _image.draw(_xPosLED2,_yPosLED2,81, 96);
    }
    void drawLED1(int number){
        ofRect(_xPosLED1-1, _yPosLED1-1, 130, 155);
        _image.draw(_xPosLED1,_yPosLED1,128, 153);
    }
};


#endif