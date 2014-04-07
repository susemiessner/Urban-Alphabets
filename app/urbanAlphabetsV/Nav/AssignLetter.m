//
//  AssignLetter.m
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "AssignLetter.h"
#import "BottomNavBar.h"
#import "AlphabetView.h"
#import "C4WorkSpace.h"
@interface AssignLetter (){
    AlphabetView *alphabetView;
    C4WorkSpace *workspace;
    
    int notificationCounter; //to make sure Ok button is only added 1x
    NSMutableArray *greyRectArray;
    C4Shape *currentImage; //the image currently highlighted
    C4Image *croppedImage;
    
    NSMutableArray *greyGridArray;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    //saving image
    CGContextRef graphicsContext;

    
}
@property (nonatomic) BottomNavBar *bottomNavBar;

@end

@implementation AssignLetter
-(void)viewWillAppear:(BOOL)animated
{
    [self redrawAlphabet];
    self.bottomNavBar.centerImage.hidden=YES;
}
-(void)redrawAlphabet{
    
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        
        C4Image *image=[self.currentAlphabet objectAtIndex:i ];
        [image removeFromSuperview];
        [self stopListeningFor:@"touchesBegan" object:image];
    }
    [self grabCurrentAlphabetViaNavigationController];
}
-(void)closeView{}
-(void)setup:(C4Image*)croppedImagePassed  {
    self.title=@"Assign Letter";
    
    croppedImage=[C4Image imageWithImage:croppedImagePassed];
    
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;

    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:croppedImage withFrame:CGRectMake(0, 0, 32.788, 40.022) centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45)];
    [self.canvas addShape:self.bottomNavBar];
    self.bottomNavBar.centerImage.hidden=YES;
    
    //start location updating
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
}
-(void)grabCurrentAlphabetViaNavigationController {
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    self.currentLanguage=workspace.currentLanguage;
    [self drawCurrentAlphabet:[workspace.currentAlphabet mutableCopy]];
    [self initGreyGrid];
}

-(void)initGreyGrid{
    greyGridArray=[[NSMutableArray alloc]init];
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=UA_NAV_CTRL_COLOR;
        greyRect.lineWidth=2;
        greyRect.strokeColor=UA_NAV_BAR_COLOR;
        [greyGridArray addObject:greyRect];
        [self.canvas addShape:greyRect];
        [self listenFor:@"touchesBegan" fromObject:greyRect andRunMethod:@"highlightLetter:"];
    }
}
-(void)drawCurrentAlphabet: (NSMutableArray*)currentAlphabetPassed{
    notificationCounter=0; //to make sure ok button is only added 1x
    self.currentAlphabet=[currentAlphabetPassed mutableCopy];
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        C4Image *image=[self.currentAlphabet objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
    }
}
-(void)highlightLetter:(NSNotification *)notification {
    for (int i=0; i<42; i++) {
        currentImage= greyGridArray[i];
        currentImage.backgroundColor=UA_NAV_CTRL_COLOR;
    }
    currentImage = (C4Shape *)notification.object;
    currentImage.backgroundColor= UA_HIGHLIGHT_COLOR;
    
    //making sure that the "OK" button is only added ones not every time the person clicks on a new letter
    if (notificationCounter==0) {
        self.bottomNavBar.centerImage.hidden=NO;
        [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"goToAlphabetsViewAddingImageToAlphabet"];
    }
    notificationCounter++;
    
}
//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) goToAlphabetsViewAddingImageToAlphabet{
    
    self.bottomNavBar.centerImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    //--------------------------------------------------
    //which image was chosen
    //--------------------------------------------------
    float imageWidth=53.53;
    float imageHeight=65.1;
    float i=currentImage.origin.x/imageWidth;
    float j=currentImage.origin.y/imageHeight;
    
    self.chosenImageNumberInArray=((j-1)*6)+i+1;
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
    [save sendLetterToDatabase: currentLocation ImageNo:self.chosenImageNumberInArray Image:croppedImage Language:self.currentLanguage Username:userName];
    croppedImage=[self imageWithImage:croppedImage];
    
    //save image here (test)
    [self exportHighResImage];
    //--------------------------------------------------
    //replace current  with new letter
    //--------------------------------------------------
    //remove the image currently in that place in the alphabet
    [self.currentAlphabet removeObjectAtIndex:self.chosenImageNumberInArray];
    //add the cropped image in the same position
    [self.currentAlphabet insertObject:croppedImage atIndex:self.chosenImageNumberInArray];
    //--------------------------------------------------
    //stop updating location
    //--------------------------------------------------
    [locationManager stopUpdatingLocation];
    //--------------------------------------------------
    //replace the alphabet in main view with new alphabet
    //--------------------------------------------------
    workspace.currentAlphabet=self.currentAlphabet;
    //--------------------------------------------------
    //prepare next view and go there
    //--------------------------------------------------
    alphabetView=[[AlphabetView alloc]initWithNibName:@"AlphabetView" bundle:[NSBundle mainBundle]];
    [alphabetView setup:self.currentAlphabet];
    [self.navigationController pushViewController:alphabetView animated:YES];
    [alphabetView grabCurrentLanguageViaNavigationController];
}
//------------------------------------------------------------------------
//FOR SENDING TO DATABASE
//------------------------------------------------------------------------
-(C4Image*)imageWithImage:(C4Image*)theImage {
    //size to scale to
    CGSize newSize=CGSizeMake(53.53,65.1);
    //convert to UIImage
    UIImage *image=theImage.UIImage;
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //convert back to C4Image
    C4Image *convertedImage=[C4Image imageWithUIImage:newImage];
    //return C4Image
    return convertedImage;
}
//------------------------------------------------------------------------
//LOCATION UPDATING
//------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
}
//------------------------------------------------------------------------
//SAVING CROPPED IMAGE TO DOCUMENTS DIRECTORY (TRY FOR NOW)
//------------------------------------------------------------------------
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    //C4Log(@"graphicsContext: %@", graphicsContext.);
    [croppedImage renderInContext:graphicsContext];
    NSString *letterToAdd=@" ";
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]) {
        letterToAdd=[workspace.finnish objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"German"]){
        letterToAdd=[workspace.german objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"English"]){
        letterToAdd=[workspace.english objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"Danish/Norwegian"]){
        letterToAdd=[workspace.danish objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"Spanish"]){
        letterToAdd=[workspace.spanish objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"Russian"]){
        letterToAdd=[workspace.russian objectAtIndex:self.chosenImageNumberInArray];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", letterToAdd ];
    [self saveImage:fileName];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(croppedImage.width-1, croppedImage.height-1), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image,80);
    //save in a certain folder
    NSString *dataPath = [[self documentsDirectory] stringByAppendingString:@"/"];
    dataPath=[dataPath stringByAppendingPathComponent:workspace.alphabetName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *savePath = [dataPath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
}
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}
@end
