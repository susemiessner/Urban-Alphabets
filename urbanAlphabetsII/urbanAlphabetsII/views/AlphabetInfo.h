//
//  AlphabetInfo.h
//  urbanAlphabetsII
//
//  Created by Suse on 29/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface AlphabetInfo : C4CanvasController{
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
    UIColor *greyType;
    //>fonts
    C4Font *fatFont;
    C4Font *normalFont;
    //>icons
    C4Image *iconClose;
    C4Image *iconAlphabet;
    C4Image *iconBack;
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
    C4Image *photoButtonImage;
    
    //-----------------------
    //OTHER STUFF
    //-----------------------
    //labels for the actual info
    C4Label *nameLabel;
    C4Label *alphabetName;
    C4Label *languageLabel;
    C4Label *language;
    C4Label *changeLanguage;
}
-(void)transferVariables:(int) number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault greyType:(UIColor*)greyTypeDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault backImage:(C4Image*)iconBackDefault closeIcon:(C4Image*)iconCloseDefault alphabetIcon:(C4Image*)iconAlphabetDefault;
-(void)setup;
-(void)topBarSetup;
-(void)bottomBarSetup;
-(void)addInfo;
//navigation functions
-(void)navigateBack;
-(void) goToAlphabetsView;
@end
