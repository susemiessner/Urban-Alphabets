//
//  CropPhoto.m
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "CropPhoto.h"

@interface CropPhoto ()

@end

@implementation CropPhoto

-(void)transferVariables:(int)number topBarFroTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault overlayColor:(UIColor*)overlayColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault iconOk:(C4Image*)iconOkDefault{
    //nav bar heights
    topBarFromTop=TopBarFromTopDefault;
    topBarHeight=TopNavBarHeightDefault;
    bottomBarHeight=BottomBarHeightDefault;
    //colors
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    typeColor=typeColorDefault;
    overlayColor=overlayColorDefault;
    //fonts
    fatFont=fatFontDefault;
    normalFont=normalFontDefault;
    //icons
    iconOk=iconOkDefault;
    iconClose=iconCloseDefault;
    iconBack=iconBackDefault;
}
-(void)setup{
    [self topBarSetup];
    [self bottomBarSetup];
}
-(void)topBarSetup{
    //--------------------
    //white rect under top bar
    //--------------------
    defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, topBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    //--------------------
    //nav bar grey
    //--------------------
    topNavBar=[C4Shape rect:CGRectMake(0, topBarFromTop, self.canvas.width, topBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    //title text center
    titleLabel = [C4Label labelWithText:@"Crop photo letter" font:fatFont];
    titleLabel.center=topNavBar.center;
    [self.canvas addLabel:titleLabel];
    
    //--------------------
    //LEFT
    //--------------------
    //text
    backLabel=[C4Label labelWithText:@"Back" font: normalFont];
    backLabel.center=CGPointMake(40, topNavBar.center.y);
    [self.canvas addLabel:backLabel];
    
    //back icon
    backButtonImage=iconBack;
    backButtonImage.width= 12.2;
    backButtonImage.center=CGPointMake(10, topNavBar.center.y);
    [self.canvas addImage:backButtonImage];
    
    //invisible rect for navigation
    navigateBackRect=[C4Shape rect: CGRectMake(0, topBarFromTop, 60, topNavBar.height)];
    navigateBackRect.fillColor=navigationColor;
    navigateBackRect.lineWidth=0;
    [self.canvas addShape:navigateBackRect];
    [self listenFor:@"touchesBegan" fromObject:navigateBackRect andRunMethod:@"navigateBack"];
    
    //--------------------
    //RIGHT
    //--------------------
    //close icon
    closeButtonImage=iconClose;
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    [self.canvas addImage:closeButtonImage];
    
    //invisible rect for navigation
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, topBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    //closeRect.zPosition=102;
    [self.canvas addShape:closeRect];
    [self listenFor:@"touchesBegan" fromObject:closeRect andRunMethod:@"goToAlphabetsView"];
}
-(void)bottomBarSetup{
    //--------------------------------------------------
    //underlying rect
    //--------------------------------------------------
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(bottomBarHeight), self.canvas.width, bottomBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    
    [self.canvas addShape:bottomNavBar];
    
    //--------------------------------------------------
    //BUTTON CENTER
    //--------------------------------------------------
    OkButtonImage=iconOk;
    OkButtonImage.height=45;
    OkButtonImage.width=90;
    OkButtonImage.center=CGPointMake(self.canvas.width/2, self.canvas.height-bottomBarHeight/2);
    OkButtonImage.zPosition=10;
    [self.canvas addImage:OkButtonImage];
    [self listenFor:@"touchesBegan" fromObject:OkButtonImage andRunMethod:@"saveImage"];
    
    //--------------------------------------------------
    //ZOOM STEPPER
    //--------------------------------------------------
    zoomStepper=[C4Stepper stepper];
    zoomStepper.center=CGPointMake(50, self.canvas.height-20);
    zoomStepper.backgroundColor=navBarColor;
    [zoomStepper runMethod:@"stepperValueChanged:" target:self forEvent:VALUECHANGED];
    [self.canvas addSubview:zoomStepper];
    zoomStepper.maximumValue=10.0f;
    zoomStepper.minimumValue=0.5f;
    zoomStepper.value=1.0f;
    zoomStepper.stepValue=0.25f;
    
}
-(void)stepperValueChanged:(UIStepper*)theStepper{
    C4Log(@"current sender.value %f", theStepper.value);
    photoTaken.height=self.canvas.height*theStepper.value;
    photoTaken.center=self.canvas.center;
}
-(void)displayImage:(C4Image*)image{
    photoTaken=image;
    photoTaken.origin=CGPointMake(0, topBarFromTop+topBarHeight);
    //photoTaken.width=self.canvas.width;
    photoTaken.zPosition=0;
    photoTaken.height=self.canvas.height-(topBarFromTop+topBarHeight+bottomBarHeight);
    [self.canvas addImage:photoTaken];
    [photoTaken addGesture:PAN name:@"pan" action:@"move:"];
    //initialize the overlay
    [self transparentOverlayX1:50.532 Y1:86.764+topBarHeight+topBarFromTop X2: self.canvas.width-50.3532 Y2: 86.764+266.472+topBarHeight+topBarFromTop];
    
}
-(void)transparentOverlayX1: (NSUInteger)touchX1 Y1:(NSUInteger)touchY1 X2:(NSUInteger) touchX2 Y2:(NSUInteger)touchY2{
    //upper rect
    upperRect=[C4Shape rect: CGRectMake(0, topBarFromTop+topBarHeight, self.canvas.width, touchY1-topBarFromTop-topBarHeight)];
    upperRect.fillColor=overlayColor;
    upperRect.lineWidth=0;
    [self.canvas addShape:upperRect];
    
    //lower rect
    lowerRect=[C4Shape rect:CGRectMake(0, touchY2, self.canvas.width, self.canvas.height-touchY2-bottomBarHeight)];
    lowerRect.fillColor=overlayColor;
    lowerRect.lineWidth=0;
    [self.canvas addShape:lowerRect];
    
    //left rect
    leftRect = [C4Shape rect:CGRectMake(0, touchY1, touchX1, touchY2-touchY1)];
    leftRect.fillColor=overlayColor;
    leftRect.lineWidth=0;
    [self.canvas addShape:leftRect];
    
    //right rect
    rightRect = [C4Shape rect: CGRectMake(touchX2, touchY1, self.canvas.width-touchX2, touchY2-touchY1)];
    rightRect.fillColor=overlayColor;
    rightRect.lineWidth=0;
    [self.canvas addShape:rightRect];
    
}
//------------------------------------------------------------------------
//REMOVE ALL ELEMENTS FROM VIEW WHEN NAVIGATING SOMEWHERE ELSE
//------------------------------------------------------------------------
-(void)removeFromView{
    //top bar
    [defaultRect removeFromSuperview];
    [topNavBar removeFromSuperview];
    [titleLabel removeFromSuperview];
    
    [backLabel removeFromSuperview];
    [backLabel removeFromSuperview];
    [navigateBackRect removeFromSuperview];
    
    [closeButtonImage removeFromSuperview];
    [closeRect removeFromSuperview];
    
    //bottom bar
    [bottomNavBar removeFromSuperview];
    [OkButtonImage removeFromSuperview];
    [zoomStepper removeFromSuperview];
    
    //overlay rects
    [upperRect removeFromSuperview];
    [lowerRect removeFromSuperview];
    [leftRect removeFromSuperview];
    [rightRect removeFromSuperview];
    
    //other stuff
    [photoTaken removeFromSuperview];
    [self.croppedPhoto removeFromSuperview];
}

//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) navigateBack{
    C4Log(@"navigating back");
    [self postNotification:@"goToTakePhoto"];
    [self removeFromView];
}

-(void) goToAlphabetsView{
    C4Log(@"going to Alphabetsview");
    [self postNotification:@"goToAlphabetsView"];
    //[self removeFromView];
}
-(void)saveImage{
    C4Log(@"saving image!");
    //crop image
    self.croppedPhoto=[self cropImage:photoTaken withOrigin:photoTaken.origin toArea:CGRectMake(50.532, topBarFromTop+topBarHeight+86.764, self.canvas.width-2*50.532, 266.472)];
    self.croppedPhoto.origin=CGPointMake(0, 0);
    
    [self removeFromView];
    
    //uncomment to save the photo to photo library and app's image directory
    //[self exportHighResImage];
    
    //this goes to the next view
    [self postNotification:@"goToAssignPhoto"];
}

//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
-(C4Image *)cropImage:(C4Image *)originalImage withOrigin:(CGPoint)origin toArea:(CGRect)rect{
    //grab the image scale
    CGFloat scale = originalImage.UIImage.scale;
    
    //begin an image context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //shift BACKWARDS in both directions because this moves the image
    //the area to crop shifts INTO: (0, 0, rect.size.width, rect.size.height)
    CGContextTranslateCTM(c, origin.x-rect.origin.x, origin.y-rect.origin.y);
    
    //render the original image into the context
    [originalImage renderInContext:c];
    
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end the image context
    UIGraphicsEndImageContext();
    
    //create a new C4Image
    C4Image *newImage = [C4Image imageWithUIImage:newUIImage];
    
    //return the new image
    return newImage;
}
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    [self.croppedPhoto renderInContext:graphicsContext];
    NSString *fileName = [NSString stringWithFormat:@"awesomeshot%@.jpg", [NSDate date]];
    //C4Log(@"%@",s );
    
    [self saveImage:fileName];
    [self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(218, 266), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *savePath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
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
