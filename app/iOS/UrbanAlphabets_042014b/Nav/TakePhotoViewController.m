//
//  TakePhotoViewController.m
//  UAlphabets
//
//  Created by Suse on 05/04/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "bottomNavBar.h"
#import "AssignLetter.h"
#define degreesToRadians(x) (M_PI * x / 180.0)

@interface TakePhotoViewController (){
    C4WorkSpace *workspace;
    AssignLetter *assignLetter;
    //camera setup
    double proportion;
    double imageTop;
    
    UIImage *capturedImage;
    //overlay rectangles
    UIView *upperRect;
    UIView *lowerRect;
    UIView *leftRect;
    UIView *rightRect;
    
    //gesture recognizers for cropping photo
    UIPanGestureRecognizer *panRecognizer;
    UIPinchGestureRecognizer *pinchRecognizer;
    UIRotationGestureRecognizer *rotationRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    
    //corners of cropped image
    float touchX1;
    float touchX2;
    float touchY1;
    float touchY2;
    
    CGContextRef graphicsContext;
    float alphabetFromLeft;

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
-(void)cameraSetup{
    // verification to not set up again
    if (!self.isCameraAlreadySetup)
    {
        
        self.isCameraAlreadySetup = YES;
        self.previewLayerHostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        
        [self.view addSubview:self.previewLayerHostView];
        
        //create the "snapshot" display layer
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
        
        proportion = 640.0/480.0;
        imageTop = ([[UIScreen mainScreen] bounds].size.height / 2.0) - (320*proportion / 2.0);
        
        self.stillLayer.frame = CGRectMake(0,imageTop,320,(320*640)/480);
        
        //[self adjustImageFramesForDeviceOrientation:nil];
        
        //add the layer
        [self.previewLayerHostView.layer addSublayer:self.avPreviewLayer];
        [self.previewLayerHostView.layer setMasksToBounds:YES];
        
        //start the session
        [self.avSession startRunning];
        
        self.isPhotoBeingTaken = YES;
        
        
        CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
        self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_PHOTOLIBRARY withFrame:CGRectMake(0, 0, 60, 30) centerIcon:UA_ICON_TAKE_PHOTO_BIG withFrame:CGRectMake(0, 0, 90, 45) rightIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 70, 35)];
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
-(UIImage*) rotate:(UIImage*) src
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context=(UIGraphicsGetCurrentContext());
    
    
    CGContextRotateCTM (context, 90/180*M_PI) ;
    
    [src drawAtPoint:CGPointMake(0, 0)];
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}
// this prepares to takes the picture
-(void)take{
    if (self.isPhotoBeingTaken)
    {
        [self snapshot];
        [self.bottomNavBar changeCenterImage:UA_ICON_OK withFrame:CGRectMake(0, 0, 80, 40)];
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
-(void)cameraPrepareToRetake{
    self.avPreviewLayer.opacity = 1.0;
    
    [self.bottomNavBar changeCenterImage:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 90, 45)];
    self.bottomNavBar.rightImageView.hidden = YES;
    
    UITapGestureRecognizer *takePhotoButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(take)];
    takePhotoButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:takePhotoButtonRecognizer];
    
    
    [self removeOverlay];
    //remove gesture recognizers
    [self.view removeGestureRecognizer:panRecognizer];
    [self.view removeGestureRecognizer:pinchRecognizer];
    [self.view removeGestureRecognizer:rotationRecognizer];
    [self.view removeGestureRecognizer:tapRecognizer];
    
    //reset the camera image
    [self.previewLayerHostView removeFromSuperview];
    [self cameraSetup];

}

// snapshot and show picture on screen
-(void)snapshot{
    AVCaptureConnection *captureConnection=[self.avSnapper connectionWithMediaType:AVMediaTypeVideo];
    
    typedef void (^BufferBlock)(CMSampleBufferRef, NSError*);
    
    BufferBlock handler=^(CMSampleBufferRef buffer, NSError *error)
    {
        NSData *data=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buffer];
        
        dispatch_async(dispatch_get_main_queue(),^(void)
                       {
                           
                           self.avPreviewLayer.opacity=0.0;
                           self.stillLayer.contents=(id)[[UIImage alloc] initWithData:data].CGImage;
                           capturedImage = nil;
                           capturedImage = [[UIImage alloc] initWithData:data];
                           
                           capturedImage=[self rotate:capturedImage];

                           [self saveImageToLibrary];
                       });
    };
    
    [self.avSnapper captureStillImageAsynchronouslyFromConnection:captureConnection
                                                completionHandler:handler];
    

    
    //display the cropPhoto overlay
    [self displayOverlay];
    [self initGestureRecognizers];

}

-(void)displayOverlay{
    touchY1= [[UIScreen mainScreen] bounds].size.height/2 - 266.472/2;
    touchX1=50.532;
    touchY2= touchY1 + 266.472;
    touchX2= [[UIScreen mainScreen] bounds].size.width-50.3532;
    //upper rect
    upperRect=[[UIView alloc]initWithFrame:CGRectMake(0, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, touchY1-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT))];
    [upperRect setBackgroundColor:UA_OVERLAY_COLOR];
    [self.view addSubview:upperRect];
    
    //lower rect
    lowerRect=[[UIView alloc] initWithFrame: CGRectMake(0, touchY2, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-touchY2-UA_BOTTOM_BAR_HEIGHT)];
    [lowerRect setBackgroundColor:UA_OVERLAY_COLOR];
    [self.view addSubview:lowerRect];
    
    //left rect
    leftRect = [[UIView alloc] initWithFrame:CGRectMake(0, touchY1, touchX1, touchY2-touchY1)];
    [leftRect setBackgroundColor:UA_OVERLAY_COLOR];
    [self.view addSubview:leftRect];
    
    //right rect
    rightRect = [[UIView alloc] initWithFrame: CGRectMake(touchX2, touchY1, [[UIScreen mainScreen] bounds].size.width-touchX2, touchY2-touchY1)];
    [rightRect setBackgroundColor:UA_OVERLAY_COLOR];
    [self.view addSubview:rightRect];
}
-(void)removeOverlay{
    [leftRect removeFromSuperview];
    [rightRect removeFromSuperview];
    [upperRect removeFromSuperview];
    [lowerRect removeFromSuperview];
}
-(void)initGestureRecognizers{
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapRecognizer];
    
    panRecognizer.delegate = self;
    pinchRecognizer.delegate = self;
    rotationRecognizer.delegate = self;}

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizerFound{
    CGPoint translation = [panRecognizerFound translationInView:self.view];
    CGPoint imageViewPosition = self.previewLayerHostView.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.previewLayerHostView.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self.view];
}
- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizerFound{
    CGFloat scale = pinchRecognizerFound.scale;
    self.previewLayerHostView.transform = CGAffineTransformScale(self.previewLayerHostView.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizerFound{
    CGFloat angle = rotationRecognizerFound.rotation;
    self.previewLayerHostView.transform = CGAffineTransformRotate(self.previewLayerHostView.transform, angle);
    rotationRecognizer.rotation = 0.0;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizerFound{
    [UIView animateWithDuration:0.25 animations:^{
        self.previewLayerHostView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        self.previewLayerHostView.transform = CGAffineTransformIdentity;
    }];
}


// method used when pressing OK button
-(void)imageSelected{
    [self.avSession stopRunning];

    //crop image
    double screenScale = [[UIScreen mainScreen] scale];
    CGImageRef imageRef = CGImageCreateWithImageInRect([[self createScreenshot] CGImage], CGRectMake(touchX1 * screenScale,touchY1 * screenScale,(touchX2 - touchX1) * screenScale, 266.472 * screenScale));
    self.croppedPhoto = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    //this goes to the next view
    assignLetter = [[AssignLetter alloc] initWithNibName:@"AssignLetter" bundle:[NSBundle mainBundle]];
    [assignLetter setup:self.croppedPhoto];
    
    [self.navigationController pushViewController:assignLetter animated:YES];
}

- (UIImage *)createScreenshot
{
    //    UIGraphicsBeginImageContext(pageSize);
    CGSize pageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(pageSize, YES, 0.0f);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(void)goToPhotoLibrary{
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.delegate = self;
    pickerLibrary.allowsEditing = NO;
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerLibrary animated:YES completion:NULL];
}
//--------------------------------------------------
//save Image to Library
//--------------------------------------------------
-(void)saveImageToLibrary {
    CGImageRef imageRef = CGImageCreateWithImageInRect([capturedImage CGImage], CGRectMake(0, 0, capturedImage.size.width, capturedImage.size.height));
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    
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
    CGImageRef img = [image CGImage];
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
//--------------------------------------------------
//load image from photo library
//--------------------------------------------------
- (void) imagePickerController:(UIImagePickerController *)pickerLibrary didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [pickerLibrary dismissModalViewControllerAnimated:TRUE];
    self.img = image;
    float scaleFactorImage=image.size.width/image.size.height;
    
    proportion = 640.0/480.0;
    imageTop = ([[UIScreen mainScreen] bounds].size.height / 2.0) - (320*proportion / 2.0);
    
    //self.stillLayer.frame = CGRectMake(0,imageTop,320,(320*640)/480);
    UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, imageTop, [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width/scaleFactorImage)] ;
    [imageView setImage:image];
    
    [self.previewLayerHostView addSubview:imageView];
    
    [self displayOverlay];

    //gesture recognizers
    [self initGestureRecognizers];
    
    //change bottom bar
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


@end
