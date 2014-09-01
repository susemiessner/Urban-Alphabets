//
//  C4WorkSpace.h
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4CanvasController.h"
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface C4WorkSpace : UIViewController<UITextViewDelegate, UIScrollViewDelegate>

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
@property (readwrite) NSString *defaultLanguage;

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
-(void)saveUsernameToUserDefaults;
-(void)loadCorrectAlphabet;

@property (readwrite)NSMutableArray *receivedLettersArray;
@property (readwrite)NSMutableArray *theNewAlphabetArray;
@property (readwrite)NSMutableArray *finalAlphabetArray;

@property (readwrite) int letterTouched;
@property (readwrite, strong) UIImage *currentAlphabetImage;
@property (readwrite, strong) UIImage *currentAlphabetImageAsUIImage;

//postcard
@property (readwrite, strong) NSMutableArray *postcardArray, *greyRectArray, *postcardViewArray;
@property (readwrite)     NSString *entireText;
@property (readwrite) NSString *postcardText;
@property (readwrite) int maxPostcardLength;
-(void)writePostcard;
-(void)savePostcard;

//question
@property(readwrite)NSString *question;
//buttons
@property (readwrite)UIImageView *buttonRefreshView;
@property (readwrite)UIImageView *buttonSendView;

@end
