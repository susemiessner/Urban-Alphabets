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
    UIColor *whiteColor;
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
    C4Image *iconSaveAlphabet;
    
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
    
    
    //-----------------------
    //MENU
    //-----------------------
    C4Shape *menuBackground;
    //cancel
    C4Shape *cancelShape;
    C4Label *cancelLabel;
    //my alphabets
    C4Shape *myAlphabetsShape;
    C4Label *myAlphabetsLabel;
    C4Image *myAlphabetsIcon;
    //my postcards
    C4Shape *myPostcardsShape;
    C4Label *myPostcardsLabel;
    C4Image *myPostcardsIcon;
    //writePostcard
    C4Shape *writePostcardShape;
    C4Label *writePostcardLabel;
    C4Image *writePostcardIcon;
    //save alphabet
    C4Shape *saveAlphabetShape;
    C4Label *saveAlphabetLabel;
    C4Image *saveAlphabetIcon;
    //share alphabet
    C4Shape *shareAlphabetShape;
    C4Label *shareAlphabetLabel;
    C4Image *shareAlphabetIcon;
    //alphabet info
    C4Shape *alphabetInfoShape;
    C4Label *alphabetInfoLabel;
    C4Image *alphabetInfoIcon;
    
    //saving image
    CGContextRef graphicsContext;
    
}
@property (readwrite, strong) C4Image *currentAlphabetImage;
@property (readwrite) int LetterTouched;
-(void)transferVaribles:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault darkenColor:(UIColor*)darkenColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault iconMenu:(C4Image*)iconMenuDefault iconTakePhoto:(C4Image*)iconTakePhotoDefault iconAlphabetInfo:(C4Image*)iconAlphabetInfoDefault iconShareAlphabet:(C4Image*)iconShareAlphabetDefault iconWritePostcard:(C4Image*)iconWritePostcardDefault iconMyPostcards:(C4Image*)iconMyPostcardsDefault iconMyAlphabets:(C4Image*)iconMyAlphabetsDefault iconSaveImage:(C4Image*)iconSaveAlphabetDefault currentAlphabet: (NSMutableArray*)defaultAlphabet;
-(void)setup;
-(void)topBarSetup;
-(void)bottomBarSetup;
-(void)drawCurrentAlphabet:(NSMutableArray*)passedAlphabet;
-(void)greyGrid;

-(void)removeFromView;
-(void)setupMenu;
-(void)saveAlphabet;

//navigation functions
-(void)openMenu;
-(void)closeMenu;

-(void) goToTakePhoto;
-(void) navigateBack;
-(void)openLetterView;
-(void)goToMyAlphabets;
-(void)goToMyPostcards;
-(void)goToWritePostcard;
-(void)goToSaveAlphabet;
-(void)goToShareAlphabet;
-(void)goToAlphabetInfo;
@end
