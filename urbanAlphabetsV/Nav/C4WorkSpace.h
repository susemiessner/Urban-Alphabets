//
//  C4WorkSpace.h
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4CanvasController.h"
#import "BottomNavBar.h"

@interface C4WorkSpace : C4CanvasController<UIImagePickerControllerDelegate, UITextViewDelegate>
//taking the photo
@property (readwrite, strong) C4Image *img;//the image captured
@property (nonatomic) BottomNavBar *bottomNavBar;

//defaults
@property (readwrite) NSMutableArray *currentAlphabet;
@property (readwrite) NSString *currentLanguage;
@property (readwrite) NSString *oldLanguage;
@property (readwrite) NSString *alphabetName;
@property (readwrite) NSString *userName;
-(void)setup;
-(void)cameraSetup;

@end
