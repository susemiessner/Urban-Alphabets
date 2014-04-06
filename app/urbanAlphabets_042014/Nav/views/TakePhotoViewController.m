//
//  TakePhotoViewController.m
//  UAlphabets
//
//  Created by Suse on 05/04/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "bottomNavBar.h"
#import "CropPhoto.h"
#define degreesToRadians(x) (M_PI * x / 180.0)

@interface TakePhotoViewController (){
    CropPhoto *cropPhoto;

    
    UIImage *capturedImage;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@end

@implementation TakePhotoViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.isCameraAlreadySetup = NO;
}
-(void)setup{
    self.title=@"Take Photo";
    
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    
    [self cameraSetup];
}
-(void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
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


@end
