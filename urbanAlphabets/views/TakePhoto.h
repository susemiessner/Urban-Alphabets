//
//  TakePhoto.h
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "C4CanvasController.h"
#import "CropPhoto.h"

@interface TakePhoto : C4CanvasController{

    
    //common variables
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    UIColor *navigationColor;
    
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
    
    //camera
    C4Camera *cam;
    
    //bottom Toolbar
    C4Shape *bottomNavBar;
    C4Image *photoButtonImage;
    
    //the captured image
    C4Image *img;
    //counter
    NSInteger counter;
    
    CropPhoto *cropPhoto;
}
@property (readwrite, strong) C4Window *mainCanvas;
-(void) resetCounter;
@end
