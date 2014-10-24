//
//  AssignLetter.m
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "AssignLetter.h"
#import "BottomNavBar.h"
#import "C4WorkSpace.h"
@interface AssignLetter (){
    C4WorkSpace *workspace;
    
    int notificationCounter; //to make sure Ok button is only added 1x
    NSMutableArray *greyRectArray;
    UIView *currentImage; //the image currently highlighted
    UIImage *croppedImage;
    
    NSMutableArray *greyGridArray;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    //enter username
    UIImageView *enterUsername;
    UITextView *userNameField;
    float yPosUsername;
    float xPosUsername;
    
    //saving image
    CGContextRef graphicsContext;
    
    float imageWidth;
    float imageHeight;
    float alphabetFromLeft;
    float alphabetFromTop;
    
    int selectedLetter;
    
}
@property (nonatomic) BottomNavBar *bottomNavBar;

@end

@implementation AssignLetter
-(void)viewWillAppear:(BOOL)animated
{
    [self redrawAlphabet];
}
-(void)redrawAlphabet{
    
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        
        UIImageView *image=[self.currentAlphabet objectAtIndex:i ];
        [image removeFromSuperview];
    }
    [self grabCurrentAlphabetViaNavigationController];
}
-(void)closeView{}
-(void)setup:(UIImage*)croppedImagePassed  {
    self.title=@"Assign Letter";
    
    croppedImage=croppedImagePassed;
    self.chosenImageNumberInArray=50;
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //white background
    UIView *background=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [background setBackgroundColor:UA_WHITE_COLOR];
    
    background.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
    background.layer.borderWidth=1.0f;
    background.userInteractionEnabled=NO;
    [self.view addSubview:background];
    
    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:croppedImage withFrame:CGRectMake(0, 0, 32.788, 40.022) centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45)];
    [self.view addSubview:self.bottomNavBar];
    
    //start location updating
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    imageWidth=UA_LETTER_IMG_WIDTH_5;
    imageHeight=UA_LETTER_IMG_HEIGHT_5;
    yPosUsername=0;
    alphabetFromLeft=0;
    if ( UA_IPHONE_4_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
        imageHeight=UA_LETTER_IMG_HEIGHT_4;
        imageWidth=UA_LETTER_IMG_WIDTH_4;
        alphabetFromLeft=UA_LETTER_SIDE_MARGIN_ALPHABETS;
    } else if (UA_IPHONE_6_HEIGHT==[[UIScreen mainScreen]bounds].size.height){
        imageHeight=UA_LETTER_IMG_HEIGHT_6;
        imageWidth=UA_LETTER_IMG_WIDTH_6;
        alphabetFromTop=UA_LETTER_TOP_MARGIN_ALPHABETS;
    }else if (UA_IPHONE_6PLUS_HEIGHT==[[UIScreen mainScreen]bounds].size.height){
        imageHeight=UA_LETTER_IMG_HEIGHT_6PLUS;
        imageWidth=UA_LETTER_IMG_WIDTH_6PLUS;
        alphabetFromTop=UA_LETTER_TOP_MARGIN_ALPHABETS_6PLUS;
    }


    self.bottomNavBar.centerImageView.hidden=YES;

}
-(void)preselectLetter{
    currentImage = [greyGridArray objectAtIndex:self.chosenImageNumberInArray];
    currentImage.backgroundColor= UA_HIGHLIGHT_COLOR;
    selectedLetter=(int)self.chosenImageNumberInArray;
    [self unhideOkButton];
    
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
    NSLog(@"chosen image %lu", (unsigned long)self.chosenImageNumberInArray);
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth+alphabetFromLeft;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight+alphabetFromTop;
        UIView *greyRect=[[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        if (self.chosenImageNumberInArray ==i) {
            [greyRect setBackgroundColor:UA_HIGHLIGHT_COLOR];

        } else{
            [greyRect setBackgroundColor:UA_NAV_CTRL_COLOR];
            if (notificationCounter==0) {
                [self unhideOkButton];
            }
        }
        
        greyRect.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        greyRect.layer.borderWidth=1.0f;
        greyRect.userInteractionEnabled=YES;
        [greyGridArray addObject:greyRect];
        [self.view addSubview:greyRect];
        
        //make them touchable
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        letterTapRecognizer.numberOfTapsRequired = 1;
        [greyRect addGestureRecognizer:letterTapRecognizer];
    }
}
-(void)drawCurrentAlphabet: (NSMutableArray*)currentAlphabetPassed{
    notificationCounter=0; //to make sure ok button is only added 1x
    self.currentAlphabet=[currentAlphabetPassed mutableCopy];
    
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth+alphabetFromLeft;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight+alphabetFromTop;
        UIImageView *image=[self.currentAlphabet objectAtIndex:i ];
        image.frame=CGRectMake(xPos, yPos, imageWidth, imageHeight);
        [self.view addSubview:image];
    }
}


-(void)highlightLetter:(UITapGestureRecognizer *)notification {
    for (int i=0; i<42; i++) {
        currentImage= greyGridArray[i];
        currentImage.backgroundColor=UA_NAV_CTRL_COLOR;
        
        if ((UIView *)notification.view == currentImage)
        {
            selectedLetter = i;
        }
    }
    currentImage = (UIView *)notification.view;
    currentImage.backgroundColor= UA_HIGHLIGHT_COLOR;
    
    //making sure that the "OK" button is only added ones not every time the person clicks on a new letter
    if (notificationCounter==0) {
        [self unhideOkButton];
    }
    notificationCounter++;
}
-(void)unhideOkButton{
    self.bottomNavBar.centerImageView.hidden=NO;
    //make them touchable
    UITapGestureRecognizer *okButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkUserNameExists)];
    okButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:okButtonRecognizer];
    notificationCounter++;
}
//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)checkUserNameExists{
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    if ([workspace.userName isEqualToString:@"defaultUsername" ]) {
        //ask for new username
        enterUsername=[[UIImageView alloc]initWithFrame:CGRectMake(0,UA_TOP_BAR_HEIGHT+UA_TOP_WHITE, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-UA_TOP_BAR_HEIGHT-UA_TOP_WHITE)];
        if ( UA_IPHONE_4_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
            //iphone 4
            enterUsername.image=[UIImage imageNamed:@"intro_iphone43"];
            yPosUsername=-75;
            xPosUsername=0;
        } else if ( UA_IPHONE_6_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
            //iphone 6
            enterUsername.image=[UIImage imageNamed:@"intro_iphone53"];
            yPosUsername=20;
            xPosUsername=20;
        } else if (UA_IPHONE_6PLUS_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
            //iphone 6plus
            enterUsername.image=[UIImage imageNamed:@"intro_iphone53"];
            yPosUsername=30;
            xPosUsername=20;
        } else {
            //iphone5
            enterUsername.image=[UIImage imageNamed:@"intro_iphone53"];
            xPosUsername=0;
        }
        [self.view addSubview:enterUsername];
        //add text field
        CGRect textViewFrame = CGRectMake(60+xPosUsername, 180+yPosUsername, [[UIScreen mainScreen] bounds].size.width-60-20-xPosUsername, 25.0f);
        userNameField = [[UITextView alloc] initWithFrame:textViewFrame];
        userNameField.returnKeyType = UIReturnKeyDone;
        userNameField.layer.borderWidth=1.0f;
        userNameField.layer.borderColor=[UA_OVERLAY_COLOR CGColor];
        userNameField.backgroundColor=UA_NAV_CTRL_COLOR;
        [userNameField becomeFirstResponder];
        userNameField.delegate = self;
        [self.view addSubview:userNameField];
    } else{
        [self goToAlphabetsViewAddingImageToAlphabet];
    }
    
}
-(void) goToAlphabetsViewAddingImageToAlphabet{
    
    self.chosenImageNumberInArray=selectedLetter;
    
    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------
    save=[[SaveToDatabase alloc]init];
    [save sendLetterToDatabase: currentLocation ImageNo:self.chosenImageNumberInArray Image:croppedImage Language:self.currentLanguage Username:workspace.userName];
    if ( UA_IPHONE_4_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
        croppedImage=[self imageWithImage:croppedImage];
    }
    
    //save image here (test)
    [self exportHighResImage];
    //--------------------------------------------------
    //replace current  with new letter
    //--------------------------------------------------
    //remove the image currently in that place in the alphabet
    [self.currentAlphabet removeObjectAtIndex:self.chosenImageNumberInArray];
    UIImageView *croppedImageView=[[UIImageView alloc]initWithImage:croppedImage];
    //add the cropped image in the same position
    [self.currentAlphabet insertObject:croppedImageView atIndex:self.chosenImageNumberInArray];
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
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
//-----------------------------------------------------------
-(void)saveUserName{
    if ([userNameField.text isEqualToString: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid user name"
                                                        message:@"Your username cannot be empty."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else{
        workspace.userName=userNameField.text;
        [workspace saveUsernameToUserDefaults];
        //and remove the username stuff
        [userNameField removeFromSuperview];
        [enterUsername removeFromSuperview];
        [self goToAlphabetsViewAddingImageToAlphabet];
    }
}
//------------------------------------------------------------------------
//FOR SENDING TO DATABASE
//------------------------------------------------------------------------
-(UIImage*)imageWithImage:(UIImage*)theImage {
    //size to scale to
    CGSize newSize=CGSizeMake(53.53,65.1);
    UIGraphicsBeginImageContext(newSize);
    [theImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return UIImage
    return newImage;
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
//SAVING CROPPED IMAGE TO DOCUMENTS DIRECTORY
//------------------------------------------------------------------------
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    
    NSString *letterToAdd=@" ";
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]) {
        letterToAdd=[workspace.finnish objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"German"]){
        letterToAdd=[workspace.german objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"English/Portugese"]){
        letterToAdd=[workspace.english objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"Danish/Norwegian"]){
        letterToAdd=[workspace.danish objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"Spanish"]){
        letterToAdd=[workspace.spanish objectAtIndex:self.chosenImageNumberInArray];
    }else if([self.currentLanguage isEqualToString:@"Russian"]){
        letterToAdd=[workspace.russian objectAtIndex:self.chosenImageNumberInArray];
    } else if([self.currentLanguage isEqualToString:@"Latvian"]){
        letterToAdd=[workspace.latvian objectAtIndex:self.chosenImageNumberInArray];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", letterToAdd ];
    [self saveImage:fileName];
    
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(croppedImage.size.width-1, croppedImage.size.height-1), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    NSData *imageData = UIImageJPEGRepresentation(croppedImage, 80);
    
    //save in a certain folder
    NSString *dataPath = [[self documentsDirectory] stringByAppendingString:@"/"];
    dataPath=[dataPath stringByAppendingPathComponent:workspace.alphabetName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *savePath = [dataPath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
    

    //write to photo library if iphone 4
    if ( UA_IPHONE_4_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
        NSString *albumName=@"Urban Alphabets";
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        __block ALAssetsGroup* groupToAddTo;
        [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                               usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                   if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                       groupToAddTo = group;
                                   }
                               }
                             failureBlock:^(NSError* error) {
                             }];
        CGImageRef img = [croppedImage CGImage];
        [library writeImageToSavedPhotosAlbum:img
                                     metadata:nil
                              completionBlock:^(NSURL* assetURL, NSError* error) {
                                  if (error.code == 0) {
                                      
                                      // try to get the asset
                                      [library assetForURL:assetURL
                                               resultBlock:^(ALAsset *asset) {
                                                   // assign the photo to the album
                                                   [groupToAddTo addAsset:asset];
                                               }
                                              failureBlock:^(NSError* error) {
                                              }];
                                  }
                                  else {
                                  }
                              }];
    }
    
}
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    /*--
     * This method is called when the textView becomes active, or is the First Responder
     --*/
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self saveUserName];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 40){//140 characters are in the textView
        if (location != NSNotFound){ //Did not find any newline characters
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){ //Did not find any newline characters
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //This method is called when the user makes a change to the text in the textview
    NSString *lastChar= [NSString stringWithFormat:@"%c",[textView.text characterAtIndex: [textView.text length]-1]];
    if ([lastChar isEqualToString:@"ä"]||[lastChar isEqualToString:@"Ä"]||[lastChar isEqualToString:@"ö"]||[lastChar isEqualToString:@"Ö"]||[lastChar isEqualToString:@"ü"]||[lastChar isEqualToString:@"Ü"]||[lastChar isEqualToString:@"å"]||[lastChar isEqualToString:@"Å"]||[lastChar isEqualToString:@"!"]||[lastChar isEqualToString:@"?"]||[lastChar isEqualToString:@"ß"]||[lastChar isEqualToString:@"Ñ"]||[lastChar isEqualToString:@"ñ"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid user name"
                                                        message:@"Your username cannot include any of the following characters: Ä, Ö, Å, Ü, Ñ, !, ?, ß."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        textView.text=[textView.text substringToIndex:[textView.text length] - 1];
    }
    
}

@end