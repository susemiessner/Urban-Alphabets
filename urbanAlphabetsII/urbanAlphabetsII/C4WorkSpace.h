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

@interface C4WorkSpace : C4CanvasController{
    //views
    TakePhoto       *takePhoto;
    CropPhoto       *cropPhoto;
    AssignLetter    *assignLetter;
    
    //default variables
    //>colors
    UIColor *navBarColorDefault;
    UIColor *navigationColorDefault;
    UIColor *buttonColorDefault;
    UIColor *typeColorDefault;
    UIColor *overlayColorDefault;
    UIColor *highlightColorDefault;
    
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
}
-(void)createViews;
-(void)goToTakePhoto;
-(void)goToCropPhoto;
-(void)goToAssignPhoto;
@end
