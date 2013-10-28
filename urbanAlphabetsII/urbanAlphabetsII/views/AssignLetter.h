//
//  AssignLetter.h
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface AssignLetter : C4CanvasController{
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
    UIColor *highlightColor;
    //>fonts
    C4Font *fatFont;
    C4Font *normalFont;
    //>icons
    C4Image *iconOk;
    C4Image *iconClose;
    C4Image *iconBack;
    C4Image *iconSettings;
    
    //-----------------------
    //TOP BAR
    //-----------------------
    C4Shape *defaultRect;//very top white rect
    C4Shape *topNavBar; //underlying rect
    C4Label *titleLabel;
    
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
    C4Image *okButtonImage;
    int notificationCounter; //to make sure Ok button is only added 1x
    C4Image *settingsButtonImage;
    
    //-----------------------
    //OTHER STUFF
    //-----------------------
    C4Image *croppedImage;
    CGPoint chosenImage;
    NSMutableArray *greyRectArray;
    C4Image *currentImage;
    
    
}
@property (readwrite, strong)  NSMutableArray *currentAlphabet;//the current alphabet > will be changed so should be accessible from outside for next screen
@property (readwrite) NSUInteger chosenImageNumberInArray;

-(void)transferVariables:(int) number topBarFroTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault highlightColor:(UIColor*)highlightColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault iconOk:(C4Image*)iconOkDefault iconSettings:(C4Image*)iconSettingsDefault;
-(void)setup;
-(void)topBarSetup;
-(void)bottomBarSetup;

-(void)drawCurrentAlphabet: (NSMutableArray*)currentAlphabetPassed;
-(void)highlightLetter:(NSNotification *)notification;
-(void)greyGrid;
-(void)drawCroppedPhoto:(C4Image*)croppedPhoto;

-(void)removeFromView;

//navigation functions
-(void)navigateBack;
-(void)goToAlphabetsView;
-(void)goToAlphabetsViewAddingImageToAlphabet;
-(void)goToSettings;
@end
