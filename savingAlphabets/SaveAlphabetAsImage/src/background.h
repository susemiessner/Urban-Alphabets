//
//  background.h
//  MadridAlphabet
//
//  Created by Suse on 06/03/14.
//
//

#ifndef MadridAlphabet_background_h
#define MadridAlphabet_background_h
class backgroundRect{
public:
    int _id;
    int _xPos=200;
    int _yPos=60;
    int _offset=60;
    int _constNo;
    
    //constructor
    backgroundRect(int constructorNumber){
        
        _constNo=constructorNumber;
        if (_constNo>31){
            _constNo++;
        }
    };
    void draw(){
        //printf("xPos %i ", _xPos);
        float scale=6.5;
        float width=17*scale;
        float height=22*scale;
        int spacing=4;
        int noOfColumns=11;
        int column=_constNo % noOfColumns;
        //printf("no: %i ", _constNo);
        //printf("col: %i ",column);
        int myXPos=12+column*(width+spacing);
        
        int myYPos=35+(_constNo-column)/noOfColumns*(height+spacing)+25;
        //printf("xPos %i ", myXPos);
        //printf("yPos %i\n ", myYPos);
        ofSetColor(30,30,30);
        ofRect(myXPos,myYPos,width ,height);
        ofSetColor(255);
        
    }
    
};



#endif
