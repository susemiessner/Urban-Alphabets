//
//  WritePostcard.h
//  urbanAlphabetsII
//
//  Created by Suse on 31/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"
#import <UIKit/UIKit.h>
@interface WritePostcard : C4CanvasController<UITextViewDelegate>{
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
    UIColor *buttonColor;
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
    C4Image *iconSharePostcard;
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
    
    //right
    C4Image *closeButtonImage;
    C4Shape *closeRect;
    
    //-----------------------
    //BOTTOM BAR
    //-----------------------
    C4Shape *bottomNavBar;
    C4Image *menuButtonImage;
    C4Image *takePhotoButton;

    
    //-----------------------
    //BAR ON TOP OF KEYBOARD
    //-----------------------
    C4Shape *keyboardBarBackground;
    C4Shape *DoneButton;
    C4Label *doneLabel;
    C4Label *countingLabel;
    
    //whenever clicked outside the keyboard, resign it as first responder
    C4Shape *openKeyboardShape;
    
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
    //save postcard
    C4Shape *savePostcardShape;
    C4Label *savePostcardLabel;
    C4Image *savePostcardIcon;
    //share postcard
    C4Shape *sharePostcardShape;
    C4Label *sharePostcardLabel;
    C4Image *sharePostcardIcon;
    //postcard info
    C4Shape *postcardInfoShape;
    C4Label *postcardInfoLabel;
    C4Image *postcardInfoIcon;

    
    
    //-----------------------
    //other stuff
    //-----------------------
    UITextView *textViewTest;
    NSString *entireText;
    NSString *newCharacter;
    NSString *currentLanguage;
    NSMutableArray *postcardArray;
    NSMutableArray *currentAlphabet;
    NSMutableArray *greyRectArray;

    C4Image *emptyLetter;
    
    int maxPostcardLength;
    
    //saving image
    CGContextRef graphicsContext;
    
    C4Shape *background; //white background for saving the image to library

    
}
@property (readwrite, strong) C4Image *currentPostcardImage;

-(void)transferVariables:(int) number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault darkenColor:(UIColor*)darkenColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault backImage:(C4Image*)iconBackDefault iconClose:(C4Image*)iconCloseDefault emptyLetter:(C4Image*)emptyLetterDefault iconMenu:(C4Image*)iconMenuDefault takePhoto:(C4Image*)iconTakePhotoDefault iconAlphabetInfo:(C4Image*)iconAlphabetInfoDefault iconShareAlphabet:(C4Image*)iconShareAlphabetDefault iconWritePostcard:(C4Image*)iconWritePostcardDefault iconMyPostcards:(C4Image*)iconMyPostcardsDefault iconMyAlphabets:(C4Image*)iconMyAlphabetsDefault iconSaveImage:(C4Image*)iconSaveAlphabetDefault;
-(void)setup:(NSMutableArray*)passedAlphabet currentLanguage:(NSString*)passedLanguage;
-(void)topBarSetup;
-(void)setupTextField;
//to display the postcard
-(void)displayPostcard;
-(void)addLetterToPostcard;

//stuff to handle keyboard input
- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView;
@end
