//
//  Postcard.h
//  Riga01
//
//  Created by Suse on 08/05/14.
//
//

#ifndef Riga01_Postcard_h
#define Riga01_Postcard_h

class Postcard{
public:
    int _id;
    ofImage _image;
    float _longi;
    float _lati;
    string _text;
    string _owner;
    string _date;
    
    //LED1
    int _xPosLED1=272;
    int _yPosLED1=7;
    //LED2
    int _xPos=130;
    int _yPos=7;
    
    Postcard(string THEID, string LONGI, string LA, string TEXT, string OWNER){
        _id=ofToInt(THEID);
        _longi=ofToFloat( LONGI);
        _lati=ofToFloat(LA);
        _text=TEXT;
        _owner=OWNER;
    }
    void print(){
        printf("id     %i ",_id);
        printf("longi  %f ",_longi);
        printf("lati   %f ",_lati);
        printf("letter %s ",_text.c_str());
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
        printf("loaded Image: %i \n", _id);
    }
    
    void draw(){
        //draw in LED 1
        ofPushMatrix();
        ofTranslate(220, 452);
        
        ofRect(_xPosLED1-1, _yPosLED1-1, 223, 275);
        _image.draw(_xPosLED1,_yPosLED1,221, 273);
        
        ofPopMatrix();
        
        //draw in LED 2
        ofPushMatrix();
        ofTranslate(508, 77);
        
        ofRect(_xPos-1, _yPos-1, 223, 275);
        _image.draw(_xPos,_yPos,221, 273);
        
        ofPopMatrix();
        
    }
};



#endif