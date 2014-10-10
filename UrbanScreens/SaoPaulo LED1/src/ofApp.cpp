#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    //base setup
    ofSetFrameRate(FRAME_RATE);
    ofBackground(200);
    ofTrueTypeFont::setGlobalDpi(72);
    ofRegisterURLNotification(this);
    
    syphonServer.setName("Syphon Output");
    
    //size of LED 1
    screenWidth=768;
    screenHeight=288;
    
    //
    recentPostcards="http://www.ualphabets.com/requests/Riga/postcards.php";
    recentLetters="http://www.ualphabets.com/requests/Riga/letters.php";
    currentAlphabet="http://www.ualphabets.com/requests/Riga/alphabet.php";
    currentQuestion="http://www.ualphabets.com/requests/Riga/connected/question.php";
    
    info="Info";
    
    //setup of the URLS that need to be loaded
    URLsToLoad[0]=info;
    URLsToLoad[1]=currentQuestion;
    URLsToLoad[2]=recentPostcards;
    URLsToLoad[3]=recentLetters;
    URLsToLoad[4]=recentPostcards;
    URLsToLoad[5]=currentAlphabet;
    URLsToLoad[6]=recentPostcards;
    
    currentURLNo=0; //first screen to be shown
    currentURL=URLsToLoad[currentURLNo];
    loading= true; //send the first request on start alphabets/postcards/...
    
    englishTitleScale=0.8;
    
    //setup for intro screens before actual
    loadingResponseDone=false;
    blendInfo=0;
    introLength=5;
    
    //setup for alphabet screen
    counterDrawAlphabet=0;
    alphabetLength=15;
    counterAlphabetsTitle=0;
    alphabetTitle.loadImage("intro/intro_currentAlphabet.png");
    alphabetTitleLat.loadImage("intro/intro_currentAlphabetLat.png");
    
    //setup for postcards and letters screen
    lengthPostcards=12;//in secs
    lengthLetters=10;//in secs
    counterPostcardsAndLetters=0;
    counterPostcardsTitle=0;
    counterPostcardsQuestion=0;
    counterLettersTitle=0;
    counterNumberPostcards=0;
    lettersTitle.loadImage("intro/intro_titleLetters.png");
    lettersTitleLat.loadImage("intro/intro_titleLettersLat.png");
    
    //changing questions setup
    questions[0].loadImage("questions/questions_english_ -01.png");
    questions[1].loadImage("questions/questions_english_ -02.png");
    questions[2].loadImage("questions/questions_english_ -03.png");
    questions[3].loadImage("questions/questions_english_ -04.png");
    /*
    //latvian questions
    questionsLat[0].loadImage("questions/questions_latvian_ -01.png");
    questionsLat[1].loadImage("questions/questions_latvian_ -02.png");
    questionsLat[2].loadImage("questions/questions_latvian_ -03.png");
    questionsLat[3].loadImage("questions/questions_latvian_ -04.png");*/
    
    currentQuestionNumber=0;
    postcardsTitle.loadImage("intro/intro_titlePostcards.png");
    postcardsTitleLat.loadImage("intro/intro_titlePostcardsLat.png");
    
    
    //the latvian alphabet
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
        if (currentURL==recentPostcards) {
            updatePostcards();
        } else if(currentURL==recentLetters){
            updateLetters();
        } else if(currentURL==currentAlphabet){
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
    //overlay Sao Paulo
    ofSetColor(0);
    //left
    ofBeginShape();
        ofVertex(37,259);
        ofVertex(37,426);
        ofVertex(98,426);
        ofVertex(46,259);
    ofEndShape();
    //center
    ofBeginShape();
        ofVertex(120,259);
        ofVertex(99,426);
        ofVertex(192,426);
        ofVertex(171,259);
    ofEndShape();
    //right
    ofBeginShape();
        ofVertex(245,259);
        ofVertex(193,426);
        ofVertex(251,426);
        ofVertex(251,259);
    ofEndShape();
    ofRect(508, 77, 480, 288);
    ofRect(220, 452, 768, 288);
    ofSetColor(0);
    //start drawing
    if (loadingResponseDone) {
        loading=false;
        loadingResponseDone=false;
    }
    ofPushMatrix();
    ofTranslate(220, 452);
    
    //the actual screens
    if(loading==false){
        //printf("currentURL: %s, recentPostcards: %s \n", currentURL.c_str(), recentPostcards.c_str());
        if(currentURL==recentPostcards){
            drawPostcards();
        }else if (currentURL==recentLetters){
            drawLetters();
        } else if(currentURL==currentAlphabet){
            drawAlphabet();
        } else if(currentURL==info){
            about.draw();
        }
    }
    ofPopMatrix();
    syphonServer.publishScreen();
}
void ofApp::urlResponse(ofHttpResponse & response){
    printf("  received response\n");
    loadingResponseDone=true;
    theResponse=ofToString(response.data);
    ofStringReplace(theResponse, "[{", "");
    ofStringReplace(theResponse, "}]", "");
    //printf("%s", theResponse.c_str());
    
    allEntries=ofSplitString(theResponse, "},{");
    if (URLsToLoad[currentURLNo]==recentPostcards){
        loadURL_recentPostcards(response);
    } else if (URLsToLoad[currentURLNo]==recentLetters){
        loadURL_recentLetters(response);
    } else if(URLsToLoad[currentURLNo]==currentAlphabet){
        loadURL_alphabet(response);
    } else if (URLsToLoad[currentURLNo]==currentQuestion){
        loadQuestion(response);
    }

}
void ofApp::loadURL_recentPostcards(ofHttpResponse &response){
    if (allEntries.size()>1) {
        for(int i=0; i<allEntries.size(); i++){
            vector<string> cutEntries =ofSplitString(allEntries[i], ",");
            //delete the first parts in all of them
            ofStringReplace(cutEntries[0], "\"ID\":\"", "");
            ofStringReplace(cutEntries[1], "\"longitude\":\"", "");
            ofStringReplace(cutEntries[2], "\"latitude\":\"", "");
            ofStringReplace(cutEntries[3], "\"postcardText\":\"", "");
            ofStringReplace(cutEntries[4], "\"owner\":\"", "");
            //delete the last " in all of them
            ofStringReplace(cutEntries[0], "\"", "");
            ofStringReplace(cutEntries[1], "\"", "");
            ofStringReplace(cutEntries[2], "\"", "");
            ofStringReplace(cutEntries[3], "\"", "");
            ofStringReplace(cutEntries[4], "\"", "");
            Postcard entry(cutEntries[0], cutEntries[1], cutEntries[2],cutEntries[3],cutEntries[4]);
            if(allPostcards.size()<5){
                allPostcards.push_back(entry);
                allPostcards[allPostcards.size()-1].loadImage();
            } else{
                for (int i=0; i<allPostcards.size(); i++) {
                    if (entry._id==allPostcards[i]._id) {
                        break;
                    }
                    if (i==allPostcards.size()-1) {
                        allPostcards.insert(allPostcards.begin(),entry);
                        allPostcards[0].loadImage();
                        allPostcards.pop_back();
                        break;
                    }
                }
            }
        }
    }
    if (response.status==200 && response.request.name=="async_req") {
        //setup which ones are shown first
        currImgNo=allPostcards.size()-1;
    }
}
void ofApp::loadURL_recentLetters(ofHttpResponse &response){
    for (int i=0; i<allEntries.size(); i++) {
        vector<string> cutEntries=ofSplitString(allEntries[i], ",");
        //delete the first parts in all of them
        ofStringReplace(cutEntries[0], "\"ID\":\"", "");
        ofStringReplace(cutEntries[1], "\"letter\":\"", "");
        ofStringReplace(cutEntries[2], "\"owner\":\"", "");
        //delete the last " in all of them
        ofStringReplace(cutEntries[0], "\"", "");
        ofStringReplace(cutEntries[1], "\"", "");
        ofStringReplace(cutEntries[2], "\"", "");
        Letter entry(cutEntries[0], cutEntries[1], cutEntries[2], i);
        if(allLetters.size()<5){
            allLetters.push_back(entry);
            allLetters[allLetters.size()-1].loadImage();
        } else{
            for (int i=0; i<allLetters.size(); i++) {
                if (entry._id==allLetters[i]._id) {
                    break;
                }
                if (i==allLetters.size()-1) {
                    allLetters.insert(allLetters.begin(),entry);
                    allLetters[0].loadImage();
                    allLetters.pop_back();
                    break;
                }
            }
        }
    }
    if (response.status==200 && response.request.name=="async_req") {
        //setup which ones are shown first
        currLetterImgNo1=allLetters.size()-1;
        currLetterImgNo2=allLetters.size()-2;
        currLetterImgNo3=allLetters.size()-3;
        currLetterImgNo4=allLetters.size()-4;
        currLetterImgNo5=allLetters.size()-5;
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
void ofApp::loadQuestion(ofHttpResponse &response){
    
    //delete the first parts in all of them
    ofStringReplace(allEntries[0], "\"ID\":\"", "");
    //delete the last " in all of them
    ofStringReplace(allEntries[0], "\"", "");
    
    currentQuestionNumber=ofToInt(allEntries[0])-1;
    currentURLNo++;
    sendRequest();
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
void ofApp::updatePostcards(){
    int noOfPostcards=(int)allPostcards.size();
    if (counterPostcardsTitle>introLength*FRAME_RATE) {
        counterPostcardsAndLetters++;
        counterNumberPostcards++;
    }
    if (counterPostcardsTitle>introLength*FRAME_RATE){
        counterPostcardsQuestion++;
    }
    counterPostcardsTitle++;
    //blending for postcards
    if (currentURL==recentPostcards && counterNumberPostcards>lengthPostcards*FRAME_RATE*4 && noOfPostcards>3) {
        currImgNo=4;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE*5) {
            counterPostcardsAndLetters=0;
            blendInfo=0;
        }
    }else if (currentURL==recentPostcards && counterNumberPostcards>lengthPostcards*FRAME_RATE*3 && noOfPostcards>3) {
        currImgNo=3;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE*4) {
            counterPostcardsAndLetters=0;
            blendInfo=0;
        }
    }else if (currentURL==recentPostcards && counterNumberPostcards>lengthPostcards*FRAME_RATE*2 && noOfPostcards>2) {
        currImgNo=2;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE*3) {
            counterPostcardsAndLetters=0;
            blendInfo=0;
        }
    }else if (currentURL==recentPostcards && counterNumberPostcards>lengthPostcards*FRAME_RATE && noOfPostcards>1) {
        currImgNo=1;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE*2) {
            counterPostcardsAndLetters=0;
            blendInfo=0;
        }
    } else{
        currImgNo=0;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE) {
            counterPostcardsAndLetters=0;
            blendInfo=0;
        }
    }
    
    //send request for next thing
    int changeToNextNumber=lengthPostcards*FRAME_RATE*(noOfPostcards-0.8);
    if (counterNumberPostcards==changeToNextNumber) {
        goToNextScreen();
    }
    //determining when this is over
    if (currentURL==recentPostcards && currImgNo==noOfPostcards-1 && counterNumberPostcards>lengthPostcards*FRAME_RATE*(noOfPostcards)) {
        counterPostcardsAndLetters=0;
        counterNumberPostcards=0;
        currImgNo=0;
        blendInfo=0;
        counterPostcardsTitle=0;
        counterPostcardsQuestion=0;
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
    }
}
void ofApp::updateLetters(){
    counterPostcardsAndLetters++;
    
    
    //send request for next thing
    if (counterPostcardsAndLetters==FRAME_RATE) {
        goToNextScreen();
    }
    //determining when it is over
    if (currentURL==recentLetters && counterPostcardsAndLetters>lengthLetters*FRAME_RATE) {
        counterPostcardsAndLetters=0;
        counterLettersTitle=0;
        blendInfo=0;
        
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
        printf("next screen :%s\n", currentURL.c_str());
    }
}
void ofApp::updateAlphabet(){
    counterDrawAlphabet++;
    //start updating for the individual letters only
    if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
        
        if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
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
        }
    }
    //send request to next screen already
    if (counterDrawAlphabet==FRAME_RATE*(alphabetLength-3)) {
        goToNextScreen();
    }
    //determining when it's over
    if (currentURL==currentAlphabet && currImgNoAlphabet[5]>40 && allAlphabet[currImgNoAlphabet[5]]._xPos<-128) {
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
void ofApp::drawPostcards(){
    int noOfPostcards=(int)allPostcards.size();

    ofEnableAlphaBlending();

    
    //blend in
    if(counterPostcardsAndLetters<FRAME_RATE){
        blendInfo+=8;
        ofSetColor(255, 255, 255, blendInfo);
    }
    //blend out
    else if(counterPostcardsAndLetters>FRAME_RATE*(lengthPostcards-1) && counterPostcardsAndLetters<FRAME_RATE*lengthPostcards){
        blendInfo-=8;
        ofSetColor(255, 255, 255, blendInfo);
    } else{
        ofSetColor(255);
    }
    //draw postcard
    if(allPostcards.size()-1>=currImgNo){
        allPostcards[currImgNo].draw();
    }
    //title and question
    //blend in
    if(counterPostcardsAndLetters<FRAME_RATE &&currImgNo==allPostcards.size()-1){
        blendInfo+=8;
        ofSetColor(255, 255, 255, blendInfo);
    }
    //blend out
    else if(counterPostcardsAndLetters>FRAME_RATE*(lengthPostcards-1) && currImgNo<1){
        blendInfo-=8;
        ofSetColor(255, 255, 255, blendInfo);
    } else{
        ofSetColor(255);
    }

    //draw title
    postcardsTitle.draw(screenWidth-postcardsTitle.width-5, 0);
    
    //draw question
    questions[currentQuestionNumber].draw(5,0);
    
    ofDisableAlphaBlending();
}
void ofApp::drawLetters(){
    ofEnableAlphaBlending();
    
    //blend in
    if(counterPostcardsAndLetters<FRAME_RATE){
        blendInfo+=8;
        ofSetColor(255, 255, 255, blendInfo);
    }
    //blend out
    else if(counterPostcardsAndLetters>FRAME_RATE*(lengthLetters-1)){
        blendInfo-=8;
        ofSetColor(255, 255, 255, blendInfo);
    } else{
        ofSetColor(255);
    }
    //draw letters Sao Paulo
    int noOfLetters=(int)allLetters.size();
    
    if(noOfLetters>0){
        allLetters[currLetterImgNo1].draw(currLetterImgNo1);
    }
    if(noOfLetters>1){
        allLetters[currLetterImgNo2].draw(currLetterImgNo2);
    }
    if(noOfLetters>2){
        allLetters[currLetterImgNo3].draw(currLetterImgNo3);
    }
    if(noOfLetters>3){
        allLetters[currLetterImgNo4].draw(currLetterImgNo4);
    }
    if(noOfLetters>4){
        allLetters[currLetterImgNo5].draw(currLetterImgNo5);
    }

    lettersTitle.draw(screenWidth-lettersTitle.width-5, 0);

    
    ofDisableAlphaBlending();
}
void ofApp::drawAlphabet(){
    if (counterDrawAlphabet<FRAME_RATE*alphabetLength) {
        //blend in
        if(counterDrawAlphabet<FRAME_RATE){
            blendInfo+=8;
            ofSetColor(255, 255, 255, blendInfo);
        }
        //blend out
        else if(counterDrawAlphabet>FRAME_RATE*(alphabetLength-1)){
            blendInfo-=8;
            ofSetColor(255, 255, 255, blendInfo);
        } else{
            ofSetColor(255);
        }
        //draw entire alphabet
        for (int i=0; i<allAlphabet.size(); i++) {
            allAlphabet[i].drawWhole(i);
        }

    }else{
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH; i++) {
            allAlphabet[currImgNoAlphabet[i]].draw();
        }
        
    }
    alphabetTitle.draw(screenWidth-alphabetTitle.width-5, 0);
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
