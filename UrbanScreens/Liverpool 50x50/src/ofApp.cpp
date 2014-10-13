#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    //base setup
    ofSetFrameRate(FRAME_RATE);
    ofBackground(0);
    ofTrueTypeFont::setGlobalDpi(72);
    ofRegisterURLNotification(this);
    
    //
    currentAlphabet="http://www.ualphabets.com/requests/Liverpool/alphabet.php";
    info="Info";
    
    //setup of the URLS that need to be loaded
    URLsToLoad[0]=info;
    URLsToLoad[1]=currentAlphabet;
    
    currentURLNo=0; //first screen to be shown
    currentURL=URLsToLoad[currentURLNo];
    loading= true; //send the first request on start alphabets/postcards/...
    
    
    //setup for intro screens before actual
    loadingResponseDone=false;
    blendInfo=0;
    introLength=5;
    
    //setup for alphabet screen
    counterDrawAlphabet=0;
    alphabetLength=15;
    counterAlphabetsTitle=0;
    alphabetTitle.loadImage("intro/intro_currentAlphabet.png");
    
    //the english alphabet
    alphabet[0]="A";
    alphabet[1]="B";
    alphabet[2]="C";
    alphabet[3]="D";
    alphabet[4]="E";
    alphabet[5]="F";
    alphabet[6]="G";
    alphabet[7]="H";
    alphabet[8]="I";
    alphabet[9]="J";
    alphabet[10]="K";
    alphabet[11]="L";
    alphabet[12]="M";
    alphabet[13]="N";
    alphabet[14]="O";
    alphabet[15]="P";
    alphabet[16]="Q";
    alphabet[17]="R";
    alphabet[18]="S";
    alphabet[19]="T";
    alphabet[20]="U";
    alphabet[21]="V";
    alphabet[22]="W";
    alphabet[23]="X";
    alphabet[24]="Y";
    alphabet[25]="Z";
    alphabet[26]="+";
    alphabet[27]="$";
    alphabet[28]=",";
    alphabet[29]=".";
    alphabet[30]="!";
    alphabet[31]="?";
    alphabet[32]="0";
    alphabet[33]="1";
    alphabet[34]="2";
    alphabet[35]="3";
    alphabet[36]="4";
    alphabet[37]="5";
    alphabet[38]="6";
    alphabet[39]="7";
    alphabet[40]="8";
    alphabet[41]="9";
    
    
    //send the first request
    if (currentURL!="Info") {
        printf("now \n");
        int id = ofLoadURLAsync(currentURL, "async_req");
    } else {
        printf("%s", currentURL.c_str());
        loadingResponseDone=true;
    }
    


}

//--------------------------------------------------------------
void ofApp::update(){
    //update screens
    if (loading==false) {
        if(currentURL==currentAlphabet){
            updateAlphabet();
        } else if(currentURL==info){
            about.update();
            //send the request to the next screen
            if (about.counter==20){
                goToNextScreen();
            }
            if (about.over) {
                about.reset();
                //now go to that screen
                currentURL=URLsToLoad[currentURLNo];
                printf("next screen :%s\n", currentURL.c_str());
            }
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
        //start drawing
    if (loadingResponseDone) {
        loading=false;
        loadingResponseDone=false;
    }
    
    //the actual screens
    if(loading==false){
        //printf("currentURL: %s, recentPostcards: %s \n", currentURL.c_str(), recentPostcards.c_str());
        if(currentURL==currentAlphabet){
            drawAlphabet();
        } else if(currentURL==info){
            about.draw();
        }
    }
}
void ofApp::urlResponse(ofHttpResponse & response){
    printf("  received response\n");
    loadingResponseDone=true;
    theResponse=ofToString(response.data);
    ofStringReplace(theResponse, "[{", "");
    ofStringReplace(theResponse, "}]", "");
    //printf("%s", theResponse.c_str());
    
    allEntries=ofSplitString(theResponse, "},{");
    if(URLsToLoad[currentURLNo]==currentAlphabet){
        loadURL_alphabet(response);
    }

}
void ofApp::loadURL_alphabet(ofHttpResponse &response){
    newAlphabet.clear();
    int numberOfLettersAdded=0;
    vector<AlphabetEntry> allLetters;
    for (int i=0; i<allEntries.size(); i++) {
        ofStringReplace(allEntries[i], "letter\":\"", "");
        vector<string> cutEntries =ofSplitString(allEntries[i], "\",\"");
        //delete the first parts in all of them
        ofStringReplace(cutEntries[0], "\"ID\":\"","");
        ofStringReplace(cutEntries[0], "\"", "");
        ofStringReplace(cutEntries[1], "\"", "");
        string letter=cutEntries[1];
        if (i>1) {
            if (allLetters[numberOfLettersAdded-1]._letter!=letter) {
                AlphabetEntry entry(cutEntries[0], cutEntries[1], numberOfLettersAdded);
                allLetters.push_back(entry);
                numberOfLettersAdded++;
            }
        } else{
            AlphabetEntry entry(cutEntries[0], cutEntries[1], i);
            allLetters.push_back(entry);
            numberOfLettersAdded++;
        }
    }
    for (int j=0; j<42; j++) {
        //go through all letters we have
        for (int i=0; i<allLetters.size(); i++){
            if (allLetters[i]._letter==alphabet[j]) {
                AlphabetEntry entry(ofToString(allLetters[i]._id), allLetters[i]._letter, j);
                newAlphabet.push_back(entry);
                break;
            } else if (i==allLetters.size()-1){
                AlphabetEntry entry("0000", alphabet[j], j);
                newAlphabet.push_back(entry);
                break;
            }
        }
    }
    //if first time load > put the letters directly into the alphabet
    if (allAlphabet.size()<1) {
        for (int j=0; j<newAlphabet.size(); j++) {
            allAlphabet.push_back(newAlphabet[j]);
            if (allAlphabet[j]._id!=0) {
                allAlphabet[j].loadImage();
            }else{
                //load letter from image directory
                allAlphabet[j].loadImageDirectory();
            }
            
        }
    }else{//if there is already something in the alphabet
        for (int j=0; j<42; j++) {
            if (allAlphabet[j]._id!=newAlphabet[j]._id) {
                allAlphabet[j]=newAlphabet[j];
                allAlphabet.push_back(newAlphabet[j]);
                if (allAlphabet[j]._id!=0) {
                    allAlphabet[j].loadImage();
                }else{
                    //load letter from image directory
                    allAlphabet[j].loadImageDirectory();
                }
                
            }else{
                allAlphabet[j].reset();
            }
        }
    }
    if (response.status==200 && response.request.name=="async_req") {
        for (int i=0; i< NO_OF_ALPHABETS_RUNNING_THROUGH; i++) {
            currImgNoAlphabet[i]=i;
        }
    }
}


//--------------------------------------------------------------
//next screen
//--------------------------------------------------------------
void ofApp::goToNextScreen(){
    currentURLNo++;
    if (currentURLNo>=LENGTH_OF_URL_ARRAY) {
        currentURLNo=0;
    }
    sendRequest();
}
//--------------------------------------------------------------
void ofApp::sendRequest(){
    if (URLsToLoad[currentURLNo]!="Info") {
        string requestURL=URLsToLoad[currentURLNo];
        int id = ofLoadURLAsync(requestURL, "async_req");
    }else{
        loadingResponseDone=true;
    }
}


//--------------------------------------------------------------
//updating
//--------------------------------------------------------------
void ofApp::updateAlphabet(){
    counterDrawAlphabet++;
    //start updating for the individual letters only
    
    for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH; i++) {
        //next image?
        if (allAlphabet[currImgNoAlphabet[i]].nextImage()) {
            currImgNoAlphabet[i]+=NO_OF_ALPHABETS_RUNNING_THROUGH;
            if (currImgNoAlphabet[i]>allAlphabet.size()-1) {
                currImgNoAlphabet[i]=currImgNoAlphabet[i]-allAlphabet.size();
            }
        }
        //update
        if (ofGetFrameNum()%2==0) {
            allAlphabet[currImgNoAlphabet[i]].update();
        }
    }
    
    
    //send request to next screen already
    if (counterDrawAlphabet==FRAME_RATE*(alphabetLength-3)) {
        goToNextScreen();
    }
    //determining when it's over
    if (currentURL==currentAlphabet && currImgNoAlphabet[2]>40 && allAlphabet[currImgNoAlphabet[2]]._xPos<-50) {
        counterDrawAlphabet=0;
        blendInfo=0;
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
        printf("next screen :%s\n", currentURL.c_str());
    }
}
//--------------------------------------------------------------
//drawing
//--------------------------------------------------------------
void ofApp::drawAlphabet(){
    ofEnableAlphaBlending();
    for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH; i++) {
        allAlphabet[currImgNoAlphabet[i]].draw();
    }
    //alphabetTitle.draw(screenWidth-alphabetTitle.width-5, 0);
    ofDisableAlphaBlending();
}


//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
