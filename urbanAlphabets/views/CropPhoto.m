//
//  CropPhoto.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "CropPhoto.h"


#define TopNavBarHeight 42
#define TopBarFromTop 20.558
#define BottomNavBarHeight 49

@implementation CropPhoto
-(void) setup {
    //photoTaken=image;
    //lastView=previousView;
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    buttonColor= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    overlayColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5];
    navigationColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    
    [self listenFor:@"getPhoto" andRunMethod:@"displayPhoto"];
}
-(void) sendPhoto:(C4Image*)image{

}

-(void)displayPhoto{
    photoTaken=[C4Image imageNamed:@"image.jpg"]; //used as long as I cannot actually get the real photo from there... (Stackoverflow question from oct 24th)
    [self photoToCrop];
    [self topBarSetup];
    [self bottomBarSetup];
    [self transparentOverlayX1:50.532 Y1:86.764+TopNavBarHeight+TopBarFromTop X2: self.canvas.width-50.3532 Y2: 86.764+266.472+TopNavBarHeight+TopBarFromTop];
    
    [self stepperSetup];
}

-(void)topBarSetup{
    //white rect under top bar that stays
    defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, TopBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    //defaultRect.zPosition=100;
    
    
    //navigation bar
    topNavBar=[C4Shape rect:CGRectMake(0, TopBarFromTop, self.canvas.width, TopNavBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    //topNavBar.zPosition=100;
    [self.canvas addShape:topNavBar];
    
    
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    cropPhoto = [C4Label labelWithText:@"Crop photo letter" font:fatFont];
    cropPhoto.center=topNavBar.center;
    //cropPhoto.zPosition=101;
    [self.canvas addLabel:cropPhoto];
    //upper left
    normalFont =[C4Font fontWithName:@"HelveticaNeue" size:17];
    backLabel=[C4Label labelWithText:@"Back" font: normalFont];
    backLabel.center=CGPointMake(40, topNavBar.center.y);
    //backLabel.zPosition=101;
    [self.canvas addLabel:backLabel];
    
    backButtonImage=[C4Image imageNamed:@"icon_back.png"];
    backButtonImage.width= 12.2;
    backButtonImage.center=CGPointMake(10, topNavBar.center.y);
    //backButtonImage.zPosition=105;
    [self.canvas addImage:backButtonImage];
    
    navigateBackRect=[C4Shape rect: CGRectMake(0, TopBarFromTop, 60, topNavBar.height)];
    navigateBackRect.fillColor=navigationColor;
    navigateBackRect.lineWidth=0;
    //navigateBackRect.zPosition=104;
    [self.canvas addShape:navigateBackRect];
    [self listenFor:@"touchesBegan" fromObject:navigateBackRect andRunMethod:@"navigateBack"];
    //upper right
    closeButtonImage=[C4Image imageNamed:@"icons_close.png"];
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    //closeButtonImage.zPosition=101;
    [self.canvas addImage:closeButtonImage];
    
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, TopBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    //closeRect.zPosition=102;
    [self.canvas addShape:closeRect];
    [self listenFor:@"touchesBegan" fromObject:closeRect andRunMethod:@"goToAlphabetsView"];
}
-(void) bottomBarSetup{
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(BottomNavBarHeight), self.canvas.width, BottomNavBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    //bottomNavBar.zPosition=1;
    //C4Log(@"zposition bottom bar: %f", bottomNavBar.zPosition);
    [self.canvas addShape:bottomNavBar];
    
    
    //IMAGE AS BUTTON
    okButtonImage=[C4Image imageNamed:@"icons-20.png"];
    okButtonImage.height=45;
    okButtonImage.width=90;
    okButtonImage.center=bottomNavBar.center;
    //okButtonImage.zPosition=bottomNavBar.zPosition+1;
    //C4Log(@"zposition ok button: %f", okButtonImage.zPosition);
    [self.canvas addImage:okButtonImage];
    [self listenFor:@"touchesBegan" fromObject:okButtonImage andRunMethod:@"saveImage"];

    
}
-(void)transparentOverlayX1: (NSUInteger)touchX1 Y1:(NSUInteger)touchY1 X2:(NSUInteger) touchX2 Y2:(NSUInteger)touchY2{
    //upper rect
    upperRect=[C4Shape rect: CGRectMake(0, TopBarFromTop+TopNavBarHeight, self.canvas.width, touchY1-TopBarFromTop-TopNavBarHeight)];
    upperRect.fillColor=overlayColor;
    upperRect.lineWidth=0;
    //upperRect.zPosition=100;
    //upperRect.zPosition=1000;
    [self.canvas addShape:upperRect];
    //lower rect
    lowerRect=[C4Shape rect:CGRectMake(0, touchY2, self.canvas.width, self.canvas.height-touchY2-BottomNavBarHeight)];
    lowerRect.fillColor=overlayColor;
    lowerRect.lineWidth=0;
    //lowerRect.zPosition=100;
    [self.canvas addShape:lowerRect];
    
    //left rect
    leftRect = [C4Shape rect:CGRectMake(0, touchY1, touchX1, touchY2-touchY1)];
    leftRect.fillColor=overlayColor;
    leftRect.lineWidth=0;
    //leftRect.zPosition=100;
    [self.canvas addShape:leftRect];
    
    //right rect
    rightRect = [C4Shape rect: CGRectMake(touchX2, touchY1, self.canvas.width-touchX2, touchY2-touchY1)];
    rightRect.fillColor=overlayColor;
    rightRect.lineWidth=0;
    //rightRect.zPosition=100;
    [self.canvas addShape:rightRect];

}
-(void)photoToCrop{
    photoTaken.height=self.canvas.height;
    photoTaken.origin=CGPointMake(0, 0);
    //photoTaken.zPosition=0;
    //C4Log(@"zposition photo: %i", photoTaken.zPosition);
    [self.canvas addImage:photoTaken];
    
    [photoTaken addGesture:PAN name:@"pan" action:@"move:"];
}

-(void)stepperSetup{
    zoomStepper=[C4Stepper stepper];
    zoomStepper.center=CGPointMake(50, self.canvas.height-20);
    zoomStepper.backgroundColor=navBarColor;
    [zoomStepper runMethod:@"stepperValueChanged:" target:self forEvent:VALUECHANGED];
    [self.canvas addSubview:zoomStepper];
    zoomStepper.maximumValue=10.0f;
    zoomStepper.minimumValue=0.5f;
    zoomStepper.value=1.0f;
    zoomStepper.stepValue=0.25f;
    //zoomStepper.zPosition=101;
}

-(void)stepperValueChanged:(UIStepper*)theStepper{
    C4Log(@"current sender.value %f", theStepper.value);
    photoTaken.height=self.canvas.height*theStepper.value;
    photoTaken.center=self.canvas.center;
}
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
-(void)saveImage {
    C4Log(@"saving image!");
    //[self exportHighResImage];
    
    //crop image
    croppedPhoto=[self cropImage:photoTaken withOrigin:photoTaken.origin toArea:CGRectMake(50.532, TopBarFromTop+TopNavBarHeight+86.764, self.canvas.width-2*50.532, 266.472)];
    croppedPhoto.origin=CGPointMake(0, 0);
    /*[self.canvas addImage:croppedPhoto];
    C4Log(@"croppedPhotoWidth %f", croppedPhoto.width);

    */
    [self postNotification:@"goToAssignPhoto"];


}

//this is all for saving an image
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(218, 266), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}

-(NSString *)documentsDirectory { 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
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

-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
       [self.canvas renderInContext:graphicsContext];
    NSString *fileName = [NSString stringWithFormat:@"awesomeshot%@.jpg", [NSDate date]];
    //C4Log(@"%@",s );
    
    [self saveImage:fileName];
    [self saveImageToLibrary];
}

-(void) navigateBack{
    C4Log(@"navigating back");
    [self postNotification:@"goToTakePhoto"];
    
}
-(void) goToAlphabetsView{
    C4Log(@"going to Alphabetsview");
}


@end
