#pragma once

#include "ofMain.h"
#include "Entries.h"

#define LENGTH_OF_URL_ARRAY 2
#define FRAME_RATE 30
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
    
    void urlResponse(ofHttpResponse &response);
    void loadURL_MadridrecentLetters(ofHttpResponse &response);
    void loadURL_requestMadrid(ofHttpResponse &response);
    void update_MadridrecentLetters();
    void update_requestMadrid();
    void drawInfo();
    void testOverlayMediaLabPrado();
    
    bool loading;
    string fullResponse;
    vector<string> individualEntries;
    
    vector<SingleEntry> allEntriesLastLetters;
    vector<SingleEntry> allEntriesAlphabet;
    
    int currImg1, currImg2, currImg3, currImg4, currImg5;
    int counter;

    //time to send next request
    int secsToNextRequest;
    
    string URLsToLoad[LENGTH_OF_URL_ARRAY];
    string currentURL;
    string loadedURL;
    string spanishAlphabet[42];
    int currentURLNo;
    
    //static info while loading next view
    ofTrueTypeFont infoFont;
    
};
