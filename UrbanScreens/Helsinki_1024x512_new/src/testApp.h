#pragma once

#include "ofMain.h"
#include "Postcard.h"
#include "Letter.h"
#include "Alphabet.h"
#include "About.h"

#define LENGTH_OF_URL_ARRAY 6
#define FRAME_RATE 70
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
    void goToNextScreen();
    
    void loadURL_recentPostcards(ofHttpResponse &response);
    void loadURL_recentLetters(ofHttpResponse &response);
    void loadURL_alphabet(ofHttpResponse &response);
    
    //update the screens
    void updatePostcards();
    void updateLetters();
    void updateAlphabet();
    
    //draw screens
    void drawPostcards();
    void drawLetters();
    void drawAlphabet();
    
    //OWN VARIABLES
    
    string theResponse; //the response received from the php script
    string URLsToLoad[LENGTH_OF_URL_ARRAY]; //all URLS that are being loaded
    int currentURLNo; //the number of URL array currently loaded/ing
    string currentURL; //the URL currently loaded/ing
    bool loading; //determines whether somthing is currently loading or not
    
    //storing the URLS in strings
    string recentPostcards;
    string recentLetters;
    string currentAlphabet;
    string info;
    
    //the alphabet
    string alphabet[42];
    
    //images before the actual screens
    ofImage imagesIntro[NO_OF_INTRO_IMAGES];
    int counterDrawInfo; //how long the start screen is drawn
    bool loadingResponseDone; //when startscreen is started to draw
    int blendInfo; //for fading in and out the info screen
    int introLength; //how long the intro screen is shown all together (in secs)
    
    //
    vector<string> allEntries;//the entries received from database
    vector<Postcard> allPostcards; //all postcards
    vector<Letter> allLetters; //all recent letters
    int lengthPostcards;
    int lengthLetters;
    int counterPostcardsAndLetters;
    int counterNumberPostcards;
    vector<AlphabetEntry> allAlphabet; //the entire alphabet
    int counterDrawAlphabet; //counting how long the entire alphabet is drawn
    int alphabetLength; //how long the entire alphabet should be drawn (in secs)
    
    About about;//the info text with credits and stuff
    
    int currImgNo1, currImgNo2, currImgNo3, currImgNo4, currImgNo5;//the numbers of the alphabets
    int currLetterImgNo1, currLetterImgNo2, currLetterImgNo3, currLetterImgNo4, currLetterImgNo5;//the numbers of the letters currently displayed
    int currImgNo;//the numbers of the postcard currently displayed
    
    
    ofImage alphabetTitle, lettersTitle, postcardsTitle;
};