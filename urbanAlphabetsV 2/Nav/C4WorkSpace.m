//
//  C4WorkSpace.m
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4Workspace.h"
#import "CropPhoto.h"

@implementation C4WorkSpace {
    CropPhoto *cropPhoto;
    
    UIImage *capturedImage;
        
    //saving image
    CGContextRef graphicsContext;
    UIImage *currentImageToExport;
    
    //for intro
    NSMutableArray *introPics;
    NSMutableArray *introPicsViews;
    UITextView *userNameField;
    int currentNoInIntro;
    UIImage *nextButton;
    UIImageView *nextButtonView;
    UILabel *webadress;
    
    //images loaded from documents directory
    UIImage *loadedImage;
}

-(void)setup {
    self.title=@"Take Photo";

    //load the defaults
    //[self loadDefaultAlphabet];
    self.currentLanguage= @"Finnish/Swedish";
    self.myAlphabets=[[NSMutableArray alloc]init];
    self.myAlphabetsLanguages=[[NSMutableArray alloc]init];
    self.alphabetName=@"Untitled";
    self.languages=[NSMutableArray arrayWithObjects:@"Danish/Norwegian", @"English", @"Finnish/Swedish", @"German", @"Russian", @"Spanish", nil];

    //to see when app becomes active/inactive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    //setup the TakePhoto view
    //[self cameraSetup];
    
    //setup the bottom bar
    //bottomNavbar WITH 2 ICONS
    /*CGRect bottomBarFrame = CGRectMake(0, self.view.frame.size.height-UA_BOTTOM_BAR_HEIGHT, self.view.frame.size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_PHOTOLIBRARY withFrame:CGRectMake(0, 0, 45, 22.5) centerIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 90, 45)];
    UIView *bottomBarView=[[UIView alloc]initWithFrame:bottomBarFrame];
    [self.view addSubview:bottomBarView];*/

    //take photo button
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"captureImage"];
    //photo library button
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToPhotoLibrary"];
    
    
   // [self numberOfTouchesRequired:1 forGesture:@"capture"];
   // [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"goToCropPhoto"];
    
    if (self.userName==nil) {
        self.title=@"Intro";
        introPics=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"intro_1_1.png"],[UIImage imageNamed:@"intro_3"],[UIImage imageNamed:@"intro_4"],[UIImage imageNamed:@"intro_5"], nil];
        introPicsViews=[[NSMutableArray alloc]init];
        for (int i=0; i<[introPics count]; i++) {
            UIImageView *introView=[[UIImageView alloc]initWithFrame:CGRectMake(0,UA_TOP_BAR_HEIGHT+UA_TOP_WHITE, self.view.frame.size.width, self.view.frame.size.height-UA_TOP_BAR_HEIGHT-UA_TOP_WHITE)];
            introView.image=[introPics objectAtIndex:i];
            [introPicsViews addObject:introView];
        }
        currentNoInIntro=0;
       
        [self.view addSubview:[introPicsViews objectAtIndex:0]];

        
        
        nextButton=UA_ICON_NEXT;
        //nextButtonView=[[UIImageView alloc]initWithFrame:CGRectMake(self.canvas.width-nextButton.size.width-20, self.canvas.height-nextButton.size.height-20, 80, 34)];
        nextButtonView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-100, 80, 34)];
        nextButtonView.image=nextButton;
        [self.view addSubview:nextButtonView];
        nextButtonView.userInteractionEnabled=YES;
        //[self listenFor:@"touchesBegan" fromObject:nextButtonView andRunMethod:@"nextIntroPic"];
        UITapGestureRecognizer *nextButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextIntroPic)];
        nextButtonTap.numberOfTapsRequired = 1;
        [nextButtonView addGestureRecognizer:nextButtonTap];
    } else{
        [self cameraSetup];
    }

}
-(void)nextIntroPic{
    NSLog(@"nextIntroPic");
    //remove old
    UIImageView *image=[introPicsViews objectAtIndex:currentNoInIntro];
    
    [image removeFromSuperview];
    [nextButtonView removeFromSuperview];
    //[self stopListeningFor:@"touchesBegan" object:nextButton];
    if (currentNoInIntro==1) {
        [webadress removeFromSuperview];
    }
    //next number
    currentNoInIntro++;
    if (currentNoInIntro<[introPics count]) {
        //add next
        
        [self.view addSubview:[introPicsViews objectAtIndex:currentNoInIntro]];
        
        if (currentNoInIntro==1) {
            
            CGRect labelFrame = CGRectMake( 25, self.view.frame.size.height-150, 100, 30 );
            UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
            [label setText: @"My Label"];
            [label setTextColor: [UIColor orangeColor]];
            [self.view addSubview: label];
            
            webadress=[[UILabel alloc] initWithFrame:labelFrame];
            [webadress setText:@"www.ualphabets.com"];
            [webadress setTextColor:UA_GREY_TYPE_COLOR];
           // webadress.origin=CGPointMake(25, self.view.frame.size.height-150);
            [self.view addSubview:webadress];
            
        }
        if (currentNoInIntro==2) {
            //add text field
            CGRect textViewFrame = CGRectMake(20, 200, self.view.frame.size.width-2*20, 25.0f);
            userNameField = [[UITextView alloc] initWithFrame:textViewFrame];
            userNameField.returnKeyType = UIReturnKeyDone;
            userNameField.layer.borderWidth=1.0f;
            userNameField.layer.borderColor=[UA_OVERLAY_COLOR CGColor];
            [userNameField becomeFirstResponder];
            userNameField.delegate = self;
            [self.view addSubview:userNameField];
        }
        [self.view addSubview:nextButtonView];
        //[self listenFor:@"touchesBegan" fromObject:nextButtonView andRunMethod:@"nextIntroPic"];
    } else{
        self.title=@"Take Photo";
        [self cameraSetup];
    }
    
}


-(void)viewDidLoad{
    self.userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}

-(void)saveUserName{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.userName=userNameField.text;
    [defaults setValue:self.userName forKey:@"userName"];
    [defaults synchronize];
    //and remove the username stuff
    [userNameField removeFromSuperview];
}
-(void)cameraSetup{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:imagePicker animated:NO completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}
/*- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //show camera...
    if (!hasLoadedCamera)
        [self performSelector:@selector(cameraSetup) withObject:nil afterDelay:0.3];
}*/
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //This creates a filepath with the current date/time as the name to save the image
    //NSString *presentTimeStamp = [Utilities getPresentDateTime];
    //NSString *fileSavePath = [Utilities documentsPath:presentTimeStamp];
    //fileSavePath = [fileSavePath stringByAppendingString:@".png"];
    
    //This checks to see if the image was edited, if it was it saves the edited version as a .png
    if ([info objectForKey:UIImagePickerControllerEditedImage]) {
        //save the edited image
       // NSData *imgPngData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
        //[imgPngData writeToFile:fileSavePath atomically:YES];
        
        
    }else{
        //save the original image
        NSData *imgPngData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);
        capturedImage=[UIImage imageWithData:imgPngData];
        //[imgPngData writeToFile:fileSavePath atomically:YES];
        
    }
    [self dismissModalViewControllerAnimated:YES];
    [self goToCropPhoto];
}

-(void)goToCropPhoto {
    self.img = capturedImage;
    cropPhoto = [[CropPhoto alloc] initWithNibName:@"CropPhoto" bundle:[NSBundle mainBundle]];
    [cropPhoto displayImage:self.img];
    [cropPhoto setup];
    NSLog(@"SELF.IMG: %@", self.img);
    [self.navigationController pushViewController:cropPhoto animated:NO];
}

-(void)goToPhotoLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}
 //--------------------------------------------------
//load image from photo library
 //--------------------------------------------------
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.img = image;
    cropPhoto = [[CropPhoto alloc] initWithNibName:@"CropPhoto" bundle:[NSBundle mainBundle]];
    [cropPhoto displayImage:self.img];
    [cropPhoto setup];
    [self.navigationController pushViewController:cropPhoto animated:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
//--------------------------------------------------
//load default alphabet
//--------------------------------------------------
-(void)loadDefaultAlphabet{
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"] ||[self.currentLanguage isEqualToString:@"German"]||[self.currentLanguage isEqualToString:@"Danish/Norwegian"]||[self.currentLanguage isEqualToString:@"English"]||[self.currentLanguage isEqualToString:@"Spanish"]) {
        self.currentAlphabet=[NSMutableArray arrayWithObjects:
                              //first row
                              [UIImage imageNamed:@"letter_A.png"],
                              [UIImage imageNamed:@"letter_B.png"],
                              [UIImage imageNamed:@"letter_C.png"],
                              [UIImage imageNamed:@"letter_D.png"],
                              [UIImage imageNamed:@"letter_E.png"],
                              [UIImage imageNamed:@"letter_F.png"],
                              //second row
                              [UIImage imageNamed:@"letter_G.png"],
                              [UIImage imageNamed:@"letter_H.png"],
                              [UIImage imageNamed:@"letter_I.png"],
                              [UIImage imageNamed:@"letter_J.png"],
                              [UIImage imageNamed:@"letter_K.png"],
                              [UIImage imageNamed:@"letter_L.png"],
                              
                              [UIImage imageNamed:@"letter_M.png"],
                              [UIImage imageNamed:@"letter_N.png"],
                              [UIImage imageNamed:@"letter_O.png"],
                              [UIImage imageNamed:@"letter_P.png"],
                              [UIImage imageNamed:@"letter_Q.png"],
                              [UIImage imageNamed:@"letter_R.png"],
                              
                              [UIImage imageNamed:@"letter_S.png"],
                              [UIImage imageNamed:@"letter_T.png"],
                              [UIImage imageNamed:@"letter_U.png"],
                              [UIImage imageNamed:@"letter_V.png"],
                              [UIImage imageNamed:@"letter_W.png"],
                              [UIImage imageNamed:@"letter_X.png"],
                              
                              [UIImage imageNamed:@"letter_Y.png"],
                              [UIImage imageNamed:@"letter_Z.png"],
                              //here the special characters will be inserted
                              [UIImage imageNamed:@"letter_.png"],//.
                              
                              [UIImage imageNamed:@"letter_!.png"],
                              [UIImage imageNamed:@"letter_-.png"],//?
                              [UIImage imageNamed:@"letter_0.png"],
                              [UIImage imageNamed:@"letter_1.png"],
                              [UIImage imageNamed:@"letter_2.png"],
                              [UIImage imageNamed:@"letter_3.png"],
                              
                              [UIImage imageNamed:@"letter_4.png"],
                              [UIImage imageNamed:@"letter_5.png"],
                              [UIImage imageNamed:@"letter_6.png"],
                              [UIImage imageNamed:@"letter_7.png"],
                              [UIImage imageNamed:@"letter_8.png"],
                              [UIImage imageNamed:@"letter_9.png"],
                              nil];
        if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]) {
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Ä.png"] atIndex:26];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Ö.png"] atIndex:27];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Å.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"German"]) {
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Ä.png"] atIndex:26];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Ö.png"] atIndex:27];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Ü.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"Danish/Norwegian"]) {
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_ae.png"] atIndex:26];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_danisho.png"] atIndex:27];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Å.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"English"]) {
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_+.png"] atIndex:26];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_$.png"] atIndex:27];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_,.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"Spanish"]) {
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_spanishN.png"] atIndex:26];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_+.png"] atIndex:27];
            [self.currentAlphabet insertObject:[UIImage imageNamed:@"letter_,.png"] atIndex:28];
        }
    } else{
        self.currentAlphabet=[NSMutableArray arrayWithObjects:
                              //first row
                              [UIImage imageNamed:@"letter_A.png"],
                              [UIImage imageNamed:@"letter_RusB.png"],
                              [UIImage imageNamed:@"letter_B.png"],
                              [UIImage imageNamed:@"letter_RusG.png"],
                              [UIImage imageNamed:@"letter_RusD.png"],
                              [UIImage imageNamed:@"letter_E.png"],
                              //second row
                              [UIImage imageNamed:@"letter_RusJo.png"],
                              [UIImage imageNamed:@"letter_RusSche.png"],
                              [UIImage imageNamed:@"letter_RusSe.png"],
                              [UIImage imageNamed:@"letter_RusI.png"],
                              [UIImage imageNamed:@"letter_RusIkratkoje.png"],
                              [UIImage imageNamed:@"letter_K.png"],
                              
                              [UIImage imageNamed:@"letter_RusL.png"],
                              [UIImage imageNamed:@"letter_M.png"],
                              [UIImage imageNamed:@"letter_RusN.png"],
                              [UIImage imageNamed:@"letter_O.png"],
                              [UIImage imageNamed:@"letter_RusP.png"],
                              [UIImage imageNamed:@"letter_P.png"],
                              
                              [UIImage imageNamed:@"letter_C.png"],
                              [UIImage imageNamed:@"letter_T.png"],
                              [UIImage imageNamed:@"letter_Y.png"],
                              [UIImage imageNamed:@"letter_RusF.png"],
                              [UIImage imageNamed:@"letter_X.png"],
                              [UIImage imageNamed:@"letter_RusZ.png"],
                              
                              [UIImage imageNamed:@"letter_RusTsche.png"],
                              [UIImage imageNamed:@"letter_RusScha.png"],
                              [UIImage imageNamed:@"letter_RusTschescha.png"],
                              [UIImage imageNamed:@"letter_RusMjachkiSnak.png"],
                              [UIImage imageNamed:@"letter_RusUi.png"],
                              [UIImage imageNamed:@"letter_RusE.png"],
                              
                              [UIImage imageNamed:@"letter_RusJu.png"],
                              [UIImage imageNamed:@"letter_RusJa.png"],
                              [UIImage imageNamed:@"letter_0.png"],
                              [UIImage imageNamed:@"letter_1.png"],
                              [UIImage imageNamed:@"letter_2.png"],
                              [UIImage imageNamed:@"letter_3.png"],
                              
                              [UIImage imageNamed:@"letter_4.png"],
                              [UIImage imageNamed:@"letter_5.png"],
                              [UIImage imageNamed:@"letter_6.png"],
                              [UIImage imageNamed:@"letter_7.png"],
                              [UIImage imageNamed:@"letter_8.png"],
                              [UIImage imageNamed:@"letter_9.png"],
                              nil];
    }
    self.finnish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"Ä", @"Ö", @"Å", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.german=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"Ä", @"Ö", @"Ü", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.danish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"ae", @"danisho", @"Å", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.english=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"+", @"$", @",", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.spanish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"spanishN", @"+", @",", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.russian=[NSArray arrayWithObjects:@"A", @"RusB", @"B", @"RusG", @"RusD", @"E", @"RusJo", @"RusSche", @"RusSe", @"RusI", @"RusIkratkoje", @"K", @"RusL", @"M", @"RusN", @"O", @"RusP", @"P", @"C", @"T", @"Y", @"RusF", @"X", @"RusZ", @"RusTsche", @"RusScha", @"RusTschescha", @"RusMjachkiSnak", @"RusUi", @"RusE", @"RusJu", @"RusJa", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",nil];
    
}
//--------------------------------------------------
//save alphabet when app becomes inactive
//--------------------------------------------------
-(void)appWillResignActive:(NSNotification*)note
{
    //save all images under alphabetName
    [self writeAlphabetsUserDefaults];
}
-(void)writeAlphabetsUserDefaults{
    NSUserDefaults *alphabetName=[NSUserDefaults standardUserDefaults];
    [alphabetName setValue:self.alphabetName forKey:@"alphabetName"];
    [alphabetName setValue:self.currentLanguage forKey:@"language"];
    [alphabetName setValue:self.myAlphabets forKey:@"myAlphabets"];
    [alphabetName setValue:self.myAlphabetsLanguages forKey:@"myAlphabetsLanguages"];
    [alphabetName synchronize];
}
-(void)appWillBecomeActive:(NSNotification*)note{
    NSString *loadedName;
    loadedName=[[NSUserDefaults standardUserDefaults] objectForKey:@"alphabetName"];
    if (!loadedName) {
        self.alphabetName=@"Untitled";
        //[self.myAlphabets addObject:self.alphabetName];
        [self.myAlphabetsLanguages addObject:self.currentLanguage];
        //set default alphabet name as first user default
        NSUserDefaults *alphabetName=[NSUserDefaults standardUserDefaults];
        [alphabetName setValue:self.alphabetName forKey:@"alphabetName"];
        [alphabetName synchronize];
    } else{
        self.alphabetName=loadedName;
    }
    
    NSString *loadedLanguage=[[NSUserDefaults standardUserDefaults]objectForKey:@"language"];
    if (loadedLanguage) {
        self.currentLanguage=loadedLanguage;
    }
    NSMutableArray *alphabets=[[NSUserDefaults standardUserDefaults]objectForKey:@"myAlphabets"];
    if (alphabets) {
        self.myAlphabets=[alphabets mutableCopy];
    }  else{
        [self.myAlphabets addObject:self.alphabetName];
    }
    NSMutableArray *AlphabetsLanguages=[[NSUserDefaults standardUserDefaults]objectForKey:@"myAlphabetsLanguages"];
    if (AlphabetsLanguages) {
        self.myAlphabetsLanguages=[AlphabetsLanguages mutableCopy];
    }else{
        [self.myAlphabetsLanguages addObject:self.currentLanguage];
    }
    [self loadCorrectAlphabet];
    }
-(void)loadCorrectAlphabet{
    //load default alphabet (in case needed)
    [self loadDefaultAlphabet];
    //loading all letters
    NSString *path= [[self documentsDirectory] stringByAppendingString:@"/"];
    path=[path stringByAppendingPathComponent:self.alphabetName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSMutableArray *defaultAlphabet=[self.currentAlphabet mutableCopy];
        self.currentAlphabet=[[NSMutableArray alloc]init];
        for (int i=0; i<42; i++) {
            NSString *letterToAdd=@" ";
            if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]) {
                letterToAdd=[self.finnish objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"German"]){
                letterToAdd=[self.german objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"English"]){
                letterToAdd=[self.english objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"Danish/Norwegian"]){
                letterToAdd=[self.danish objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"Spanish"]){
                letterToAdd=[self.spanish objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"Russian"]){
                letterToAdd=[self.russian objectAtIndex:i];
            }
            
            NSString *filePath=[[path stringByAppendingPathComponent:letterToAdd] stringByAppendingString:@".jpg"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                NSData *imageData = [NSData dataWithContentsOfFile:filePath];
                UIImage *img = [UIImage imageWithData:imageData];
                loadedImage=img;
            }else{
                loadedImage=[defaultAlphabet objectAtIndex:i];
            }
            [self.currentAlphabet addObject:loadedImage];
        }
    }

}

-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(currentImageToExport.size.width, currentImageToExport.size.height), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    //NSData *imageData = UIImagePNGRepresentation(image);
    NSData *imageData = UIImageJPEGRepresentation(image,80);
    //save in a certain folder
    NSString *dataPath = [[self documentsDirectory] stringByAppendingString:@"/"];
    dataPath=[dataPath stringByAppendingPathComponent:self.alphabetName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *savePath = [dataPath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
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
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView becomes active, or is the First Responder
     --*/
    
    NSLog(@"textViewDidBeginEditing:");
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //prepare next view and go there
    [self saveUserName];
    [self nextIntroPic];
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
    //NSLog(@"textViewDidChange:");
    //This method is called when the user makes a change to the text in the textview
}

@end
