//
//  CropPhoto.h
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "C4CanvasController.h"

@interface CropPhoto : C4CanvasController{
    //common variables
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    UIColor *overlayColor;
    
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *takePhoto;
    
    //bottom Toolbar
    C4Shape *bottomNavBar;
    
    //photo
    C4Image *photoTaken;
    
    //slider
    C4Label *sliderLabel;
    C4Slider *zoomSlider;
    CGFloat *scalefactor;
    
    //for saving that image
    CGSize *areaToSave;
    
    CGContextRef graphicsContext;
    

}
@property (readwrite, strong) C4Window *mainCanvas;
@end
