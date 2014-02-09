//
//  AlphabetView.m
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "AlphabetView.h"
#import "BottomNavBar.h"
#import "AlphabetMenu.h"
#import "SaveToDatabase.h"
#import "C4WorkSpace.h"
#import "LetterView.h"
#import "Write Postcard.h"
#import "ShareAlphabet.h"
#import "MyAlphabets.h"

@interface AlphabetView (){
    AlphabetInfo *alphabetInfo;
    C4WorkSpace *workspace;
    LetterView *letterView;
    Write_Postcard *writePostcard;
    SaveToDatabase *save;
    ShareAlphabet *shareAlphabet;
    MyAlphabets *myAlphabets;
    
    NSMutableArray *greyRectArray;
    NSString *currentLanguage;
    
    //saving image
    CGContextRef graphicsContext;
    
    
    //location when saving alphabet to server
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    //username for database
    NSString *userName;
    
    float imageWidth;
    float imageHeight;
    float alphabetFromLeft;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (nonatomic) AlphabetMenu *menu;

@end

@implementation AlphabetView

-(void )setup:(NSMutableArray*)passedAlphabet  {
    self.navigationItem.hidesBackButton = YES;
    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 60, 30)  centerIcon:UA_ICON_MENU withFrame:CGRectMake(0, 0, 45, 45)];
    [self.view addSubview:self.bottomNavBar];
    
    //make it touchable
    UITapGestureRecognizer *photoButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToTakePhoto)];
    photoButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.leftImageView addGestureRecognizer:photoButtonRecognizer];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToTakePhoto"];
    
    //make it touchable
    UITapGestureRecognizer *menuButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenu)];
    menuButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:menuButtonRecognizer];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"openMenu"];
    
    
    imageWidth=UA_LETTER_IMG_WIDTH_5;
    imageHeight=UA_LETTER_IMG_HEIGHT_5;
    alphabetFromLeft=0;
    if ( UA_IPHONE_5_HEIGHT != [[UIScreen mainScreen] bounds].size.height) {
    //if ( UA_IPHONE_5_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
        imageHeight=UA_LETTER_IMG_HEIGHT_4;
        imageWidth=UA_LETTER_IMG_WIDTH_4;
        alphabetFromLeft=UA_LETTER_SIDE_MARGIN_ALPHABETS;
    }

}
-(void)viewDidAppear:(BOOL)animated{
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    self.title=workspace.alphabetName;
}
-(void)grabCurrentLanguageViaNavigationController {
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    //load things from main view
    self.currentAlphabet=[workspace.currentAlphabet mutableCopy];
    currentLanguage=workspace.currentLanguage;
    userName=workspace.userName;
    [self drawCurrentAlphabet];
    [self initGreyGrid];
}
-(void)initGreyGrid{
    greyRectArray=[[NSMutableArray alloc]init];
   
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth+alphabetFromLeft;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        UIView *greyRect=[[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        [greyRect setBackgroundColor:UA_NAV_CTRL_COLOR];
        
        greyRect.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        greyRect.layer.borderWidth=1.0f;
        greyRect.userInteractionEnabled=YES;
        [greyRectArray addObject:greyRect];
        [self.view addSubview:greyRect];
        //NSLog(@"greyGrid: %i: %@", i, greyRect);
        
        //make them touchable
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLetter:)];
        letterTapRecognizer.numberOfTapsRequired = 1;
        [greyRect addGestureRecognizer:letterTapRecognizer];
        //[self listenFor:@"touchesBegan" fromObject:greyRect andRunMethod:@"tappedLetter:"];
    }
}
-(void)drawCurrentAlphabet{
        for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth+alphabetFromLeft;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        
        UIImageView *image=[self.currentAlphabet objectAtIndex:i ];
        image.frame=CGRectMake(xPos, yPos, imageWidth, imageHeight);
        [self.view addSubview:image];
        if (i==0) {
            NSLog(@"image: %@",image.image);
        }
    }
}
//------------------------------------------------------------------------
//REDRAWING AFTER CHANGING LANGUAGE
//------------------------------------------------------------------------
-(void)redrawAlphabet{
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        UIImageView *image=[self.currentAlphabet objectAtIndex:i ];
        [image removeFromSuperview];

        UIView *rectShape=[greyRectArray objectAtIndex:i];
        [rectShape removeFromSuperview];
    }
    [self grabCurrentLanguageViaNavigationController];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToTakePhoto{
    self.bottomNavBar.leftImageView.backgroundColor=UA_HIGHLIGHT_COLOR;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)goToSaveAlphabet{
    NSLog(@"saveAlphabet");
    //self.menu.saveAlphabetShape.fillColor=UA_HIGHLIGHT_COLOR;
    [self closeMenu];
    [self saveCurrentAlphabetAsImage];

    [self saveAlphabet];
}
-(void)goToWritePostcard{
    NSLog(@"write Postcard");
    //self.menu.writePostcardShape.fillColor=UA_HIGHLIGHT_COLOR;
    [self closeMenu];
    writePostcard=[[Write_Postcard alloc] initWithNibName:@"Write Postcard" bundle:[NSBundle mainBundle]];
    [writePostcard setupWithLanguage:workspace.currentLanguage Alphabet:workspace.currentAlphabet];
    [self.navigationController pushViewController:writePostcard animated:YES];
    
}
-(void)goToAlphabetInfo{
    NSLog(@"goToAlphabetInfo");
    
    //--------------------------------------------------
    //prepare alphabetInfo
    //--------------------------------------------------
    alphabetInfo=[[AlphabetInfo alloc]initWithNibName:@"AlphabetInfo" bundle:[NSBundle mainBundle]];
    [alphabetInfo setup];
    [self.navigationController pushViewController:alphabetInfo animated:YES];
    [alphabetInfo grabCurrentLanguageViaNavigationController ];
    [self closeMenu];
}
-(void)tappedLetter:(UIGestureRecognizer *)notification {
    UIView *currentImage = (UIView *)notification.view;
    
    float i=(currentImage.frame.origin.x-alphabetFromLeft)/imageWidth;
    float j=currentImage.frame.origin.y/imageHeight;
    int j1=j+1;
    if ( UA_IPHONE_5_HEIGHT != [[UIScreen mainScreen] bounds].size.height) {
        //if ( UA_IPHONE_5_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
        j1=floor(j);
    }
    NSLog(@"chosen i:j== %f:%i", i,j1);

    self.letterTouched=((j1-1)*6)+i;
    NSLog(@"arryNum: %i", self.letterTouched);

    [self openLetterView];
}
-(void)openLetterView{
    NSLog(@"openLetterView");
    letterView=[[LetterView alloc] initWithNibName:@"LetterView" bundle:[NSBundle mainBundle]];
    [letterView setupWithLetterNo: self.letterTouched currentAlphabet:self.currentAlphabet];
    [self.navigationController pushViewController:letterView animated:YES];
}
-(void)goToShareAlphabet{
    NSLog(@"ShareAlphabet");
    //get the current alphabet as a photo
    //[self saveAlphabet];
    [self closeMenu];
    shareAlphabet=[[ShareAlphabet alloc]initWithNibName:@"ShareAlphabet" bundle:[NSBundle mainBundle]];
    [shareAlphabet setup: self.currentAlphabetImageAsUIImage];
    [self.navigationController pushViewController:shareAlphabet animated:YES];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goToMyAlphabets{
    NSLog(@"myAlphabets");
    
    [self closeMenu];
    myAlphabets=[[MyAlphabets alloc] initWithNibName:@"MyAlphabets" bundle:[NSBundle mainBundle]];
    [myAlphabets setup];
    [self.navigationController pushViewController:myAlphabets animated:NO];
    [myAlphabets grabCurrentLanguageViaNavigationController];
}
//------------------------------------------------------------------------
//MENU
//------------------------------------------------------------------------
-(void)openMenu{
    NSLog(@"openMenu");
    //[self saveCurrentAlphabetAsImage];
    CGRect menuFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.menu=[[AlphabetMenu alloc]initWithFrame:menuFrame ];
    [self.view addSubview:self.menu];
        //start location updating
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //all gesture recognizers
    //alphabet info
    UITapGestureRecognizer *alphabetInfoIconRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAlphabetInfo)];
    alphabetInfoIconRecognizer.numberOfTapsRequired = 1;
    [self.menu.alphabetInfoIcon addGestureRecognizer:alphabetInfoIconRecognizer];
    UITapGestureRecognizer *alphabetInfoShapeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAlphabetInfo)];
    alphabetInfoShapeRecognizer.numberOfTapsRequired = 1;
    [self.menu.alphabetInfoShape addGestureRecognizer:alphabetInfoShapeRecognizer];
    UITapGestureRecognizer *alphabetInfoLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAlphabetInfo)];
    alphabetInfoLabelRecognizer.numberOfTapsRequired = 1;
    [self.menu.alphabetInfoLabel addGestureRecognizer:alphabetInfoLabelRecognizer];
    
    //write postcard
    UITapGestureRecognizer *writePostcardShapeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToWritePostcard)];
    writePostcardShapeRecognizer.numberOfTapsRequired = 1;
    [self.menu.writePostcardShape addGestureRecognizer:writePostcardShapeRecognizer];
    UITapGestureRecognizer *writePostcardLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToWritePostcard)];
    writePostcardLabelRecognizer.numberOfTapsRequired = 1;
    [self.menu.writePostcardLabel addGestureRecognizer:writePostcardLabelRecognizer];
    UITapGestureRecognizer *writePostcardIconRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToWritePostcard)];
    writePostcardIconRecognizer.numberOfTapsRequired = 1;
    [self.menu.writePostcardIcon addGestureRecognizer:writePostcardIconRecognizer];
    
    //share alphabet
    UITapGestureRecognizer *shareAlphabetShapeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToShareAlphabet)];
    shareAlphabetShapeRecognizer.numberOfTapsRequired = 1;
    [self.menu.shareAlphabetShape addGestureRecognizer:shareAlphabetShapeRecognizer];
    UITapGestureRecognizer *shareAlphabetLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToShareAlphabet)];
    shareAlphabetLabelRecognizer.numberOfTapsRequired = 1;
    [self.menu.shareAlphabetLabel addGestureRecognizer:shareAlphabetLabelRecognizer];
    UITapGestureRecognizer *shareAlphabetIconRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToShareAlphabet)];
    shareAlphabetIconRecognizer.numberOfTapsRequired = 1;
    [self.menu.shareAlphabetIcon addGestureRecognizer:shareAlphabetIconRecognizer];

    
    //my alphabets
    UITapGestureRecognizer *myAlphabetsShapeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMyAlphabets)];
    myAlphabetsShapeRecognizer.numberOfTapsRequired = 1;
    [self.menu.myAlphabetsShape addGestureRecognizer:myAlphabetsShapeRecognizer];
    UITapGestureRecognizer *myAlphabetsLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMyAlphabets)];
    myAlphabetsLabelRecognizer.numberOfTapsRequired = 1;
    [self.menu.myAlphabetsLabel addGestureRecognizer:myAlphabetsLabelRecognizer];
    UITapGestureRecognizer *myAlphabetsIconRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMyAlphabets)];
    myAlphabetsIconRecognizer.numberOfTapsRequired = 1;
    [self.menu.myAlphabetsIcon addGestureRecognizer:myAlphabetsIconRecognizer];
    
    //saveAlphabet
    UITapGestureRecognizer *saveAlphabetShapeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToSaveAlphabet)];
    saveAlphabetShapeRecognizer.numberOfTapsRequired = 1;
    [self.menu.saveAlphabetShape addGestureRecognizer:saveAlphabetShapeRecognizer];
    UITapGestureRecognizer *saveAlphabetLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToSaveAlphabet)];
    saveAlphabetLabelRecognizer.numberOfTapsRequired = 1;
    [self.menu.saveAlphabetLabel addGestureRecognizer:saveAlphabetLabelRecognizer];
    UITapGestureRecognizer *saveAlphabetIconRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToSaveAlphabet)];
    saveAlphabetIconRecognizer.numberOfTapsRequired = 1;
    [self.menu.saveAlphabetIcon addGestureRecognizer:saveAlphabetIconRecognizer];

    //cancel
    UITapGestureRecognizer *cancelShapeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
   cancelShapeRecognizer.numberOfTapsRequired = 1;
    [self.menu.cancelShape addGestureRecognizer:cancelShapeRecognizer];
    UITapGestureRecognizer *cancelLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
    cancelLabelRecognizer.numberOfTapsRequired = 1;
    [self.menu.cancelLabel addGestureRecognizer:cancelLabelRecognizer];

}
-(void)closeMenu{
    //stop location updating
    [locationManager stopUpdatingLocation];
    [self.menu removeFromSuperview];
}

//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
//------------------------------------------------------------------------
-(void)saveAlphabet{
    [self exportHighResImage];
}

-(void)saveCurrentAlphabetAsImage{
    double screenScale = [[UIScreen mainScreen] scale];
    CGImageRef imageRef = CGImageCreateWithImageInRect([[self createScreenshot] CGImage], CGRectMake(0, (UA_TOP_WHITE+UA_TOP_BAR_HEIGHT) * screenScale, [[UIScreen mainScreen] bounds].size.width * screenScale, ([[UIScreen mainScreen] bounds].size.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT))*screenScale));
    self.currentAlphabetImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}

- (UIImage *)createScreenshot
{
    //    UIGraphicsBeginImageContext(pageSize);
    CGSize pageSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    UIGraphicsBeginImageContextWithOptions(pageSize, YES, 0.0f);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)exportHighResImage {
    NSString *fileName = [NSString stringWithFormat:@"exportedAlphabet%@.jpg", [NSDate date]];
    [self saveImage:fileName];
    [self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT)), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = self.currentAlphabetImage;
    self.currentAlphabetImageAsUIImage=[image copy];
    NSData *imageData = UIImagePNGRepresentation(image);
    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------
    save=[[SaveToDatabase alloc]init];
    [save sendAlphabetToDatabase:imageData withLanguage: currentLanguage withLocation:currentLocation withUsername:userName];
    //--------------------------------------------------
    //save to documents directory
    //--------------------------------------------------
    NSString *dataPath = [[self documentsDirectory] stringByAppendingPathComponent:@"/alphabets"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *savePath = [dataPath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
}
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}
-(void)saveImageToLibrary {
    UIImage *image = self.currentAlphabetImageAsUIImage;
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

//------------------------------------------------------------------------
//LOCATION UPDATING
//------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    currentLocation = newLocation;
}

@end
