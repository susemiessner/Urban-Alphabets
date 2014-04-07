#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    ofBackground(50, 50, 50);
    ofSetFrameRate(30);
    ofTrueTypeFont::setGlobalDpi(72);
    
    loading=true;
    ofRegisterURLNotification(this);
    
    int id = ofLoadURLAsync("http://www.mlab.taik.fi/UrbanAlphabets/requests/requestHelsinki.php", "async_req");
}

//--------------------------------------------------------------
void testApp::update(){
    if (ofGetFrameNum() %1==0) {
        myInfo.update();
    }
}

//--------------------------------------------------------------
void testApp::draw(){
    myInfo.draw();
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){

}

//--------------------------------------------------------------
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
void testApp::urlResponse(ofHttpResponse & response){
    printf("urlResponse %s \n",ofToString( response.data).c_str());
    if(response.status==200 && response.request.name== "async-req"){
        printf("response");
        loading=false;
    } else{
        cout <<response.status << " " << response.error << endl;
        if (response.status!=-1) {
            loading=false;
        }
    }
}