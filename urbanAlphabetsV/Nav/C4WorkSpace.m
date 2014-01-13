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
    
    C4Camera *cam;
    
    //to set a username when first using the app
    UITextView *userNameField;
    C4Image *okImage;
    C4Label *userNameLabel, *enterUserNameLabel;
   // NSString *userName;
    C4Shape *backgroundRect;
    
    //saving image
    CGContextRef graphicsContext;
    C4Image *currentImageToExport;

}

-(void)setup {
    self.title=@"Take Photo";

    //load the defaults
    [self loadDefaultAlphabet];
    self.currentLanguage= @"Finnish/Swedish";
    self.myAlphabets=[[NSMutableArray alloc]init];
    self.myAlphabetsLanguages=[[NSMutableArray alloc]init];
    self.alphabetName=@"Untitled";
    //C4Log(@"myAlphabets: %@",self.myAlphabets);
    self.languages=[NSArray arrayWithObjects:@"Danish/Norwegian", @"English", @"Finnish/Swedish", @"German", @"Russian", @"Spanish", nil];

        //to see when app becomes active/inactive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //setup the TakePhoto view
    [self cameraSetup];
    
    //setup the bottom bar
    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_PHOTOLIBRARY withFrame:CGRectMake(0, 0, 45, 22.5) centerIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 90, 45)];
    [self.canvas addShape:self.bottomNavBar];
    //take photo button
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"captureImage"];
    //photo library button
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToPhotoLibrary"];
    
    
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"goToCropPhoto"];
    
    if (self.userName==nil) {
        //backgroundrect
        backgroundRect=[C4Shape rect:CGRectMake(20, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+30, self.canvas.width-40, 180)];
        backgroundRect.fillColor=UA_NAV_BAR_COLOR;
        backgroundRect.strokeColor=UA_NAV_CTRL_COLOR;
        [self.canvas addShape:backgroundRect];
        
        //enterUserNameLabel
        enterUserNameLabel=[C4Label labelWithText:@"Please choose a user name:" font:UA_FAT_FONT];
        enterUserNameLabel.origin=CGPointMake(backgroundRect.origin.x+10, backgroundRect.origin.y+20);
        [self.canvas addLabel:enterUserNameLabel];
        
        //UserNameLabel:
        userNameLabel=[C4Label labelWithText:@"username:" font:UA_NORMAL_FONT];
        userNameLabel.textColor=UA_TYPE_COLOR;
        userNameLabel.origin=CGPointMake(backgroundRect.origin.x+10, backgroundRect.origin.y+50);
        [self.canvas addLabel:userNameLabel];
        
        //add text field
        CGRect textViewFrame = CGRectMake(backgroundRect.origin.x+userNameLabel.width+20, backgroundRect.origin.y+50, backgroundRect.width-userNameLabel.width-30, 20.0f);
        userNameField = [[UITextView alloc] initWithFrame:textViewFrame];
        userNameField.returnKeyType = UIReturnKeyDone;
        [userNameField becomeFirstResponder];
        userNameField.delegate = self;
        [self.view addSubview:userNameField];
        
        //saveButton =okImage
        okImage=[C4Image imageWithImage:UA_ICON_OK];
        okImage.width=100;
        okImage.origin=CGPointMake(self.canvas.center.x-okImage.width/2, backgroundRect.center.y+10);
        [self listenFor:@"touchesBegan" fromObject:okImage andRunMethod:@"saveUserName"];
        
        [self.canvas addImage:okImage];
        
    }

}
-(void)viewDidLoad{
    self.userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    //C4Log(@"userName:%@", self.userName);

}
-(void)saveUserName{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.userName=userNameField.text;
    [defaults setValue:self.userName forKey:@"userName"];
    //C4Log(@"userName:%@", self.userName);
    [defaults synchronize];
    //C4Log(@"defaults: %@", [defaults objectForKey:@"userName"]);
    //and remove the username stuff
    [backgroundRect removeFromSuperview];
    [enterUserNameLabel removeFromSuperview];
    [userNameLabel removeFromSuperview];
    [userNameField removeFromSuperview];
    [okImage removeFromSuperview];
}
-(void)cameraSetup{
    cam = [C4Camera cameraWithFrame:CGRectMake(0,0, self.canvas.width, self.canvas.height)];
    cam.cameraPosition = CAMERABACK;
    [self.canvas addCamera:cam];
    [cam initCapture];
    
}
-(void)captureImage{
    self.bottomNavBar.centerImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    [cam captureImage];
    //C4Log(@"capturing image");
}

-(void)goToCropPhoto {
    self.img = cam.capturedImage;
    C4Log(@"goToCropPhoto");
    cropPhoto = [[CropPhoto alloc] initWithNibName:@"CropPhoto" bundle:[NSBundle mainBundle]];
    [cropPhoto displayImage:self.img];
    [cropPhoto setup];
    
    [self.navigationController pushViewController:cropPhoto animated:YES];
}
-(void)goToPhotoLibrary{
    C4Log(@"goToPhotoLibrary");

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
    //C4Log(@"done");

    
    self.img = [C4Image imageWithUIImage:image];
    C4Log(@"goToCropPhoto");
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
    //C4Log(@"loading default alphabet");
    //self.currentAlphabet=[[NSMutableArray alloc]init];
    self.currentAlphabet=[NSMutableArray arrayWithObjects:
                          //first row
                          [C4Image imageNamed:@"letter_A.png"],
                          [C4Image imageNamed:@"letter_B.png"],
                          [C4Image imageNamed:@"letter_C.png"],
                          [C4Image imageNamed:@"letter_D.png"],
                          [C4Image imageNamed:@"letter_E.png"],
                          [C4Image imageNamed:@"letter_F.png"],
                          //second row
                          [C4Image imageNamed:@"letter_G.png"],
                          [C4Image imageNamed:@"letter_H.png"],
                          [C4Image imageNamed:@"letter_I.png"],
                          [C4Image imageNamed:@"letter_J.png"],
                          [C4Image imageNamed:@"letter_K.png"],
                          [C4Image imageNamed:@"letter_L.png"],
                          
                          [C4Image imageNamed:@"letter_M.png"],
                          [C4Image imageNamed:@"letter_N.png"],
                          [C4Image imageNamed:@"letter_O.png"],
                          [C4Image imageNamed:@"letter_P.png"],
                          [C4Image imageNamed:@"letter_Q.png"],
                          [C4Image imageNamed:@"letter_R.png"],
                          
                          [C4Image imageNamed:@"letter_S.png"],
                          [C4Image imageNamed:@"letter_T.png"],
                          [C4Image imageNamed:@"letter_U.png"],
                          [C4Image imageNamed:@"letter_V.png"],
                          [C4Image imageNamed:@"letter_W.png"],
                          [C4Image imageNamed:@"letter_X.png"],
                          
                          [C4Image imageNamed:@"letter_Y.png"],
                          [C4Image imageNamed:@"letter_Z.png"],
                          [C4Image imageNamed:@"letter_Ä.png"],
                          [C4Image imageNamed:@"letter_Ö.png"],
                          [C4Image imageNamed:@"letter_Å.png"],
                          [C4Image imageNamed:@"letter_.png"],//.
                          
                          [C4Image imageNamed:@"letter_!.png"],
                          [C4Image imageNamed:@"letter_-.png"],//?
                          [C4Image imageNamed:@"letter_0.png"],
                          [C4Image imageNamed:@"letter_1.png"],
                          [C4Image imageNamed:@"letter_2.png"],
                          [C4Image imageNamed:@"letter_3.png"],
                          
                          [C4Image imageNamed:@"letter_4.png"],
                          [C4Image imageNamed:@"letter_5.png"],
                          [C4Image imageNamed:@"letter_6.png"],
                          [C4Image imageNamed:@"letter_7.png"],
                          [C4Image imageNamed:@"letter_8.png"],
                          [C4Image imageNamed:@"letter_9.png"],
                          
                          /* //the ones from the other languages
                           [C4Image imageNamed:@"letter_,.png"], //42
                           [C4Image imageNamed:@"letter_$.png"], //43
                           [C4Image imageNamed:@"letter_+.png"], //44
                           [C4Image imageNamed:@"letter_ae.png"],//45
                           [C4Image imageNamed:@"letter_danisho.png"], //46
                           [C4Image imageNamed:@"letter_Ü.png"], //47*/
                          nil];
    //C4Log(@"%@",self.currentAlphabet);
}
//--------------------------------------------------
//save alphabet when app becomes inactive
//--------------------------------------------------
-(void)appWillResignActive:(NSNotification*)note
{
    C4Log(@"working");
    //save all images under alphabetName
    [self exportHighResImage];
    [self writeAlphabetsUserDefaults];
}
-(void)writeAlphabetsUserDefaults{
    NSUserDefaults *alphabetName=[NSUserDefaults standardUserDefaults];
    [alphabetName setValue:self.alphabetName forKey:@"alphabetName"];
    [alphabetName setValue:self.currentLanguage forKey:@"language"];
    [alphabetName setValue:self.myAlphabets forKey:@"myAlphabets"];
    [alphabetName setValue:self.myAlphabetsLanguages forKey:@"myAlphabetsLanguages"];
    [alphabetName synchronize];
    C4Log(@"alphabetName: %@", self.alphabetName);
}
-(void)appWillBecomeActive:(NSNotification*)note
{
    C4Log(@"becoming active");

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
    C4Log(@"loaded Name    : %@", loadedName);
    C4Log(@"loaded Language: %@", loadedLanguage);
    C4Log(@"loaded Alphabets: %@", alphabets);
    C4Log(@"myAlphabets:      %@", self.myAlphabets);
    //[self.myAlphabets addObject:self.alphabetName];

    //loading all letters
    //NSString *path= [[self documentsDirectory] stringByAppendingString:@"/Untitled"];
    NSString *path= [[self documentsDirectory] stringByAppendingString:@"/"];
    path=[path stringByAppendingPathComponent:self.alphabetName];
     //NSString *path= [self documentsDirectory];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        self.currentAlphabet=[[NSMutableArray alloc]init];
        C4Log(@"directory exists");
        for (int i=0; i<42; i++) {
            NSString *filePath=[[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", i]] stringByAppendingString:@".jpg"];
            //C4Log(@"filePath:%@", filePath);
            NSData *imageData = [NSData dataWithContentsOfFile:filePath];
            UIImage *img = [UIImage imageWithData:imageData];
            //UIImage *image=[UIImage imageNamed:@"0.jpg"];
            
            C4Image *image=[C4Image imageWithUIImage:img];
            [self.currentAlphabet addObject:image];
        }
    } else{
        C4Log(@"directory does NOT exist");
    }
    
}
-(void)exportHighResImage {
    
    for (int i=0; i<[self.currentAlphabet count]; i++) {
        
        currentImageToExport=[self.currentAlphabet objectAtIndex:i];
        graphicsContext = [self createHighResImageContext];
        [currentImageToExport renderInContext:graphicsContext];
        NSString *fileName = [NSString stringWithFormat:@"%d.jpg", i];
        [self saveImage:fileName];
    }
    
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(currentImageToExport.width-1, currentImageToExport.height-1), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    //NSData *imageData = UIImagePNGRepresentation(image);
    NSData *imageData = UIImageJPEGRepresentation(image,80);
    //save in a certain folder
    NSString *dataPath = [[self documentsDirectory] stringByAppendingString:@"/"];
    dataPath=[dataPath stringByAppendingPathComponent:self.alphabetName];

    //C4Log(@"dataPath=%@", dataPath);
    
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
