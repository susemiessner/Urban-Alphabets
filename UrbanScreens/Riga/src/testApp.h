#pragma once

#include "ofMain.h"


#define LENGTH_OF_URL_ARRAY 6
#define FRAME_RATE 35
#define NO_OF_INTRO_IMAGES 5


class testApp : public ofBaseApp{
public:
    void setup();
    void update();
    void draw();
    
    void keyPressed(int key);
    void keyReleased(int key);
    void mouseMoved(int x, int y);
    void mouseDragged(int x, int y, int button);
    void mousePressed(int x, int y, int button);
    void mouseReleased(int x, int y, int button);
    void windowResized(int w, int h);
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    
    //own voids
    //>>>url request
    void urlResponse(ofHttpResponse &response);
    void sendRequest();
    //>>draw Info
    void drawIntro();
    
    
    //own variables
    
    string theResponse; //the response received from the php script
    string URLsToLoad[LENGTH_OF_URL_ARRAY]; //all URLS that are being loaded
    int currentURLNo; //the number of URL array currently loaded/ing
    string currentURL; //the URL currently loaded/ing
    bool loading; //determines whether somthing is currently loading or not

    //the alphabet
    string alphabet[42];

    //images before the actual screens
    ofImage imagesIntro[NO_OF_INTRO_IMAGES];
    int counterDrawInfo; //how long the start screen is drawn
    bool loadingResponseDone; //when startscreen is started to draw
    int blendInfo; //for fading in and out the info screen
    
    string recentPostcards;
    string recentLetters;
    string currentAlphabet;
    string info;

};
