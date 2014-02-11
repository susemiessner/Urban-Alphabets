#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    ofSetFrameRate(FRAME_RATE);
    loading=true;
    ofRegisterURLNotification(this);
    URLsToLoad[0]="http://www.mlab.taik.fi/UrbanAlphabets/requests/MadridrecentLetters.php";
    URLsToLoad[1]="http://www.mlab.taik.fi/UrbanAlphabets/requests/requestMadrid.php";
    currentURLNo=0;
    currentURL=URLsToLoad[currentURLNo];
    int id = ofLoadURLAsync(currentURL, "async_req");
    counter=0;
    secsToNextRequest=60;
}

//--------------------------------------------------------------
void testApp::update(){
    if (ofGetFrameNum()%2) {
        if (loading==false) {
            //printf("%d:%d\n",allEntries[currentNumber].nextImage(),allEntries[currImg2].nextImage() );
            if (allEntries[currImg1].nextImage()) {
                currImg1-=5;
                if(currImg1<4){
                    currImg1=allEntries.size()-1;
                }
                //printf("currImg1  after = %i\n", currImg1);
            }
            if (allEntries[currImg2].nextImage()) {
                currImg2-=5;
                //printf("currImg2= %i\n", currImg2);
                if(currImg2<4){
                    currImg2=allEntries.size()-2;
                }
            }
            if (allEntries[currImg3].nextImage()) {
                currImg3-=5;
                if(currImg3<4){
                    currImg3=allEntries.size()-3;
                }
                //printf("currImg3= %i \n", currImg3);
            }
            if (allEntries[currImg4].nextImage()) {
                currImg4-=5;
                if(currImg4<4){
                    currImg4=allEntries.size()-4;
                }
                //printf("currImg4= %i \n", currImg4);
            }
            if (allEntries[currImg5].nextImage()) {
                currImg5-=5;
                if(currImg5<4){
                    currImg5=allEntries.size()-5;
                }
                //printf("currImg5= %i \n", currImg5);
            }
            allEntries[currImg1].update();
            allEntries[currImg2].update();
            allEntries[currImg3].update();
            allEntries[currImg4].update();
            allEntries[currImg5].update();
        }
        

    }
    int fpmin=FRAME_RATE*secsToNextRequest;
    int frameNum=ofGetFrameNum();
    if (frameNum%fpmin==0  && frameNum>=fpmin) {
        if (counter==0) {
            printf("now\n");
            loading=true;
            int id = ofLoadURLAsync(currentURL, "async_req");
            individualEntries.clear();
            allEntries.clear();
            counter++; //making sure response is only sent 1x
        }
    }
}

//--------------------------------------------------------------
void testApp::draw(){

    if (loading==false) {
        allEntries[currImg1].draw();
        allEntries[currImg2].draw();
        allEntries[currImg3].draw();
        allEntries[currImg4].draw();
        allEntries[currImg5].draw();
        //printf("\n");
    }
    
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    if (key==OF_KEY_UP) {
        secsToNextRequest++;
        printf("current secsToNextRequest: %i\n", secsToNextRequest);
    }
    if (key==OF_KEY_DOWN) {
        secsToNextRequest--;
        printf("current secsToNextRequest: %i\n", secsToNextRequest);
    }
    if (key==OF_KEY_RIGHT) {
        currentURLNo++;
        if(currentURLNo>LENGTH_OF_URL_ARRAY){ currentURLNo=0;}
        currentURL=URLsToLoad[currentURLNo];
        printf("currentURL: %s \n", currentURL.c_str());
    }
    if (key==OF_KEY_LEFT) {
        currentURLNo--;
        if(currentURLNo>=LENGTH_OF_URL_ARRAY){ currentURLNo=LENGTH_OF_URL_ARRAY-1;}
        currentURL=URLsToLoad[currentURLNo];

        printf("currentURL: %s\n", currentURL.c_str());
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

//--------------------------------------------------------------
//http request
//--------------------------------------------------------------

void testApp::urlResponse(ofHttpResponse & response){
    fullResponse=ofToString(response.data);
    //printf("urlResponse %s \n",fullResponse.c_str());
    ofStringReplace(fullResponse, "[{", "");
    ofStringReplace(fullResponse, "}]", "");
    individualEntries=ofSplitString(fullResponse, "},{");
    for(int i=0; i<individualEntries.size(); i++){

        //if MadridrecentLetters.php
        if (currentURL==URLsToLoad[0] ||currentURL==URLsToLoad[1]) {
            vector<string> cutEntries =ofSplitString(individualEntries[i], ",");
            //delete the first parts in all of them
            ofStringReplace(cutEntries[0], "\"ID\":\"", "");
            ofStringReplace(cutEntries[1], "\"path\":\"", "");
            ofStringReplace(cutEntries[2], "\"longitude\":\"", "");
            ofStringReplace(cutEntries[3], "\"latitude\":\"", "");
            ofStringReplace(cutEntries[4], "\"letter\":\"", "");
            //delete the last " in all of them
            ofStringReplace(cutEntries[0], "\"", "");
            ofStringReplace(cutEntries[1], "\"", "");
            ofStringReplace(cutEntries[2], "\"", "");
            ofStringReplace(cutEntries[3], "\"", "");
            ofStringReplace(cutEntries[4], "\"", "");
            //printf("%i ", i);
            SingleEntry entry(cutEntries[0], cutEntries[1], cutEntries[2],cutEntries[3],cutEntries[4], i, (int)individualEntries.size());
            allEntries.push_back(entry);
            // printf("size: %i\n", (int)allEntries.size());
        }
    }
    
    for (int i=0; i<allEntries.size()-1; i++) {
        allEntries[i].print();
    }
    if (response.status==200 && response.request.name=="async_req") {
        //if MadridrecentLetters.php
        if (currentURL==URLsToLoad[0]||currentURL==URLsToLoad[1]) {
            for (int i=0; i<allEntries.size(); i++) {
                allEntries[i].loadImage();
            }
            currImg1=allEntries.size()-1;
            currImg2=allEntries.size()-2;
            currImg3=allEntries.size()-3;
            currImg4=allEntries.size()-4;
            currImg5=allEntries.size()-5;
            loading=false;
            counter=0;
            printf("loaded \n");
        
        }
    } else{
        printf("not loaded \n");

    }
    
}