//
//  C4WorkSpace.h
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4CanvasController.h"
#import <CoreLocation/CoreLocation.h>
#import "BottomNavBar.h"
#import "AlphabetMenu.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface C4WorkSpace : UIViewController<UITextViewDelegate,CLLocationManagerDelegate>

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
@property (readwrite)NSArray *latvian;

-(void)setup;
-(void)loadDefaultAlphabet;
-(NSString *)documentsDirectory;
-(void)writeAlphabetsUserDefaults;
-(void)loadCorrectAlphabet;
-(void)goToMyAlphabets;


@property (nonatomic) AlphabetMenu *menu;
@property (readwrite) int letterTouched;
@property (readwrite, strong) UIImage *currentAlphabetImage;
@property (readwrite, strong) UIImage *currentAlphabetImageAsUIImage;
@end
