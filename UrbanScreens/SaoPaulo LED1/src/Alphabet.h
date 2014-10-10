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
    
    int _xPos=768;
    int _yPos=56;
    int _offset=128+25;
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
        _xPos=768;
        _yPos=56;
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
        _image.resize(128,153);
    }
    
    void draw(){
        ofSetColor(255);
        ofRect(_xPos-1, _yPos-1, 130, 155);
        _image.draw(_xPos,_yPos, 128, 153);
    }
    
    void drawWhole(int number){
        int width=49;
        int height=58;
        int spacing=5;
        int noOfColumns=14;
        int column=_constNo % noOfColumns;
        
        int myXPos=9+column*(width+spacing);
        int myYPos=55+(_constNo-column)/noOfColumns*(height+spacing);

        _image.draw(myXPos,myYPos,width ,height);
    }
    void update(){
        _xPos-=2;
    }
    bool nextImage(){
        if(_xPos<-150){
            _xPos=768;
            _yPos=290;
            return true;
        } else{
            return false;
        }
    }
};


#endif