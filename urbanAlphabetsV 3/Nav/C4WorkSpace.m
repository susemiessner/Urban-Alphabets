//
//  C4WorkSpace.m
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4Workspace.h"
#import "CropPhoto.h"
#import <AVFoundation/AVFoundation.h>
#define degreesToRadians(x) (M_PI * x / 180.0)

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
    UIImageView *loadedImage;
    
    UIImagePickerController *picker;
    float yPosIntro;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.isCameraAlreadySetup = NO;
}

-(void)setup {
    self.title=@"Take Photo";

    //load the defaults
    self.currentLanguage= @"Finnish/Swedish";
    self.myAlphabets=[[NSMutableArray alloc]init];
    self.myAlphabetsLanguages=[[NSMutableArray alloc]init];
    self.alphabetName=@"Untitled";
    self.languages=[NSMutableArray arrayWithObjects:@"Danish/Norwegian", @"English", @"Finnish/Swedish", @"German", @"Russian", @"Spanish", nil];

    //to see when app becomes active/inactive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

}
-(void)viewDidAppear:(BOOL)animated{
    
    self.userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    if (self.userName==nil) {
        self.title=@"Intro";
        
        //check which device
        if ( UA_IPHONE_5_HEIGHT != [[UIScreen mainScreen] bounds].size.height) {
            yPosIntro=-88;
            introPics=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"intro__1_iphone4"],[UIImage imageNamed:@"intro_3"],[UIImage imageNamed:@"intro__4_iphone4"],[UIImage imageNamed:@"intro_5"], nil];
        } else{
            yPosIntro=0;
            introPics=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"intro_1_1.png"],[UIImage imageNamed:@"intro_3"],[UIImage imageNamed:@"intro_4"],[UIImage imageNamed:@"intro_5"], nil];
        }
        introPicsViews=[[NSMutableArray alloc]init];
        for (int i=0; i<[introPics count]; i++) {
            UIImageView *introView=[[UIImageView alloc]initWithFrame:CGRectMake(0,UA_TOP_BAR_HEIGHT+UA_TOP_WHITE, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width*1.57744)];
            introView.image=[introPics objectAtIndex:i];
            [introPicsViews addObject:introView];
        }
        currentNoInIntro=0;
        
        [self.view addSubview:[introPicsViews objectAtIndex:0]];
        
        
        
        nextButton=UA_ICON_NEXT;
        //nextButtonView=[[UIImageView alloc]initWithFrame:CGRectMake(self.canvas.width-nextButton.size.width-20, self.canvas.height-nextButton.size.height-20, 80, 34)];
        nextButtonView=[[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-100, [[UIScreen mainScreen] bounds].size.height-100+yPosIntro, 80, 34)];
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
            
            CGRect labelFrame = CGRectMake( 25, [[UIScreen mainScreen] bounds].size.height-150, 300, 30 );
            
            webadress=[[UILabel alloc] initWithFrame:labelFrame];
            [webadress setText:@"www.ualphabets.com"];
            [webadress setTextColor:UA_GREY_TYPE_COLOR];
           // webadress.origin=CGPointMake(25, [[UIScreen mainScreen] bounds].size.height-150);
            [self.view addSubview:webadress];
            
        }
        if (currentNoInIntro==2) {
            //add text field
            CGRect textViewFrame = CGRectMake(20, 200+yPosIntro, [[UIScreen mainScreen] bounds].size.width-2*20, 25.0f);
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


-(void)saveUserName{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.userName=userNameField.text;
    [defaults setValue:self.userName forKey:@"userName"];
    [defaults synchronize];
    //and remove the username stuff
    [userNameField removeFromSuperview];
}
// new setup camera code
-(void)cameraSetup
{
    // verification to not set up again
    if (!self.isCameraAlreadySetup)
    {
        
        self.isCameraAlreadySetup = YES;
        self.previewLayerHostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        
        [self.view addSubview:self.previewLayerHostView];
        //if we wanted to display sth on top of the image (e.g. skip crop photo)
        //UIImageView *gridView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        //[gridView setImage:[UIImage imageNamed:@"cameragrid480.png"]];
        //[self.view addSubview:gridView];
        
        //crete the "snapshot" display layer
        self.stillLayer=[CALayer layer];
        
        //prepare the preview layer host view
        [self.previewLayerHostView.layer addSublayer:self.stillLayer];
        
        self.avSession=[AVCaptureSession new];
        self.avSession.sessionPreset=AVCaptureSessionPresetPhoto;
        
        self.avSnapper=[AVCaptureStillImageOutput new];
        self.avSnapper.outputSettings=[NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        [self.avSession addOutput:self.avSnapper];
        
        NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        AVCaptureDevice *camera = nil;
        
        for (AVCaptureDevice *device in videoDevices)
        {
            if (device.position == AVCaptureDevicePositionBack)
            {
                camera=device;
                break;
            }
        }
        
        NSError *error=nil;
        AVCaptureDeviceInput *input=[AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
        
        if(nil!=error)
        {
            return;
        }
        
        [self.avSession addInput:input];
        
        //assign the preview layer and setup the image frames and transformation for device orientation
        self.avPreviewLayer=[[AVCaptureVideoPreviewLayer alloc] initWithSession:self.avSession];
        
        self.avPreviewLayer.frame = self.previewLayerHostView.frame;
        
        CATransform3D transform=CATransform3DIdentity;
        transform=CATransform3DRotate(transform, degreesToRadians(90), 0.0, 0.0, 1.0);
        transform=CATransform3DScale(transform,1.0,1.0,1.0);
        
        self.stillLayer.transform=transform;
        
        double proportion = 640.0/480.0;
        double imageTop = ([[UIScreen mainScreen] bounds].size.height / 2.0) - (320*proportion / 2.0);
        
        self.stillLayer.frame = CGRectMake(0,imageTop,320,(320*640)/480);
        
        [self adjustImageFramesForDeviceOrientation:nil];
        
        //add the layer
        [self.previewLayerHostView.layer addSublayer:self.avPreviewLayer];
        [self.previewLayerHostView.layer setMasksToBounds:YES];
        
        //start the session
        [self.avSession startRunning];
        
        self.isPhotoBeingTaken = YES;
        
        
        CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
        self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_PHOTOLIBRARY withFrame:CGRectMake(0, 0, 45, 22.5) centerIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 90, 45) rightIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 70, 35)];
        [self.view addSubview:self.bottomNavBar];
        
        UITapGestureRecognizer *takePhotoButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(take)];
        takePhotoButtonRecognizer.numberOfTapsRequired = 1;
        [self.bottomNavBar.centerImageView addGestureRecognizer:takePhotoButtonRecognizer];


        
        UITapGestureRecognizer *photoLibraryButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPhotoLibrary)];
        photoLibraryButtonRecognizer.numberOfTapsRequired = 1;
        [self.bottomNavBar.leftImageView addGestureRecognizer:photoLibraryButtonRecognizer];
        
       
        
        self.bottomNavBar.rightImageView.hidden = YES;
    }
    else
    {
        [self cameraPrepareToRetake];
        self.bottomNavBar.rightImageView.hidden = YES;
    }
    
    if (![self.avSession isRunning])
    {
        [self.avSession startRunning];
    }
    
}

// to fix some orientation problems that I've found in AVFoundation classes
-(void)adjustImageFramesForDeviceOrientation:(NSNotification*)notification
{
    UIDeviceOrientation orientation=[[UIDevice currentDevice] orientation];
    
    if(orientation==UIInterfaceOrientationLandscapeRight)
    {
        CATransform3D transform = CATransform3DIdentity;
        transform=CATransform3DRotate(transform, degreesToRadians(0), 0.0, 0.0, 1.0);
        
        self.avPreviewLayer.transform=transform;
    }
    else if(orientation==UIInterfaceOrientationLandscapeLeft)
    {
        CATransform3D transform = CATransform3DIdentity;
        transform=CATransform3DRotate(transform, degreesToRadians(0), 0.0, 0.0, 1.0);
        
        self.avPreviewLayer.transform=transform;
    }
    
}

// this prepares to takes the picture
-(void)take
{
    if (self.isPhotoBeingTaken)
    {
        [self snapshot];
        [self.bottomNavBar changeCenterImage:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45)];
        self.bottomNavBar.rightImageView.hidden = NO;
        
        //retakes the photo
        UITapGestureRecognizer *photoSelectedButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelected)];
        photoSelectedButtonRecognizer.numberOfTapsRequired = 1;
        [self.bottomNavBar.centerImageView addGestureRecognizer:photoSelectedButtonRecognizer];
        
        UITapGestureRecognizer *takePhotoButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(take)];
        takePhotoButtonRecognizer.numberOfTapsRequired = 1;
        [self.bottomNavBar.rightImageView addGestureRecognizer:takePhotoButtonRecognizer];

        
        self.isPhotoBeingTaken = NO;
    }
    else
    {
        [self cameraPrepareToRetake];
        self.isPhotoBeingTaken = YES;
    }
}

// when re-taking, this just hides the picture taken
-(void)cameraPrepareToRetake
{
    self.avPreviewLayer.opacity = 1.0;
    
    [self.bottomNavBar changeCenterImage:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 90, 45)];
    self.bottomNavBar.rightImageView.hidden = YES;
    
    UITapGestureRecognizer *takePhotoButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(take)];
    takePhotoButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:takePhotoButtonRecognizer];
}

// snapshot and show picture on screen
-(void)snapshot
{
    AVCaptureConnection *captureConnection=[self.avSnapper connectionWithMediaType:AVMediaTypeVideo];
    
    typedef void (^BufferBlock)(CMSampleBufferRef, NSError*);
    
    BufferBlock handler=^(CMSampleBufferRef buffer, NSError *error)
    {
        NSData *data=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buffer];
        
        dispatch_async(dispatch_get_main_queue(),^(void)
                       {
                           [self adjustImageFramesForDeviceOrientation:nil];
                           
                           self.avPreviewLayer.opacity=0.0;
                           self.stillLayer.contents=(id)[[UIImage alloc] initWithData:data].CGImage;
                           capturedImage = nil;
                           capturedImage = [[UIImage alloc] initWithData:data];
                       });
    };
    
    [self.avSnapper captureStillImageAsynchronouslyFromConnection:captureConnection
                                                completionHandler:handler];
}

// method used when pressing OK button
-(void)imageSelected
{
    [self.avSession stopRunning];
    [self goToCropPhoto];
}



-(void)goToCropPhoto {
    self.img = capturedImage;
    cropPhoto = [[CropPhoto alloc] initWithNibName:@"CropPhoto" bundle:[NSBundle mainBundle]];
    [cropPhoto displayImage:self.img];
    [cropPhoto setup];
    [self.navigationController pushViewController:cropPhoto animated:NO];
}

-(void)goToPhotoLibrary{
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.delegate = self;
    pickerLibrary.allowsEditing = YES;
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerLibrary animated:YES completion:NULL];
}
 //--------------------------------------------------
//load image from photo library
 //--------------------------------------------------
- (void) imagePickerController:(UIImagePickerController *)pickerLibrary didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.img = image;
    cropPhoto = [[CropPhoto alloc] initWithNibName:@"CropPhoto" bundle:[NSBundle mainBundle]];
    [cropPhoto displayImage:self.img];
    [cropPhoto setup];
    [self.navigationController pushViewController:cropPhoto animated:YES];
    [pickerLibrary dismissViewControllerAnimated:YES completion:NULL];
}
//--------------------------------------------------
//load default alphabet
//--------------------------------------------------
-(void)loadDefaultAlphabet{
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"] ||[self.currentLanguage isEqualToString:@"German"]||[self.currentLanguage isEqualToString:@"Danish/Norwegian"]||[self.currentLanguage isEqualToString:@"English"]||[self.currentLanguage isEqualToString:@"Spanish"]) {
        self.currentAlphabetUIImage=[NSMutableArray arrayWithObjects:
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
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ä.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ö.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Å.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"German"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ä.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ö.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ü.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"Danish/Norwegian"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_ae.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_danisho.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Å.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"English"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_+.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_$.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_,.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"Spanish"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_spanishN.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_+.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_,.png"] atIndex:28];
        }
    } else{
        self.currentAlphabetUIImage=[NSMutableArray arrayWithObjects:
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
    self.currentAlphabet=[[NSMutableArray alloc]init];
    for (int i=0; i<[self.currentAlphabetUIImage count]; i++) {
        [self.currentAlphabet addObject:[[UIImageView alloc]initWithImage:[self.currentAlphabetUIImage objectAtIndex:i]]];
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
                UIImageView *imgView=[[UIImageView alloc]initWithImage:img];
                loadedImage=imgView;
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
    //This method is called when the user makes a change to the text in the textview
}

@end
