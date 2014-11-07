#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    

    
    //base setup
    ofSetFrameRate(FRAME_RATE);
    ofBackground(100);
    ofTrueTypeFont::setGlobalDpi(72);
    ofRegisterURLNotification(this);
    
    syphonServer.setName("Syphon Output");
    
    //size of LED 2
    screenWidth=480;
    screenHeight=288;
    
    //size of LED1
    screenWidthLED1=768;
    screenHeightLED1=288;
    
    //
    recentPostcards="http://www.ualphabets.com/requests/SaoPaulo/postcards.php";
    recentLetters="http://www.ualphabets.com/requests/SaoPaulo/letters.php";
    currentAlphabet="http://www.ualphabets.com/requests/SaoPaulo/alphabet.php";
    currentQuestion="http://www.ualphabets.com/requests/Riga/connected/question.php";
    
    info="Info";
    
    //setup of the URLS that need to be loaded
    URLsToLoad[0]=info;
    URLsToLoad[1]=currentAlphabet;
    URLsToLoad[2]=recentPostcards;
    URLsToLoad[3]=recentPostcards;
    URLsToLoad[4]=recentLetters;
    URLsToLoad[5]=recentPostcards;
    URLsToLoad[6]=recentPostcards;
    
    currentURLNo=0; //first screen to be shown
    currentURL=URLsToLoad[currentURLNo];
    loading= true; //send the first request on start alphabets/postcards/...
    
    
    //setup for intro screens before actual
    loadingResponseDone=false;
    blendInfoFacade=0;
    blendInfoLED2=0;
    introLength=5;
    
    //setup for alphabet screen
    counterDrawAlphabet=0;
    alphabetLength=11.6;
    alphabetLengthLED1=alphabetLength-4.4;
    counterAlphabetsTitle=0;
    alphabetTitleFacade.loadImage("intro_facade/intro_currentAlphabet.png");
    alphabetTitleLED1.loadImage("intro_LED1/intro_currentAlphabet.png");
    alphabetTitleLED2.loadImage("intro_LED2/intro_currentAlphabet.png");
    
    //setup for postcards and letters screen
    lengthPostcards=10;//in secs
    lengthLetters=8;//in secs
    counterPostcardsAndLetters=0;
    counterPostcardsTitle=0;
    counterPostcardsQuestion=0;
    counterLettersTitle=0;
    counterNumberPostcards=0;
    lettersTitleFacade.loadImage("intro_facade/intro_titleLetters.png");
    lettersTitleLED1.loadImage("intro_LED1/intro_titleLetters.png");
    lettersTitleLED2.loadImage("intro_LED2/intro_titleLetters.png");
    currImgNo=0;
    
    //changing questions setup
    questionsFacade[0].loadImage("questions_facade/questions_english_-01.png");
    questionsFacade[1].loadImage("questions_facade/questions_english_-02.png");
    questionsFacade[2].loadImage("questions_facade/questions_english_-03.png");
    questionsFacade[3].loadImage("questions_facade/questions_english_-04.png");
    //LED questions
    questionsLED2[0].loadImage("questions_LED2/questions_english_-01.png");
    questionsLED2[1].loadImage("questions_LED2/questions_english_-02.png");
    questionsLED2[2].loadImage("questions_LED2/questions_english_-03.png");
    questionsLED2[3].loadImage("questions_LED2/questions_english_-04.png");
    currentQuestionNumber=0;
    
    postcardsTitleLED1.loadImage("intro_LED1/intro_titlePostcards.png");
    postcardsTitleLED2.loadImage("intro_LED2/intro_titlePostcards.png");
    
    
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
    
    //question
    xPosQuestion=430;
    
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
    syphonServer.publishScreen();
}
void ofApp::urlResponse(ofHttpResponse & response){
    printf("  received response\n");
    loadingResponseDone=true;
    theResponse=ofToString(response.data);
    ofStringReplace(theResponse, "[{", "");
    ofStringReplace(theResponse, "}]", "");
    printf("%s", theResponse.c_str());
    
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
            if(allPostcards.size()<4){
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
    //initialize the question;
    initQuestion(currentQuestionNumber, allAlphabet);
    //Question questionFacadeAnimated(currentQuestionNumber, allAlphabet);
    //printf("question size %lu",question.size());
    if (response.status==200 && response.request.name=="async_req") {
        //setup which ones are shown first
        currImgNo=allPostcards.size()-1;
    }
}
void ofApp::initQuestion(int _currentQuestionNumber, vector<AlphabetEntry>_alphabet){
    string text="O QUE VOCE VE?";
    question.clear();
    printf("question size: %lu\n", question.size());
    for (int i=0; i<text.size(); i++) {
        char letter=text[i];
        for (int j=0; j<_alphabet.size(); j++) {
            //printf("postcardLetter: '%c', alphabetLetter: '%s' questionSize: %lu\n", letter, _alphabet[j]._letter.c_str(), question.size());
            char alphabetLetter=_alphabet[j]._letter[0];
            if (i==1|| i==5 ||i==10){ //for spaces " "
                printf("added: %c\n", letter);
                ofImage emptyLetter;
                emptyLetter.loadImage("letters/letter_empty_dark.png");
                question.push_back(emptyLetter);
                darkness.push_back(0.0);
                break;
            }
            if (letter==alphabetLetter) {
                ofImage image=_alphabet[j]._image;
                question.push_back(image);
                darkness.push_back(_alphabet[j].darkness);
                printf("added: %c\n", letter);
                break;
            }
        }
    }
    printf("question size: %lu\n", question.size());

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
        for (int i=0; i< NO_OF_ALPHABETS_RUNNING_THROUGH_LED; i++) {
            currImgNoAlphabetLED2[i]=i;
        }
        for (int i=0; i< NO_OF_ALPHABETS_RUNNING_THROUGH_LED1; i++) {
            currImgNoAlphabetLED1[i]=i;
        }
    }
}
void ofApp::loadQuestion(ofHttpResponse &response){
    question.clear();
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
        if (URLsToLoad[currentURLNo]==recentPostcards && currImgNo!=0) {
            loadingResponseDone=true;
            printf("%s, %s: %i \n", URLsToLoad[currentURLNo].c_str(), recentPostcards.c_str(), currImgNo);
        } else{
            string requestURL=URLsToLoad[currentURLNo];
            int id = ofLoadURLAsync(requestURL, "async_req");
            printf("%s", requestURL.c_str());
        }
        
    }else{
        loadingResponseDone=true;
    }
}


//--------------------------------------------------------------
//updating
//--------------------------------------------------------------
void ofApp::updatePostcards(){
    //printf("question size %lu",question.size());
    
    int noOfPostcards=(int)allPostcards.size();
    updateQuestion();
    counterNumberPostcards++;
    counterPostcardsTitle++;
    
    //blending for postcards
    if (currentURL==recentPostcards && counterNumberPostcards>lengthPostcards*FRAME_RATE*4 && noOfPostcards>3) {
        currImgNo=4;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE*5) {
            counterPostcardsAndLetters=0;
            blendInfoLED1=0;
        }
    }else if (currentURL==recentPostcards && counterNumberPostcards>lengthPostcards*FRAME_RATE*3 && noOfPostcards>3) {
        currImgNo=3;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE*4) {
            counterPostcardsAndLetters=0;
            blendInfoLED1=0;
        }
    }else if (currentURL==recentPostcards && counterNumberPostcards>lengthPostcards*FRAME_RATE*2 && noOfPostcards>2) {
        currImgNo=2;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE*3) {
            counterPostcardsAndLetters=0;
            blendInfoLED1=0;
        }
    }else if (currentURL==recentPostcards && counterNumberPostcards>lengthPostcards*FRAME_RATE && noOfPostcards>1) {
        currImgNo=1;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE*2) {
            counterPostcardsAndLetters=0;
            blendInfoLED1=0;
        }
    } else{
        currImgNo=0;
        if (counterNumberPostcards==lengthPostcards*FRAME_RATE) {
            counterPostcardsAndLetters=0;
            blendInfoLED1=0;
        }
    }

    
    //send request for next thing
    int changeToNextNumber=lengthPostcards*FRAME_RATE*(0.8);
    if (counterNumberPostcards==changeToNextNumber) {
        goToNextScreen();
    }
    //determining when this is over
    if (currentURL==recentPostcards && currImgNo==noOfPostcards-1 && counterNumberPostcards>lengthPostcards*FRAME_RATE) {
        counterPostcardsAndLetters=0;
        counterNumberPostcards=0;
        currImgNo=0;
        blendInfoFacade=0;
        counterPostcardsTitle=0;
        counterPostcardsQuestion=0;
        if (currImgNo==noOfPostcards-1) {
            currImgNo=0;
        }
        
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
    }
}
void ofApp::updateQuestion(){
    if(ofGetFrameNum()%2){
        xPosQuestion--;
    }
    if (xPosQuestion<-160) {
        xPosQuestion=430;
    }
}
void ofApp::updateLetters(){
    if (counterLettersTitle>5*FRAME_RATE) {
        counterPostcardsAndLetters++;
    }
    counterLettersTitle++;
    
    //send request for next thing
    if (counterPostcardsAndLetters==FRAME_RATE) {
        goToNextScreen();
    }
    //determining when it is over
    if (currentURL==recentLetters && counterPostcardsAndLetters>lengthLetters*FRAME_RATE) {
        counterPostcardsAndLetters=0;
        counterLettersTitle=0;
        blendInfoFacade=0;
        blendInfoLED2=0;
        blendInfoLED1=0;
        
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
        printf("next screen :%s\n", currentURL.c_str());
    }
}
void ofApp::updateAlphabet(){
    counterAlphabetsTitle++;
    if (counterAlphabetsTitle>introLength*FRAME_RATE) {
        counterDrawAlphabet++;
    }
    //update facade after the intro screen
    if (counterAlphabetsTitle>introLength*FRAME_RATE) {
        //facade
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH; i++) {
            //next image?
            if (allAlphabet[currImgNoAlphabet[i]].nextImageFacade()) {
                currImgNoAlphabet[i]+=NO_OF_ALPHABETS_RUNNING_THROUGH;
                if (currImgNoAlphabet[i]>allAlphabet.size()-1) {
                    currImgNoAlphabet[i]=currImgNoAlphabet[i]-allAlphabet.size();
                }
            }
            //update
            if (ofGetFrameNum()%5==0) {
                allAlphabet[currImgNoAlphabet[i]].updateFacade();
            }
        }
    }
    //update LEDs after alphabet overview
    if(counterDrawAlphabet>FRAME_RATE*alphabetLengthLED1){
        
        //LED1
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH_LED1; i++) {
            //next image?
            if (allAlphabet[currImgNoAlphabetLED1[i]].nextImageLED1()) {
                currImgNoAlphabetLED1[i]+=NO_OF_ALPHABETS_RUNNING_THROUGH_LED1;
                if (currImgNoAlphabetLED1[i]>allAlphabet.size()-1) {
                    currImgNoAlphabetLED1[i]=currImgNoAlphabetLED1[i]-allAlphabet.size();
                }
            }
            //update
            allAlphabet[currImgNoAlphabetLED1[i]].updateLED1();
        }
    }
    if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
        //LED2
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH_LED; i++) {
            //next image?
            if (allAlphabet[currImgNoAlphabetLED2[i]].nextImageLED2()) {
                currImgNoAlphabetLED2[i]+=NO_OF_ALPHABETS_RUNNING_THROUGH_LED;
                if (currImgNoAlphabetLED2[i]>allAlphabet.size()-1) {
                    currImgNoAlphabetLED2[i]=currImgNoAlphabetLED2[i]-allAlphabet.size();
                }
            }
            //update
            allAlphabet[currImgNoAlphabetLED2[i]].updateLED();
        }
    }
    //send request to next screen already
    if (counterDrawAlphabet==1/*FRAME_RATE*(introLength-4)*/) {
        goToNextScreen();
    }
    //determining when it's over
    if (currentURL==currentAlphabet && currImgNoAlphabet[1/*13*/]>3/*40*/ && allAlphabet[currImgNoAlphabet[13]]._yPos<259-26-16) {
        counterDrawAlphabet=0;
        blendInfoFacade=0;
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
        printf("next screen :%s\n", currentURL.c_str());
    }
}
//--------------------------------------------------------------
//drawing
//--------------------------------------------------------------
void ofApp::drawPostcards(){
    //printf("question size %lu",question.size());

    int noOfPostcards=(int)allPostcards.size();

    ofEnableAlphaBlending();
    //---------------draw postcard
    //blend in
    if(counterPostcardsAndLetters<FRAME_RATE){
        blendInfoLED1+=8;
        ofSetColor(255, 255, 255, blendInfoLED1);
    }
    //blend out
    else if(counterPostcardsAndLetters>=FRAME_RATE*(lengthPostcards-1) && counterPostcardsAndLetters<FRAME_RATE*lengthPostcards){
        blendInfoLED1-=8;
        ofSetColor(255, 255, 255, blendInfoLED1);
    } else{
        ofSetColor(255);
    }
    if(allPostcards.size()-1>=currImgNo){
        allPostcards[currImgNo].draw();
    }

    
    //-----------------question and title
    //blend in
    if(counterPostcardsTitle<FRAME_RATE && currImgNo==allPostcards.size()-1){
        blendInfoFacade+=8;
        ofSetColor(255, 255, 255, blendInfoLED1);
    }
    //blend out
    else if(counterPostcardsTitle>FRAME_RATE*(lengthPostcards-1) && currImgNo<1){
        blendInfoFacade-=8;
        ofSetColor(255, 255, 255, blendInfoLED1);
    } else{
        ofSetColor(255);
    }
    //draw title    
    //on LED2
    ofPushMatrix();
    ofTranslate(508, 77);
    
    postcardsTitleLED2.draw(screenWidth-postcardsTitleLED2.width-5, 0);
    questionsLED2[currentQuestionNumber].draw(5,0);
    ofPopMatrix();
    
    //on LED1
    ofPushMatrix();
    ofTranslate(220, 452);
    
    postcardsTitleLED1.draw(screenWidthLED1-postcardsTitleLED1.width-5, 0);
    questionsLED2[currentQuestionNumber].draw(5,0);
    
    ofPopMatrix();
    
    drawQuestion();

    ofDisableAlphaBlending();
}
void ofApp::drawQuestion(){
    //printf("question size (draw): %lu\n", question.size());
    for (int i=0; i<question.size(); i++) {
        if(darkness[i]<100 && darkness[i]!=0.0){
            cont.setBrightnessAndContrast(question[i], 80,  60).draw(135,xPosQuestion+30*i,22, 26);
        } else{
            cont.setBrightnessAndContrast(question[i], 10,  60 ).draw(135,xPosQuestion+30*i,22, 26);
        }
    }
}
void ofApp::drawLetters(){
    ofEnableAlphaBlending();
    //first 5 seconds draw letters title
    if (counterLettersTitle<introLength*FRAME_RATE) {
        //draw title facade
        if(counterLettersTitle<FRAME_RATE){
            blendInfoFacade+=8;
            ofSetColor(255, 255, 255, blendInfoFacade);
        }
        //blend out
        else if(counterLettersTitle>FRAME_RATE*(introLength-1)){
            blendInfoFacade-=8;
            ofSetColor(255, 255, 255, blendInfoFacade);
        } else{
            ofSetColor(255);
        }
        
        lettersTitleFacade.draw(37, 259);
        
        //draw title LEDs
        if(counterLettersTitle<FRAME_RATE){
            blendInfoLED2+=8;
            ofSetColor(255, 255, 255, blendInfoLED2);
        }else{
            ofSetColor(255);
        }
        //LED2
        ofPushMatrix();
        ofTranslate(508, 77);
        
        lettersTitleLED2.draw(0,0);
        //draw letters LED already
        int noOfLetters=(int)allLetters.size();
        
        if(noOfLetters>0){
            allLetters[currLetterImgNo1].drawLED2(currLetterImgNo1);
        }
        if(noOfLetters>1){
            allLetters[currLetterImgNo2].drawLED2(currLetterImgNo2);
        }
        if(noOfLetters>2){
            allLetters[currLetterImgNo3].drawLED2(currLetterImgNo3);
        }
        if(noOfLetters>3){
            allLetters[currLetterImgNo4].drawLED2(currLetterImgNo4);
        }
        if(noOfLetters>4){
            allLetters[currLetterImgNo5].drawLED2(currLetterImgNo5);
        }

        ofPopMatrix();
        //LED1
        ofPushMatrix();
        ofTranslate(220, 452);
        
        lettersTitleLED1.draw(0,0);
        //draw letters LED already
        if(noOfLetters>0){
            allLetters[currLetterImgNo1].drawLED1(currLetterImgNo1);
        }
        if(noOfLetters>1){
            allLetters[currLetterImgNo2].drawLED1(currLetterImgNo2);
        }
        if(noOfLetters>2){
            allLetters[currLetterImgNo3].drawLED1(currLetterImgNo3);
        }
        if(noOfLetters>3){
            allLetters[currLetterImgNo4].drawLED1(currLetterImgNo4);
        }
        if(noOfLetters>4){
            allLetters[currLetterImgNo5].drawLED1(currLetterImgNo5);
        }
        
        ofPopMatrix();
        

    } else{
        //facade
        //blend in
        if(counterPostcardsAndLetters<FRAME_RATE){
            blendInfoFacade+=8;
            ofSetColor(255, 255, 255, blendInfoFacade);
        }
        //blend out
        else if(counterPostcardsAndLetters>FRAME_RATE*(lengthLetters-1)){
            blendInfoFacade-=8;
            ofSetColor(255, 255, 255, blendInfoFacade);
        } else{
            ofSetColor(255);
        }
        //draw letters Sao Paulo
        int noOfLetters=(int)allLetters.size();
        
        if(noOfLetters>0){
            allLetters[currLetterImgNo1].drawFacade(currLetterImgNo1);
        }
        if(noOfLetters>1){
            allLetters[currLetterImgNo2].drawFacade(currLetterImgNo2);
        }
        if(noOfLetters>2){
            allLetters[currLetterImgNo3].drawFacade(currLetterImgNo3);
        }
        if(noOfLetters>3){
            allLetters[currLetterImgNo4].drawFacade(currLetterImgNo4);
        }
        if(noOfLetters>4){
            allLetters[currLetterImgNo5].drawFacade(currLetterImgNo5);
        }
        
        //draw title on LED2

        //blend out
        if(counterPostcardsAndLetters>FRAME_RATE*(lengthLetters-1)){
            blendInfoLED2-=8;
            ofSetColor(255, 255, 255, blendInfoLED2);
        } else{
            ofSetColor(255);
        }

        ofPushMatrix();
        ofTranslate(508, 77);
        //title LED2
        lettersTitleLED2.draw(0,0);
        //draw letters LED 2
        if(noOfLetters>0){
            allLetters[currLetterImgNo1].drawLED2(currLetterImgNo1);
        }
        if(noOfLetters>1){
            allLetters[currLetterImgNo2].drawLED2(currLetterImgNo2);
        }
        if(noOfLetters>2){
            allLetters[currLetterImgNo3].drawLED2(currLetterImgNo3);
        }
        if(noOfLetters>3){
            allLetters[currLetterImgNo4].drawLED2(currLetterImgNo4);
        }
        if(noOfLetters>4){
            allLetters[currLetterImgNo5].drawLED2(currLetterImgNo5);
        }

        ofPopMatrix();
        
        //LED1
        ofPushMatrix();
        ofTranslate(220, 452);
        
        lettersTitleLED1.draw(0,0);
        //draw letters LED1
        if(noOfLetters>0){
            allLetters[currLetterImgNo1].drawLED1(currLetterImgNo1);
        }
        if(noOfLetters>1){
            allLetters[currLetterImgNo2].drawLED1(currLetterImgNo2);
        }
        if(noOfLetters>2){
            allLetters[currLetterImgNo3].drawLED1(currLetterImgNo3);
        }
        if(noOfLetters>3){
            allLetters[currLetterImgNo4].drawLED1(currLetterImgNo4);
        }
        if(noOfLetters>4){
            allLetters[currLetterImgNo5].drawLED1(currLetterImgNo5);
        }
        
        ofPopMatrix();

    }
    
    ofDisableAlphaBlending();
}
void ofApp::drawAlphabet(){
    ofEnableAlphaBlending();
    if (counterAlphabetsTitle<FRAME_RATE*introLength) {
        //facade title
        //blend in
        if(counterAlphabetsTitle<FRAME_RATE){
            blendInfoFacade+=8;
            ofSetColor(255, 255, 255, blendInfoFacade);
        }
        //blend out
        else if(counterAlphabetsTitle>FRAME_RATE*(introLength-1)){
            blendInfoFacade-=8;
            ofSetColor(255, 255, 255, blendInfoFacade);
        } else{
            ofSetColor(255);
        }
        alphabetTitleFacade.draw(37, 259);
        
        
        //LEDs
        //blend in
        if(counterAlphabetsTitle<FRAME_RATE){
            blendInfoLED2+=8;
            blendInfoLED1+=8;
            ofSetColor(255, 255, 255, blendInfoLED2);
        }else{
            ofSetColor(255);
        }

        //LED1
        ofPushMatrix();
        ofTranslate(220, 452);
        
        alphabetTitleLED1.draw(5,0);
        //draw entire alphabet
        for (int i=0; i<allAlphabet.size(); i++) {
            allAlphabet[i].drawWholeLED1(i);
        }
        ofPopMatrix();
        //LED2
        ofPushMatrix();
        ofTranslate(508, 77);
        
        alphabetTitleLED2.draw(5,0);
        //draw entire alphabet
        for (int i=0; i<allAlphabet.size(); i++) {
            allAlphabet[i].drawWholeLED2(i);
        }
        ofPopMatrix();

        
    } else if (counterDrawAlphabet<FRAME_RATE*alphabetLengthLED1) {
        //facade
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH; i++) {
            allAlphabet[currImgNoAlphabet[i]].drawFacade();
        }
        //black background for LED1
        ofSetColor(0);
        ofRect(220, 452, 768, 288);
        
        ofSetColor(255);
        //LED2
        ofPushMatrix();
        ofTranslate(508, 77);
        
        alphabetTitleLED2.draw(5,0);
        //draw entire alphabet
        for (int i=0; i<allAlphabet.size(); i++) {
            allAlphabet[i].drawWholeLED2(i);
        }
        ofPopMatrix();
        
        //LED 1
        //blend out
        if(counterDrawAlphabet>FRAME_RATE*(alphabetLengthLED1-1)){
            blendInfoLED1-=8;
            ofSetColor(255, 255, 255, blendInfoLED1);
        } else{
            ofSetColor(255);
        }
        ofPushMatrix();
        ofTranslate(220, 452);
        for (int i=0; i<allAlphabet.size(); i++) {
            allAlphabet[i].drawWholeLED1(i);
        }
        ofSetColor(255);
        alphabetTitleLED1.draw(5,0);

        
    }else if (counterDrawAlphabet<FRAME_RATE*alphabetLength) {
        //facade
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH; i++) {
            allAlphabet[currImgNoAlphabet[i]].drawFacade();
        }
        //black background for LED1
        ofSetColor(0);
        ofRect(220, 452, 768, 288);
        
        //LED1
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH_LED1; i++) {
            ofPushMatrix();
            ofTranslate(220, 452);
            alphabetTitleLED1.draw(5,0);
            allAlphabet[currImgNoAlphabetLED1[i]].drawLED1();
            ofPopMatrix();
        }
        //blend out
        if(counterDrawAlphabet>FRAME_RATE*(alphabetLength-1)){
            blendInfoLED2-=8;
            ofSetColor(255, 255, 255, blendInfoLED2);
        } else{
            ofSetColor(255);
        }
        //LED2
        ofPushMatrix();
        ofTranslate(508, 77);
        for (int i=0; i<allAlphabet.size(); i++) {
            allAlphabet[i].drawWholeLED2(i);
        }
        ofSetColor(255);
        alphabetTitleLED2.draw(5,0);

        ofPopMatrix();
        
    }else{
        //facade
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH; i++) {
            allAlphabet[currImgNoAlphabet[i]].drawFacade();
        }
        //black background for LED1
        ofSetColor(0);
        ofRect(220, 452, 768, 288);
        //LED1
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH_LED1; i++) {
            ofPushMatrix();
            ofTranslate(220, 452);
            alphabetTitleLED1.draw(5,0);
            allAlphabet[currImgNoAlphabetLED1[i]].drawLED1();
            ofPopMatrix();
        }

        
        //LED2
        for (int i=0; i<NO_OF_ALPHABETS_RUNNING_THROUGH_LED; i++) {
                       //LED2
            ofPushMatrix();
            ofTranslate(508, 77);
            alphabetTitleLED2.draw(5,0);

            allAlphabet[currImgNoAlphabetLED2[i]].drawLED2();
            
            ofPopMatrix();
        }

        
    }
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
