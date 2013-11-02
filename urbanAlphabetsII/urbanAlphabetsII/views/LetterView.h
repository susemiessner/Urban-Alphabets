//
//  LetterView.h
//  urbanAlphabetsII
//
//  Created by Suse on 29/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface LetterView : C4CanvasController{
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
    //>fonts
    C4Font *fatFont;
    C4Font *normalFont;
    //>icons
    C4Image *iconClose;
    C4Image *iconAlphabet;
    C4Image *iconArrowForward;
    C4Image *iconArrowBack;
    
    
    NSMutableArray *currentAlphabet;

    //-----------------------
    //TOP BAR
    //-----------------------
    C4Shape *defaultRect;//very top white rect
    C4Shape *topNavBar; //underlying rect
    C4Label *titleLabel;
    
    C4Image *closeButtonImage;
    C4Shape *closeRect;
       

    
    //-----------------------
    //BOTTOM BAR
    //-----------------------
    C4Shape *bottomNavBar;
    C4Image *alphabetButton;
    C4Image *forwardButton;
    C4Image *backwardButton;
    
    //-----------------------
    //OTHER STUFF
    //-----------------------
    //currentLetterToDisplay
    NSInteger currentLetter;
    C4Image *currentImage; //the image currently displayed
}
-(void)transferVariables:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconAlphabet:(C4Image*)iconAlphabetDefault iconArrowForward:(C4Image*)iconArrowForwardDefault iconArrowBack:(C4Image*)iconArrowBackwardDefault currentAlphabet: (NSMutableArray*)transferredAlphabet;
-(void)setup;
-(void)topBarSetup;
-(void)bottomBarSetup;
-(void)displayLetter:(int)letterToDisplay currentAlphabet:(NSMutableArray*)transferredAlphabet;
-(void)removeFromView;

//navigation functions
-(void) goToAlphabetsView;
-(void) goForward;
-(void) goBackward;
@end
