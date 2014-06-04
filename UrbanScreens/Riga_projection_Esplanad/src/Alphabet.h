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
    
    int _xPos=1024;
    int _yPos=200;
    int _offset=221+27;
    int _constNo;
    
    //constructor
    AlphabetEntry(string THEID, string LETTER, int constructorNumber){
        _id=ofToInt(THEID);
        _letter=LETTER;
        _constNo=constructorNumber;
        if(constructorNumber<5){
            //  printf("now");
            _xPos=_xPos+(constructorNumber)*_offset;
        }
        
        // printf("inital xpos: %i\n",_xPos);
        
    }
    void print(){
        printf("id     %i ",_id);
        printf("letter %s \n",_letter.c_str());
        
    }
    void loadImage(){
        string URL="http://www.ualphabets.com/images/244x200/"+ofToString(_id)+".png";
        // printf("%s \n", URL.c_str());
        ofHttpResponse resp=ofLoadURL(URL);
        _image.loadImage(resp);
        //printf("letter: %s \n", _letter.c_str());
    }
    void loadImageDirectory(){
        string path="letters/letter_";
        path+=ofToString(_letter);
        path+=".png";
        // printf("path: %s \n", path.c_str());
        _image.loadImage(path);
    }
    
    void draw(){
        ofSetColor(255);
        //printf("xPos %i ", _xPos);
        _image.draw(_xPos,_yPos, 221, 270);
    }
    void drawWhole(){
        int width=81;
        int height=99;
        int spacing=11;
        int noOfColumns=11;
        int column=_constNo % noOfColumns;
        int myXPos=12+column*(width+spacing);
        
        int myYPos=50+96+(_constNo-column)/noOfColumns*(height+spacing);
        //ofSetColor(255);
        _image.draw(myXPos,myYPos,width, height);
    }
    void update(){
        _xPos--;
    }
    bool nextImage(){
        //printf("___ %i::", _xPos);
        if(_xPos<-221){
            _xPos=1920;
            _yPos=2000;
            return true;
        } else{
            return false;
        }
    }
};


#endif
