//
//  C4WorkSpace.h
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4CanvasController.h"
#import "BottomNavBar.h"


@interface C4WorkSpace : UIViewController<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//taking the photo
@property (readwrite, strong) UIImage *img;//the image captured
@property (nonatomic) BottomNavBar *bottomNavBar;

//defaults
@property (readwrite) NSMutableArray *currentAlphabet; //UIImageViews
@property (readwrite) NSMutableArray *currentAlphabetUIImage;
@property (readwrite) NSString *currentLanguage;
@property (readwrite) NSMutableArray *languages;
@property (readwrite) NSString *oldLanguage;
@property (readwrite) NSString *alphabetName;
@property (readwrite) NSString *userName;
@property (readwrite) NSMutableArray *myAlphabets;
@property (readwrite) NSMutableArray *myAlphabetsLanguages;

//languages
@property (readwrite)NSArray *finnish;
@property (readwrite)NSArray *german;
@property(readwrite)NSArray *danish;
@property(readwrite)NSArray *english;
@property (readwrite)NSArray *spanish;
@property (readwrite)NSArray *russian;

-(void)setup;
-(void)cameraSetup;
-(void)loadDefaultAlphabet;
-(NSString *)documentsDirectory;
-(void)writeAlphabetsUserDefaults;
-(void)loadCorrectAlphabet;
@end
