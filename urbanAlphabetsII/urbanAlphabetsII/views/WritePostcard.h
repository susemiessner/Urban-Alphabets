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
    //>fonts
    C4Font *fatFont;
    C4Font *normalFont;
    //>icons
    C4Image *iconClose;
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
    //other stuff
    //-----------------------
    NSString *entireText;
    NSString *newCharacter;
    NSString *currentLanguage;
    NSMutableArray *postcardArray;
    NSMutableArray *currentAlphabet;
    C4Image *emptyLetter;
    
}
-(void)transferVariables:(int) number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault  fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault backImage:(C4Image*)iconBackDefault iconClose:(C4Image*)iconCloseDefault emptyLetter:(C4Image*)emptyLetterDefault;
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
