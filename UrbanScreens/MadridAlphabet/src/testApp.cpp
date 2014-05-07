#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    ofBackground(0,0,0);
    ofTrueTypeFont::setGlobalDpi(72);

    ofRegisterURLNotification(this);
    ofSetFrameRate(1);
    spanishAlphabet[0]="A";
    spanishAlphabet[1]="B";
    spanishAlphabet[2]="C";
    spanishAlphabet[3]="D";
    spanishAlphabet[4]="E";
    spanishAlphabet[5]="F";
    spanishAlphabet[6]="G";
    spanishAlphabet[7]="H";
    spanishAlphabet[8]="I";
    spanishAlphabet[9]="J";
    spanishAlphabet[10]="K";
    spanishAlphabet[11]="L";
    spanishAlphabet[12]="M";
    spanishAlphabet[13]="N";
    spanishAlphabet[14]="O";
    spanishAlphabet[15]="P";
    spanishAlphabet[16]="Q";
    spanishAlphabet[17]="R";
    spanishAlphabet[18]="S";
    spanishAlphabet[19]="T";
    spanishAlphabet[20]="U";
    spanishAlphabet[21]="V";
    spanishAlphabet[22]="W";
    spanishAlphabet[23]="X";
    spanishAlphabet[24]="Y";
    spanishAlphabet[25]="Z";
    spanishAlphabet[26]="NN";
    spanishAlphabet[27]=" ";
    spanishAlphabet[28]=",";
    spanishAlphabet[29]=".";
    spanishAlphabet[30]="!";
    spanishAlphabet[31]="?";
    spanishAlphabet[32]="0";
    spanishAlphabet[33]="1";
    spanishAlphabet[34]="2";
    spanishAlphabet[35]="3";
    spanishAlphabet[36]="4";
    spanishAlphabet[37]="5";
    spanishAlphabet[38]="6";
    spanishAlphabet[39]="7";
    spanishAlphabet[40]="8";
    spanishAlphabet[41]="9";
    
    for (int i=0; i<42; i++){
        backgroundRect entry(i);
        allBackgroundRects.push_back(entry);
    }
    
    loadingResponseDone=false;
    font.loadFont("Arial.ttf", 18, true, true);
    font.setLineHeight(22.0f);

    currentURL="http://www.mlab.taik.fi/UrbanAlphabets/requests/requestMadridVideo.php";
    int id = ofLoadURLAsync(currentURL, "async_req");
    numberToDraw=0;
}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){
    for (int i=0; i<allBackgroundRects.size(); i++) {
        
            allBackgroundRects[i].draw();
        
    }
    if (numberToDraw<allEntriesAlphabet.size()) {

        for (int i=0; i<numberToDraw; i++) {
        
            allEntriesAlphabet[i].draw();
            ofSetColor(255);
            font.drawString(allEntriesAlphabet[numberToDraw-1]._date, ofGetWidth()-120, ofGetHeight()-100);
        }
        string filename = "screen"+ofToString(numberToDraw)+".png";
        ofSaveScreen(filename);
        numberToDraw++;

    }
    
}

void testApp::urlResponse(ofHttpResponse & response){
    printf("response ");
    fullResponse=ofToString(response.data);
    //printf("urlResponse %s \n",fullResponse.c_str());
    ofStringReplace(fullResponse, "[{", "");
    ofStringReplace(fullResponse, "}]", "");
    individualEntries=ofSplitString(fullResponse, "},{");
    loadingResponseDone=true;
    
    //process the response
    allEntriesAlphabet.clear();
    int numberOfLettersAdded=0;
    vector <SingleEntry> allLetters;
    for(int i=0; i<individualEntries.size(); i++){
        //printf("individualEntries %s", individualEntries[i].c_str());
        ofStringReplace(individualEntries[i], "letter\":\"", "");
        //printf("individualEntries %s", individualEntries[i].c_str());
        vector<string> cutEntries =ofSplitString(individualEntries[i], "\",\"");
        //delete the first parts in all of them
        ofStringReplace(cutEntries[0], "\"ID\":\"","");
        ofStringReplace(cutEntries[2], "date\":\"","");
        //ofStringReplace(cutEntries[1], "\"letter\":\"", "");
        //delete the last " in all of them
        ofStringReplace(cutEntries[0], "\"", "");
        ofStringReplace(cutEntries[1], "\"", "");
        ofStringReplace(cutEntries[2], "\"", "");
        //printf("%i ", i);
        string letter=cutEntries[1];
        string date=cutEntries[2];
        ofStringReplace(date, " ", "\n");
        printf("%s letter:%s date:'%s'\n",cutEntries[0].c_str(), letter.c_str(), date.c_str());
        if (i>1) {
                SingleEntry entry(cutEntries[0], cutEntries[1], numberOfLettersAdded, date);
                allLetters.push_back(entry);
                numberOfLettersAdded++;
        } else{
            SingleEntry entry(cutEntries[0], cutEntries[1], i, date);
            allLetters.push_back(entry);
            numberOfLettersAdded++;
        }
        
        //printf("size: %i\n", (int)allEntriesAlphabet.size());
    }
 
        //go through all letters we have
        for (int i=0; i<allLetters.size(); i++){
            int letterNumber=43;
            for (int j=0; j<42; j++) {
                if (allLetters[i]._letter==spanishAlphabet[j]) {
                    letterNumber=j;
                    break;
                }
            }
            SingleEntry entry(ofToString(allLetters[i]._id), allLetters[i]._letter, letterNumber, allLetters[i]._date);
            allEntriesAlphabet.push_back(entry);
            
        }
    
    for (int i=0; i<allEntriesAlphabet.size()-1; i++) {
     printf("%i", i);
     allEntriesAlphabet[i].print();
     }
    if (response.status==200 && response.request.name=="async_req") {
        for (int i=0; i<allEntriesAlphabet.size(); i++) {
            if (allEntriesAlphabet[i]._id!=0) {
                allEntriesAlphabet[i].loadImage();
            }
        }
        
    } else{
        printf("not loaded \n");
        
    }


}

//--------------------------------------------------------------
void testApp::keyPressed(int key){

}

//--------------------------------------------------------------
void testApp::keyReleased(int key){

}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ 

}
