//
//  Alphabet.h
//  Riga01
//
//  Created by Suse on 09/05/14.
//
//

#ifndef Riga01_Alphabet_h
#define Riga01_Alphabet_h
#include "ofxContrast.h"

class AlphabetEntry{
public:
    int _id;
    string _letter;
    ofImage _image;
    
    //facade
    int _xPos=122;
    int _yPos=426;
    int _offset=26+4;
    
    //LED1
    int _xPosLED1=768;
    int _yPosLED1=56;
    int _offsetLED1=128+25;
    
    //LED2
    int _xPosLED2=480;
    int _yPosLED2=56;
    int _offsetLED2=128+15;
    
    int _constNo;
    ofxContrast cont;
    float darkness;

    
    //constructor
    AlphabetEntry(string THEID, string LETTER, int constructorNumber){
        _id=ofToInt(THEID);
        _letter=LETTER;
        _constNo=constructorNumber;
        if(_constNo%2==1){
            _xPos=_xPos+22+4;
        }
        if(_constNo<5){
            _xPosLED2=_xPosLED2+_constNo*_offsetLED2;
        }
        if(_constNo<6){
            _xPosLED1=_xPosLED1+_constNo*_offsetLED1;
        }
        //y value
        if(_constNo>13){
        } else if(_constNo>11){
            _yPos+=_offset*6;
            
        }else if(_constNo>9){
            _yPos+=_offset*5;
            
        } else if(_constNo>7){
            _yPos+=_offset*4;
            
        } else if(_constNo>5){
            _yPos+=_offset*3;
            
        } else if(_constNo>3){
            _yPos+=_offset*2;

        } else if (_constNo>1) {
            _yPos+=_offset;
        }
        darkness=0.0;
    }
    void reset(){
        //facade
        _xPos=121;
        _yPos=426;
        if(_constNo%2==1){
            _xPos=_xPos+22+4;
        }
        //y value
        if(_constNo>13){
        } else if(_constNo>11){
            _yPos+=_offset*6;
            
        }else if(_constNo>9){
            _yPos+=_offset*5;
            
        } else if(_constNo>7){
            _yPos+=_offset*4;
            
        } else if(_constNo>5){
            _yPos+=_offset*3;
            
        } else if(_constNo>3){
            _yPos+=_offset*2;
            
        } else if (_constNo>1) {
            _yPos+=_offset;
        }
        
        //LED1
        _xPosLED1=768;
        _yPosLED1=56;
        if(_constNo<6){
            _xPosLED1=_xPosLED1+_constNo*_offsetLED1;
        }
        //LED2
        _xPosLED2=480;
        _yPosLED2=56;
        if(_constNo<5){
            _xPosLED2=_xPosLED2+(_constNo)*_offsetLED2;
        }
        
    }
    void print(){
        printf("id     %i ",_id);
        printf("letter %s \n",_letter.c_str());
        
    }
    void loadImage(){
        string identifier=ofToString(_id);
        string folderName=ofToString(identifier.at(0))+ofToString(identifier.at(1));
        if (_id<1000) {
            folderName=ofToString(identifier.at(0));
        }
        string URL="http://www.ualphabets.com/images/244x200/"+folderName+"/"+ofToString(_id)+".png";
        //printf("%s \n", URL.c_str());
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
        //printf("letter: %s \n", _letter.c_str());
        
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
       //printf("letter: %s darkness: %f\n", _letter.c_str(), darkness);
    }
    void loadImageDirectory(){
        string path="letters/letter_";
        if (ofToString(_letter)=="?") {
            path+="-";
        }else if (ofToString(_letter)==".") {
            path+="";
        }else{
            path+=ofToString(_letter);
        }
        path+=".png";
        
        // printf("path: %s \n", path.c_str());
        _image.loadImage(path);
       // _image.resize(75,52);
    }
    
    void drawFacade(){
        int toLeft=80;
        ofSetColor(255);
        ofRect(_xPos-1, _yPos-1, 24, 28);
        if (_constNo%2==0) {
            ofRect(_xPos-1-toLeft, _yPos-1, 24, 28);
        }else{
            ofRect(_xPos-1+toLeft-5, _yPos-1, 24, 28);
        }

        if(darkness<100 && darkness!=0.0){
            cont.setBrightnessAndContrast(_image, 80,  60).draw(_xPos,_yPos,22, 26);
            if (_constNo%2==0) {
                cont.setBrightnessAndContrast(_image, 80,  60 ).draw(_xPos-toLeft,_yPos,22, 26);
            }else{
                cont.setBrightnessAndContrast(_image, 80,  60 ).draw(_xPos+toLeft-5,_yPos,22, 26);
            }
           // printf("%s darkness: %f\n", _letter.c_str(), darkness);
        } else{
            cont.setBrightnessAndContrast(_image, 10,  60 ).draw(_xPos,_yPos,22, 26);
            if (_constNo%2==0) {
                cont.setBrightnessAndContrast(_image, 10,  60 ).draw(_xPos-toLeft,_yPos,22, 26);
            }else{
                cont.setBrightnessAndContrast(_image, 10,  60 ).draw(_xPos+toLeft-5,_yPos,22, 26);
            }
        }
    }
    void drawLED1(){
        ofSetColor(255);
        ofRect(_xPosLED1-1, _yPosLED1-1, 130, 155);
        if(darkness<100 && darkness!=0.0){
            cont.setBrightnessAndContrast(_image, 70,  30 ).draw(_xPosLED1,_yPosLED1,128,153);
        } else{
            _image.draw(_xPosLED1,_yPosLED1, 128, 153);
        }
    }

    void drawLED2(){
        ofSetColor(255);
        ofRect(_xPosLED2-1, _yPosLED2-1, 130, 155);
        if(darkness<100 && darkness!=0.0){
            cont.setBrightnessAndContrast(_image, 70,  30 ).draw(_xPosLED2,_yPosLED2,128,153);
        } else{
            _image.draw(_xPosLED2,_yPosLED2, 128, 153);
        }
    }
    
    void drawWholeLED1(int number){
        

        int width=49;
        int height=58;
        int spacing=5;
        int noOfColumns=14;
        int column=_constNo % noOfColumns;
        
        int myXPos=9+column*(width+spacing);
        int myYPos=55+(_constNo-column)/noOfColumns*(height+spacing);
        
        if(darkness<100 && darkness!=0.0){
            cont.setBrightnessAndContrast(_image, 70,  30 ).draw(myXPos,myYPos,width,height);
        } else{
            _image.draw(myXPos,myYPos,width ,height);
        }
    }

    void drawWholeLED2(int number){
        int width=39;
        int height=46;
        int spacing=4;
        int noOfColumns=11;
        int column=_constNo % noOfColumns;
        
        int myXPos=6+column*(width+spacing);
        int myYPos=49+(_constNo-column)/noOfColumns*(height+spacing);
        if(darkness<100 && darkness!=0.0){
            cont.setBrightnessAndContrast(_image, 70,  30 ).draw(myXPos,myYPos,width,height);
        } else{
            _image.draw(myXPos,myYPos,width ,height);
        }
    }
    void updateFacade(){
        _yPos-=1;
    }
    void updateLED(){
        _xPosLED2-=2;
    }
    void updateLED1(){
        _xPosLED1-=2;
    }
    bool nextImageFacade(){
        if(_yPos<259-26-16){
            _xPos=-15;
            _yPos=1426;
            if(_constNo%2==1){
                _xPos=_xPos+22+4;
            }
            return true;
        } else{
            return false;
        }
    }
    bool nextImageLED1(){
        if(_xPosLED1<-150){
            _xPosLED1=768;
            _yPosLED1=290;
            return true;
        } else{
            return false;
        }
    }
    bool nextImageLED2(){
        if(_xPosLED2<-235){
            _xPosLED2=480;
            _yPosLED2=-160;
            return true;
        } else{
            return false;
        }
    }
};


#endif