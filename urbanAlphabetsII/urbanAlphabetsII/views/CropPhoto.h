//
//  CropPhoto.h
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface CropPhoto : C4CanvasController{
    //-----------------------
    //DEFAULT STUFF that comes from C4Workspace
    //-----------------------
    //>nav bar heights
    float topBarFromTop;
    float topBarHeight;
    float bottomBarHeight;
    //>colors
    UIColor *navBarColor;
    UIColor *navigationColor;
    UIColor *typeColor;
    UIColor *overlayColor;
    //>fonts
    C4Font *fatFont;
    C4Font *normalFont;
    //>icons
    C4Image *iconOk;
    C4Image *iconClose;
    C4Image *iconBack;
    
    //-----------------------
    //TOP BAR
    //-----------------------
    C4Shape *defaultRect; //white rect under top bar
    C4Shape *topNavBar; //underlying shape
    C4Label *titleLabel; //center=title
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
    C4Image *OkButtonImage;
    C4Stepper *zoomStepper;

    //-----------------------
    //OTHER STUFF
    //-----------------------
    C4Image *photoTaken;
    
    //overlay rectangles
    C4Shape *upperRect;
    C4Shape *lowerRect;
    C4Shape *leftRect;
    C4Shape *rightRect;
    
    //saving image
    CGContextRef graphicsContext;

}
@property (readwrite, strong) C4Image *croppedPhoto;//the croppedImage

-(void)transferVariables:(int)number topBarFroTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault overlayColor:(UIColor*)overlayColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault iconOk:(C4Image*)iconOkDefault;
-(void)setup;
-(void)topBarSetup;
-(void)bottomBarSetup;
-(void)stepperValueChanged:(UIStepper*)theStepper;
-(void)displayImage:(C4Image*)image;
-(void)transparentOverlayX1: (NSUInteger)touchX1 Y1:(NSUInteger)touchY1 X2:(NSUInteger) touchX2 Y2:(NSUInteger)touchY2;

//navigation functions
-(void) navigateBack;
-(void) goToAlphabetsView;

//saving image functions
-(C4Image *)cropImage:(C4Image *)originalImage withOrigin:(CGPoint)origin toArea:(CGRect)rect;
-(void)exportHighResImage;
-(CGContextRef)createHighResImageContext;
-(void)saveImage:(NSString *)fileName;
-(void)saveImageToLibrary;
-(NSString *)documentsDirectory;
@end
