//
//  ChangeLanguage.h
//  urbanAlphabetsII
//
//  Created by Suse on 30/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface ChangeLanguage : C4CanvasController{
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
    C4Image *iconClose;
    C4Image *iconChecked;
    C4Image *iconBack;
    C4Image *iconOk;
    
    NSString *currentLanguage;

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
    C4Image *okButton;
    
    //-----------------------
    //CONTENT
    //-----------------------
    NSMutableArray *shapesForBackground;
    NSArray *languages;
    C4Image *checkedIcon;
    int elementNoChosen;

}
@property (readwrite) NSString *chosenLanguage;

-(void)transferVariables:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault highlightColor:(UIColor*)highlightColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault backImage:(C4Image*)iconBackDefault iconClose:(C4Image*)iconCloseDefault iconChecked:(C4Image*)iconCheckedDefault iconOk:(C4Image*)iconOkDefault currentLanguage:(NSString*)currentLanguageDefault;
-(void)setupCurrentLanguage:(NSString*)passedLanguage;
-(void)topBarSetup;
-(void)bottomBarSetup;
-(void)contentSetup;
-(void)languageChanged:(NSNotification *)notification;
-(void)removeFromView;
//navigation functions
-(void)navigateBack;
@end
