#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    //base setup
    ofSetFrameRate(FRAME_RATE);
    ofBackground(0);
	ofTrueTypeFont::setGlobalDpi(72);
    ofRegisterURLNotification(this);
    
    //
    recentPostcardsBerlin="http://www.ualphabets.com/requests/Berlin/postcards.php";
    recentLettersBerlin="http://www.ualphabets.com/requests/Berlin/letters.php";
    currentAlphabetBerlin="http://www.ualphabets.com/requests/Berlin/alphabet.php";

    recentPostcardsRiga="http://www.ualphabets.com/requests/Riga/connected/postcards.php";
    recentLettersRiga="http://www.ualphabets.com/requests/Riga/connected/letters.php";
    currentAlphabetRiga="http://www.ualphabets.com/requests/Riga/connected/alphabet.php";
    
    currentQuestion="http://www.ualphabets.com/requests/Riga/connected/question.php";
    
    recentPostcards=recentPostcardsBerlin;
    recentLetters=recentLettersBerlin;
    currentAlphabet=currentAlphabetBerlin;
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
    
    //setup of Riga and Berlin images in lower corners
    berlin.loadImage("intro/intro_Berlin.png");
    riga.loadImage("intro/intro_Riga.png");
    
    //setup for intro screens before actual
    loadingResponseDone=false;
    blendInfo=0;
    introLength=4;
    
    //setup for alphabet screen
    counterDrawAlphabet=0;
    alphabetLength=10;
    alphabetTitle.loadImage("intro/intro_currentAlphabet.png");
    berlinAlphabetLoaded=false;
    
    //setup for postcards and letters screen
    lengthPostcards=8;//in secs
    lengthLetters=10;//in secs
    counterPostcardsAndLetters=0;
    counterNumberPostcards=0;
    lettersTitle.loadImage("intro/intro_titleLetters.png");
    postcardsTitle.loadImage("intro/intro_titlePostcards.png");
    
    //changing questions setup
    questions[0].loadImage("questions/questions_english_ -01.png");
    questions[1].loadImage("questions/questions_english_ -02.png");
    questions[2].loadImage("questions/questions_english_ -03.png");
    questions[3].loadImage("questions/questions_english_ -04.png");
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
    
    //the latvian alphabet
    alphabetLatvian[0]="A";
    alphabetLatvian[1]="LatvA";
    alphabetLatvian[2]="B";
    alphabetLatvian[3]="C";
    alphabetLatvian[4]="LatvC";
    alphabetLatvian[5]="D";
    alphabetLatvian[6]="E";
    alphabetLatvian[7]="LatvE";
    alphabetLatvian[8]="F";
    alphabetLatvian[9]="G";
    alphabetLatvian[10]="LatvG";
    alphabetLatvian[11]="H";
    alphabetLatvian[12]="I";
    alphabetLatvian[13]="LatvI";
    alphabetLatvian[14]="J";
    alphabetLatvian[15]="K";
    alphabetLatvian[16]="LatvK";
    alphabetLatvian[17]="L";
    alphabetLatvian[18]="LatvL";
    alphabetLatvian[19]="M";
    alphabetLatvian[20]="N";
    alphabetLatvian[21]="LatvN";
    alphabetLatvian[22]="O";
    alphabetLatvian[23]="P";
    alphabetLatvian[24]="R";
    alphabetLatvian[25]="S";
    alphabetLatvian[26]="LatvS";
    alphabetLatvian[27]="T";
    alphabetLatvian[28]="U";
    alphabetLatvian[29]="LatvU";
    alphabetLatvian[30]="V";
    alphabetLatvian[31]="Z";
    alphabetLatvian[32]="LatvZ";
    alphabetLatvian[33]="1";
    alphabetLatvian[34]="2";
    alphabetLatvian[35]="3";
    alphabetLatvian[36]="4";
    alphabetLatvian[37]="5";
    alphabetLatvian[38]="6";
    alphabetLatvian[39]="7";
    alphabetLatvian[40]="8";
    alphabetLatvian[41]="9";
    
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
            //ofRect(ofGetWidth()/2-1, 0, 2, ofGetHeight());
            //background for Berlin
            ofRect(AROUND, questions[0].height+AROUND, (ofGetWidth()-AROUND*4)/2, ofGetHeight()-questions[0].height-AROUND*2);
            //background for Riga
            ofRect(AROUND*3+(ofGetWidth()-AROUND*4)/2, questions[0].height+AROUND, (ofGetWidth()-AROUND*4)/2, ofGetHeight()-questions[0].height-AROUND*2);
            ofSetColor(255);
            ofEnableAlphaBlending();
            berlin.draw(AROUND, questions[0].height+AROUND*2);
            riga.draw(ofGetWidth()-riga.width-AROUND, questions[0].height+AROUND*2);
            ofDisableAlphaBlending();
        }
        //printf("currentURL: %s, recentPostcards: %s \n", currentURL.c_str(), recentPostcards.c_str());
        if(currentURL==recentPostcardsBerlin){
            drawPostcards();
        }else if (currentURL==recentLettersBerlin){
            drawLetters();
        } else if(currentURL==currentAlphabetBerlin){
            drawAlphabet();
        } else if(currentURL==info){
            about.draw();
        }
    }
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
    //printf("%s", theResponse.c_str());
    
    allEntries=ofSplitString(theResponse, "},{");
    //printf("\nURLs to load: %s\n", URLsToLoad[currentURLNo].c_str());
    //printf(" all Entries size %lu \n", allEntries.size());
    if (URLsToLoad[currentURLNo]==recentPostcardsBerlin){
        loadURL_recentPostcards(response);
    } else if (URLsToLoad[currentURLNo]==recentLettersBerlin){
        loadURL_recentLetters(response);
    } else if(URLsToLoad[currentURLNo]==currentAlphabetBerlin && berlinAlphabetLoaded==false){
        loadURL_alphabetGerman(response);
    } else if(URLsToLoad[currentURLNo]==currentAlphabetBerlin && berlinAlphabetLoaded==true){
        loadURL_alphabetLatvian(response);
    } else if (URLsToLoad[currentURLNo]==currentQuestion){
        loadQuestion(response);
    }

}
void testApp::loadURL_recentPostcards(ofHttpResponse &response){
    printf("loadURL_recentPostcards\n");
    if (allEntries.size()>1) {
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
            //printf("cutEntries0=%s", cutEntries[0].c_str());
            string rigaBerlin="";
            if (recentPostcards==recentPostcardsBerlin) {
                rigaBerlin="Berlin";
            }else {
                rigaBerlin="Riga";
            }
            Postcard entry(cutEntries[0], cutEntries[1], cutEntries[2],cutEntries[3],cutEntries[4], rigaBerlin, cutEntries[5]);
            printf(" entry____ ");
            entry.print();
            if (recentPostcards==recentPostcardsBerlin) {
                if(allPostcardsBerlin.size()<5){
                    allPostcardsBerlin.push_back(entry);
                    allPostcardsBerlin[allPostcardsBerlin.size()-1].loadImage();
                } else{
                    for (int i=0; i<allPostcardsBerlin.size(); i++) {
                        /*printf("allPostcardsBerlinsize-1: %i", (int)allPostcardsBerlin.size()-1);
                        printf("i: %i", i);
                        printf("entry id: %i  ", entry._id);
                        printf("postcard id: %i\n", allPostcardsBerlin[i]._id);*/
                        if (entry._id==allPostcardsBerlin[i]._id) {
                            break;
                        }
                        if (i==allPostcardsBerlin.size()-1) {
                            allPostcardsBerlin.insert(allPostcardsBerlin.begin(),entry);
                            allPostcardsBerlin[0].loadImage();
                            allPostcardsBerlin.pop_back();
                            break;
                        }
                    }
                }
            } else{
                if(allPostcardsRiga.size()<5){
                    allPostcardsRiga.push_back(entry);
                    allPostcardsRiga[allPostcardsRiga.size()-1].loadImage();
                } else{
                    for (int i=0; i<allPostcardsRiga.size(); i++) {
                        /*printf("allPostcardsRigasize-1: %i", (int)allPostcardsRiga.size()-1);
                        printf("i: %i", i);
                        printf("entry id: %i  ", entry._id);
                        printf("postcard id: %i\n", allPostcardsRiga[i]._id);*/
                        if (entry._id==allPostcardsRiga[i]._id) {
                            break;
                        }
                        if (i==allPostcardsRiga.size()-1) {
                            allPostcardsRiga.insert(allPostcardsRiga.begin(),entry);
                            allPostcardsRiga[0].loadImage();
                            allPostcardsRiga.pop_back();
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
        if(allPostcardsBerlin.size()>allPostcardsRiga.size()){
            currImgNo=allPostcardsBerlin.size()-1;
        }else{
            currImgNo=allPostcardsRiga.size()-1;
        }
    } else{
        //printf("not loaded \n");
        
    }
    printf("loaded postcards \n");
    if (recentPostcards==recentPostcardsBerlin) {
        recentPostcards=recentPostcardsRiga;
        //sending request to Riga
        int id = ofLoadURLAsync(recentPostcards, "async_req");
        printf("sending request to %s\n",recentPostcards.c_str());
    } else{
        recentPostcards=recentPostcardsBerlin;
    }
}
void testApp::loadURL_recentLetters(ofHttpResponse &response){
    if (recentLetters==recentLettersBerlin) {
        allLettersBerlin.clear();
    } else{
        allLettersRiga.clear();
    }
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
        if (recentLetters==recentLettersBerlin) {
            rigaBerlin="Berlin";
        }else {
            rigaBerlin="Riga";
        }
        Letter entry(cutEntries[0], cutEntries[1], cutEntries[2], i, rigaBerlin);
        if (recentLetters==recentLettersBerlin) {
            if(allLettersBerlin.size()<3){
                allLettersBerlin.push_back(entry);
                allLettersBerlin[allLettersBerlin.size()-1].loadImage();
            } else{
                for (int i=0; i<allLettersBerlin.size(); i++) {
                    /*printf("allPostcardsBerlinsize-1: %i", (int)allPostcardsBerlin.size()-1);
                     printf("i: %i", i);
                     printf("entry id: %i  ", entry._id);
                     printf("postcard id: %i\n", allPostcardsBerlin[i]._id);*/
                    if (entry._id==allLettersBerlin[i]._id) {
                        break;
                    }
                    if (i==allLettersBerlin.size()-1) {
                        allLettersBerlin.insert(allLettersBerlin.begin(),entry);
                        allLettersBerlin[0].loadImage();
                        allLettersBerlin.pop_back();
                        break;
                    }
                }
            }
        } else{
            if(allLettersRiga.size()<3){
                allLettersRiga.push_back(entry);
                allLettersRiga[allLettersRiga.size()-1].loadImage();
            } else{
                for (int i=0; i<allLettersRiga.size(); i++) {
                    if (entry._id==allLettersRiga[i]._id) {
                        break;
                    }
                    if (i==allLettersRiga.size()-1) {
                        allLettersRiga.insert(allLettersBerlin.begin(),entry);
                        allLettersRiga[0].loadImage();
                        allLettersRiga.pop_back();
                        break;
                    }
                }
            }
        }
    }
    if (response.status==200 && response.request.name=="async_req") {
        //setup which ones are shown first
        currLetterImgNo1=allLettersBerlin.size()-1;
        currLetterImgNo2=allLettersBerlin.size()-2;
        currLetterImgNo3=allLettersBerlin.size()-3;
        currLetterImgNo4=allLettersBerlin.size()-4;
        currLetterImgNo5=allLettersBerlin.size()-5;
        
        if (recentLetters==recentLettersBerlin) {
            recentLetters =recentLettersRiga;
            //sending request to Riga
            int id = ofLoadURLAsync(recentLetters, "async_req");
            printf("sending request to %s\n",recentLetters.c_str());
        } else{
            recentLetters=recentLettersBerlin;
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
    //printf("number of Letters received: %i\n", numberOfLettersAdded);
    
    for (int j=0; j<42; j++) {
        //go through all letters we have
        for (int i=0; i<allLetters.size(); i++){
            if (allLetters[i]._letter==alphabetGerman[j]) {
                AlphabetEntry entry(ofToString(allLetters[i]._id), allLetters[i]._letter, j);
                newAlphabet.push_back(entry);
                printf(" entry____ ");
                entry.print();
                break;
            } else if (i==allLetters.size()-1){
                AlphabetEntry entry("0000", alphabetGerman[j], j);
                newAlphabet.push_back(entry);
                break;
            }
        }
    }
    //if first time load > put the letters directly into the alphabet
    if (allAlphabetBerlin.size()<1) {
        for (int j=0; j<newAlphabet.size(); j++) {
            allAlphabetBerlin.push_back(newAlphabet[j]);
            if (allAlphabetBerlin[j]._id!=0) {
                allAlphabetBerlin[j].loadImage();
            }else{
                //load letter from image directory
                allAlphabetBerlin[j].loadImageDirectory();
            }

        }
    }else{//if there is already something in the alphabet
        for (int j=0; j<42; j++) {
            //printf("letter: %s all alphabet: %i, new alphabet: %i\n", allAlphabetBerlin[j]._letter.c_str() ,allAlphabetBerlin[j]._id, newAlphabet[j]._id);
            if (allAlphabetBerlin[j]._id!=newAlphabet[j]._id) {
                allAlphabetBerlin[j]=newAlphabet[j];
                allAlphabetBerlin.push_back(newAlphabet[j]);
                if (allAlphabetBerlin[j]._id!=0) {
                    allAlphabetBerlin[j].loadImage();
                }else{
                    //load letter from image directory
                    allAlphabetBerlin[j].loadImageDirectory();
                }

            }else{
                allAlphabetBerlin[j].reset();
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
    if (currentAlphabet==currentAlphabetBerlin) {
        currentAlphabet=currentAlphabetRiga;
        //sending request to Riga
        int id = ofLoadURLAsync(currentAlphabet, "async_req");
        printf("sending request to %s\n",currentAlphabet.c_str());
    } else{
        currentAlphabet=currentAlphabetBerlin;
    }
    berlinAlphabetLoaded=true;
}
void testApp::loadURL_alphabetLatvian(ofHttpResponse &response){
    printf("loading Latvian\n");
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
    printf("number of Letters received: %i\n", numberOfLettersAdded);
    
    for (int j=0; j<42; j++) {
        //go through all letters we have
        for (int i=0; i<allLetters.size(); i++){
            if (allLetters[i]._letter==alphabetLatvian[j]) {
                AlphabetEntry entry(ofToString(allLetters[i]._id), allLetters[i]._letter, j);
                newAlphabet.push_back(entry);
                break;
            } else if (i==allLetters.size()-1){
                AlphabetEntry entry("0000", alphabetLatvian[j], j);
                newAlphabet.push_back(entry);
                break;
            }
        }
    }
    
    //if first time load > put the letters directly into the alphabet
    if (allAlphabetRiga.size()<1) {
        for (int j=0; j<newAlphabet.size(); j++) {
            allAlphabetRiga.push_back(newAlphabet[j]);
            if (allAlphabetRiga[j]._id!=0) {
                allAlphabetRiga[j].loadImage();
            }else{
                //load letter from image directory
                allAlphabetRiga[j].loadImageDirectory();
            }

        }
    }else{//if there is already something in the alphabet
        for (int j=0; j<42; j++) {
            printf("letter: %s all alphabet: %i, new alphabet: %i\n", allAlphabetRiga[j]._letter.c_str() ,allAlphabetRiga[j]._id, newAlphabet[j]._id);
            if (allAlphabetRiga[j]._id!=newAlphabet[j]._id) {
                allAlphabetRiga[j]=newAlphabet[j];
                if (allAlphabetRiga[j]._id!=0) {
                    allAlphabetRiga[j].loadImage();
                }else{
                    //load letter from image directory
                    allAlphabetBerlin[j].loadImageDirectory();
                }

            }else{
                allAlphabetRiga[j].reset();
            }
        }
    }
    berlinAlphabetLoaded=false;
    currentAlphabet=currentAlphabetBerlin;
}

void testApp::loadQuestion(ofHttpResponse &response){
    
        printf("allEntries:%s",allEntries[0].c_str());
            //delete the first parts in all of them
            ofStringReplace(allEntries[0], "\"ID\":\"", "");
            //delete the last " in all of them
            ofStringReplace(allEntries[0], "\"", "");
    printf("allEntries (after cutting):%s",allEntries[0].c_str());

    currentQuestionNumber=ofToInt(allEntries[0])-1;
    printf("current Question No: %i", currentQuestionNumber);
    
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
        printf("sending request to %s\n", requestURL.c_str());
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
    if ((int)allPostcardsBerlin.size()>(int)allPostcardsRiga.size()) {
        noOfPostcards=(int)allPostcardsBerlin.size();
    }else{
        noOfPostcards=(int)allPostcardsRiga.size();
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
        printf("next screen :%s\n", currentURL.c_str());
        
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
        printf("next screen :%s\n", currentURL.c_str());
    }
}
void testApp::updateAlphabet(){
    counterDrawAlphabet++;
    //start updating for the individual letters only
    if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
        
        if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
            if (allAlphabetBerlin[currImgNo1].nextImage()) {
                currImgNo1+=5;
                if(currImgNo1>allAlphabetBerlin.size()-1){
                    currImgNo1=currImgNo1-allAlphabetBerlin.size();
                }
            }
            if (allAlphabetBerlin[currImgNo2].nextImage()) {
                currImgNo2+=5;
                if(currImgNo2>allAlphabetBerlin.size()-1){
                    currImgNo2=currImgNo2-allAlphabetBerlin.size();
                }
            }
            if (allAlphabetBerlin[currImgNo3].nextImage()) {
                currImgNo3+=5;
                if(currImgNo3>allAlphabetBerlin.size()-1){
                    currImgNo3=currImgNo3-allAlphabetBerlin.size();
                }
            }
            if (allAlphabetBerlin[currImgNo4].nextImage()) {
                currImgNo4+=5;
                if(currImgNo4>allAlphabetBerlin.size()-1){
                    currImgNo4=currImgNo4-allAlphabetBerlin.size();
                }
            }
            if (allAlphabetBerlin[currImgNo5].nextImage()) {
                currImgNo5+=5;
                if(currImgNo5>allAlphabetBerlin.size()-1){
                    currImgNo5=currImgNo5-allAlphabetBerlin.size();
                }
            }
            //update berlin
            allAlphabetBerlin[currImgNo1].update();
            allAlphabetBerlin[currImgNo2].update();
            allAlphabetBerlin[currImgNo3].update();
            allAlphabetBerlin[currImgNo4].update();
            allAlphabetBerlin[currImgNo5].update();
            //update Riga
            allAlphabetRiga[currImgNo1].update();
            allAlphabetRiga[currImgNo2].update();
            allAlphabetRiga[currImgNo3].update();
            allAlphabetRiga[currImgNo4].update();
            allAlphabetRiga[currImgNo5].update();
        }
    }
    //send request to next screen already
    if (counterDrawAlphabet==FRAME_RATE*(alphabetLength-3)) {
        goToNextScreen();
    }
    //determining when it's over
    if (currentURL==currentAlphabet && currImgNo2>39 && allAlphabetBerlin[currImgNo2]._xPos<-200) {
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
void testApp::drawPostcards(){
    int noOfPostcards=0;
    if ((int)allPostcardsBerlin.size()>allPostcardsRiga.size()) {
        noOfPostcards=(int)allPostcardsBerlin.size();
    }else{
        noOfPostcards=(int)allPostcardsRiga.size();
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
    if(allPostcardsBerlin.size()-1>=currImgNo){
        allPostcardsBerlin[currImgNo].draw();
    }
    if (allPostcardsRiga.size()-1>=currImgNo) {
        allPostcardsRiga[currImgNo].draw();
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
    //draw letters Berlin
    int noOfLetters=(int)allLettersBerlin.size();

    if(noOfLetters>0){
        allLettersBerlin[currLetterImgNo1].draw();
    }
    if(noOfLetters>1){
        allLettersBerlin[currLetterImgNo2].draw();
    }
    if(noOfLetters>2){
        allLettersBerlin[currLetterImgNo3].draw();
    }
    //draw letters Riga
    noOfLetters=(int)allLettersRiga.size();
    
    if(noOfLetters>0){
        allLettersRiga[currLetterImgNo1].draw();
    }
    if(noOfLetters>1){
        allLettersRiga[currLetterImgNo2].draw();
    }
    if(noOfLetters>2){
        allLettersRiga[currLetterImgNo3].draw();
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
    for (int i=0; i<allAlphabetBerlin.size(); i++) {
        allAlphabetBerlin[i].drawWhole();
    }
    ofPushMatrix();
    ofTranslate((ofGetWidth()-4*AROUND)/2+2*AROUND, 0);
    for (int i=0; i<allAlphabetRiga.size(); i++) {
        allAlphabetRiga[i].drawWhole();
    }
    ofPopMatrix();
    if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
        allAlphabetBerlin[currImgNo1].draw();
        allAlphabetBerlin[currImgNo2].draw();
        allAlphabetBerlin[currImgNo3].draw();
        allAlphabetBerlin[currImgNo4].draw();
        allAlphabetBerlin[currImgNo5].draw();
        ofPushMatrix();
        ofTranslate((ofGetWidth()-4*AROUND)/2+2*AROUND, 0);
        allAlphabetRiga[currImgNo1].draw();
        allAlphabetRiga[currImgNo2].draw();
        allAlphabetRiga[currImgNo3].draw();
        allAlphabetRiga[currImgNo4].draw();
        allAlphabetRiga[currImgNo5].draw();
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