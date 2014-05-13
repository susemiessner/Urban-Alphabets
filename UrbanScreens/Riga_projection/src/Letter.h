#//
//  Letter.h
//  Riga01
//
//  Created by Suse on 09/05/14.
//
//

#ifndef Riga01_Letter_h
#define Riga01_Letter_h

class Letter{
public:
    int _id;
    ofImage _image;
    string _owner;
    string _letter;
    
    int _xPos=15;
    int _yPos=200;
    int _offset=171+16;
    int _constNumber;
    
    Letter(string THEID, string LETTER, string OWNER, int constructorNumber){
        _id=ofToInt(THEID);
        _owner=OWNER;
        _letter=LETTER;
        _constNumber=constructorNumber;
        if(constructorNumber<5){
            _xPos=_xPos+(constructorNumber)*_offset;
        }
    }
    void print(){
        printf("id     %i ",_id);
        printf("letter %s ",_letter.c_str());
        printf("owner %s \n",_owner.c_str());
    }
    void loadImage(){
        string URL="http://www.ualphabets.com/images/original/"+ofToString(_id)+".png";
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
    }
    
    void draw(){
        //ofSetColor(255);
        ofRect(_xPos-1, _yPos-1, 173, 211);
        _image.draw(_xPos,_yPos,171, 209);
    }
    void update(){
        //_xPos--;
    }
};


#endif
