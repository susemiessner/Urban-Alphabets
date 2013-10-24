//
//  AssignPhotoLetter.h
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/21/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "C4CanvasController.h"

@interface AssignPhotoLetter : C4CanvasController{
    //common variables
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    UIColor *overlayColor;
    UIColor *navigationColor;
    //top rect
    C4Shape *defaultRect;
    
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *takePhoto;
    C4Font *normalFont;

    //>upper left
    C4Label *backLabel;
    C4Image *backButtonImage;
    C4Shape *navigateBackRect;
    //>upper right
    C4Image *closeButtonImage;
    C4Shape *closeRect;
    
    //bottom Toolbar
    C4Shape *bottomNavBar;
    C4Image *okButtonImage;

    //cropped image> lower left
    C4Image *croppedPhoto;
    
    //array of default letters
    NSArray *defaultLetters;
    
    //shapes to highllight the letter clicked
    NSMutableArray *gridRects;
    
    //makes sure that the "ok" button gets only added ones and not every time the person chooses a new letter
    int *notificationCounter;
    

}
@property (readwrite, strong) C4Window *mainCanvas;
//-(void)setup:(C4Image *)image;

@end
