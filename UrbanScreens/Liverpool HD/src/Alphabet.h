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
    int _yPos=287;
    int _offset=354+24;
    int _constNo;
    
    //constructor
    AlphabetEntry(string THEID, string LETTER, int constructorNumber){
        _id=ofToInt(THEID);
        _letter=LETTER;
        _constNo=constructorNumber;
        if(_constNo<6){
            _xPos=_xPos+(_constNo)*_offset;
        }
    }
    void reset(){
        _xPos=1920;
        _yPos=287;
        if(_constNo<6){
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
    }
    
    void draw(){
        ofSetColor(255);
        ofRect(_xPos-1, _yPos-1, 356, 437);
        _image.draw(_xPos,_yPos, 354, 435);
    }
    
    void drawWhole(int number){
        int width=159;
        int height=186;
        int spacing=13;
        int noOfColumns=11;
        int column=_constNo % noOfColumns;
        
        int myXPos=20+column*(width+spacing);
        int myYPos=145+(_constNo-column)/noOfColumns*(height+spacing);

        _image.draw(myXPos,myYPos,width ,height);
    }
    void update(){
        _xPos-=5;
    }
    bool nextImage(){
        if(_xPos<-354){
            _xPos=1920;
            _yPos=1090;
            return true;
        } else{
            return false;
        }
    }
};


#endif