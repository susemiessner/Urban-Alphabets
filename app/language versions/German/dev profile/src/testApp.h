#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "button.h"
#include "notification.h"

#define numLetters 42

class testApp : public ofxiOSApp{
	
	public:
        void setup();
        void update();
        void draw();
        void exit();
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
	
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
    //my voids
    //-----TAKE PHOTO
    void TAKEPHOTOsetup();
    void TAKEPHOTOupdate();
    void TAKEPHOTOdraw();
    void TAKEPHOTOgrab();
    
    
    //-----CROP PHOTO
    void CROPPHOTOsetup();
    void CROPPHOTOupdate();
    void CROPPHOTOdraw();
    void CROPPHOTOmaskImageSetBack();
    void CROPPHOTOmaskImageMask();
    void CROPPHOTOtouchdown(int touchID,int touchx, int touchy);
    
    //-----ASSIGN INFO
    void ASSIGNINFOdraw();
    void ASSIGNINFOtouch();

    //-----ASSIGN PHOTO
    void ASSIGNPHOTOsetup();
    void ASSIGNPHOTOdraw();
    void ASSIGNPHOTOtouch(int touchx, int touchy);
    
    //-----ASSIGN RIGHT
    void ASSIGNRIGHTsetup();
    void ASSIGNRIGHTdraw();
    void ASSIGNRIGHTtouched();
    
    //-------VIEW COLLECTION
    void VIEWCOLLECTIONsetup();
    void VIEWCOLLECTIONdraw();

    //-------MENU
    void MENUsetup();
    void MENUdraw();
    void MENUtouch();
    
    //-------LIBRARY
    void LIBRARYsetup();
    void LIBRARYupdate();
    void LIBRARYtouch();

    //-------TYPETEXT
    void TYPETEXTsetup();
    void TYPETEXTdraw();

    //-------URBAN POSTCARD
    void URBANPOSTCARDsetup();
    void URBANPOSTCARDdraw();
    void URBANPOSTCARDtouch();
    
    //-------URBANPOSTCARDMENU
    void URBANPOSTCARDMENUsetup();
    void URBANPOSTCARDMENUdraw();
    void URBANPOSTCARDMENUtouch();
    

		
    
    //my variables
    //global
    string switchBetweenScreens; //will be used to show different parts/screens at different times
    ofTrueTypeFont font;
    
    //-------TAKE PHOTO
    ofVideoGrabber grabber;
    ofImage photo; 
    unsigned char* photoPixels;
    bool photoTaken;
    int counterAfterPhotoTaken; //to forward to next screen after fixed amount of time
    Button takePhotoButton;
    bool photoSavedToLibrary;
    
    //-------CROP PHOTO
        //for touching the screen
    float x0, y0; //first finger
    float x1, y1; //second finger

    float sizeX, sizeY;
    
    ofImage  maskImage;
    unsigned char* maskImagePixels;

    ofImage savedImage;
    unsigned char* savedImagePixels; //------------> not exactly sure if and when I will need this, might be deleted later??
    
    bool photoSaved;
    Button cropButton;

    //-------ASSIGN INFO
    Button assignOkButton;

    //-------ASSIGN PHOTO
    ofImage letterImages[numLetters];
    ofImage selectedLetterImages[numLetters];
    bool isSelected[numLetters];
    float xPos, yPos;
    float imageWidth, imageHeight;
    
    int chosenColumn;
    int chosenRow;
    int chosenimageNum;
    Notification assignNotification;

    //-------ASSIGN RIGHT
    Button yesButton;
    Button noButton;

    //-------VIEW COLLECTION
    Notification viewNotification;
    
    //-------MENU
    Button saveButton;
    Button postcardButton;
    Button addUseCameraButton;
    Button addUseLibraryButton;
    Button closeButton;
    int counter; //it waits a little before it will detect the next touch up
    Notification savedNotification;
    bool saveNotificationVisible;
    
    //-------LIBRARY
    ofxiOSImagePicker camera;
    bool ImageChosen;
    
    //-------TYPETEXT
    ofxiOSKeyboard * keyboard;
    string typedText;
    
    //-------URBANPOSTCARD
    string characters;
    int typedTextLength;
    ofImage urbanPostcardImages[numLetters];
    Notification urbanPostcardNotification;
    ofImage emptyImage;
    
    
    //-------URBANPOSTCARDMENU
    Button savePostcardButton;
    Button backPostcardButton;
    Button backCollectionButton;
    Notification savedPostcardNotification;
    bool savedPostcardNotificationVisible;
    
    
    
};
