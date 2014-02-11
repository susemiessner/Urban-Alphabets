#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    //initially we wanna see the photo taking (for now)
    switchBetweenScreens="take photo";
    //for testing
    //switchBetweenScreens="menu";
    cout << "width "+  ofToString(ofGetWidth())+" height" +ofToString(ofGetHeight()) << std::endl;

   // printf("width %i, height %i", ofGetWidth(), ofGetHeight());

    closeButton.setup();

    
    //default setup stuff
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    ofBackground(0,0,0);
    ofSetFrameRate(30);
    ofEnableAlphaBlending();
    
    //font.loadFont("Papyrus.ttc", 28);
    font.loadFont("Helvetica.dfont", 28);

    ASSIGNPHOTOsetup(); //(reads the initial alphabet) needs to be done here otherwise it reloads every time I load this screen
    keyboard = new ofxiOSKeyboard(0,52,320,32); //setting thekeyboard up initially
    keyboard->setVisible(false);
    
    //load empty image only once
    emptyImage.loadImage("empty.png");
    if (switchBetweenScreens=="take photo") {
        TAKEPHOTOsetup();
    }
    	ofSetColor(255, 255, 255);
}

//--------------------------------------------------------------
void testApp::update(){
	if (switchBetweenScreens=="take photo") {
        TAKEPHOTOupdate();
    }
    if (switchBetweenScreens=="menu") {
        counter++;
    }
    if (switchBetweenScreens=="library") {
        LIBRARYupdate();
    }
	if (switchBetweenScreens=="urban posctard menu") {
        counter++;
    }
    if (switchBetweenScreens!="type text") {
        keyboard->setVisible(false);

    }
	
}

//--------------------------------------------------------------
void testApp::draw(){

    
    //take photo
    if (switchBetweenScreens=="take photo") {
        TAKEPHOTOdraw();
        if (takePhotoButton.isPressed==true) {
            TAKEPHOTOgrab();
        }

    }
    
    //crop photo
    if (switchBetweenScreens=="crop photo")
    {
        CROPPHOTOdraw();
        
    }
    
    //assign info
    if (switchBetweenScreens=="assign info") {
        ASSIGNINFOdraw();
    }
    
    //assign photo
    if (switchBetweenScreens=="assign photo") {
        ASSIGNPHOTOdraw();
    }
    
    //assign right
    if (switchBetweenScreens=="assign right") {
        ASSIGNRIGHTdraw();
    }

    //view collection
    if (switchBetweenScreens=="view collection") {
        VIEWCOLLECTIONdraw();
    }
    
    //menu
    if (switchBetweenScreens=="menu"){
        MENUdraw();
    }
    
    //type text
    if (switchBetweenScreens=="type text") {
        TYPETEXTdraw();
    }
    
    //urban postcard
    if (switchBetweenScreens=="urban postcard") {
        URBANPOSTCARDdraw();
    }
    
    //urban postcard menu
    if (switchBetweenScreens=="urban postcard menu") {
        URBANPOSTCARDMENUdraw();
    }
}

//--------------------------------------------------------------
void testApp::exit(){
    
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
   

    //take photo
    if (switchBetweenScreens=="take photo") {

        //go to next screen is button is pressed
        if (touch.id==0) {
            takePhotoButton.checkTouched(touch.x, touch.y);
            if (takePhotoButton.isPressed==true) {
                photoSavedToLibrary=true;
            }
        }
    }
    
    //crop photo
    if (switchBetweenScreens=="crop photo") {
        
        //whichever finger tabs on button triggers it
        if (touch.id==0 || touch.id==1 || touch.id==2) {
            cropButton.checkTouched(touch.x, touch.y);
            if (cropButton.isPressed==true) {
                savedImage.cropFrom(photo, x0, y0, sizeX, sizeY);
                photoSaved=true;
            }
        }
        
        //first finger
        if (touch.id==0) {
            CROPPHOTOtouchdown(touch.id, touch.x, touch.y);
        }
        //second finger
        if (touch.id==1) {
            CROPPHOTOtouchdown(touch.id, touch.x, touch.y);
        }
       
    }
    
    //assign info
    if (switchBetweenScreens=="assign info"){
        ASSIGNINFOtouch();
    }
    
    //assign photo
    if (switchBetweenScreens=="assign photo") {
        if (touch.id==0) {
            ASSIGNPHOTOtouch(touch.x, touch.y);

        }
    }
    
    //assign right
    if (switchBetweenScreens=="assign right") {
        if (touch.id==0) {
            yesButton.checkTouched(touch.x, touch.y);
            noButton.checkTouched(touch.x, touch.y);
        }
    }
    //menu
    if (switchBetweenScreens=="menu") {
        if (touch.id==0) {
            saveButton.checkTouched(touch.x, touch.y);
            postcardButton.checkTouched(touch.x, touch.y);
            addUseCameraButton.checkTouched(touch.x, touch.y);
            addUseLibraryButton.checkTouched(touch.x, touch.y);
            closeButton.checkTouched(touch.x, touch.y);
        }
    }
    
    //urbanpostcardmenu
    if (switchBetweenScreens=="urban postcard menu") {
        if (touch.id==0) {
            savePostcardButton.checkTouched(touch.x, touch.y);
            backPostcardButton.checkTouched(touch.x, touch.y);
            backCollectionButton.checkTouched(touch.x, touch.y);
        }
    }

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    if (switchBetweenScreens=="crop photo") {
        //first finger
        if (touch.id==0) {
            CROPPHOTOtouchdown(touch.id, touch.x, touch.y);
        }
        //second finger
        if (touch.id==1) {
            CROPPHOTOtouchdown(touch.id, touch.x, touch.y);
        }
    }
    
    //assign photo
    if (switchBetweenScreens=="assign photo") {
        if (touch.id==0) {
            ASSIGNPHOTOtouch(touch.x, touch.y);
        }
    }
    //assign right
    if (switchBetweenScreens=="assign right") {
        if (touch.id==0) {
            yesButton.checkTouched(touch.x, touch.y);
            noButton.checkTouched(touch.x, touch.y);
        }
    }
    
    //menu
    if (switchBetweenScreens=="menu") {
        if (touch.id==0) {
            saveButton.checkTouched(touch.x, touch.y);
            postcardButton.checkTouched(touch.x, touch.y);
            addUseCameraButton.checkTouched(touch.x, touch.y);
            addUseLibraryButton.checkTouched(touch.x, touch.y);
            closeButton.checkTouched(touch.x, touch.y);
            
        }
    }
    //urbanpostcardmenu
    if (switchBetweenScreens=="urban postcard menu") {
        if (touch.id==0) {
            savePostcardButton.checkTouched(touch.x, touch.y);
            backPostcardButton.checkTouched(touch.x, touch.y);
            backCollectionButton.checkTouched(touch.x, touch.y);
        }
    }
    
    
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
        
    //assign right
    if (switchBetweenScreens=="assign right") {
        ASSIGNRIGHTtouched();
    }
    
    //menu
    if (switchBetweenScreens=="menu") {
        //need to make sure it doesn't automatically forward cause first touch up might be detected from prev tab to go to this screen
        if (counter>10) {
            MENUtouch();
        }
       // printf("counter %i \n", counter);
    }
    if (switchBetweenScreens=="urban postcard menu") {
        if (counter>10) {
            URBANPOSTCARDMENUtouch();
        }
    }
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    if (switchBetweenScreens=="assign photo") {
        switchBetweenScreens="assign right";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens assign right \n");
        ASSIGNRIGHTsetup();
        
    }
    
    if (switchBetweenScreens=="view collection") {
        switchBetweenScreens="menu";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens menu \n");
        MENUsetup();

    }
    
    if (switchBetweenScreens=="urban postcard") {
        URBANPOSTCARDtouch();
    }
}
//-------------------------------------------------------------
//-------------- myVoids begin --------------------------------
//-------------------------------------------------------------

//------------------------------------->>>>TAKE PHOTO
void testApp::TAKEPHOTOsetup(){
	grabber.initGrabber(480, 360, OF_PIXELS_BGRA); //maybe only BGR?
    photo.allocate(grabber.width, grabber.height, OF_IMAGE_COLOR);
    photoTaken=false;
    counterAfterPhotoTaken=0;
    takePhotoButton.setup();
    photoSavedToLibrary=false;
}

void testApp::TAKEPHOTOupdate(){
    grabber.update();
}

void testApp::TAKEPHOTOdraw(){
	if (photoTaken==false) {
        grabber.draw(0, 0);
    } else if(photoTaken==true){
        photo.draw(0, 0);
        counterAfterPhotoTaken++;
        if (counterAfterPhotoTaken > 30) {
            //setup what we need to crop the photo
            CROPPHOTOsetup();
            //switch to crop photo
            switchBetweenScreens="crop photo";
            //ofEnableAlphaBlending();
            cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
            //printf("switchedBetweenScreens crop photo \n");

        }
        if (photoSavedToLibrary==true) {
            //take screen capture
            ofxiOSAppDelegate * delegate=ofxiOSGetAppDelegate();
            ofxiOSScreenGrab(delegate);
            photoSavedToLibrary=false;
        }
    }
    int posx=10;
    int sizex=ofGetWidth()-2*posx;
    int sizey=60;
    takePhotoButton.draw(posx, ofGetHeight()-sizey, sizex, sizey, "take photo");
    
}

void testApp::TAKEPHOTOgrab(){
   
    photoPixels=grabber.getPixels();
    photo.setFromPixels(photoPixels, grabber.width, grabber.height, OF_IMAGE_COLOR);
    photoTaken=true;
    
    
}


//------------------------------------->>>>CROP PHOTO
void testApp::CROPPHOTOsetup(){
    sizeX=107;
    sizeY= sizeX*1.28971962616822;
    
    //intitialize a masked rectangle
    x0=50;
    y0=50;
    x1=x0+sizeX;
    y1=y0+sizeY;
    
    //initialize mask image
    maskImage.allocate(ofGetWidth(), ofGetHeight(), OF_IMAGE_COLOR_ALPHA);
    maskImagePixels=maskImage.getPixels();
    //sets all pixels to alpha 150
    CROPPHOTOmaskImageSetBack();
    //sets "active" area to transparent
    CROPPHOTOmaskImageMask();
    maskImage.setFromPixels(maskImagePixels, maskImage.width, maskImage.height, OF_IMAGE_COLOR_ALPHA);
    
    photoSaved=false;
    cropButton.setup();
}
void testApp::CROPPHOTOupdate(){
    
}
void testApp::CROPPHOTOdraw(){
    
    ofSetColor(255,255,255,255);
    if (photoSaved==false) {
        //draw photo
        photo.draw(0,0);
        //darken area outside the selected area
        maskImage.draw(0,0);
        int posx=10;
        int sizex=ofGetWidth()-2*posx;
        int sizey=60;

        cropButton.draw(posx, ofGetHeight()-sizey, sizex, sizey, "crop");
    }
    else {
        //if you wanna see how the saved image looks like
        /*ofSetColor(0, 0, 0);
        ofRect(0, 0, ofGetWidth(), ofGetHeight());
        ofSetColor(255, 255, 255,255);
        savedImage.draw(0, 0);*/
        //ofDisableAlphaBlending();
        switchBetweenScreens="assign info";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens assign info \n");
        assignOkButton.setup();
    }
}
void testApp::CROPPHOTOtouchdown(int touchID,int touchx, int touchy){
    if (touchID==0) {
        x0=touchx;
        y0=touchy;
        
    }
    if (touchID==1) {
        //only update if new touch2y < height of image/screen
        
        sizeX=abs((ofDist(x0, y0, touchx, touchy))/1.5);
        sizeY= sizeX*1.28971962616822;
        x1=x0+sizeX;
        y1=x0+sizeY;
    }
    if (touchID==0 || touchID==1) {
        maskImagePixels=maskImage.getPixels();
        CROPPHOTOmaskImageSetBack();
        CROPPHOTOmaskImageMask();
        maskImage.setFromPixels(maskImagePixels, maskImage.width, maskImage.height, OF_IMAGE_COLOR_ALPHA);
    }    
}

void testApp::CROPPHOTOmaskImageSetBack(){
    for (int i=0; i<maskImage.width*maskImage.height*4; i=i+4) {
        maskImagePixels[i]=0;
        maskImagePixels[i+1]=0;
        maskImagePixels[i+2]=0;
        maskImagePixels[i+3]=150;
    }
}

void testApp::CROPPHOTOmaskImageMask(){
    //setting up maskcolors
    int maskR=0;
    int maskG=0;
    int maskB=0;
    int maskA=0;
    //make sure image doesn't wrap around the line break
    if ((x0+sizeX)*4 < maskImage.width*4){
        //could maybe be deleted ?
        if ((x0+sizeX)*4<maskImage.width*maskImage.height*4) {
            //shouldn't extend number of pixels
            if (((y0+sizeY)*4)*maskImage.width+(x0+sizeX)*4 +3 < maskImage.width*maskImage.height*4) {
                //every row
                for (int j=y0*4; j<(y0+sizeY)*4; j=j+4) {
                    //every column but *4 cause it has 4 channels: R G B Alpha
                    for (int i=x0*4; i<(x0+sizeX)*4; i=i+4) {
                        // (maskImage.width*4) get's us to next row
                        // *j so we get to right row number
                        //+i for right channel
                        maskImagePixels[((j*maskImage.width+i))]=maskR;
                        maskImagePixels[((j*maskImage.width+i))+1]=maskG;
                        maskImagePixels[((j*maskImage.width+i))+2]=maskB;
                        maskImagePixels[((j*maskImage.width+i))+3]=maskA;
                    }
                    
                }
            }
            
        }
        
    }
  
}

//------------------------------------->>>>ASSIGN INFO

void testApp::ASSIGNINFOdraw(){
    ofSetColor(0, 0, 0);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
    int sizex=savedImage.width;
    int sizey=savedImage.height;
    if (sizex>200) {
        sizex=200;
        sizey=sizex*1.28971962616822;
    }
    
    ofDrawBitmapString(ofToString(sizex)+","+ofToString(sizey), 10, 10);
    
    //drawing string
    string msg;
    msg="assign";
    //calculating size
    ofRectangle boundingMsg=font.getStringBoundingBox(msg, 0, 0);
    int msgPosX=(ofGetWidth()-boundingMsg.width)/2;
    ofSetColor(200, 200, 200);
    font.drawString(msg, msgPosX, 40);
    
    //centering image
    int posX=ofGetWidth()/2-sizex/2;
    int posY=60;
    savedImage.draw(posX, posY, sizex, sizey);
    
    //drawing second string
    msg="to right letter";
    boundingMsg=font.getStringBoundingBox(msg, 0, 0);
    msgPosX=(ofGetWidth()-boundingMsg.width)/2;
    ofSetColor(200, 200, 200);
    font.drawString(msg, msgPosX, posY+sizey+50);
    
    //draw button
    int posx=10;
    sizex=ofGetWidth()-2*posx;
    sizey=60;
    assignOkButton.draw(posx, ofGetHeight()-sizey, sizex, sizey, "I understand");
}
void testApp::ASSIGNINFOtouch(){
    //ASSIGNPHOTOsetup();
    switchBetweenScreens="assign photo";
    cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
    //printf("switchedBetweenScreens assign photo\n");
    assignNotification.setup();
}

//------------------------------------->>>>ASSIGN PHOTO
void testApp::ASSIGNPHOTOsetup(){
    //image/tile dimensions
    imageWidth=ofGetWidth()/6;
    imageHeight=ofGetHeight()/7;
    
    //initialize images > load them all in setup
    for (int i=0;i<numLetters;i++){
        letterImages[i].loadImage("01/01-"+ofToString(i+1)+".png");
        selectedLetterImages[i].loadImage("01-background/01-"+ofToString(i+1)+".png");
        isSelected[i]=false;
        ofLog(OF_LOG_NOTICE, "set up image " + ofToString(i));
    }
    //assignNotification.setup();

}
void testApp::ASSIGNPHOTOdraw(){
    for(int i=0; i<numLetters; i++){
        int xMultiplier=(i)%6;
        string yMultiplierString=ofToString((i)/6,0);
        int yMultiplier=ofToInt(yMultiplierString);
        xPos=xMultiplier*imageWidth;
        yPos=yMultiplier*imageHeight;
        if (isSelected[i]==false) {
            letterImages[i].draw( xPos, yPos, imageWidth, imageHeight);
        } else{
            selectedLetterImages[i].draw( xPos, yPos, imageWidth, imageHeight);
        }
        //ofLog(OF_LOG_NOTICE, "drawing sucessful ");
        
    }
    
    //show notification in beginning
    assignNotification.draw("doubletab to \nchose letter");
}
void testApp::ASSIGNPHOTOtouch(int touchx, int touchy){
    
        chosenColumn=ofToInt(ofToString(touchx/imageWidth));
        chosenRow=ofToInt(ofToString(touchy/imageHeight));
        chosenimageNum=chosenRow*6+chosenColumn;
        //set all to false
        for (int i=0;i<numLetters;i++){
            isSelected[i]=false;
        }
        //only the one you touch should be selected
        isSelected[chosenimageNum]=true;
}

//------------------------------------->>>>ASSIGN RIGHT
void testApp::ASSIGNRIGHTsetup(){
    yesButton.setup();
    noButton.setup();
}

void testApp::ASSIGNRIGHTdraw(){
    ofSetColor(0, 0, 0);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
       // ofDrawBitmapString(ofToString(sizex)+","+ofToString(sizey), 10, 10);
    
    //drawing string
    string msg;
    msg="is";
    //calculating size
    ofRectangle boundingMsg=font.getStringBoundingBox(msg, 0, 0);
    int msgPosX=(ofGetWidth()-boundingMsg.width)/2;
    ofSetColor(200, 200, 200);
    font.drawString(msg, msgPosX, 30);
    
    //saved image
    int sizex=savedImage.width;
    int sizey=savedImage.height;
    if (sizex>160) {
        sizex=100;
        sizey=sizex*1.28971962616822;
    }
    int posX=10;
    int posY=70;
    savedImage.draw(posX, posY, sizex, sizey);
    
    //chosen image
    
    posX=ofGetWidth()-10-sizex;
    posY=70;
    letterImages[chosenimageNum].draw(posX, posY, sizex, sizey);
    
    //drawing second string "?"
    msg="?";
    boundingMsg=font.getStringBoundingBox(msg, 0, 0);
    msgPosX=(ofGetWidth()-boundingMsg.width)/2;
    ofSetColor(200, 200, 200);
    font.drawString(msg, msgPosX, posY+sizey+50);

    //drawing the buttons
    int buttonSizeX=100;
    int buttonSizeY=60;
    yesButton.draw(10, ofGetHeight()-buttonSizeY, buttonSizeX,buttonSizeY,"yes");
    noButton.draw(ofGetWidth()-buttonSizeX-10, ofGetHeight()-buttonSizeY, buttonSizeX, buttonSizeY, "no");
}
void testApp::ASSIGNRIGHTtouched(){

    if (yesButton.isPressed==true) {
        //setup view collection
        VIEWCOLLECTIONsetup();
        //switch to view collection
        switchBetweenScreens="view collection";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens view collection \n");
    }
    if (noButton.isPressed==true) {
        switchBetweenScreens="assign info";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens assign info \n");
    }

    yesButton.isPressed=false;
    noButton.isPressed=false;

}
//------------------------------------->>>>VIEW COLLECTION
void testApp::VIEWCOLLECTIONsetup(){
    letterImages[chosenimageNum]=savedImage;
    viewNotification.setup();
}
void testApp::VIEWCOLLECTIONdraw(){
    for(int i=0; i<numLetters; i++){
        int xMultiplier=(i)%6;
        string yMultiplierString=ofToString((i)/6,0);
        int yMultiplier=ofToInt(yMultiplierString);
        xPos=xMultiplier*imageWidth;
        yPos=yMultiplier*imageHeight;
        letterImages[i].draw( xPos, yPos, imageWidth, imageHeight);
    }
    
    //show notification on top
    viewNotification.draw("doubletab to\n view menu");
}
//------------------------------------->>>>MENU
void testApp::MENUsetup(){
    saveButton.setup();
    postcardButton.setup();
    addUseCameraButton.setup();
    addUseLibraryButton.setup();
    closeButton.setup();
    counter=0;
    savedNotification.setup();
    saveNotificationVisible=false;
}
void testApp::MENUdraw(){
    
    int spacing=10;
    
    int xpos=10;
    int ypos=spacing;
    
    int sizex=ofGetWidth()-2*xpos;
    int sizey=55;
    
    saveButton.draw(xpos, ypos, sizex, sizey, "save to photo library");
    postcardButton.draw(xpos, 2*spacing+sizey, sizex, sizey*1.5, "use for urban \n postcard");
    addUseCameraButton.draw(xpos, 3*spacing+sizey*2.5, sizex, sizey*1.5, "add new photo \n using camera");
    addUseLibraryButton.draw(xpos, 4*spacing+sizey*4, sizex, sizey*1.5, "add new photo \n from library");
    closeButton.draw(xpos, 5*spacing+sizey*5.5, sizex, sizey, "back to collection");
    if (saveNotificationVisible==true) {
        savedNotification.draw("collection was saved");
    }
    if (savedNotification.counter>=savedNotification.duration-1) {
        saveNotificationVisible=false;
    }
    

}

void testApp::MENUtouch(){
    if(saveButton.isPressed==true){
        for(int i=0; i<numLetters; i++){
            int xMultiplier=(i)%6;
            string yMultiplierString=ofToString((i)/6,0);
            int yMultiplier=ofToInt(yMultiplierString);
            xPos=xMultiplier*imageWidth;
            yPos=yMultiplier*imageHeight;
            letterImages[i].draw( xPos, yPos, imageWidth, imageHeight);
        }
        //take screen capture
        ofxiOSAppDelegate * delegate=ofxiOSGetAppDelegate();
        ofxiOSScreenGrab(delegate);
        cout << "switchedBetweenScreens screencapture taken" << std::endl;
        //printf("screencapture taken \n");
        saveNotificationVisible=true;
        saveButton.isPressed=false;
    }
    if(postcardButton.isPressed==true){
        //printf("postcardButton");
        switchBetweenScreens="type text";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
       // printf("switchedBetweenScreens type text \n");
        postcardButton.isPressed=false;
        TYPETEXTsetup();
    }
    if(addUseCameraButton.isPressed==true){
        printf("addUseCameraButton");
        
        //initialize take photo again
        TAKEPHOTOsetup();
        //go to take photo
        switchBetweenScreens="take photo";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens take photo \n");
        addUseCameraButton.isPressed=false;
    }
    if(addUseLibraryButton.isPressed==true){
        switchBetweenScreens="library";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens library \n");
        //printf("addUseLibraryButton");
        addUseLibraryButton.isPressed=false;
        LIBRARYsetup();
    }
    if (closeButton.isPressed==true) {
        switchBetweenScreens="view collection";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens view collection \n");
        viewNotification.setup();
    }


    
}

//------------------------------------->>>>LIBRARY
void testApp::LIBRARYsetup(){
    ImageChosen=false;
   // printf("image chosen %b", ImageChosen);
    if (ImageChosen==false) {
        camera.openLibrary();
        //photo.setFromPixels(camera.pixels, camera.width, camera.height, OF_IMAGE_COLOR_ALPHA);
        //ImageChosen=true;
    }
}
void testApp::LIBRARYupdate(){
    if(camera.imageUpdated){
        photo.setFromPixels(camera.pixels, camera.width, camera.height, OF_IMAGE_COLOR_ALPHA);
        photo.resize(ofGetWidth(),ofGetHeight());
        camera.imageUpdated = false;
        camera.close();
        //switch to crop photo
        switchBetweenScreens="crop photo";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens crop photo \n");
      //setup cropphoto
        CROPPHOTOsetup();
        //ofEnableAlphaBlending();
    }
}
void testApp::LIBRARYtouch(){
    if (ImageChosen==false) {
        ImageChosen=true;
    }
}

//------------------------------------->>>>LIBRARY
void testApp::TYPETEXTsetup(){
   // keyboard = new ofxiOSKeyboard(0,52,320,32);
	keyboard->setVisible(true);
	keyboard->setBgColor(0, 0, 0, 255);
	keyboard->setFontColor(255,255,255, 255);
	keyboard->setFontSize(26);
    keyboard->setMaxChars(42);
    keyboard->openKeyboard();
    keyboard->setText("");
    cout << "label text "+ofToString(keyboard->getLabelText()) << std::endl;

   // typedText="";
    
    
}

void testApp::TYPETEXTdraw(){
    
    ofSetColor(0,0,0,255);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
    //get typed string
    //ofSetColor(100, 0, 0,255);
    
    typedText=keyboard->getLabelText();
    //ofDrawBitmapString("text entered = "+  keyboard->getText() , 2, 70);
    
    cout << typedText << std::endl;

    if (keyboard->isKeyboardShowing()==false) {
        //switch to urbanpostcard
        cout << "typed text :"+typedText << std::endl;
        switchBetweenScreens="urban postcard";
        cout << "switchedBetweenScreens urban postcard" << std::endl;
       // printf("switchedBetweenScreens urban postcard");
        //keyboard->closeKeyboard();
        keyboard->setFontColor(255, 255, 255, 0);
        keyboard->setBgColor(255, 255, 255, 0);
        URBANPOSTCARDsetup();
    }
    ofSetColor(255, 255, 255,255);
}

//------------------------------------->>>>URBANPOSTCARD
void testApp::URBANPOSTCARDsetup(){
    
    vector<string> characterVector;
    characterVector.clear();
    //typedTextLength=0;
    typedTextLength=typedText.length();
    for (int i=0; i<typedTextLength; i++) {
        //if it's not "\320" or "\321" (which both just act weird...)
        if (ofToString(typedText.at(i))=="\320" || ofToString(typedText.at(i))=="\321") {
            //erase this and update the length of the text, then go to the same position again so we don't jump over one letter
            typedText.erase(i,1);
            typedTextLength--;
            i--;
        }
    }
    cout << "typed text length :"+ ofToString(typedTextLength) << std::endl;

    for (int i=0; i<typedTextLength; i++) {
        string characterInput=ofToString(typedText.at(i));
        cout << "character "+ofToString(characterInput) << std::endl;
 
        //if (ofToString(characterInput) !="\320" && ofToString(characterInput)!="\321" /*&& ofToString(characterInput)!="\201"*/) {
            //if it's not "\320" or "\321" (which both just act weird...)
            if (ofToString(characterInput) !="\303" /*&& ofToString(characterInput)!="\321" */ /*&& ofToString(characterInput)!="\201"*/) {
                //if it's not "\320" or "\321" (which both just act weird...)
                if (ofToString(characterInput)=="\244") {
                    characterInput="ä";
                } else if (ofToString(characterInput)=="\204") {
                    characterInput="Ä";
                }
                else if (ofToString(characterInput)=="\266") {
                    characterInput="ö";
                }else if (ofToString(characterInput)=="\226") {
                    characterInput="Ö";
                }
                else if (ofToString(characterInput)=="\274") {
                    characterInput="ü";
                }else if (ofToString(characterInput)=="\234") {
                    characterInput="Ü";
                }
                
                else if (ofToString(characterInput)=="\237") {
                    characterInput="ß";
                }



            
            cout << "character inVector "+ofToString(characterInput) << std::endl;

            characterVector.push_back(characterInput);
        } 
    }
    
    
    /*for(int i=0; i<numLetters;i++){
        urbanPostcardImages[i]=letterImages[i];
    }*/
    
    for(int i=0; i<characterVector.size();i++){
        characters=ofToString(characterVector[i]);
        cout << "character passed "+ofToString(characters) << std::endl;

        //ofStringReplace(characters, "\244", "ä");
        //ofStringReplace(characters, "\266", "ö");
        //ofStringReplace(characters, "\245", "å");
        //ofLog(OF_LOG_NOTICE, "character "+ characters);
        
        if (characters=="a" ||characters=="А" ) {
            urbanPostcardImages[i]=letterImages[0];
        } else
        if (characters=="b" ||characters=="B" ) {
            urbanPostcardImages[i]=letterImages[1];
        } else
        if (characters=="c" ||characters=="C" ) {
            urbanPostcardImages[i]=letterImages[2];
        } else
        if (characters=="d" ||characters=="D" ) {
            urbanPostcardImages[i]=letterImages[3];
        } else
        if (characters=="e" ||characters=="E" ) {
            urbanPostcardImages[i]=letterImages[4];
        } else
        if (characters=="f" ||characters=="F" ) {
            urbanPostcardImages[i]=letterImages[5];
        } else
        /*if (characters=="ё" ||characters=="Ё" ) {
            urbanPostcardImages[i]=letterImages[6];
        } else*/
        if (characters=="g" ||characters=="G" ) {
            urbanPostcardImages[i]=letterImages[6];
        } else
        if (characters=="h" ||characters=="H" ) {
            urbanPostcardImages[i]=letterImages[7];
        } else
        if (characters=="i" ||characters=="I" ) {
            urbanPostcardImages[i]=letterImages[8];
        } else
        if (characters=="j" ||characters=="J" ) {
            urbanPostcardImages[i]=letterImages[9];
        } else
        if (characters=="k" ||characters=="K" ) {
            urbanPostcardImages[i]=letterImages[10];
        } else
        if (characters=="l" ||characters=="L" ) {
            urbanPostcardImages[i]=letterImages[11];
        } else
        if (characters=="m" ||characters=="M" ) {
            urbanPostcardImages[i]=letterImages[12];
        } else
        if (characters=="n" ||characters=="N" ) {
            urbanPostcardImages[i]=letterImages[13];
        } else
        if (characters=="o" ||characters=="O" ) {
            urbanPostcardImages[i]=letterImages[14];
        } else
        if (characters=="p" ||characters=="P" ) {
            urbanPostcardImages[i]=letterImages[15];
        } else
        if (characters=="q" ||characters=="Q" ) {
            urbanPostcardImages[i]=letterImages[16];
        } else
        if (characters=="r" ||characters=="R" ) {
            urbanPostcardImages[i]=letterImages[17];
        } else
        if (characters=="s" ||characters=="S" ) {
            urbanPostcardImages[i]=letterImages[18];
        } else
        if (characters=="t" ||characters=="T" ) {
            urbanPostcardImages[i]=letterImages[19];
        } else
        if (characters=="u" ||characters=="U" ) {
            urbanPostcardImages[i]=letterImages[20];
        } else
        if (characters=="v" ||characters=="V" ) {
            urbanPostcardImages[i]=letterImages[21];
        } else
        if (characters=="w" ||characters=="W" ) {
            urbanPostcardImages[i]=letterImages[22];
        } else
        if (characters=="x" ||characters=="X" ) {
            urbanPostcardImages[i]=letterImages[23];
        } else
        if (characters=="y" ||characters=="Y" ) {
            urbanPostcardImages[i]=letterImages[24];
        }else
        if (characters=="z" ||characters=="Z" ) {
            urbanPostcardImages[i]=letterImages[25];
        } else
        if (characters=="ä" ||characters=="Ä" ) {
            urbanPostcardImages[i]=letterImages[26];
        } else
        if (characters=="ö" ||characters=="Ö" ) {
            urbanPostcardImages[i]=letterImages[27];
        } else
        if (characters=="ü" ||characters=="Ü" ) {
            urbanPostcardImages[i]=letterImages[28];
        } else
        if (characters=="ß" ) {
            urbanPostcardImages[i]=letterImages[29];
        } else
        if (characters=="." ) {
            urbanPostcardImages[i]=letterImages[30];
        } else
        if (characters=="!" ) {
            urbanPostcardImages[i]=letterImages[31];
        }else
        if (characters=="0" ) {
            urbanPostcardImages[i]=letterImages[32];
        }else
        if (characters=="1" ) {
            urbanPostcardImages[i]=letterImages[33];
        } else
        if (characters=="2" ) {
            urbanPostcardImages[i]=letterImages[34];
        } else
        if (characters=="3" ) {
            urbanPostcardImages[i]=letterImages[35];
        } else
        if (characters=="4" ) {
            urbanPostcardImages[i]=letterImages[36];
        } else
        if (characters=="5" ) {
            urbanPostcardImages[i]=letterImages[37];
        } else
        if (characters=="6" ) {
            urbanPostcardImages[i]=letterImages[38];
        } else
        if (characters=="7" ) {
            urbanPostcardImages[i]=letterImages[39];
        } else
        if (characters=="8" ) {
            urbanPostcardImages[i]=letterImages[40];
        } else
        if (characters=="9" ) {
            urbanPostcardImages[i]=letterImages[41];
        } else 
        if (characters==" " ) {
            urbanPostcardImages[i]=emptyImage;
        }
    }
    //characterVector.clear();

    
   urbanPostcardNotification.setup();
}
void testApp::URBANPOSTCARDdraw(){
    
    ofSetColor(0, 0, 0,255);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
    ofSetColor(255, 255, 255,255);
    //urbanPostcardImages[0].draw(100, 0,100,100);

    for(int i=0; i<typedTextLength; i++){
        int xMultiplier=(i)%6;
        string yMultiplierString=ofToString((i)/6,0);
        int yMultiplier=ofToInt(yMultiplierString);
        xPos=xMultiplier*imageWidth;
        yPos=yMultiplier*imageHeight;
        urbanPostcardImages[i].draw( xPos, yPos, imageWidth, imageHeight);
    }
    //viewNotification.draw("doubletab to\n view menu");
    urbanPostcardNotification.draw("doubletab to\nview menu");
    
}
void testApp::URBANPOSTCARDtouch(){
  
    
    //switch to menu
    switchBetweenScreens="urban postcard menu";
    cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;

   // printf("switchedBetweenScreens urban postcard menu \n");

    //initialize urban postcard menu
    URBANPOSTCARDMENUsetup();
}
//------------------------------------->>>>URBANPOSTCARDMENU
void testApp::URBANPOSTCARDMENUsetup(){
    //buttons
    savePostcardButton.setup();
    backPostcardButton.setup();
    backCollectionButton.setup();
    savePostcardButton.setup();
    //notifications
    /*savedNotification.setup();
    saveNotificationVisible=false;*/
    savedPostcardNotification.setup();
    savedPostcardNotificationVisible=false;
    counter=0;
}

void testApp::URBANPOSTCARDMENUdraw(){
    ofSetColor(0, 0, 0,255);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
    ofSetColor(255, 255, 255,255);
    
    
    int spacing=10;
    
    int xpos=10;
    int ypos=spacing;
    
    int sizex=ofGetWidth()-2*xpos;
    int sizey=55;

    savePostcardButton.draw(xpos,ypos,sizex,sizey*1.5,"save urban postcard \nto library");
    backPostcardButton.draw(xpos, 2*spacing+sizey*1.5, sizex, sizey*1.5, "back to urban \npostcard");
    backCollectionButton.draw(xpos, 3*spacing+sizey*3, sizex, sizey, "back to collection");
    counter++;
    //show notification after saved
    if (savedPostcardNotificationVisible==true) {
        savedPostcardNotification.draw("urban postcard \nwas saved");
    }
    if (savedPostcardNotification.counter>=savedPostcardNotification.duration-1) {
        savedPostcardNotificationVisible=false;
        savedPostcardNotification.counter=0;
    }

}

void testApp::URBANPOSTCARDMENUtouch(){
    if(savePostcardButton.isPressed==true){
        //redraw the urban postcard
        ofSetColor(0, 0, 0,255);
        ofRect(0, 0, ofGetWidth(), ofGetHeight());
        ofSetColor(255, 255, 255,255);
        
        for(int i=0; i<typedTextLength; i++){
            int xMultiplier=(i)%6;
            string yMultiplierString=ofToString((i)/6,0);
            int yMultiplier=ofToInt(yMultiplierString);
            xPos=xMultiplier*imageWidth;
            yPos=yMultiplier*imageHeight;
            urbanPostcardImages[i].draw( xPos, yPos, imageWidth, imageHeight);
            //savedPostcardNotification.draw("saved postcard");

        }
        //take screen capture
        ofxiOSAppDelegate * delegate=ofxiOSGetAppDelegate();
        ofxiOSScreenGrab(delegate);
        
        printf("urbanpostcard taken \n");

        //show message > but for some reason doesn't work
        savedPostcardNotificationVisible=true;

        savePostcardButton.isPressed=false;
    }
    
    
    if (backPostcardButton.isPressed==true) {
        switchBetweenScreens="urban postcard";
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
        //printf("switchedBetweenScreens urban postcard \n");
        urbanPostcardNotification.setup();
    }


    if (backCollectionButton.isPressed==true) {
        switchBetweenScreens="view collection";
        //vector should be deleted here
       // characterVector.clear();
        cout << "switchedBetweenScreens " + switchBetweenScreens << std::endl;
       // printf("switchedBetweenScreens view collection \n");
        viewNotification.setup();
    }
}


//-------------------------------------------------------------
//-------------- myVoids end ----------------------------------
//-------------------------------------------------------------



//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    
}

