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

@interface C4WorkSpace : C4CanvasController{
    //views
    TakePhoto       *takePhoto;
    CropPhoto       *cropPhoto;
    AssignLetter    *assignLetter;
    AlphabetView    *alphabetView;
    
    //default variables
    //>colors
    UIColor *navBarColorDefault;
    UIColor *navigationColorDefault;
    UIColor *buttonColorDefault;
    UIColor *typeColorDefault;
    UIColor *overlayColorDefault;
    UIColor *highlightColorDefault;
    UIColor *darkenColorDefault;
    
    //type
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
    
    //current alphabet
    NSMutableArray *currentAlphabet;
    NSArray *finnishAlphabet; //default
}
-(void)createViews;

-(void)loadDefaultAlphabet;
-(void)currentAlphabetChanged;

//navigation Functions
-(void)goToTakePhoto;
-(void)goToCropPhoto;
-(void)goToAssignPhoto;
-(void)goToAlphabetsView;
-(void)navigatingBackBetweenAlphabetAndAssignLetter;

@end
