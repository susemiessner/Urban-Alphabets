#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    ofSetFrameRate(FRAME_RATE);
    ofBackground(100, 100, 100);
	ofTrueTypeFont::setGlobalDpi(72);
    
    loading=true;
    ofRegisterURLNotification(this);
    URLsToLoad[0]="Info";
    URLsToLoad[1]="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentPostcards.php";
    URLsToLoad[2]="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentLetters.php";
    URLsToLoad[3]="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentPostcards.php";
    URLsToLoad[4]="http://www.mlab.taik.fi/UrbanAlphabets/requests/requestMadrid.php";
    URLsToLoad[5]="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentPostcards.php";
    currentURLNo=0;

    currentURL=URLsToLoad[currentURLNo];
        loadedURL=" ";
    
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
    
    imagesIntro[0].loadImage("intro/intros-09.png");//logo
    imagesIntro[1].loadImage("intro/intros-05.png");//letters
    imagesIntro[2].loadImage("intro/intros-03.png");//alphabet
    imagesIntro[3].loadImage("intro/intros-04.png");//postcards
    imagesIntro[4].loadImage("intro/intros-11.png");//by me


    counter=0;
    counterAlphabet=0;
    introImageCounter=0;
    
    
    counterDrawInfo=0;
    loadingResponseDone=false;
    drawProjectInfo=false;
    
    
    if (currentURL!="Info") {
        printf("now \n");
        int id = ofLoadURLAsync(currentURL, "async_req");
    } else {
        loadedURL=currentURL;
        loadingResponseDone=true;
        printf("%s", loadedURL.c_str());
    }
}

//--------------------------------------------------------------
void testApp::update(){
    if (ofGetFrameNum()%2==0) {
        if (loading==false) {
            if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentLetters.php") {
                update_MadridrecentLetters();
            } else if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/requestMadrid.php") {
                counterAlphabet++;
                if (counterAlphabet>FRAME_RATE*3) {
                    update_requestMadrid();
                }
            }else if (loadedURL=="Info"){    //projectinfo
                myInfo.update();
                if (myInfo.over) {
                    myInfo.reset();
                    goToNextScreen();
                    sendRequest();
                }
            }
        }
    }
    if (ofGetFrameNum()%3==0 && loading==false) {
        if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentPostcards.php"){
            update_MadridrecentPostcards();
        }
    }
}
//--------------------------------------------------------------
void testApp::sendRequest(){
    if (currentURL!="Info") {
        printf("now\n");
        individualEntries.clear();
        int id = ofLoadURLAsync(currentURL, "async_req");
        loading=true;
        counter++;
        introImageCounter=0;
    }else{
        loading=true;
        loadedURL=currentURL;
        loadingResponseDone=true;
        printf("%s", loadedURL.c_str());
    }
}

//--------------------------------------------------------------
void testApp::draw(){
    ofPushMatrix();
    ofTranslate(40, 40);
    ofSetColor(0);
    ofRect(0, 0, 192, 125+32);
    ofSetColor(255);
    if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentLetters.php" && recentLetters.size()>0 &&currImg1==recentLetters.size()-1 && recentLetters[currImg1]._xPos<-73 && counter==0) {
        sendRequest();
    } else if(loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/requestMadrid.php" && allEntriesAlphabet.size()>0 && currImg1>39 &&allEntriesAlphabet[currImg1]._xPos<-99 && counter==0){
        sendRequest();
    } else if(loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentPostcards.php" && recentPostcards.size()>0 && currImg1==recentPostcards.size()-1 &&recentPostcards[currImg1]._xPos<-120 &&counter==0){
         sendRequest();
    }

    //draw the title of upcoming stuff for 5seconds
    if (loadingResponseDone) {
        counterDrawInfo++;
        drawInfo();
    }
    if (counterDrawInfo>FRAME_RATE*5) {
        loading=false;
        loadingResponseDone=false;
        counterDrawInfo=0;
    }
    //the actual screens
    if(loading==false){
        if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentLetters.php") { //recent letter
            if(recentLetters.size()>0){
                recentLetters[currImg1].draw();
            }
            if(recentLetters.size()>1){
                recentLetters[currImg2].draw();
            }
            if(recentLetters.size()>2){
                recentLetters[currImg3].draw();
            }
            if(recentLetters.size()>3){
                recentLetters[currImg4].draw();
            }
            if(recentLetters.size()>4){
                recentLetters[currImg5].draw();
            }
        } else if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/requestMadrid.php") { //current alphabet
            if (counterAlphabet<FRAME_RATE*5) {
                for (int i=0; i<allEntriesAlphabet.size(); i++) {
                    allEntriesAlphabet[i].drawWhole();
                }
            }else{
                //printf("current imageNo: %i, %i, %i, %i, %i\n", currImg1, currImg2,currImg3,currImg4,currImg5);
                allEntriesAlphabet[currImg1].draw();
                allEntriesAlphabet[currImg2].draw();
                allEntriesAlphabet[currImg3].draw();
                allEntriesAlphabet[currImg4].draw();
                allEntriesAlphabet[currImg5].draw();
            }
        }else if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentPostcards.php") {
            if (recentPostcards.size()>0) {
                recentPostcards[currImg1].draw();
            }
            if (recentPostcards.size()>1) {
                recentPostcards[currImg2].draw();
            }
            if (recentPostcards.size()>2) {
                recentPostcards[currImg3].draw();
            }
            if (recentPostcards.size()>3) {
                recentPostcards[currImg4].draw();
            }
            if (recentPostcards.size()>4) {
                recentPostcards[currImg5].draw();
            }
        } 
        if (loadedURL=="Info"){    //projectinfo
            myInfo.draw();
        }
    }
    //getting the right shape
    testOverlayMediaLabPrado();
    ofPopMatrix();
    ofDrawBitmapString("current: "+loadedURL, 10, 500);
    ofDrawBitmapString("next   : "+currentURL, 10,520);
    ofDrawBitmapString("press < > to go to previous or next URL", 10,540);
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    if (key==OF_KEY_RIGHT) {
        currentURLNo++;
        if(currentURLNo>=LENGTH_OF_URL_ARRAY){ currentURLNo=0;}
        currentURL=URLsToLoad[currentURLNo];
        printf("RIGHT currentURL: %s \n", currentURL.c_str());
    }
    if (key==OF_KEY_LEFT) {
        currentURLNo--;
        if(currentURLNo<0){ currentURLNo=LENGTH_OF_URL_ARRAY-1;}
        currentURL=URLsToLoad[currentURLNo];
        printf("LEFT  currentURL: %s\n", currentURL.c_str());
    }
}
void testApp::drawInfo(){
    //printf("draw info");
    /*ofSetColor(50,50,50);
     ofRect(0, 0, ofGetWidth(), ofGetHeight());*/
    ofSetColor(200, 200, 200);
    if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentLetters.php") { //recent letters
        imagesIntro[1].draw(0, 0);
    } else if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/requestMadrid.php") { //current alphabet
        imagesIntro[2].draw(0, 0);
    }   else if (loadedURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentPostcards.php") { //recent postcards
        imagesIntro[3].draw(0, 0);
    } else if(loadedURL=="Info"){ //info
        introImageCounter++;
        if (introImageCounter>FRAME_RATE*3) {
            imagesIntro[4].draw(0, 0);
        } else{
            imagesIntro[0].draw(0, 0);
        }
    }
    ofSetColor(255);
}
void testApp::testOverlayMediaLabPrado(){
    ofSetColor(255);
    ofRect(0, 0, 36, 32);
    ofRect(36, 0, 36, 16);
    ofRect(36*2+48, 0, 36, 16);
    ofRect(36*3+48, 0, 36, 32);
}


//--------------------------------------------------------------
//http request and ordering
//--------------------------------------------------------------

void testApp::urlResponse(ofHttpResponse & response){
    fullResponse=ofToString(response.data);
    //printf("urlResponse %s \n",fullResponse.c_str());
    ofStringReplace(fullResponse, "[{", "");
    ofStringReplace(fullResponse, "}]", "");
    individualEntries=ofSplitString(fullResponse, "},{");
    if (currentURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentLetters.php") {
        loadURL_MadridrecentLetters(response);
    }else if (currentURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/requestMadrid.php") {
        loadURL_requestMadrid(response);
    } else if (currentURL=="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentPostcards.php"){
        loadURL_MadridrecentPostcards(response);
    }
    loadingResponseDone=true;
}
void testApp::loadURL_MadridrecentLetters(ofHttpResponse &response){
    recentLetters.clear();
    for(int i=0; i<individualEntries.size(); i++){
        vector<string> cutEntries =ofSplitString(individualEntries[i], ",");
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
        recentLetters.push_back(entry);
        //printf("size: %i\n", (int)allEntriesLastLetters.size());
    }
    
    /* for (int i=0; i<recentLetters.size()-1; i++) {
     recentLetters[i].print();
     }*/
    if (response.status==200 && response.request.name=="async_req") {
        for (int i=0; i<recentLetters.size(); i++) {
            recentLetters[i].loadImage();
        }
        currImg1=recentLetters.size()-1;
        currImg2=recentLetters.size()-2;
        currImg3=recentLetters.size()-3;
        currImg4=recentLetters.size()-4;
        currImg5=recentLetters.size()-5;
        goToNextScreen();
    } else{
        printf("not loaded \n");
        
    }
}
void testApp::loadURL_requestMadrid(ofHttpResponse &response){
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
        //ofStringReplace(cutEntries[1], "\"letter\":\"", "");
        //delete the last " in all of them
        ofStringReplace(cutEntries[0], "\"", "");
        ofStringReplace(cutEntries[1], "\"", "");
        //printf("%i ", i);
        string letter=cutEntries[1];
        printf("%s letter:%s\n",cutEntries[0].c_str(), letter.c_str());
        if (i>1) {
            // printf("currentLetter:lastLetter= %s,%s\n", letter.c_str(), allLetters[numberOfLettersAdded-1]._letter.c_str());
            if (allLetters[numberOfLettersAdded-1]._letter!=letter) {
                SingleEntry entry(cutEntries[0], cutEntries[1], numberOfLettersAdded);
                allLetters.push_back(entry);
                numberOfLettersAdded++;
            }
        } else{
            SingleEntry entry(cutEntries[0], cutEntries[1], i);
            allLetters.push_back(entry);
            numberOfLettersAdded++;
        }
        
        //printf("size: %i\n", (int)allEntriesAlphabet.size());
    }
    /*for (int i=0; i<allLetters.size()-1; i++) {
     printf("%i", i);
     allLetters[i].print();
     }*/
    //trying to put it into a proper alphabet
    //go through spanish alphabet
    
    for (int j=0; j<42; j++) {
        //go through all letters we have
        for (int i=0; i<allLetters.size(); i++){
           // printf("letter:alphabet %s:%s\n",allLetters[i]._letter.c_str(), spanishAlphabet[j].c_str() );
            if (allLetters[i]._letter==spanishAlphabet[j]) {
                SingleEntry entry(ofToString(allLetters[i]._id), allLetters[i]._letter, j);
                allEntriesAlphabet.push_back(entry);
                //printf("letter added(right): %s, position: %i\n", spanishAlphabet[j].c_str(), j);
                break;
            } else if (i==allLetters.size()-1){
                SingleEntry entry("0000", spanishAlphabet[j], j);
                allEntriesAlphabet.push_back(entry);
                //printf("letter added (fake): %s, position: %i\n", spanishAlphabet[j].c_str(), j);
                
                break;
            }
        }
    }
    /* for (int i=0; i<allEntriesAlphabet.size()-1; i++) {
     printf("%i", i);
     allEntriesAlphabet[i].print();
     }*/
    if (response.status==200 && response.request.name=="async_req") {
        for (int i=0; i<allEntriesAlphabet.size(); i++) {
            if (allEntriesAlphabet[i]._id!=0) {
                allEntriesAlphabet[i].loadImage();
            }else{
                //load letter from image directory
                allEntriesAlphabet[i].loadImageDirectory();
            }
        }
        currImg1=0;
        currImg2=1;
        currImg3=2;
        currImg4=3;
        currImg5=4;
        goToNextScreen();

    } else{
        printf("not loaded \n");
        
    }
}
void testApp::loadURL_MadridrecentPostcards(ofHttpResponse &response){
    recentPostcards.clear();
    //printf(" number of entries: %i \n",(int) individualEntries.size());
    for(int i=0; i<individualEntries.size(); i++){
        vector<string> cutEntries =ofSplitString(individualEntries[i], ",");
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
        recentPostcards.push_back(entry);
        
    }
    /*for (int i=0; i<recentPostcards.size(); i++) {
     recentPostcards[i].print();
     }*/
    
    if (response.status==200 && response.request.name=="async_req") {
        for (int i=0; i<recentPostcards.size(); i++) {
            recentPostcards[i].loadImage();
        }
        currImg1=recentPostcards.size()-1;
        currImg2=recentPostcards.size()-2;
        currImg3=recentPostcards.size()-3;
        currImg4=recentPostcards.size()-4;
        currImg5=recentPostcards.size()-5;
        goToNextScreen();
    } else{
        printf("not loaded \n");
        
    }
    
}

void testApp::goToNextScreen(){
    counter=0;
    loadedURL=currentURL;
    printf("loaded %s \n", currentURL.c_str());
    currentURLNo++;
    if(currentURLNo>=LENGTH_OF_URL_ARRAY){ currentURLNo=0;}
    currentURL=URLsToLoad[currentURLNo];
    printf("current %s \n", currentURL.c_str());
}
//--------------------------------------------------------------
//updates
//--------------------------------------------------------------
void testApp::update_MadridrecentLetters(){
    if(recentLetters.size()>0){
        recentLetters[currImg1].update();
    }
    if(recentLetters.size()>1){
        recentLetters[currImg2].update();
    }
    if(recentLetters.size()>2){
        recentLetters[currImg3].update();
    }
    if(recentLetters.size()>3){
        recentLetters[currImg4].update();
    }
    if(recentLetters.size()>4){
        recentLetters[currImg5].update();
    }
}
void testApp::update_requestMadrid(){
    if (allEntriesAlphabet[currImg1].nextImage()) {
        currImg1+=5;
        if(currImg1>allEntriesAlphabet.size()-1){
            currImg1=currImg1-allEntriesAlphabet.size();
        }
        printf("current imageNo: %i, %i, %i, %i, %i\n", currImg1, currImg2,currImg3,currImg4,currImg5);

        //printf("currImg1  after = %i\n", currImg1);
    }
    if (allEntriesAlphabet[currImg2].nextImage()) {
        currImg2+=5;
        if(currImg2>allEntriesAlphabet.size()-1){
            currImg2=currImg2-allEntriesAlphabet.size();
        }
        printf("current imageNo: %i, %i, %i, %i, %i\n", currImg1, currImg2,currImg3,currImg4,currImg5);
        // printf("currImg2  after = %i\n", currImg2);
    }
    if (allEntriesAlphabet[currImg3].nextImage()) {
        currImg3+=5;
        if(currImg3>allEntriesAlphabet.size()-1){
            currImg3=currImg3-allEntriesAlphabet.size();
        }
        printf("current imageNo: %i, %i, %i, %i, %i\n", currImg1, currImg2,currImg3,currImg4,currImg5);

        // printf("currImg3  after = %i\n", currImg3);
    }
    if (allEntriesAlphabet[currImg4].nextImage()) {
        currImg4+=5;
        if(currImg4>allEntriesAlphabet.size()-1){
            currImg4=currImg4-allEntriesAlphabet.size();
        }
        printf("current imageNo: %i, %i, %i, %i, %i\n", currImg1, currImg2,currImg3,currImg4,currImg5);

        // printf("currImg4  after = %i\n", currImg4);
    }
    if (allEntriesAlphabet[currImg5].nextImage()) {
        currImg5+=5;
        if(currImg5>allEntriesAlphabet.size()-1){
            currImg5=currImg5-allEntriesAlphabet.size();
        }
        printf("current imageNo: %i, %i, %i, %i, %i\n", currImg1, currImg2,currImg3,currImg4,currImg5);

        // printf("currImg5  after = %i\n", currImg5);
    }
    allEntriesAlphabet[currImg1].update();
    allEntriesAlphabet[currImg2].update();
    allEntriesAlphabet[currImg3].update();
    allEntriesAlphabet[currImg4].update();
    allEntriesAlphabet[currImg5].update();
}
void testApp::update_MadridrecentPostcards(){
    
    int recentPostcardSize=(int)recentPostcards.size();
    
    if (recentPostcardSize>0) {
        recentPostcards[currImg1].update();
    }
    if (recentPostcardSize>1) {
        recentPostcards[currImg2].update();
    }
    if (recentPostcardSize>2) {
        recentPostcards[currImg3].update();
    }
    if (recentPostcardSize>3) {
        recentPostcards[currImg4].update();
    }
    if (recentPostcardSize>4) {
        recentPostcards[currImg5].update();
    }
    //printf("xpositions: %i: %i \n", recentPostcards[currImg1]._xPos, recentPostcards[currImg2]._xPos);
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
