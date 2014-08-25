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
    
    int _xPos=328;
    int _yPos=20;
    int _offset=342+32;
    
    Postcard(string THEID, string LONGI, string LA, string TEXT, string OWNER, int constructorNumber){
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
        printf("owner %s \n",_owner.c_str());
        
    }
    void loadImage(){
        string identifier=ofToString(_id);
        string folderName=ofToString(identifier.at(0))+ofToString(identifier.at(1));
        if (_id<1000) {
            folderName=ofToString(identifier.at(0));
        }
        string URL="http://www.ualphabets.com/images/original/"+folderName+"/"+ofToString(_id)+".png";
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
    }
    
    void draw(){
        //ofSetColor(255);
        ofRect(_xPos-1, _yPos-1, 370, 450);
        _image.draw(_xPos,_yPos,368, 448);
    }
    void update(){
        //_xPos--;
    }
};



#endif