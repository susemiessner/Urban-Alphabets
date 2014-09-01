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
    
    int _xPos=2560;
    int _yPos=350;
    int _offset=558+65;
    int _constNo;
    
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
        _yPos=150;
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
        string URL="http://www.ualphabets.com/images/244x200/"+folderName+"/"+ofToString(_id)+".png";
        //printf("%s \n", URL.c_str());
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
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
        _image.resize(200,244);
    }
    
    void draw(){
        ofSetColor(255);
        ofRect(_xPos-1, _yPos-1, 560, 683);
        _image.draw(_xPos,_yPos, 558, 681);
    }
    void drawWhole(){
        int width=207;
        int height=253;
        int spacing=22;
        int noOfColumns=11;
        int column=_constNo % noOfColumns;
        
        int myXPos=30+column*(width+spacing);
        int myYPos=120+(_constNo-column)/noOfColumns*(height+spacing);
        //ofSetColor(255);
        _image.draw(myXPos,myYPos,width ,height);
    }
    void update(){
        _xPos--;
    }
    bool nextImage(){
        //printf("___ %i::", _xPos);
        if(_xPos<-558){
            _xPos=2560;
            _yPos=2000;
            return true;
        } else{
            return false;
        }
    }
};


#endif