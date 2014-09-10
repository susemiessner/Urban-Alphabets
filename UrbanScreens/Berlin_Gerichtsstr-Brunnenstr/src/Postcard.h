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
    
    int _xPos=35;
    int _yPos=90;
    
    Postcard(string THEID, string LONGI, string LA, string TEXT, string OWNER, string RigaBerlin, string DATE){
        _id=ofToInt(THEID);
        _longi=ofToFloat( LONGI);
        _lati=ofToFloat(LA);
        _text=TEXT;
        _owner=OWNER;
        if (RigaBerlin=="Riga") {
            _xPos=_xPos+ofGetWidth()/2;
        } else{
            _xPos=35;
        }
        _date=DATE;
    }
    void print(){
        printf("id     %i ",_id);
        printf("longi  %f ",_longi);
        printf("lati   %f ",_lati);
        printf("letter %s ",_text.c_str());
        printf("owner %s",_owner.c_str());
        printf("date %s \n",_date.c_str() );
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
        ofRect(_xPos-1, _yPos-1, 330, 402);
        _image.draw(_xPos,_yPos,328, 400);
    }
    void update(){
    }
};



#endif