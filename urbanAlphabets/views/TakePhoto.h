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
    
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *takePhoto;
    
    //camera
    C4Camera *cam;
    
    //bottom Toolbar
    C4Shape *bottomNavBar;
    C4Image *photoButtonImage;
    
    //the views I want to switch to
    CropPhoto *cropPhoto;
    
    //the captured image
    C4Image *img;    
}
@property (readwrite, strong) C4Window *mainCanvas;

@end
