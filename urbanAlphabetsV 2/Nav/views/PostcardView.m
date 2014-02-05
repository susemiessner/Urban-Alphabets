//
//  PostcardView.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "PostcardView.h"
#import "SaveToDatabase.h"
#import "PostcardMenu.h"
#import "Write Postcard.h"
#import "AlphabetView.h"
#import "SharePostcard.h"
#import "C4WorkSpace.h"
#import "MyAlphabets.h"

@interface PostcardView (){
    SaveToDatabase *save;
    Write_Postcard *writePostcard;
    AlphabetView *alphabetView;
    SharePostcard *sharePostcard;
    C4WorkSpace *workspace;
    MyAlphabets *myAlphabets;
    //saving image
    CGContextRef graphicsContext;
    //location when saving alphabet to server
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite) NSMutableArray  *postcardArray, *greyRectArray;
@property (nonatomic) PostcardMenu *menu;
@end
@implementation PostcardView

-(void)setupWithPostcard: (NSMutableArray*)postcardPassed Rect: (NSMutableArray*)postcardRect withLanguage:(NSString*)language withPostcardText:(NSString*)postcardText{
    self.title=@"Postcard";
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //close button
    frame = CGRectMake(0, 0, 22.5, 22.5);
    UIButton *closeButton = [[UIButton alloc] initWithFrame:frame];
    [closeButton setBackgroundImage:UA_ICON_CLOSE_UI forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeView)
         forControlEvents:UIControlEventTouchUpInside];
    [closeButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    self.postcardArray=[[NSMutableArray alloc]init];
    self.postcardArray=[postcardPassed mutableCopy];
    self.greyRectArray=[[NSMutableArray alloc]init];
    self.greyRectArray=[postcardRect mutableCopy];
    self.currentLanguage=language;
    self.postcardText=postcardText;
    
    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.view.frame.size.height-UA_BOTTOM_BAR_HEIGHT, self.view.frame.size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 60, 30)  centerIcon:UA_ICON_MENU withFrame:CGRectMake(0, 0, 45, 45) rightIcon:UA_ICON_ALPHABET withFrame:CGRectMake(0, 0, 80, 40)];
    [self.view addSubview:self.bottomNavBar];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToTakePhoto"];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"openMenu"];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.rightImage andRunMethod:@"closeView"];

    //display the postcard
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (int i=0; i<[self.postcardArray count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        UIImageView *image=[self.postcardArray objectAtIndex:i ];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        [self.view addSubview:imageView];
    }
    for (int i=0; i<[self.greyRectArray count]; i++) {
        UIView *greyRect=[self.greyRectArray objectAtIndex:i];
        [greyRect setBackgroundColor:UA_NAV_CTRL_COLOR];
        greyRect.layer.borderWidth=1.0f;
        greyRect.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        [self.view addSubview:greyRect];
        
    }
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToTakePhoto{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)openMenu{
    [self saveCurrentPostcardAsImage];
    CGRect menuFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.menu=[[PostcardMenu alloc]initWithFrame:menuFrame];
    [self.view addSubview:self.menu];
    //start location updating
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //cancel shape
    //[self listenFor:@"touchesBegan" fromObjects:@[self.menu.cancelShape, self.menu.cancelLabel] andRunMethod:@"closeMenu"];
    //save postcard
    //[self listenFor:@"touchesBegan" fromObjects:@[self.menu.savePostcardShape, self.menu.savePostcardLabel,self.menu.savePostcardIcon] andRunMethod:@"goToSavePostcard"];
    //write new postcard
    //[self listenFor:@"touchesBegan" fromObjects:@[self.menu.writePostcardShape, self.menu.writePostcardLabel,self.menu.writePostcardIcon] andRunMethod:@"goToWritePostcard"];
    //sharePostcard
    //[self listenFor:@"touchesBegan" fromObjects:@[self.menu.sharePostcardShape, self.menu.sharePostcardLabel,self.menu.sharePostcardIcon] andRunMethod:@"goToSharePostcard"];
    //my alphabets
    //[self listenFor:@"touchesBegan" fromObjects:@[self.menu.myAlphabetsShape, self.menu.myAlphabetsLabel,self.menu.myAlphabetsIcon] andRunMethod:@"goToMyAlphabets"];
}
-(void)closeMenu{
    [self.menu removeFromSuperview];
    [locationManager stopUpdatingLocation];
}
-(void)goToSavePostcard{
    self.menu.savePostcardShape.backgroundColor=UA_HIGHLIGHT_COLOR;
    [self.menu removeFromSuperview];
    [self closeMenu];
    [self savePostcard];
}
-(void)goToWritePostcard{
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    writePostcard=(Write_Postcard*)obj;
    [writePostcard clearPostcard];
    [self.navigationController popViewControllerAnimated:NO];
    [self closeMenu];
    
}
-(void)goToMyAlphabets{
    [self closeMenu];
    myAlphabets=[[MyAlphabets alloc] initWithNibName:@"MyAlphabets" bundle:[NSBundle mainBundle]];
    [myAlphabets setup];
    [self.navigationController pushViewController:myAlphabets animated:NO];
    [myAlphabets grabCurrentLanguageViaNavigationController];
}
-(void)closeView{
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3];
    alphabetView=(AlphabetView*)obj;
    [self.navigationController popToViewController:alphabetView animated:NO];
}
-(void)goToSharePostcard{
    [self savePostcard];
    sharePostcard=[[SharePostcard alloc]initWithNibName:@"SharePostcard" bundle:[NSBundle mainBundle]];
    [sharePostcard setup:self.currentPostcardImageAsUIImage];
    [self.navigationController pushViewController:sharePostcard animated:NO];
    [self closeMenu];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:NO];
}
//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
-(void)savePostcard{
    //crop the screenshot
    self.currentPostcardImage=[self cropImage:self.currentPostcardImage toArea:CGRectMake(0, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT))];
    [self exportHighResImage];
}
-(void)saveCurrentPostcardAsImage{
    CGFloat scale = 10.0;
    //begin an image context
    CGSize  rect=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    //render the canvas image into the context

    //[self.view renderInContext:c];
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    //end the image context
    UIGraphicsEndImageContext();
    //create a new UIImage
    self.currentPostcardImage = newUIImage;
}

-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
   // [self.currentPostcardImage renderInContext:graphicsContext];
    NSString *fileName = [NSString stringWithFormat:@"exportedPostcard%@.jpg", [NSDate date]];
    [self saveImage:fileName];
    [self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT)), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    self.currentPostcardImageAsUIImage=[image copy];
    NSData *imageData = UIImagePNGRepresentation(image);
    //--------------------------------------------------
    //getting username from main view
    //--------------------------------------------------
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    NSString *userName=workspace.userName;
    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------
    save=[[SaveToDatabase alloc]init];
    [save sendPostcardToDatabase:imageData withLanguage: self.currentLanguage withText: self.postcardText withLocation:currentLocation withUsername:userName];
    //--------------------------------------------------
    //save to documents directory
    //--------------------------------------------------
    NSString *dataPath = [[self documentsDirectory] stringByAppendingPathComponent:@"/postcards"];
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
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}
-(UIImage *)cropImage:(UIImage *)originalImage toArea:(CGRect)rect{
    //grab the image scale
    CGFloat scale = 1.0;
    //begin an image context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    //shift BACKWARDS in both directions because this moves the image
    //the area to crop shifts INTO: (0, 0, rect.size.width, rect.size.height)
    CGContextTranslateCTM(c, -rect.origin.x, -rect.origin.y);
    //render the original image into the context
    //[originalImage renderInContext:c];
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    //end the image context
    UIGraphicsEndImageContext();
    //create a new UIImage
    UIImage *newImage = newUIImage;
    //return the new image
    return newImage;
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
