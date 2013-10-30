//
//  C4WorkSpace.h
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//

#import "C4CanvasController.h"
#import "TakePhoto.h"
#import "CropPhoto.h"
#import "AssignLetter.h"
#import "AlphabetView.h"
#import "LetterView.h"
#import "AlphabetInfo.h"

@interface C4WorkSpace : C4CanvasController{
    //views
    TakePhoto       *takePhoto;
    CropPhoto       *cropPhoto;
    AssignLetter    *assignLetter;
    AlphabetView    *alphabetView;
    LetterView      *letterView;
    AlphabetInfo    *alphabetInfo;
    
    //default variables
    //>colors
    UIColor *navBarColorDefault;
    UIColor *navigationColorDefault;
    UIColor *buttonColorDefault;
    UIColor *typeColorDefault;
    UIColor *overlayColorDefault;
    UIColor *highlightColorDefault;
    UIColor *darkenColorDefault;
    UIColor *greyTypeDefault;
    
    //>type
    C4Font *fatFontDefault;
    C4Font *normalFontDefault;
    
    //>nav bar heights
    float TopBarFromTopDefault;
    float TopNavBarHeightDefault;
    float BottomBarHeightDefault;
    
    //icons
    C4Image *iconTakePhoto;
    C4Image *iconClose;
    C4Image *iconBack;
    C4Image *iconOk;
    C4Image *iconSettings;
    C4Image *iconAlphabetInfo;
    C4Image *iconShareAlphabet;
    C4Image *iconSaveAlphabet;
    C4Image *iconWritePostcard;
    C4Image *iconMyPostcards;
    C4Image *iconMyAlphabets;
    C4Image *iconMenu;
    C4Image *iconArrowForward;
    C4Image *iconArrowBackward;
    C4Image *iconAlphabet;
    C4Image *iconZoomPlus;
    C4Image *iconZoomMinus;
    C4Image *iconZoom;
    
    //current alphabet
    NSMutableArray *currentAlphabet;
    NSArray *finnishAlphabet; //default
}
-(void)createViews;

-(void)loadDefaultAlphabet;
-(void)currentAlphabetChanged;
-(void)saveCurrentAlphabetAsImage;

//navigation Functions
-(void)goToTakePhoto;
-(void)goToCropPhoto;
-(void)goToAssignPhoto;
-(void)goToAlphabetsView;
-(void)navigatingBackBetweenAlphabetAndAssignLetter;
-(void)goToLetterView;
-(void)goToAlphabetInfo;
@end
