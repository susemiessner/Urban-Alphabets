#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    //base setup
    ofSetFrameRate(FRAME_RATE);
    ofBackground(0);
	ofTrueTypeFont::setGlobalDpi(72);
    ofRegisterURLNotification(this);
    
    //
    recentPostcardsGerichtsstrasse="http://www.ualphabets.com/requests/Berlin/Gerichtsstrasse/postcards.php";
    recentLettersGerichtsstrasse="http://www.ualphabets.com/requests/Berlin/Gerichtsstrasse/letters.php";
    currentAlphabetGerichtsstrasse="http://www.ualphabets.com/requests/Berlin/Gerichtsstrasse/alphabet.php";

    recentPostcardsBrunnenstrasse="http://www.ualphabets.com/requests/Berlin/Brunnenstrasse/postcards.php";
    recentLettersBrunnenstrasse="http://www.ualphabets.com/requests/Berlin/Brunnenstrasse/letters.php";
    currentAlphabetBrunnenstrasse="http://www.ualphabets.com/requests/Berlin/Brunnenstrasse/alphabet.php";
    
    currentQuestion="http://www.ualphabets.com/requests/Berlin/question.php";
    
    recentPostcards=recentPostcardsGerichtsstrasse;
    recentLetters=recentLettersGerichtsstrasse;
    currentAlphabet=currentAlphabetGerichtsstrasse;
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
    
    //setup of Gerichstrasse + brunennstrasse images
    gerichsstrasse.loadImage("intro/intro_Gerichtsstr.png");
    brunnenstrasse.loadImage("intro/intro_Brunnenstr.png");
    
    //setup for intro screens before actual
    loadingResponseDone=false;
    blendInfo=0;
    introLength=4;
    
    //setup for alphabet screen
    counterDrawAlphabet=0;
    alphabetLength=10;//put in at least 5!
    alphabetTitle.loadImage("intro/intro_currentAlphabet.png");
    firstAlphabetLoaded=false;
    
    //setup for postcards and letters screen
    lengthPostcards=8;//in secs
    lengthLetters=10;//in secs
    counterPostcardsAndLetters=0;
    counterNumberPostcards=0;
    lettersTitle.loadImage("intro/intro_titleLetters.png");
    postcardsTitle.loadImage("intro/intro_titlePostcards.png");
    
    //changing questions setup
    questions[0].loadImage("questions/questions_german_ -01.png");
    questions[1].loadImage("questions/questions_german_ -02.png");
    questions[2].loadImage("questions/questions_german_ -03.png");
    questions[3].loadImage("questions/questions_german_ -04.png");
    currentQuestionNumber=0;

    
    //the German alphabet
    alphabetGerman[0]="A";
    alphabetGerman[1]="B";
    alphabetGerman[2]="C";
    alphabetGerman[3]="D";
    alphabetGerman[4]="E";
    alphabetGerman[5]="F";
    alphabetGerman[6]="G";
    alphabetGerman[7]="H";
    alphabetGerman[8]="I";
    alphabetGerman[9]="J";
    alphabetGerman[10]="K";
    alphabetGerman[11]="L";
    alphabetGerman[12]="M";
    alphabetGerman[13]="N";
    alphabetGerman[14]="O";
    alphabetGerman[15]="P";
    alphabetGerman[16]="Q";
    alphabetGerman[17]="R";
    alphabetGerman[18]="S";
    alphabetGerman[19]="T";
    alphabetGerman[20]="U";
    alphabetGerman[21]="V";
    alphabetGerman[22]="W";
    alphabetGerman[23]="X";
    alphabetGerman[24]="Y";
    alphabetGerman[25]="Z";
    alphabetGerman[26]="AA";
    alphabetGerman[27]="OO";
    alphabetGerman[28]="UU";
    alphabetGerman[29]=".";
    alphabetGerman[30]="!";
    alphabetGerman[31]="?";
    alphabetGerman[32]="0";
    alphabetGerman[33]="1";
    alphabetGerman[34]="2";
    alphabetGerman[35]="3";
    alphabetGerman[36]="4";
    alphabetGerman[37]="5";
    alphabetGerman[38]="6";
    alphabetGerman[39]="7";
    alphabetGerman[40]="8";
    alphabetGerman[41]="9";
    
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
void testApp::update(){
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
void testApp::draw(){
    /*//just for testing
    ofSetColor(255);
    ofRect(0, 0, ofGetWidth(), 100);*/
    
    ofPushMatrix();
    ofTranslate(0, 100);
    
    ofSetColor(0);
    //start drawing
    if (loadingResponseDone) {
        loading=false;
        loadingResponseDone=false;
    }
    
    //the actual screens
    if(loading==false){
        //grey rectangle + city titles
        if(currentURL!=info){
            ofSetColor(50, 50, 50);
            //background for Berlin
            ofRect(AROUND, questions[0].height+AROUND, (ofGetWidth()-AROUND*4)/2, ofGetHeight()-questions[0].height-AROUND-100);
            //background for Riga
            ofRect(AROUND*3+(ofGetWidth()-AROUND*4)/2, questions[0].height+AROUND, (ofGetWidth()-AROUND*4)/2, ofGetHeight()-questions[0].height-AROUND-100);
            ofSetColor(255);
            ofEnableAlphaBlending();
            brunnenstrasse.draw(ofGetWidth()-brunnenstrasse.width-AROUND, questions[0].height+AROUND*2);
            gerichsstrasse.draw(AROUND, questions[0].height+AROUND*2);
            ofDisableAlphaBlending();
        }
        if(currentURL==recentPostcardsGerichtsstrasse){
            drawPostcards();
        }else if (currentURL==recentLettersGerichtsstrasse){
            drawLetters();
        } else if(currentURL==currentAlphabetGerichtsstrasse){
            drawAlphabet();
        } else if(currentURL==info){
            about.draw();
        }
    }
    ofPopMatrix();
    screen.grabScreen(0,0,ofGetWidth(),ofGetHeight());
    screen.mirror(false, true);
    screen.draw(0, 0);

}


//--------------------------------------------------------------
void testApp::keyPressed(int key){
    
}



//--------------------------------------------------------------
//http request and ordering
//--------------------------------------------------------------

void testApp::urlResponse(ofHttpResponse & response){
    printf("  received response\n");
    loadingResponseDone=true;
    theResponse=ofToString(response.data);
    ofStringReplace(theResponse, "[{", "");
    ofStringReplace(theResponse, "}]", "");
    
    allEntries=ofSplitString(theResponse, "},{");
    if (URLsToLoad[currentURLNo]==recentPostcardsGerichtsstrasse){
        loadURL_recentPostcards(response);
    } else if (URLsToLoad[currentURLNo]==recentLettersGerichtsstrasse){
        loadURL_recentLetters(response);
    } else if(URLsToLoad[currentURLNo]==currentAlphabetGerichtsstrasse && firstAlphabetLoaded==false){
        loadURL_alphabetGerman(response);
    } else if(URLsToLoad[currentURLNo]==currentAlphabetGerichtsstrasse && firstAlphabetLoaded==true){
        loadURL_alphabetGerman(response);
    } else if (URLsToLoad[currentURLNo]==currentQuestion){
        loadQuestion(response);
    }

}
void testApp::loadURL_recentPostcards(ofHttpResponse &response){
    if (allEntries.size()>0) {
        for(int i=0; i<allEntries.size(); i++){
            vector<string> cutEntries =ofSplitString(allEntries[i], ",");
            /*for (int i=0; i<cutEntries.size(); i++) {
                printf("%s\n", cutEntries[i].c_str());
            }*/
            //delete the first parts in all of them
            ofStringReplace(cutEntries[0], "\"ID\":\"", "");
            ofStringReplace(cutEntries[1], "\"longitude\":\"", "");
            ofStringReplace(cutEntries[2], "\"latitude\":\"", "");
            ofStringReplace(cutEntries[3], "\"postcardText\":\"", "");
            ofStringReplace(cutEntries[4], "\"owner\":\"", "");
            ofStringReplace(cutEntries[5], "\"date\":\"", "");
            //delete the last " in all of them
            ofStringReplace(cutEntries[0], "\"", "");
            ofStringReplace(cutEntries[1], "\"", "");
            ofStringReplace(cutEntries[2], "\"", "");
            ofStringReplace(cutEntries[3], "\"", "");
            ofStringReplace(cutEntries[4], "\"", "");
            ofStringReplace(cutEntries[5], "\"", "");
            string rigaBerlin="";
            if (recentPostcards==recentPostcardsGerichtsstrasse) {
                rigaBerlin="Berlin";
            }else {
                rigaBerlin="Riga";
            }
            Postcard entry(cutEntries[0], cutEntries[1], cutEntries[2],cutEntries[3],cutEntries[4], rigaBerlin, cutEntries[5]);
            if (recentPostcards==recentPostcardsGerichtsstrasse) {
                if(allPostcardsGerichtsstrasse.size()<5){
                    allPostcardsGerichtsstrasse.push_back(entry);
                    allPostcardsGerichtsstrasse[allPostcardsGerichtsstrasse.size()-1].loadImage();
                } else{
                    for (int i=0; i<allPostcardsGerichtsstrasse.size(); i++) {
                        /*printf("allPostcardsBerlinsize-1: %i", (int)allPostcardsBerlin.size()-1);
                        printf("i: %i", i);
                        printf("entry id: %i  ", entry._id);
                        printf("postcard id: %i\n", allPostcardsBerlin[i]._id);*/
                        if (entry._id==allPostcardsGerichtsstrasse[i]._id) {
                            break;
                        }
                        if (i==allPostcardsGerichtsstrasse.size()-1) {
                            allPostcardsGerichtsstrasse.insert(allPostcardsGerichtsstrasse.begin(),entry);
                            allPostcardsGerichtsstrasse[0].loadImage();
                            allPostcardsGerichtsstrasse.pop_back();
                            break;
                        }
                    }
                }
            } else{
                if(allPostcardsBrunnenstrasse.size()<5){
                    allPostcardsBrunnenstrasse.push_back(entry);
                    allPostcardsBrunnenstrasse[allPostcardsBrunnenstrasse.size()-1].loadImage();
                } else{
                    for (int i=0; i<allPostcardsBrunnenstrasse.size(); i++) {
                        /*printf("allPostcardsRigasize-1: %i", (int)allPostcardsRiga.size()-1);
                        printf("i: %i", i);
                        printf("entry id: %i  ", entry._id);
                        printf("postcard id: %i\n", allPostcardsRiga[i]._id);*/
                        if (entry._id==allPostcardsBrunnenstrasse[i]._id) {
                            break;
                        }
                        if (i==allPostcardsBrunnenstrasse.size()-1) {
                            allPostcardsBrunnenstrasse.insert(allPostcardsBrunnenstrasse.begin(),entry);
                            allPostcardsBrunnenstrasse[0].loadImage();
                            allPostcardsBrunnenstrasse.pop_back();
                            break;
                        }
                    }
                }
            }
        }
    }
    //just for testing
    //printf("allPostcards size %lu \n", allPostcards.size());
    /*for (int i=0; i<allPostcardsBerlin.size(); i++) {
     allPostcardsBerlin[i].print();
     }*/
    if (response.status==200 && response.request.name=="async_req") {
        //setup which ones are shown first
        if(allPostcardsGerichtsstrasse.size()>allPostcardsBrunnenstrasse.size()){
            currImgNo=allPostcardsGerichtsstrasse.size()-1;
        }else{
            currImgNo=allPostcardsBrunnenstrasse.size()-1;
        }
    } else{
        //printf("not loaded \n");
        
    }
    if (recentPostcards==recentPostcardsGerichtsstrasse) {
        recentPostcards=recentPostcardsBrunnenstrasse;
        //sending request to Riga
        int id = ofLoadURLAsync(recentPostcards, "async_req");
    } else{
        recentPostcards=recentPostcardsGerichtsstrasse;
    }
}
void testApp::loadURL_recentLetters(ofHttpResponse &response){
    /*if (recentLetters==recentLettersGerichtsstrasse) {
        allLettersGerichtsstrasse.clear();
    } else{
        allLettersBrunnenstrasse.clear();
    }*/
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
        string rigaBerlin="";
        if (recentLetters==recentLettersGerichtsstrasse) {
            rigaBerlin="Berlin";
        }else {
            rigaBerlin="Riga";
        }
        Letter entry(cutEntries[0], cutEntries[1], cutEntries[2], i, rigaBerlin);
        if (recentLetters==recentLettersGerichtsstrasse) {
            if(allLettersGerichtsstrasse.size()<3){
                allLettersGerichtsstrasse.push_back(entry);
                allLettersGerichtsstrasse[allLettersGerichtsstrasse.size()-1].loadImage();
            } else{
                for (int i=0; i<allLettersGerichtsstrasse.size(); i++) {
                    /*printf("allPostcardsBerlinsize-1: %i", (int)allPostcardsBerlin.size()-1);
                     printf("i: %i", i);
                     printf("entry id: %i  ", entry._id);
                     printf("postcard id: %i\n", allPostcardsBerlin[i]._id);*/
                    if (entry._id==allLettersGerichtsstrasse[i]._id) {
                        break;
                    }
                    if (i==allLettersGerichtsstrasse.size()-1) {
                        allLettersGerichtsstrasse.insert(allLettersGerichtsstrasse.begin(),entry);
                        allLettersGerichtsstrasse[0].loadImage();
                        allLettersGerichtsstrasse.pop_back();
                        break;
                    }
                }
            }
        } else{
            if(allLettersBrunnenstrasse.size()<3){
                allLettersBrunnenstrasse.push_back(entry);
                allLettersBrunnenstrasse[allLettersBrunnenstrasse.size()-1].loadImage();
            } else{
                for (int i=0; i<allLettersBrunnenstrasse.size(); i++) {
                    if (entry._id==allLettersBrunnenstrasse[i]._id) {
                        break;
                    }
                    if (i==allLettersBrunnenstrasse.size()-1) {
                        allLettersBrunnenstrasse.insert(allLettersBrunnenstrasse.begin(),entry);
                        allLettersBrunnenstrasse[0].loadImage();
                        allLettersBrunnenstrasse.pop_back();
                        break;
                    }
                }
            }
        }
    }
    if (response.status==200 && response.request.name=="async_req") {
        //setup which ones are shown first
        currLetterImgNo1=allLettersGerichtsstrasse.size()-1;
        currLetterImgNo2=allLettersGerichtsstrasse.size()-2;
        currLetterImgNo3=allLettersGerichtsstrasse.size()-3;
        currLetterImgNo4=allLettersGerichtsstrasse.size()-4;
        currLetterImgNo5=allLettersGerichtsstrasse.size()-5;
        
        if (recentLetters==recentLettersGerichtsstrasse) {
            recentLetters =recentLettersBrunnenstrasse;
            //sending request to Riga
            int id = ofLoadURLAsync(recentLetters, "async_req");
        } else{
            recentLetters=recentLettersGerichtsstrasse;
        }
    }
}
void testApp::loadURL_alphabetGerman(ofHttpResponse &response){
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
            if (allLetters[i]._letter==alphabetGerman[j]) {
                AlphabetEntry entry(ofToString(allLetters[i]._id), allLetters[i]._letter, j);
                newAlphabet.push_back(entry);
                break;
            } else if (i==allLetters.size()-1){
                AlphabetEntry entry("0000", alphabetGerman[j], j);
                newAlphabet.push_back(entry);
                break;
            }
        }
    }
    if (firstAlphabetLoaded==false) {
        //if first time load > put the letters directly into the alphabet
        if (allAlphabetGerichtsstrasse.size()<1) {
            for (int j=0; j<newAlphabet.size(); j++) {
                allAlphabetGerichtsstrasse.push_back(newAlphabet[j]);
                if (allAlphabetGerichtsstrasse[j]._id!=0) {
                    allAlphabetGerichtsstrasse[j].loadImage();
                }else{
                    //load letter from image directory
                    allAlphabetGerichtsstrasse[j].loadImageDirectory();
                }
                
            }
        }else{//if there is already something in the alphabet
            for (int j=0; j<42; j++) {
                //printf("letter: %s all alphabet: %i, new alphabet: %i\n", allAlphabetGerichtsstrasse[j]._letter.c_str() ,allAlphabetBerlin[j]._id, newAlphabet[j]._id);
                if (allAlphabetGerichtsstrasse[j]._id!=newAlphabet[j]._id) {
                    allAlphabetGerichtsstrasse[j]=newAlphabet[j];
                    allAlphabetGerichtsstrasse.push_back(newAlphabet[j]);
                    if (allAlphabetGerichtsstrasse[j]._id!=0) {
                        allAlphabetGerichtsstrasse[j].loadImage();
                    }else{
                        //load letter from image directory
                        allAlphabetGerichtsstrasse[j].loadImageDirectory();
                    }
                    
                }else{
                    allAlphabetGerichtsstrasse[j].reset();
                }
            }
        }
        if (response.status==200 && response.request.name=="async_req") {
            currImgNo1=0;
            currImgNo2=1;
            currImgNo3=2;
            currImgNo4=3;
            currImgNo5=4;
        }
        if (currentAlphabet==currentAlphabetGerichtsstrasse) {
            currentAlphabet=currentAlphabetBrunnenstrasse;
            //sending request to Riga
            int id = ofLoadURLAsync(currentAlphabet, "async_req");
        } else{
            currentAlphabet=currentAlphabetGerichtsstrasse;
        }
        firstAlphabetLoaded=true;
    }else{
        //Brunnenstrasse alphabet
        //if first time load > put the letters directly into the alphabet
        if (allAlphabetBrunnenstrasse.size()<1) {
            for (int j=0; j<newAlphabet.size(); j++) {
                allAlphabetBrunnenstrasse.push_back(newAlphabet[j]);
                if (allAlphabetBrunnenstrasse[j]._id!=0) {
                    allAlphabetBrunnenstrasse[j].loadImage();
                }else{
                    //load letter from image directory
                    allAlphabetBrunnenstrasse[j].loadImageDirectory();
                }
                
            }
        }else{//if there is already something in the alphabet
            for (int j=0; j<42; j++) {
                //printf("letter: %s all alphabet: %i, new alphabet: %i\n", allAlphabetBrunnenstrasse[j]._letter.c_str() ,allAlphabetBerlin[j]._id, newAlphabet[j]._id);
                if (allAlphabetBrunnenstrasse[j]._id!=newAlphabet[j]._id) {
                    allAlphabetBrunnenstrasse[j]=newAlphabet[j];
                    allAlphabetBrunnenstrasse.push_back(newAlphabet[j]);
                    if (allAlphabetBrunnenstrasse[j]._id!=0) {
                        allAlphabetBrunnenstrasse[j].loadImage();
                    }else{
                        //load letter from image directory
                        allAlphabetBrunnenstrasse[j].loadImageDirectory();
                    }
                }else{
                    allAlphabetBrunnenstrasse[j].reset();
                }
            }
        }
        currentAlphabet=currentAlphabetGerichtsstrasse;
        firstAlphabetLoaded=false;
    }
    
}

void testApp::loadQuestion(ofHttpResponse &response){
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
void testApp::goToNextScreen(){
    currentURLNo++;
    if (currentURLNo>=LENGTH_OF_URL_ARRAY) {
        currentURLNo=0;
    }
    sendRequest();
}
//--------------------------------------------------------------
void testApp::sendRequest(){
    if (URLsToLoad[currentURLNo]!="Info") {
        string requestURL=URLsToLoad[currentURLNo];
        int id = ofLoadURLAsync(requestURL, "async_req");
    }else{
        loadingResponseDone=true;
        printf("%s", URLsToLoad[currentURLNo].c_str());
    }
}
//--------------------------------------------------------------
//updating
//--------------------------------------------------------------
void testApp::updatePostcards(){
    int noOfPostcards=0;
    if ((int)allPostcardsGerichtsstrasse.size()>(int)allPostcardsBrunnenstrasse.size()) {
        noOfPostcards=(int)allPostcardsGerichtsstrasse.size();
    }else{
        noOfPostcards=(int)allPostcardsBrunnenstrasse.size();
    }
    counterPostcardsAndLetters++;
    counterNumberPostcards++;
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
        //loading=true;
        
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
    }
}
void testApp::updateLetters(){
    counterPostcardsAndLetters++;
    
    //send request for next thing
    if (counterPostcardsAndLetters==FRAME_RATE) {
        goToNextScreen();
    }
    //determining when it is over
    if (currentURL==recentLetters && counterPostcardsAndLetters>lengthLetters*FRAME_RATE) {
        counterPostcardsAndLetters=0;
        blendInfo=0;
        
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
    }
}
void testApp::updateAlphabet(){
    counterDrawAlphabet++;
    //start updating for the individual letters only
    if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
        
        if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
            if (allAlphabetGerichtsstrasse[currImgNo1].nextImage()) {
                currImgNo1+=5;
                if(currImgNo1>allAlphabetGerichtsstrasse.size()-1){
                    currImgNo1=currImgNo1-allAlphabetGerichtsstrasse.size();
                }
            }
            if (allAlphabetGerichtsstrasse[currImgNo2].nextImage()) {
                currImgNo2+=5;
                if(currImgNo2>allAlphabetGerichtsstrasse.size()-1){
                    currImgNo2=currImgNo2-allAlphabetGerichtsstrasse.size();
                }
            }
            if (allAlphabetGerichtsstrasse[currImgNo3].nextImage()) {
                currImgNo3+=5;
                if(currImgNo3>allAlphabetGerichtsstrasse.size()-1){
                    currImgNo3=currImgNo3-allAlphabetGerichtsstrasse.size();
                }
            }
            if (allAlphabetGerichtsstrasse[currImgNo4].nextImage()) {
                currImgNo4+=5;
                if(currImgNo4>allAlphabetGerichtsstrasse.size()-1){
                    currImgNo4=currImgNo4-allAlphabetGerichtsstrasse.size();
                }
            }
            if (allAlphabetGerichtsstrasse[currImgNo5].nextImage()) {
                currImgNo5+=5;
                if(currImgNo5>allAlphabetGerichtsstrasse.size()-1){
                    currImgNo5=currImgNo5-allAlphabetGerichtsstrasse.size();
                }
            }
            //update berlin
            allAlphabetGerichtsstrasse[currImgNo1].update();
            allAlphabetGerichtsstrasse[currImgNo2].update();
            allAlphabetGerichtsstrasse[currImgNo3].update();
            allAlphabetGerichtsstrasse[currImgNo4].update();
            allAlphabetGerichtsstrasse[currImgNo5].update();
            //update Riga
            allAlphabetBrunnenstrasse[currImgNo1].update();
            allAlphabetBrunnenstrasse[currImgNo2].update();
            allAlphabetBrunnenstrasse[currImgNo3].update();
            allAlphabetBrunnenstrasse[currImgNo4].update();
            allAlphabetBrunnenstrasse[currImgNo5].update();
        }
    }
    //send request to next screen already
    if (counterDrawAlphabet==FRAME_RATE*(alphabetLength-3)) {
        goToNextScreen();
    }
    //determining when it's over
    if (currentURL==currentAlphabet && currImgNo2>39 && allAlphabetGerichtsstrasse[currImgNo2]._xPos<-200) {
        counterDrawAlphabet=0;
        blendInfo=0;
        //now go to that screen
        currentURL=URLsToLoad[currentURLNo];
    }
}
//--------------------------------------------------------------
//drawing
//--------------------------------------------------------------
void testApp::drawPostcards(){
    int noOfPostcards=0;
    if ((int)allPostcardsGerichtsstrasse.size()>allPostcardsBrunnenstrasse.size()) {
        noOfPostcards=(int)allPostcardsGerichtsstrasse.size();
    }else{
        noOfPostcards=(int)allPostcardsBrunnenstrasse.size();
    }
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
    if(allPostcardsGerichtsstrasse.size()-1>=currImgNo){
        allPostcardsGerichtsstrasse[currImgNo].draw();
    }
    if (allPostcardsBrunnenstrasse.size()-1>=currImgNo) {
        allPostcardsBrunnenstrasse[currImgNo].draw();
    }
    //draw title
    ofSetColor(255);
    questions[currentQuestionNumber].draw(0,0);
    postcardsTitle.draw((ofGetWidth()-postcardsTitle.width-AROUND), 0);
    ofDisableAlphaBlending();
}
void testApp::drawLetters(){

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
    //draw letters Gerichtsstrasse
    int noOfLetters=(int)allLettersGerichtsstrasse.size();

    if(noOfLetters>0){
        allLettersGerichtsstrasse[currLetterImgNo1].draw();
    }
    if(noOfLetters>1){
        allLettersGerichtsstrasse[currLetterImgNo2].draw();
    }
    if(noOfLetters>2){
        allLettersGerichtsstrasse[currLetterImgNo3].draw();
    }
    //draw letters Brunnenstrasse
    noOfLetters=(int)allLettersBrunnenstrasse.size();
    
    if(noOfLetters>0){
        allLettersBrunnenstrasse[currLetterImgNo1].draw();
    }
    if(noOfLetters>1){
        allLettersBrunnenstrasse[currLetterImgNo2].draw();
    }
    if(noOfLetters>2){
        allLettersBrunnenstrasse[currLetterImgNo3].draw();
    }

    //draw title
    ofSetColor(255);
    lettersTitle.draw((ofGetWidth()-lettersTitle.width-AROUND), 0);
    
    ofDisableAlphaBlending();
}
void testApp::drawAlphabet(){
    ofEnableAlphaBlending();
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
    for (int i=0; i<allAlphabetGerichtsstrasse.size(); i++) {
        allAlphabetGerichtsstrasse[i].drawWhole();
    }
    ofPushMatrix();
    ofTranslate((ofGetWidth()-4*AROUND)/2+2*AROUND, 0);
    for (int i=0; i<allAlphabetBrunnenstrasse.size(); i++) {
        allAlphabetBrunnenstrasse[i].drawWhole();
    }
    ofPopMatrix();
    if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
        allAlphabetGerichtsstrasse[currImgNo1].draw();
        allAlphabetGerichtsstrasse[currImgNo2].draw();
        allAlphabetGerichtsstrasse[currImgNo3].draw();
        allAlphabetGerichtsstrasse[currImgNo4].draw();
        allAlphabetGerichtsstrasse[currImgNo5].draw();
        ofPushMatrix();
        ofTranslate((ofGetWidth()-4*AROUND)/2+2*AROUND, 0);
        allAlphabetBrunnenstrasse[currImgNo1].draw();
        allAlphabetBrunnenstrasse[currImgNo2].draw();
        allAlphabetBrunnenstrasse[currImgNo3].draw();
        allAlphabetBrunnenstrasse[currImgNo4].draw();
        allAlphabetBrunnenstrasse[currImgNo5].draw();
        ofPopMatrix();
    }
    ofSetColor(255);
    alphabetTitle.draw((ofGetWidth()-alphabetTitle.width-AROUND), 0);
    ofDisableAlphaBlending();
}

//-------------------------------------------------
void testApp::keyReleased(int key){
    
}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y){
    
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