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
        string URL="http://www.ualphabets.com/images/244x200/"+ofToString(_id)+".png";
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
        _image.crop(0,0,200, 140);
    }
    
    void draw(){
        ofSetColor(255);
        ofRect(_xPos, _yPos, 114, 105);
        _image.draw(_xPos,_yPos,114, 105);
    }
    void update(){
        _xPos--;
    }
};



#endif
