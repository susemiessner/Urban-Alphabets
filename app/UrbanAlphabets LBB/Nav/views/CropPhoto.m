//
//  CropPhoto.m
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "CropPhoto.h"
#import "BottomNavBar.h"
#import "AssignLetter.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@interface CropPhoto (){
    AssignLetter *assignLetter;
    
    //stepper for zooming
    C4Stepper *zoomStepper;
    
    //overlay rectangles
    UIView *upperRect;
    UIView *lowerRect;
    UIView *leftRect;
    UIView *rightRect;
    //saving image
    CGContextRef graphicsContext;
    
    UIImageView *photoTakenView;
    
    float touchX1;
    float touchX2;
    float touchY1;
    float touchY2;

}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property(nonatomic) UIImage *photoTaken;

@end

@implementation CropPhoto

-(void)setup{
    NSLog(@"setup cropPhoto");
    self.title=@"Crop Photo";
    
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.view.frame.size.height-UA_BOTTOM_BAR_HEIGHT, self.view.frame.size.width, UA_BOTTOM_BAR_HEIGHT);
    //NSLog(@"UA_icon_ok: %@", UA_ICON_OK);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45)];
    [self.view addSubview:self.bottomNavBar];
    
   //ok button tap
    UITapGestureRecognizer *okButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage)];
    okButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:okButtonRecognizer];
    NSLog(@"okButton: %@", self.bottomNavBar.centerImageView);
}

-(void)displayImage:(UIImage*)image{
    NSLog(@"display image, photoTaken: %@", image);
    
    self.photoTaken = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
    
    photoTakenView=[[UIImageView alloc]initWithFrame:CGRectMake(0, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT*2)];
    
    // just adjusting the picture to be on portrait mode correctly
    double photoWidth = photoTakenView.frame.size.width;
    double photoHeight = (photoTakenView.frame.size.width * self.photoTaken.size.height) / self.photoTaken.size.width; //photoTakenView.frame.size.height;
    
    // centering and resizing image
    photoTakenView.frame = CGRectMake(0,self.view.frame.size.height/2 - photoHeight/2,photoWidth,photoHeight);

    photoTakenView.image=self.photoTaken;
    [self.view addSubview:photoTakenView];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapRecognizer];
    
    panRecognizer.delegate = self;
    pinchRecognizer.delegate = self;
    rotationRecognizer.delegate = self;
    
    [self transparentOverlay];
    
}

-(void)transparentOverlay{
    touchY1= self.view.frame.size.height/2 - 266.472/2;// 86.764+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT;
    touchX1=50.532;
    touchY2= touchY1 + 266.472;//86.764+266.472+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT;
    touchX2= self.view.frame.size.width-50.3532;
    //upper rect
    upperRect=[[UIView alloc]initWithFrame:CGRectMake(0, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, self.view.frame.size.width, touchY1-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT))];
    [upperRect setBackgroundColor:UA_OVERLAY_COLOR];
    [self.view addSubview:upperRect];
    
    //lower rect
    lowerRect=[[UIView alloc] initWithFrame: CGRectMake(0, touchY2, self.view.frame.size.width, self.view.frame.size.height-touchY2-UA_BOTTOM_BAR_HEIGHT)];
    [lowerRect setBackgroundColor:UA_OVERLAY_COLOR];
    [self.view addSubview:lowerRect];
    
    //left rect
    leftRect = [[UIView alloc] initWithFrame:CGRectMake(0, touchY1, touchX1, touchY2-touchY1)];
    [leftRect setBackgroundColor:UA_OVERLAY_COLOR];
    [self.view addSubview:leftRect];
    
    //right rect
    rightRect = [[UIView alloc] initWithFrame: CGRectMake(touchX2, touchY1, self.view.frame.size.width-touchX2, touchY2-touchY1)];
    [rightRect setBackgroundColor:UA_OVERLAY_COLOR];
    [self.view addSubview:rightRect];
    
}
-(void)stepperValueChanged:(UIStepper*)theStepper{
    float oldHeight=self.photoTaken.size.height;
    float oldWidth=self.photoTaken.size.width;
    float oldX=photoTakenView.frame.origin.x+oldWidth/2;
    float oldY=photoTakenView.frame.origin.y+oldHeight/2;
   // self.photoTaken.height=self.canvas.height*theStepper.value;
    float newHeight=self.view.frame.size.height*theStepper.value;
    float newWidth=self.view.frame.size.width*theStepper.value;
    
    float newX=self.view.frame.origin.x+self.view.frame.size.width/2-((self.view.frame.origin.x+self.view.frame.size.width/2-oldX)*newWidth/oldWidth);
    float newY=self.view.frame.origin.y+self.view.frame.size.height/2-((self.view.frame.origin.y+self.view.frame.size.height/2-oldY)*newHeight/oldHeight);
    [photoTakenView removeFromSuperview];
    photoTakenView=[[UIImageView alloc]initWithFrame:CGRectMake(newX, newY,newWidth, newHeight)];
    [self.view addSubview:photoTakenView];
}

//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//--------------------------------------------------
//SAVE IMAGE
//--------------------------------------------------
-(void)saveImage{
    NSLog(@"saveImage");
    self.bottomNavBar.centerImageView.backgroundColor=UA_HIGHLIGHT_COLOR;
    //crop image
//    self.croppedPhoto=[self cropImage:self.photoTaken withOrigin:photoTakenView.frame.origin toArea:CGRectMake(51, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+86.764, self.view.frame.size.width-2*51, 266)];
//    self.croppedPhoto=[self cropImage:self.photoTaken withOrigin:photoTakenView.frame.origin toArea:CGRectMake(100, 100, 100 , 100)];

    double screenScale = [[UIScreen mainScreen] scale];
    CGImageRef imageRef = CGImageCreateWithImageInRect([[self createScreenshot] CGImage], CGRectMake(touchX1 * screenScale,touchY1 * screenScale,(touchX2 - touchX1) * screenScale, 266.472 * screenScale));
    self.croppedPhoto = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    //------------------------------------------------------------------------------------------------
    //might cause problems here!!!!
    
    //self.croppedPhoto.origin=CGPointMake(0, 0);
    //------------------------------------------------------------------------------------------------
    // save the photo to photo library and app's image directory
    [self exportHighResImage];
    
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

-(UIImage *)cropImage:(UIImage *)originalImage withOrigin:(CGPoint)origin toArea:(CGRect)rect{
    //grab the image scale 
    CGFloat scale = originalImage.scale;
    
    //begin an image context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //shift BACKWARDS in both directions because this moves the image
    //the area to crop shifts INTO: (0, 0, rect.size.width, rect.size.height)
    CGContextTranslateCTM(c, origin.x-rect.origin.x, origin.y-rect.origin.y);
    
    //render the original image into the context
    [originalImage drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
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
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    //[self.croppedPhoto renderInContext:graphicsContext];
//    [self.croppedPhoto drawInRect:CGRectMake(0, 0, self.croppedPhoto.size.width, self.croppedPhoto.size.height)];
    NSString *fileName = [NSString stringWithFormat:@"letter%@.jpg", [NSDate date]];
    [self saveImage:fileName];
    //[self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(218, 266), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
//    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
//    NSData *imageData = UIImagePNGRepresentation(image);
    NSData *imageData = UIImagePNGRepresentation(self.croppedPhoto);
    //save in a certain folder
    NSString *dataPath = [[self documentsDirectory] stringByAppendingPathComponent:@"/letters"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *savePath = [dataPath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
}
-(void)saveImageToLibrary {
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

#pragma mark - Gesture Recognizers

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint translation = [panRecognizer translationInView:self.view];
    CGPoint imageViewPosition = photoTakenView.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    photoTakenView.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self.view];
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    CGFloat scale = pinchRecognizer.scale;
    photoTakenView.transform = CGAffineTransformScale(photoTakenView.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer
{
    CGFloat angle = rotationRecognizer.rotation;
    photoTakenView.transform = CGAffineTransformRotate(photoTakenView.transform, angle);
    rotationRecognizer.rotation = 0.0;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    [UIView animateWithDuration:0.25 animations:^{
        photoTakenView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        photoTakenView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
