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
    
    int _xPos=122;
    int _yPos=426;
    int _offset=26+4;
    int _constNo;
    
    //constructor
    AlphabetEntry(string THEID, string LETTER, int constructorNumber){
        _id=ofToInt(THEID);
        _letter=LETTER;
        _constNo=constructorNumber;
        if(_constNo%2==1){
            _xPos=_xPos+22+4;
        }
        //y value
        if(_constNo>13){
        } else if(_constNo>11){
            _yPos+=_offset*6;
            
        }else if(_constNo>9){
            _yPos+=_offset*5;
            
        } else if(_constNo>7){
            _yPos+=_offset*4;
            
        } else if(_constNo>5){
            _yPos+=_offset*3;
            
        } else if(_constNo>3){
            _yPos+=_offset*2;

        } else if (_constNo>1) {
            _yPos+=_offset;
        }
    }
    void reset(){
        _xPos=121;
        _yPos=426;
        if(_constNo%2==1){
            _xPos=_xPos+22+4;
        }
        //y value
        if(_constNo>13){
        } else if(_constNo>11){
            _yPos+=_offset*6;
            
        }else if(_constNo>9){
            _yPos+=_offset*5;
            
        } else if(_constNo>7){
            _yPos+=_offset*4;
            
        } else if(_constNo>5){
            _yPos+=_offset*3;
            
        } else if(_constNo>3){
            _yPos+=_offset*2;
            
        } else if (_constNo>1) {
            _yPos+=_offset;
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
        string URL="http://www.ualphabets.com/images/75x52/"+folderName+"/"+ofToString(_id)+".png";
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
        _image.resize(75,52);
    }
    
    void draw(){
        ofSetColor(255);
        ofRect(_xPos-1, _yPos-1, 24, 28);
        _image.draw(_xPos,_yPos, 22, 26);
    }
    
    void drawWhole(int number){
        int width=12;
        int height=14;
        int spacing=1;
        int column, row;
        switch (number) {
            case 0:
                column=3;
                row=1;
                break;
            case 1:
                column=4;
                row=1;
                break;
            case 2:
                column=2;
                row=2;
                break;
            case 3:
                column=3;
                row=2;
                break;
            case 4:
                column=4;
                row=2;
                break;
            case 5:
                column=5;
                row=2;
                break;
            case 6:
                column=2;
                row=3;
                break;
            case 7:
                column=3;
                row=3;
                break;
            case 8:
                column=4;
                row=3;
                break;
            case 9:
                column=5;
                row=3;
                break;
            case 10:
                column=2;
                row=4;
                break;
            case 11:
                column=3;
                row=4;
                break;
            case 12:
                column=4;
                row=4;
                break;
            case 13:
                column=5;
                row=4;
                break;
            case 14:
                column=2;
                row=5;
                break;
            case 15:
                column=3;
                row=5;
                break;
            case 16:
                column=4;
                row=5;
                break;
            case 17:
                column=5;
                row=5;
                break;
            case 18:
                column=2;
                row=6;
                break;
            case 19:
                column=3;
                row=6;
                break;
            case 20:
                column=4;
                row=6;
                break;
            case 21:
                column=5;
                row=6;
                break;
            case 22:
                column=2;
                row=7;
                break;
            case 23:
                column=3;
                row=7;
                break;
            case 24:
                column=4;
                row=7;
                break;
            case 25:
                column=5;
                row=7;
                break;
            case 26:
                column=2;
                row=8;
                break;
            case 27:
                column=3;
                row=8;
                break;
            case 28:
                column=4;
                row=8;
                break;
            case 29:
                column=5;
                row=8;
                break;
            case 30:
                column=1;
                row=9;
                break;
            case 31:
                column=2;
                row=9;
                break;
            case 32:
                column=3;
                row=9;
                break;
            case 33:
                column=4;
                row=9;
                break;
            case 34:
                column=5;
                row=9;
                break;
            case 35:
                column=6;
                row=9;
                break;
            case 36:
                column=1;
                row=10;
                break;
            case 37:
                column=2;
                row=10;
                break;
            case 38:
                column=3;
                row=10;
                break;
            case 39:
                column=4;
                row=10;
                break;
            case 40:
                column=5;
                row=10;
                break;
            case 41:
                column=6;
                row=10;
                break;
            default:
                break;
        }
        int myXPos=94+column*(width+spacing);
        int myYPos=253+row*(height+spacing);
        _image.draw(myXPos,myYPos,width ,height);
    }
    void update(){
        _yPos-=1;
    }
    bool nextImage(){
        if(_yPos<259-26-16){
            _xPos=-15;
            _yPos=426;
            if(_constNo%2==1){
                _xPos=_xPos+22+4;
            }
            return true;
        } else{
            return false;
        }
    }
};


#endif