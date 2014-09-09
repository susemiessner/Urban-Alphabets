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
        string URL="http://www.ualphabets.com/images/original/"+ofToString(_id)+".png";
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
        _image.draw(_xPos,_yPos, 415, 506);
    }
    void drawWhole(){
        int width=155;
        int height=189;
        int spacing=15;
        int noOfColumns=11;
        int column=_constNo % noOfColumns;
        int myXPos=30+column*(width+spacing);
        
        int myYPos=70+(_constNo-column)/noOfColumns*(height+spacing);
        //ofSetColor(255);
        _image.draw(myXPos,myYPos,width ,height);
    }
    void update(){
        _xPos--;
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
