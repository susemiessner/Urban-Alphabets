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

}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property(nonatomic) UIImage *photoTaken;

@end

@implementation CropPhoto

-(void)setup{
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
    
    //--------------------------------------------------
    //ZOOM STEPPER
    //--------------------------------------------------
    zoomStepper=[C4Stepper stepper];
    zoomStepper.center=CGPointMake(zoomStepper.width/2+5, self.bottomNavBar.center.y);
    zoomStepper.backgroundColor=UA_NAV_BAR_COLOR;
    zoomStepper.tintColor=UA_TYPE_COLOR;
    [zoomStepper runMethod:@"stepperValueChanged:" target:self forEvent:VALUECHANGED];
    [self.view addSubview:zoomStepper];
    zoomStepper.maximumValue=10.0f;
    zoomStepper.minimumValue=0.5f;
    zoomStepper.value=1.0f;
    zoomStepper.stepValue=0.25f;
}

-(void)displayImage:(UIImage*)image{
    NSLog(@"display image, photoTaken: %@", image);
    self.photoTaken=image;
    photoTakenView=[[UIImageView alloc]initWithFrame:CGRectMake(0, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT*2)];
    photoTakenView.image=self.photoTaken;
    [self.view addSubview:photoTakenView];
    //pan gesture
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handlePan:)];
    
    [photoTakenView addGestureRecognizer:pgr];
    //[self.photoTaken addGesture:PAN name:@"pan" action:@"move:"];
    //initialize the overlay
    [self transparentOverlay];
    
}
-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}
-(void)transparentOverlay{
    float touchY1=86.764+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT;
    float touchX1=50.532;
    float touchY2=86.764+266.472+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT;
    float touchX2= self.view.frame.size.width-50.3532;
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
    self.croppedPhoto=[self cropImage:self.photoTaken withOrigin:photoTakenView.frame.origin toArea:CGRectMake(51, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+86.764, self.view.frame.size.width-2*51, 266)];
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
    
    //create a new C4Image
    UIImage *newImage = newUIImage;
    
    //return the new image
    return newImage;
}
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    //[self.croppedPhoto renderInContext:graphicsContext];
    [self.croppedPhoto drawInRect:CGRectMake(0, 0, self.croppedPhoto.size.width, self.croppedPhoto.size.height)];
    NSString *fileName = [NSString stringWithFormat:@"letter%@.jpg", [NSDate date]];
    [self saveImage:fileName];
    //[self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(218, 266), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
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


@end
