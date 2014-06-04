#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    //base setup
    ofSetFrameRate(FRAME_RATE);
    ofBackground(0);
	ofTrueTypeFont::setGlobalDpi(72);
    ofRegisterURLNotification(this);
    
    //
    recentPostcards="http://www.ualphabets.com/requests/DemoDaySpring2014/postcards.php";
    recentLetters="http://www.ualphabets.com/requests/DemoDaySpring2014/letters.php";
    currentAlphabet="http://www.ualphabets.com/requests/DemoDaySpring2014/alphabet.php";
    info="Info";
    lastTweet="twitter";
    
    //setup of the URLS that need to be loaded
    URLsToLoad[0]=info;
    URLsToLoad[1]=lastTweet;
    URLsToLoad[2]=recentLetters;
    URLsToLoad[3]=recentPostcards;
    URLsToLoad[4]=currentAlphabet;
    URLsToLoad[5]=lastTweet;
    URLsToLoad[6]=recentPostcards;
    
    currentURLNo=1; //first screen to be shown
    currentURL=URLsToLoad[currentURLNo];
    loading= true; //send the first request on start alphabets/postcards/...
    
    //setup for intro screens before actual
    counterDrawInfo=0;
    loadingResponseDone=false;
    blendInfo=0;
    introLength=3;

    
    //setup for alphabet screen
    counterDrawAlphabet=0;
    alphabetLength=8;
    alphabetTitle.loadImage("intro/intro_currentAlphabet.png");
    
    //setup for postcards and letters screen
    lengthPostcardsAndLetters=8;//in secs
    counterPostcardsAndLetters=0;
    lettersTitle.loadImage("intro/intro_titleLetters.png");
    postcardsTitle.loadImage("intro/intro_titlePostcards.png");
    
    //setup twitter length
    counterTweet=0;
    lengthTweet=20;
    
    //the finnish alphabet
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
    alphabet[26]="AA";
    alphabet[27]="OO";
    alphabet[28]="AAA";
    alphabet[29]="";
    alphabet[30]="!";
    alphabet[31]="-";
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
    
    
    //images before the actual screens
    imagesIntro[0].loadImage("intro/intro_Title.png");//logo
    imagesIntro[1].loadImage("intro/intro_recentLetters.png");//letters
    imagesIntro[2].loadImage("intro/intro_currAlphabet.png");//alphabet
    imagesIntro[3].loadImage("intro/intro_recentPostcards.png");//postcards
    imagesIntro[4].loadImage("intro/intro_lastTweet.png");//lastTweet
    
    //setting up twitter
    twitterClient.setDiskCache(true);
    twitterClient.setAutoLoadImages(true, false); // Loads images into memory as ofImage;
    
    string const CONSUMER_KEY = "4766QR33Yl4IfWYz8KXWI1Fcl";
    string const CONSUMER_SECRET = "ZzcsVG00tYsJYKpIg1sxHhhhGWgHu29qWl0elJoHzle4WjwK0y";
    
    twitterClient.authorize(CONSUMER_KEY, CONSUMER_SECRET);
    
    actualTweet = 0;
    printf("%d",twitterClient.isAuthorized());
    tweetCounter=0;
    textTweet="bla";
    
    //setup tweet alphabet
    tweetAlphabet[0].loadImage("tweetAlphabet/letter_A.png");
    tweetAlphabet[1].loadImage("tweetAlphabet/letter_B.png");
    tweetAlphabet[2].loadImage("tweetAlphabet/letter_C.png");
    tweetAlphabet[3].loadImage("tweetAlphabet/letter_D.png");
    tweetAlphabet[4].loadImage("tweetAlphabet/letter_E.png");
    tweetAlphabet[5].loadImage("tweetAlphabet/letter_F.png");
    tweetAlphabet[6].loadImage("tweetAlphabet/letter_G.png");
    tweetAlphabet[7].loadImage("tweetAlphabet/letter_H.png");
    tweetAlphabet[8].loadImage("tweetAlphabet/letter_I.png");
    tweetAlphabet[9].loadImage("tweetAlphabet/letter_J.png");
    tweetAlphabet[10].loadImage("tweetAlphabet/letter_K.png");
    tweetAlphabet[11].loadImage("tweetAlphabet/letter_L.png");
    tweetAlphabet[12].loadImage("tweetAlphabet/letter_M.png");
    tweetAlphabet[13].loadImage("tweetAlphabet/letter_N.png");
    tweetAlphabet[14].loadImage("tweetAlphabet/letter_O.png");
    tweetAlphabet[15].loadImage("tweetAlphabet/letter_P.png");
    tweetAlphabet[16].loadImage("tweetAlphabet/letter_Q.png");
    tweetAlphabet[17].loadImage("tweetAlphabet/letter_R.png");
    tweetAlphabet[18].loadImage("tweetAlphabet/letter_S.png");
    tweetAlphabet[19].loadImage("tweetAlphabet/letter_T.png");
    tweetAlphabet[20].loadImage("tweetAlphabet/letter_U.png");
    tweetAlphabet[21].loadImage("tweetAlphabet/letter_V.png");
    tweetAlphabet[22].loadImage("tweetAlphabet/letter_W.png");
    tweetAlphabet[23].loadImage("tweetAlphabet/letter_X.png");
    tweetAlphabet[24].loadImage("tweetAlphabet/letter_Y.png");
    tweetAlphabet[25].loadImage("tweetAlphabet/letter_Z.png");
    tweetAlphabet[26].loadImage("tweetAlphabet/letter_AA.png"); //Ä
    tweetAlphabet[27].loadImage("tweetAlphabet/letter_OO.png"); //Ö
    tweetAlphabet[28].loadImage("tweetAlphabet/letter_AA.png"); //Å
    tweetAlphabet[29].loadImage("tweetAlphabet/letter_.png"); //.
    tweetAlphabet[30].loadImage("tweetAlphabet/letter_!.png");
    tweetAlphabet[31].loadImage("tweetAlphabet/letter_-.png"); //?
    tweetAlphabet[32].loadImage("tweetAlphabet/letter_0.png");
    tweetAlphabet[33].loadImage("tweetAlphabet/letter_1.png");
    tweetAlphabet[34].loadImage("tweetAlphabet/letter_2.png");
    tweetAlphabet[35].loadImage("tweetAlphabet/letter_3.png");
    tweetAlphabet[36].loadImage("tweetAlphabet/letter_4.png");
    tweetAlphabet[37].loadImage("tweetAlphabet/letter_5.png");
    tweetAlphabet[38].loadImage("tweetAlphabet/letter_6.png");
    tweetAlphabet[39].loadImage("tweetAlphabet/letter_7.png");
    tweetAlphabet[40].loadImage("tweetAlphabet/letter_8.png");
    tweetAlphabet[41].loadImage("tweetAlphabet/letter_9.png");
    tweetAlphabet[42].loadImage("tweetAlphabet/letter_empty.png");
    
    //for snapshot
    snapCounter = 0;
	bSnapshot = false;
	phase = 0;
	memset(snapString, 0, 255);		// clear the string by setting all chars to 0
    
    
    
    //send the first request
    if (currentURL!=info &&currentURL!=lastTweet) {
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
            if (about.over) {
                goToNextScreen();
                about.reset();
            }
        }
    }
}
//--------------------------------------------------------------
void testApp::sendRequest(){
    if (currentURL!=info && currentURL!=lastTweet) {
        int id = ofLoadURLAsync(currentURL, "async_req");
        loading=true;
    }else{
        loadingResponseDone=true;
        loading=true;
        printf("%s", currentURL.c_str());
    }
}

//--------------------------------------------------------------
void testApp::draw(){  
    ofSetColor(0);
    //draw title of upcoming thing for 5 secs
    if (loadingResponseDone) {
        ofEnableAlphaBlending();
        counterDrawInfo++;
        if (counterDrawInfo<FRAME_RATE*1){
            blendInfo+=5;
            ofSetColor(255, 255, 255, blendInfo);
        } else if(counterDrawInfo> FRAME_RATE*(introLength-1)){
            blendInfo-=5;
            ofSetColor(255, 255, 255, blendInfo);
        } else{
            ofSetColor(255, 255, 255, 255);
        }
        drawIntro();
        ofDisableAlphaBlending();
    }
    if (counterDrawInfo>FRAME_RATE*introLength) {
        loading=false;
        loadingResponseDone=false;
        
    }
    
    //the actual screens
    if(loading==false){
        if(currentURL==recentPostcards){
            drawPostcards();
        }else if (currentURL==recentLetters){
            drawLetters();
        } else if(currentURL==currentAlphabet){
            drawAlphabet();
        } else if(currentURL==info){
            about.draw();
        } else if(currentURL==lastTweet){
            drawTweet();
        }
    }
    
}
void testApp::drawIntro(){
    if (currentURL==recentLetters) { //recent letters
        imagesIntro[1].draw(0, 0);
    }else if (currentURL==currentAlphabet) { //current alphabet
        imagesIntro[2].draw(0, 0);
    }else if (currentURL==recentPostcards) { //recent postcards
        imagesIntro[3].draw(0, 0);
    }else if(currentURL==info){ //info
        imagesIntro[0].draw(0, 0);
    } else if(currentURL==lastTweet){ //last tweet
        imagesIntro[4].draw(0, 0);
    }
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    
}



//--------------------------------------------------------------
//http request and ordering
//--------------------------------------------------------------

void testApp::urlResponse(ofHttpResponse & response){
    loadingResponseDone=true;
    theResponse=ofToString(response.data);
    ofStringReplace(theResponse, "[{", "");
    ofStringReplace(theResponse, "}]", "");
    printf("%s", theResponse.c_str());
    
    allEntries=ofSplitString(theResponse, "},{");
    if (currentURL==recentPostcards){
        loadURL_recentPostcards(response);
    } else if (currentURL==recentLetters){
        loadURL_recentLetters(response);
    } else if(currentURL==currentAlphabet){
        loadURL_alphabet(response);
    }
}
void testApp::loadURL_recentPostcards(ofHttpResponse &response){
    allPostcards.clear();
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
        //printf("%i ", i);
        Postcard entry(cutEntries[0], cutEntries[1], cutEntries[2],cutEntries[3],cutEntries[4], i);
        allPostcards.push_back(entry);
        

    }
    //just for testing
    //printf("allPostcards size %lu \n", allPostcards.size());
    /*for (int i=0; i<allPostcards.size(); i++) {
        allPostcards[i].print();
    }*/
    
    if (response.status==200 && response.request.name=="async_req") {
        //load all postcard images
        for (int i=0; i<allPostcards.size(); i++) {
            allPostcards[i].loadImage();
        }
        //setup which ones are shown first
        currImgNo1=allPostcards.size()-1;
        currImgNo2=allPostcards.size()-2;
        currImgNo3=allPostcards.size()-3;
        currImgNo4=allPostcards.size()-4;
        currImgNo5=allPostcards.size()-5;
    } else{
        printf("not loaded \n");
        
    }
}
void testApp::loadURL_recentLetters(ofHttpResponse &response){
    allLetters.clear();
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
        
        //printf("%i ", i);
        Letter entry(cutEntries[0], cutEntries[1], cutEntries[2], i);
        allLetters.push_back(entry);
        
    }
    //printf("allLetters length: %lu", allLetters.size());
    
    if (response.status==200 && response.request.name=="async_req") {
        //load all lette images
        for (int i=0; i<allLetters.size(); i++) {
            allLetters[i].loadImage();
        }
        //setup which ones are shown first
        currImgNo1=allLetters.size()-1;
        currImgNo2=allLetters.size()-2;
        currImgNo3=allLetters.size()-3;
        currImgNo4=allLetters.size()-4;
        currImgNo5=allLetters.size()-5;
    } else{
        printf("not loaded \n");
        
    }
}
void testApp::loadURL_alphabet(ofHttpResponse &response){
    allAlphabet.clear();
    int numberOfLettersAdded=0;
    vector<AlphabetEntry> allLetters;
    for (int i=0; i<allEntries.size(); i++) {
        ofStringReplace(allEntries[i], "letter\":\"", "");
        vector<string> cutEntries =ofSplitString(allEntries[i], "\",\"");
        //delete the first parts in all of them
        ofStringReplace(cutEntries[0], "\"ID\":\"","");
        ofStringReplace(cutEntries[0], "\"", "");
        ofStringReplace(cutEntries[1], "\"", "");
        //printf("%i ", i);
        string letter=cutEntries[1];
        printf("%s letter:%s\n",cutEntries[0].c_str(), letter.c_str());
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
            // printf("letter:alphabet %s:%s\n",allLetters[i]._letter.c_str(), spanishAlphabet[j].c_str() );
            if (allLetters[i]._letter==alphabet[j]) {
                AlphabetEntry entry(ofToString(allLetters[i]._id), allLetters[i]._letter, j);
                allAlphabet.push_back(entry);
                //printf("letter added(right): %s, position: %i\n", spanishAlphabet[j].c_str(), j);
                break;
            } else if (i==allLetters.size()-1){
                AlphabetEntry entry("0000", alphabet[j], j);
                allAlphabet.push_back(entry);
                //printf("letter added (fake): %s, position: %i\n", spanishAlphabet[j].c_str(), j);
                
                break;
            }
        }
    }
    printf("number of Letters in alphabet array: %lu \n", allAlphabet.size());
    printf("response status: %i", response.status);
    printf("  response name: %s", response.request.name.c_str());
    if (response.status==200 && response.request.name=="async_req") {
        for (int i=0; i<allAlphabet.size(); i++) {
            printf("%i \n", i);
            if (allAlphabet[i]._id!=0) {
                allAlphabet[i].loadImage();
            }else{
                //load letter from image directory
                allAlphabet[i].loadImageDirectory();
            }
        }
        currImgNo1=0;
        currImgNo2=1;
        currImgNo3=2;
        currImgNo4=3;
        currImgNo5=4;
    } else{
        printf("not loaded \n");
        
    }

}

void testApp::goToNextScreen(){
    currentURLNo++;
    if (currentURLNo>=LENGTH_OF_URL_ARRAY) {
        currentURLNo=0;
    }
    currentURL=URLsToLoad[currentURLNo];
    printf("next screen :%s\n", currentURL.c_str());
    //reset the counters
    counterDrawInfo=0;
    blendInfo=0;
    
    sendRequest();
}
void testApp::updatePostcards(){
    int noOfPostcards=(int)allPostcards.size();
    if (noOfPostcards>0) {
        allPostcards[currImgNo1].update();
    }
    if (noOfPostcards>1) {
        allPostcards[currImgNo2].update();
    }
    if (noOfPostcards>2) {
        allPostcards[currImgNo3].update();
    }
    if (noOfPostcards>3) {
        allPostcards[currImgNo4].update();
    }
    if (noOfPostcards>4) {
        allPostcards[currImgNo5].update();
    }
    counterPostcardsAndLetters++;
    //determining when this is over
    if (currentURL==recentPostcards && counterPostcardsAndLetters>lengthPostcardsAndLetters*FRAME_RATE ) {
        goToNextScreen();
        counterPostcardsAndLetters=0;
    }
}
void testApp::updateLetters(){
    int noOfLetters=(int)allLetters.size();
    if(noOfLetters>0){
        allLetters[currImgNo1].update();
    }
    if(noOfLetters>1){
        allLetters[currImgNo2].update();
    }
    if(noOfLetters>2){
        allLetters[currImgNo3].update();
    }
    if(noOfLetters>3){
        allLetters[currImgNo4].update();
    }
    if(noOfLetters>4){
        allLetters[currImgNo5].update();
    }
    counterPostcardsAndLetters++;
    //determining when it is over
    if (currentURL==recentLetters && counterPostcardsAndLetters>lengthPostcardsAndLetters*FRAME_RATE) {
        goToNextScreen();
        counterPostcardsAndLetters=0;
    }
}
void testApp::updateAlphabet(){
    counterDrawAlphabet++;
    //start updating for the individual letters only
    if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
        
        if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
            if (allAlphabet[currImgNo1].nextImage()) {
                currImgNo1+=5;
                if(currImgNo1>allAlphabet.size()-1){
                    currImgNo1=currImgNo1-allAlphabet.size();
                }
                printf("current imageNo: %i, %i, %i, %i, %i\n", currImgNo1, currImgNo2,currImgNo3,currImgNo4,currImgNo5);
                
                //printf("currImg1  after = %i\n", currImg1);
            }
            if (allAlphabet[currImgNo2].nextImage()) {
                currImgNo2+=5;
                if(currImgNo2>allAlphabet.size()-1){
                    currImgNo2=currImgNo2-allAlphabet.size();
                }
                printf("current imageNo: %i, %i, %i, %i, %i\n", currImgNo1, currImgNo2,currImgNo3,currImgNo4,currImgNo5);
                // printf("currImg2  after = %i\n", currImg2);
            }
            if (allAlphabet[currImgNo3].nextImage()) {
                currImgNo3+=5;
                if(currImgNo3>allAlphabet.size()-1){
                    currImgNo3=currImgNo3-allAlphabet.size();
                }
                printf("current imageNo: %i, %i, %i, %i, %i\n", currImgNo1, currImgNo2,currImgNo3,currImgNo4,currImgNo5);
                
                // printf("currImg3  after = %i\n", currImg3);
            }
            if (allAlphabet[currImgNo4].nextImage()) {
                currImgNo4+=5;
                if(currImgNo4>allAlphabet.size()-1){
                    currImgNo4=currImgNo4-allAlphabet.size();
                }
                printf("current imageNo: %i, %i, %i, %i, %i\n", currImgNo1, currImgNo2,currImgNo3,currImgNo4,currImgNo5);
                
                // printf("currImg4  after = %i\n", currImg4);
            }
            if (allAlphabet[currImgNo5].nextImage()) {
                currImgNo5+=5;
                if(currImgNo5>allAlphabet.size()-1){
                    currImgNo5=currImgNo5-allAlphabet.size();
                }
                printf("current imageNo: %i, %i, %i, %i, %i\n", currImgNo1, currImgNo2,currImgNo3,currImgNo4,currImgNo5);
                
                // printf("currImg5  after = %i\n", currImg5);
            }
            allAlphabet[currImgNo1].update();
            allAlphabet[currImgNo2].update();
            allAlphabet[currImgNo3].update();
            allAlphabet[currImgNo4].update();
            allAlphabet[currImgNo5].update();

        }
    }
    //determining when it's over
    if (currentURL==currentAlphabet && currImgNo2>39 && allAlphabet[currImgNo2]._xPos<-558) {
        goToNextScreen();
        counterDrawAlphabet=0;
    }
}

void testApp::drawPostcards(){
    int noOfPostcards=(int)allPostcards.size();
    ofEnableAlphaBlending();
    //blend in
    if(counterPostcardsAndLetters<FRAME_RATE){
        blendInfo+=8;
        ofSetColor(255, 255, 255, blendInfo);
    }
    //blend out
    else if(counterPostcardsAndLetters>FRAME_RATE*(lengthPostcardsAndLetters-1)){
        blendInfo-=8;
        ofSetColor(255, 255, 255, blendInfo);
    } else{
        ofSetColor(255);
    }
    //draw title
    postcardsTitle.draw(ofGetWidth()-postcardsTitle.width, ofGetHeight()-100);
    //draw postcards
    if (noOfPostcards>0) {
        allPostcards[currImgNo1].draw();
    }
    if (noOfPostcards>1) {
        allPostcards[currImgNo2].draw();
    }
    if (noOfPostcards>2) {
        allPostcards[currImgNo3].draw();
    }
    if (noOfPostcards>3) {
        allPostcards[currImgNo4].draw();
    }
    if (noOfPostcards>4) {
        allPostcards[currImgNo5].draw();
    }
    ofDisableAlphaBlending();
}
void testApp::drawLetters(){
    int noOfLetters=(int)allLetters.size();
    ofEnableAlphaBlending();
    //blend in
    if(counterPostcardsAndLetters<FRAME_RATE){
        blendInfo+=8;
        ofSetColor(255, 255, 255, blendInfo);
    }
    //blend out
    else if(counterPostcardsAndLetters>FRAME_RATE*(lengthPostcardsAndLetters-1)){
        blendInfo-=8;
        ofSetColor(255, 255, 255, blendInfo);
    } else{
        ofSetColor(255);
    }
    //draw title
    lettersTitle.draw(ofGetWidth()-lettersTitle.width, ofGetHeight()-100);
    //draw letters
    if(noOfLetters>0){
        allLetters[currImgNo1].draw();
    }
    if(noOfLetters>1){
        allLetters[currImgNo2].draw();
    }
    if(noOfLetters>2){
        allLetters[currImgNo3].draw();
    }
    if(noOfLetters>3){
        allLetters[currImgNo4].draw();
    }
    if(noOfLetters>4){
        allLetters[currImgNo5].draw();
    }
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
    alphabetTitle.draw(ofGetWidth()-alphabetTitle.width, ofGetHeight()-100);
    //draw entire alphabet
    for (int i=0; i<allAlphabet.size(); i++) {
        allAlphabet[i].drawWhole();
    }
    if(counterDrawAlphabet>FRAME_RATE*alphabetLength){
        allAlphabet[currImgNo1].draw();
        allAlphabet[currImgNo2].draw();
        allAlphabet[currImgNo3].draw();
        allAlphabet[currImgNo4].draw();
        allAlphabet[currImgNo5].draw();
        //blend in
        if(counterDrawAlphabet<FRAME_RATE*(alphabetLength)){
            blendInfo+=8;
            ofSetColor(255, 255, 255, blendInfo);
        }
        //blend out
        else if(currentURL==currentAlphabet && currImgNo2>39 && allAlphabet[currImgNo2]._xPos<-370){
            blendInfo-=8;
            ofSetColor(255, 255, 255, blendInfo);
        } else{
            ofSetColor(255);
        }
        alphabetTitle.draw(ofGetWidth()-alphabetTitle.width, ofGetHeight()-100);

    }

    ofDisableAlphaBlending();

}
void testApp::drawTweet(){
    ofSetColor(0);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
    ofSetColor(255);
    counterTweet++;
    if (tweetCounter==0) {
        ofxTwitterSearch search;
        search.query = "#medialabhelsinki";
        search.count = 1;
        twitterClient.startSearch(search);
        printf("searching\n");
        tweetCounter++;
    }
    // Print tweets:
    int maxLineSize = 140;
    
    if(twitterClient.getTotalLoadedTweets() > 0) {
        
        tweet = twitterClient.getTweetByIndex(actualTweet);
        ofSetColor(0);
        
        if (tweetCounter==1) {
            printf("tweet text %s \n", tweet.text.c_str());
            tweetImages.clear();
            tweet.text=ofToUpper(tweet.text);
            for (int i=0; i<tweet.text.length(); i++) {
                for(int j=0; j<42; j++){
                    //printf("tweet letter %c : %c alphabet\n", tweet.text[i], alphabet[j][0]);
                    if (tweet.text[i]==alphabet[j][0]) {
                        tweetImages.push_back(tweetAlphabet[j]);
                        break;
                    } else if(j==41){
                        tweetImages.push_back(tweetAlphabet[42]);
                    }
                }
            }
            tweetCounter++;
        }
    }
    
    //draw grid
    int width=126;
    int height=154;
    int spacing=14;
    int noOfColumns=18;
    for (int i=0; i<tweetImages.size(); i++) {
        int column=i % noOfColumns;
        int myXPos=25+column*(width+spacing);
        
        int myYPos=10+(i-column)/noOfColumns*(height+spacing*1.9);
        ofEnableAlphaBlending();
        //blend in
        if(counterTweet<FRAME_RATE){
            blendInfo+=8;
            ofSetColor(255, 255, 255, blendInfo);
        }
        //blend out
        else if(counterTweet>FRAME_RATE*(lengthTweet-1)){
            blendInfo-=8;
            ofSetColor(255, 255, 255, blendInfo);
        } else{
            ofSetColor(255);
        }
        tweetImages[i].draw(myXPos, myYPos, width, height);
        ofDisableAlphaBlending();
    }
    if (counterTweet>=lengthTweet*FRAME_RATE) {
        //take snapshot
        bSnapshot = true;
        
        goToNextScreen();
        //reset everything
        counterTweet=0;
        tweetCounter=0;
    }
    if (bSnapshot == true){
		// grab a rectangle at 200,200, width and height of 300,180
		img.grabScreen(0,0,ofGetWidth(),ofGetHeight());
        printf("saving \n");
		string fileName = "snapshot_"+ofToString(ofGetTimestampString())+".png";
		img.saveImage(fileName);
		sprintf(snapString, "saved %s", fileName.c_str());
		snapCounter++;
		bSnapshot = false;
    }
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
