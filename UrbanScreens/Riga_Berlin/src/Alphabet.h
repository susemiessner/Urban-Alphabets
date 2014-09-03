//
//  Alphabet.h
//  Riga01
//
//  Created by Suse on 09/05/14.
//
//

#ifndef Riga01_Alphabet_h
#define Riga01_Alphabet_h

class AlphabetEntry{
public:
    int _id;
    string _letter;
    ofImage _image;
    
    int _xPos=(ofGetWidth()-20)/2;
    int _yPos=380;
    int _offset=287+14;
    int _constNo;
    int _around=20;
    
    //constructor
    AlphabetEntry(string THEID, string LETTER, int constructorNumber){
        _id=ofToInt(THEID);
        _letter=LETTER;
        _constNo=constructorNumber;
        if(_constNo<5){
            _xPos=_xPos+(_constNo)*_offset;
        }
    }
    void reset(){
        _xPos=(ofGetWidth()-20)/2;
        _yPos=380;
        if(_constNo<5){
            _xPos=_xPos+(_constNo)*_offset;
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
        string URL="http://www.ualphabets.com/images/original/"+folderName+"/"+ofToString(_id)+".png";
        //printf("%s \n", URL.c_str());
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
        _image.resize(287,350);

        //printf("letter: %s \n", _letter.c_str());
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
        _image.resize(287,350);
    }
    
    void draw(){
        ofSetColor(255);
        //printf("_xPos: %i", _xPos);
        /*right side*/
        if(_xPos>= (ofGetWidth()-_around*4)/2+_around-287 && _xPos<=(ofGetWidth()-_around*4)/2+_around){
            _image.drawSubsection(_xPos, _yPos,(ofGetWidth()-_around*4)/2+_around-_xPos, 350, 0, 0);
            //printf("right out \n");
        }else /*completely inside*/ if(_xPos>=_around && _xPos<((ofGetWidth()-_around*4)/2)+_around-200){
            _image.draw(_xPos,_yPos, 287, 350);
            //printf("completely inside \n");
        }/*left side*/ else if (_xPos>0 && _xPos<_around){
            _image.drawSubsection(_around, _yPos, 287+_xPos-_around, 350, _around-_xPos, 0);
            //printf("left out \n");
        } else if(_xPos<=0 && _xPos>-287+_around){
            _image.drawSubsection(_around, _yPos, 287+_xPos-_around, 350, _around-_xPos, 0);
            //printf("left out \n");
        } else {
            //printf("completely off\n");
        }
    }
    void drawWhole(){
        int width=98;
        int height=120;
        int spacing=9;
        int noOfColumns=7;
        int column=_constNo % noOfColumns;
        
        int myXPos=110+column*(width+spacing);
        int myYPos=260+(_constNo-column)/noOfColumns*(height+spacing);
        //ofSetColor(255);
        _image.draw(myXPos,myYPos,width ,height);
    }
    void update(){
        _xPos--;
    }
    bool nextImage(){
        //printf("___ %i::", _xPos);
        if(_xPos<-555){
            _xPos=1000;
            _yPos=2000;
            return true;
        } else{
            return false;
        }
    }
};


#endif