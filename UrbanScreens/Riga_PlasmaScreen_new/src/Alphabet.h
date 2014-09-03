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
    
    int _xPos=1920;
    int _yPos=280;
    int _offset=415+52;
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
        _xPos=1920;
        _yPos=280;
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
        ofRect(_xPos-1, _yPos-1, 417, 508);
        _image.draw(_xPos,_yPos, 415, 506);
    }
    
    void drawWhole(){
        int width=155;
        int height=189;
        int spacing=15;
        int noOfColumns=11;
        int column=_constNo % noOfColumns;
        
        int myXPos=30+column*(width+spacing);
        int myYPos=120+(_constNo-column)/noOfColumns*(height+spacing);
        //ofSetColor(255);
        _image.draw(myXPos,myYPos,width ,height);
    }
    void update(){
        _xPos-=2;
    }
    bool nextImage(){
        if(_xPos<-415){
            _xPos=1920;
            _yPos=2000;
            return true;
        } else{
            return false;
        }
    }
};


#endif