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
    //top rect
    C4Shape *defaultRect;
    
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *takePhoto;
    
    //bottom Toolbar
    C4Shape *bottomNavBar;
    
    //photo
    C4Image *photoTaken;
}
@property (readwrite, strong) C4Window *mainCanvas;
-(void)setup:(C4Image *)image;

@end
