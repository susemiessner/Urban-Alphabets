#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    //base setup
    ofSetFrameRate(FRAME_RATE);
    ofBackground(100, 100, 100);
	ofTrueTypeFont::setGlobalDpi(72);
    ofRegisterURLNotification(this);
    
    //
    recentPostcards="http://www.ualphabets.com/requests/MadridrecentPostcards.php";
    recentLetters="http://www.ualphabets.com/requests/MadridrecentLetters.php";
    currentAlphabet="http://www.ualphabets.com/requests/requestMadrid.php";
    info="Info";
    
    
    //setup of the URLS that need to be loaded
    URLsToLoad[0]=info;
    URLsToLoad[1]=recentPostcards;
    URLsToLoad[2]=recentLetters;
    URLsToLoad[3]=recentPostcards;
    URLsToLoad[4]=currentAlphabet;
    URLsToLoad[5]=recentPostcards;
    
    currentURLNo=2; //first screen to be shown
    currentURL=URLsToLoad[currentURLNo];
    loading= true; //send the first request on start alphabets/postcards/...
    
    //setup for intro screens before actual
    counterDrawInfo=1;
    loadingResponseDone=false;
    blendInfo=0;
    
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
    
    //images before the actual screens
    imagesIntro[0].loadImage("intro/intros-09.png");//logo
    imagesIntro[1].loadImage("intro/intros-05.png");//letters
    imagesIntro[2].loadImage("intro/intros-03.png");//alphabet
    imagesIntro[3].loadImage("intro/intros-04.png");//postcards
    imagesIntro[4].loadImage("intro/intros-11.png");//by me
    
    //send the first request
    if (currentURL!="Info") {
        printf("now \n");
        int id = ofLoadURLAsync(currentURL, "async_req");
    } else {
        printf("%s", currentURL.c_str());
    }
    
}

//--------------------------------------------------------------
void testApp::update(){
 
}
//--------------------------------------------------------------
void testApp::sendRequest(){
    if (currentURL!="Info") {
        int id = ofLoadURLAsync(currentURL, "async_req");
        loading=true;
    }else{
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
        } else if(counterDrawInfo> FRAME_RATE*4){
            blendInfo-=5;
            ofSetColor(255, 255, 255, blendInfo);
        } else{
            ofSetColor(255, 255, 255, 255);
        }
        drawIntro();
        ofDisableAlphaBlending();
    }
    if (counterDrawInfo>FRAME_RATE*5) {
        loading=false;
        loadingResponseDone=false;
        //reset the counters
        counterDrawInfo=0;
        blendInfo=0;
    }


}
void testApp::drawIntro(){
    //ofSetColor(200, 200, 200);
    if (currentURL==recentLetters) { //recent letters
        imagesIntro[1].draw(0, 0);
    }else if (currentURL==currentAlphabet) { //current alphabet
        imagesIntro[2].draw(0, 0);
    }else if (currentURL==recentPostcards) { //recent postcards
        imagesIntro[3].draw(0, 0);
    }else if(currentURL==info){ //info
        /*introImageCounter++;
        if (introImageCounter>FRAME_RATE*3) {*/
            imagesIntro[4].draw(0, 0);
        /*} else{
            imagesIntro[0].draw(0, 0);
        }*/
    }
    //ofSetColor(255);
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
