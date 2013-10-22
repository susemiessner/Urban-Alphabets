//
//  CropPhoto.h
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "C4CanvasController.h"
#import "AssignPhotoLetter.h"

@interface CropPhoto : C4CanvasController{
    //common variables
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    UIColor *overlayColor;
    //top rect
    C4Shape *defaultRect;
    
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *takePhoto;
    
    //bottom Toolbar
    C4Shape *bottomNavBar;
    C4Image *okButtonImage;
    
    //photo
    C4Image *photoTaken;
    
    
    //overlay rectangles
    C4Shape *upperRect;
    C4Shape *lowerRect;
    C4Shape *leftRect;
    C4Shape *rightRect;
    
    //stepper to zoom
    C4Stepper *zoomStepper;
  
    
    //for saving that image
    CGSize *areaToSave;
    CGContextRef graphicsContext;
    
    //the views I want to switch to
    AssignPhotoLetter *assignPhotoLetter;
}
@property (readwrite, strong) C4Window *mainCanvas;
-(void)setup:(C4Image *)image;

@end
