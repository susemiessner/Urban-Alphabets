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


// camera views and layers
@property (nonatomic, strong) UIView *previewLayerHostView;
@property (nonatomic, strong) AVCaptureSession *avSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *avSnapper;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *avPreviewLayer;
@property (nonatomic, strong) CALayer *stillLayer;

@property (nonatomic, assign) bool isPhotoBeingTaken;
@property (nonatomic, assign) bool isCameraAlreadySetup;

-(void)take;
-(void)snapshot;
-(void)cameraPrepareToRetake;
-(void)imageSelected;


-(void)setup;
-(void)cameraSetup;
-(void)loadDefaultAlphabet;
-(NSString *)documentsDirectory;
-(void)writeAlphabetsUserDefaults;
-(void)loadCorrectAlphabet;

@end
