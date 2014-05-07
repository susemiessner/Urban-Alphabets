#pragma once

#include "ofMain.h"
#include "Entries.h"
#include "Background.h"

class testApp : public ofBaseApp{

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
    
    void urlResponse(ofHttpResponse &response);
    
    string spanishAlphabet[42];
    string fullResponse;
    vector<string> individualEntries;
    vector<SingleEntry> allEntriesAlphabet;
    vector<backgroundRect> allBackgroundRects;

    string currentURL;
    bool loadingResponseDone;
    int numberToDraw;
    
    ofTrueTypeFont font;


};
