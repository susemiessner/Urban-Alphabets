#pragma once

#include "ofMain.h"
#include "Postcard.h"
#include "Letter.h"
#include "Alphabet.h"
#include "About.h"

#include "ofxSyphon.h"
#include "ofxContrast.h"

#define LENGTH_OF_URL_ARRAY 7
#define FRAME_RATE 70
#define NO_OF_INTRO_IMAGES 5
#define AROUND 10
#define NO_OF_ALPHABETS_RUNNING_THROUGH 14
#define NO_OF_ALPHABETS_RUNNING_THROUGH_LED 5
#define NO_OF_ALPHABETS_RUNNING_THROUGH_LED1 6


class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
    
    //own voids
    ofxSyphonServer syphonServer;
    //>>>url request
    void urlResponse(ofHttpResponse &response);
    void sendRequest();
    void goToNextScreen();
    
    void loadURL_recentPostcards(ofHttpResponse &response);
    void loadURL_recentLetters(ofHttpResponse &response);
    void loadURL_alphabet(ofHttpResponse &response);
    
    void loadQuestion(ofHttpResponse &response);
    
    //update the screens
    void updatePostcards();
    void updateLetters();
    void updateAlphabet();
    
    //draw screens
    void drawPostcards();
    void drawLetters();
    void drawAlphabet();
    
    
    void initQuestion(int _currentQuestionNumber, vector<AlphabetEntry>_alphabet);
    void drawQuestion();
    void updateQuestion();
    
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
    string currentQuestion;
    
    //Berlin and Riga images
    ofImage berlin;
    ofImage riga;
    
    //the alphabet
    string alphabet[42];
    
    //images before the actual screens
    ofImage imagesIntro[NO_OF_INTRO_IMAGES];
    int counterDrawInfo; //how long the start screen is drawn
    bool loadingResponseDone; //when startscreen is started to draw
    int blendInfoFacade; //for fading in and out - facade
    int blendInfoLED2, blendInfoLED1; //same for the LED
    int introLength; //how long the intro screen is shown all together (in secs)
    
    //
    vector<string> allEntries;//the entries received from database
    vector<Postcard> allPostcards; //all postcards from Berlin
    vector<Letter> allLetters; //all recent letters from Berlin
    
    int lengthPostcards;
    int lengthLetters;
    int counterPostcardsAndLetters;
    int counterNumberPostcards;
    
    vector<AlphabetEntry> allAlphabet; //the entire alphabet
    vector<AlphabetEntry> newAlphabet;
    int counterDrawAlphabet; //counting how long the entire alphabet is drawn
    float alphabetLength, alphabetLengthLED1; //how long the entire alphabet should be drawn (in secs)
    About about;//the info text with credits and stuff
    
    int currImgNo1, currImgNo2, currImgNo3, currImgNo4, currImgNo5;//the numbers of the alphabets
    int currImgNoAlphabet[NO_OF_ALPHABETS_RUNNING_THROUGH];
    int currImgNoAlphabetLED2[NO_OF_ALPHABETS_RUNNING_THROUGH_LED];
    int currImgNoAlphabetLED1[NO_OF_ALPHABETS_RUNNING_THROUGH_LED1];

    int currLetterImgNo1, currLetterImgNo2, currLetterImgNo3, currLetterImgNo4, currLetterImgNo5;//the numbers of the letters currently displayed
    int currImgNo;//the numbers of the postcard currently displayed
    
    
    ofImage alphabetTitleFacade, alphabetTitleLED2,alphabetTitleLED1, lettersTitleFacade, lettersTitleLED2, lettersTitleLED1, postcardsTitleFacade, postcardsTitleLED2, postcardsTitleLED1;
    
    int counterPostcardsTitle; //counter for intro to postcards
    int counterPostcardsQuestion; //counter for the question
    int counterLettersTitle; //counter for intro to letters
    int counterAlphabetsTitle; //counter for intro to alphabet
    //changing questions
    ofImage questionsFacade[4]; //number of questions can be changed!
    ofImage questionsLED2[4]; //same for LED2
    int currentQuestionNumber;
    
    int screenWidth, screenHeight;
    int screenWidthLED1, screenHeightLED1;
    
    vector<ofImage> question;
    vector<float> darkness;
    string text;
    int xPosQuestion;
    
    ofxContrast cont;


};
