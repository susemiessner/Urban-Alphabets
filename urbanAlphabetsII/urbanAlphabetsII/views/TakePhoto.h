//
//  TakePhoto.h
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface TakePhoto : C4CanvasController

{
    //DEFAULT STUFF that comes from C4Workspace
    //>nav bar heights
    float topBarFromTop;
    float topBarHeight;
    float bottomBarHeight;
    //>colors
    UIColor *navBarColor;
    UIColor *navigationColor;
    UIColor *typeColor;
    //>fonts
    C4Font *fatFont;
    C4Font *normalFont;
    //>icons
    C4Image *iconTakePhoto;
    C4Image *iconClose;
    C4Image *iconBack;
    
    //-----------------------
    //TOP BAR
    //-----------------------
    C4Shape *topNavBar; //underlying rect
    C4Label *titleLabel; //center
    //left
    C4Label *backLabel;
    C4Image *backButtonImage;
    C4Shape *navigateBackRect;
    //right
    C4Image *closeButtonImage;
    C4Shape *closeRect;
    
    //-----------------------
    //BOTTOM BAR
    //-----------------------
    C4Shape *bottomNavBar;
    C4Image *photoButtonImage;
    
    //-----------------------
    //OTHER STUFF
    //-----------------------
    C4Camera *cam;//camera
    //C4Image *img;    //the captured image
    NSInteger counter;     //counter

    
}

@property (readwrite, strong) C4Image *img;//the image captured



-(void)transferVariables:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconTakePhoto:(C4Image*)iconTakePhotoDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault;

-(void)setup;
-(void)topBarSetup;
-(void)bottomBarSetup;
-(void)cameraSetup;
-(void)resetCounter;

-(void)captureImage;

-(void)removeFromView;

//navigation functions
-(void) goToCropPhoto;
-(void) navigateBack;
-(void) goToAlphabetsView;
@end
