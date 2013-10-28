//
//  AlphabetView.h
//  urbanAlphabetsII
//
//  Created by Suse on 28/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface AlphabetView : C4CanvasController{
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
    UIColor *darkenColor;
    //>fonts
    C4Font *fatFont;
    C4Font *normalFont;
    //>icons
    C4Image *iconClose;
    C4Image *iconBack;
    C4Image *iconMenu;
    C4Image *iconTakePhoto;
    C4Image *iconAlphabetInfo;
    C4Image *iconShareAlphabet;
    C4Image *iconWritePostcard;
    C4Image *iconMyPostcards;
    C4Image *iconMyAlphabets;
    
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
    
    
    //-----------------------
    //BOTTOM BAR
    //-----------------------
    C4Shape *bottomNavBar;
    C4Image *menuButtonImage;
    C4Image *takePhotoButton;
    
    //-----------------------
    //OTHER STUFF
    //-----------------------
    NSMutableArray *greyRectArray;
    NSMutableArray *currentAlphabet;
    //test
    C4Label *takePhoto;
}
-(void)transferVaribles:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault darkenColor:(UIColor*)darkenColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault iconMenu:(C4Image*)iconMenuDefault iconTakePhoto:(C4Image*)iconTakePhotoDefault iconAlphabetInfo:(C4Image*)iconAlphabetInfoDefault iconShareAlphabet:(C4Image*)iconShareAlphabetDefault iconWritePostcard:(C4Image*)iconWritePostcardDefault iconMyPostcards:(C4Image*)iconMyPostcardsDefault iconMyAlphabets:(C4Image*)iconMyAlphabetsDefault currentAlphabet: (NSMutableArray*)defaultAlphabet;
-(void)setup;
-(void)topBarSetup;
-(void)bottomBarSetup;
-(void)drawCurrentAlphabet:(NSMutableArray*)passedAlphabet;
-(void)greyGrid;

-(void)removeFromView;
//navigation functions
-(void)openMenu;
-(void) goToTakePhoto;
-(void) navigateBack;
-(void)openLetterView;
@end
