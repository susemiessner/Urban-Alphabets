#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    ofBackground(255, 255, 255);
    ofRegisterURLNotification(this);
    
    //the latvian alphabet
    alphabet[0]="A";
    alphabet[1]="LatvA";
    alphabet[2]="B";
    alphabet[3]="C";
    alphabet[4]="LatvC";
    alphabet[5]="D";
    alphabet[6]="E";
    alphabet[7]="LatvE";
    alphabet[8]="F";
    alphabet[9]="G";
    alphabet[10]="LatvG";
    alphabet[11]="H";
    alphabet[12]="I";
    alphabet[13]="LatvI";
    alphabet[14]="J";
    alphabet[15]="K";
    alphabet[16]="LatvK";
    alphabet[17]="L";
    alphabet[18]="LatvL";
    alphabet[19]="M";
    alphabet[20]="N";
    alphabet[21]="LatvN";
    alphabet[22]="O";
    alphabet[23]="P";
    alphabet[24]="R";
    alphabet[25]="S";
    alphabet[26]="LatvS";
    alphabet[27]="T";
    alphabet[28]="U";
    alphabet[29]="LatvU";
    alphabet[30]="V";
    alphabet[31]="Z";
    alphabet[32]="LatvZ";
    alphabet[33]="1";
    alphabet[34]="2";
    alphabet[35]="3";
    alphabet[36]="4";
    alphabet[37]="5";
    alphabet[38]="6";
    alphabet[39]="7";
    alphabet[40]="8";
    alphabet[41]="9";
    
    /*for (int i=0; i<42; i++){
        backgroundRect entry(i);
        allBackgroundRects.push_back(entry);
    }*/
    
    loadingResponseDone=false;


    //currentURL="http://www.ualphabets.com/requests/requestHelsinkiOF.php";
    currentURL="http://www.ualphabets.com/requests/requestRigaOF.php";
    int id = ofLoadURLAsync(currentURL, "async_req");
}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){
    ofPushMatrix();
    ofRotate(90);
    ofTranslate(0, -ofGetWidth());
        for (int i=0; i<allEntriesAlphabet.size(); i++) {
        
            allEntriesAlphabet[i].draw();
            ofSetColor(255);
        }
        string filename = "screen"+ofToString(ofGetYear())+":"+ofToString(ofGetMonth())+":"+ofToString(ofGetDay())+"-"+ofToString(ofGetHours())+":"+ofToString(ofGetMinutes())+":"+ofToString(ofGetSeconds())+".png";
    if(loadingResponseDone==true){
        ofSaveScreen(filename);
        std::exit(0);
    }
    ofPopMatrix();
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
        //printf("%s letter:%s date:'%s'\n",cutEntries[0].c_str(), letter.c_str(), date.c_str());
        if (i>1) {
                SingleEntry entry(cutEntries[0], cutEntries[1], numberOfLettersAdded);
                allLetters.push_back(entry);
                numberOfLettersAdded++;
        } else{
            SingleEntry entry(cutEntries[0], cutEntries[1], i);
            allLetters.push_back(entry);
            numberOfLettersAdded++;
        }
        
    }
 
        //go through all letters we have
    for (int j=0; j<42; j++) {
        //go through all letters we have
        for (int i=0; i<allLetters.size(); i++){
            if (allLetters[i]._letter==alphabet[j]) {
                SingleEntry entry(ofToString(allLetters[i]._id), allLetters[i]._letter, j);
                allEntriesAlphabet.push_back(entry);
                break;
            } else if (i==allLetters.size()-1){
                //printf("not uploaded: %s \n",alphabet[j].c_str());
                SingleEntry entry("0000", alphabet[j], j);
                allEntriesAlphabet.push_back(entry);
                break;
            }
        }
    }
    
    for (int i=0; i<allEntriesAlphabet.size()-1; i++) {
     //printf("%i", i);
     //allEntriesAlphabet[i].print();
     }
    if (response.status==200 && response.request.name=="async_req") {
        for (int i=0; i<allEntriesAlphabet.size(); i++) {
            if (allEntriesAlphabet[i]._id!=0) {
                allEntriesAlphabet[i].loadImage();
            }else{
                //load letter from image directory
                allEntriesAlphabet[i].loadImageDirectory();
            }        }
        
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
