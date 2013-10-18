//
//  CropPhoto.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "CropPhoto.h"
#define NavBarHeight 42
#define TopBarFromTop 20

@interface CropPhoto ()

@end

@implementation CropPhoto
-(void) setup{
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    buttonColor= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    overlayColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5];
    [self photoToCrop];
    [self topBarSetup];
    [self bottomBarSetup];
    [self transparentOverlayX1:50 Y1:87+NavBarHeight+TopBarFromTop X2: self.canvas.width-50 Y2: 87+266+NavBarHeight+TopBarFromTop];
    [self sliderSetup];
}

-(void)topBarSetup{
    //white rect under top bar that stays
    C4Shape *defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, TopBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                           [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    
    
    //navigation bar
    topNavBar=[C4Shape rect:CGRectMake(0, TopBarFromTop, self.canvas.width, NavBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    takePhoto = [C4Label labelWithText:@"Crop Photo" font:fatFont];
    takePhoto.center=topNavBar.center;
    [self.canvas addLabel:takePhoto];
}
-(void) bottomBarSetup{
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(NavBarHeight), self.canvas.width, NavBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];
    
    
    //IMAGE AS BUTTON
    C4Image *okButtonImage=[C4Image imageNamed:@"icons-20.png"];
    okButtonImage.height=NavBarHeight;
    okButtonImage.center=CGPointMake(self.canvas.width/2, self.canvas.height-NavBarHeight/2);
    [self.canvas addImage:okButtonImage];
    //[photoButtonImage addGesture:TAP name:@"tap" action:@"tapped"];
    [self listenFor:@"touchesBegan" fromObject:okButtonImage andRunMethod:@"saveImage"];

    
}
-(void)transparentOverlayX1: (NSUInteger)touchX1 Y1:(NSUInteger)touchY1 X2:(NSUInteger) touchX2 Y2:(NSUInteger)touchY2{
    //upper rect
    C4Shape *upperRect=[C4Shape rect: CGRectMake(0, TopBarFromTop+NavBarHeight, self.canvas.width, touchY1-TopBarFromTop-NavBarHeight)];
    upperRect.fillColor=overlayColor;
    upperRect.lineWidth=0;
    //upperRect.zPosition=1000;
    [self.canvas addShape:upperRect];
    //lower rect
    C4Shape *lowerRect=[C4Shape rect:CGRectMake(0, touchY2, self.canvas.width, self.canvas.height-touchY2-NavBarHeight)];
    lowerRect.fillColor=overlayColor;
    lowerRect.lineWidth=0;
    [self.canvas addShape:lowerRect];
    
    //left rect
    C4Shape *leftRect = [C4Shape rect:CGRectMake(0, touchY1, touchX1, touchY2-touchY1)];
    leftRect.fillColor=overlayColor;
    leftRect.lineWidth=0;
    [self.canvas addShape:leftRect];
    
    //right rect
    C4Shape *rightRect = [C4Shape rect: CGRectMake(touchX2, touchY1, self.canvas.width-touchX2, touchY2-touchY1)];
    rightRect.fillColor=overlayColor;
    rightRect.lineWidth=0;
    [self.canvas addShape:rightRect];
    
    //areaToSave=[CGSizeMake(300, 300)];
    //[CGSize :CGSizeMake(touchX2-touchX1, touchY2-touchY1);

}
-(void)photoToCrop{
    photoTaken=[C4Image imageNamed:@"image.jpg"];
    photoTaken.height=self.canvas.height;
    photoTaken.origin=CGPointMake(0, 0);
    [self.canvas addImage:photoTaken];
   // [photoTaken addGesture:PAN name:@"pan" action:@"movePhoto:"];
    
}
-(void)movePhoto:(UIPanGestureRecognizer *)recognizer {
    CGPoint thePoint=[recognizer locationInView:self.view];
    //C4Log(@"current position:%f,%f",thePoint.x, thePoint.y);
    if (thePoint.x>photoTaken.origin.x &&thePoint.x<photoTaken.origin.x+photoTaken.width && thePoint.y>photoTaken.origin.y &&thePoint.y<photoTaken.origin.y+photoTaken.height) {
        C4Log(@"touched inside+moved");
        [photoTaken move:recognizer];
    }
    
}
-(void)sliderSetup{
    [self createAddSliderObjects];
    zoomSlider.minimumValue=0.52f;
    zoomSlider.maximumValue=10.0f;
    //scalefactor=1;
    zoomSlider.value=1.0f;
    
}
-(void)createAddSliderObjects{
    sliderLabel=[C4Label labelWithText:@"1.0"];
    sliderLabel.textColor=navBarColor;
    zoomSlider=[C4Slider slider:CGRectMake(0, 0, self.canvas.width-20, 20)];
    
    //positioning
    sliderLabel.center=CGPointMake(self.canvas.width/2,self.canvas.height-NavBarHeight-50);
    zoomSlider.center=CGPointMake(sliderLabel.center.x,sliderLabel.center.y+10);
    
    //set up action
    [zoomSlider runMethod:@"sliderWasUpdated:"
                   target:self
                 forEvent:VALUECHANGED];
    [self.canvas addObjects:@[sliderLabel, zoomSlider]];
}
-(void)sliderWasUpdated:(C4Slider*)theSlider{
    //update the label to reflect current scale factor
    sliderLabel.text=[NSString stringWithFormat:@"%4.2f", theSlider.value];
    [sliderLabel sizeToFit];
    
    //scale the image
    C4Log(@"slider:%f",theSlider.value);
    photoTaken.height=self.canvas.height*theSlider.value;
    photoTaken.center=self.canvas.center;
}

-(void)saveImage {
    C4Log(@"tapped!");
    [self exportHighResImage];

}

//this is all for saving an image
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 300), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}

-(NSString *)documentsDirectory { 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}
-(void)saveImage:(NSString *)fileName {
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
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
    //NSDate *date= ;
    NSString *fileName = @"myScreen.png" ;
    
    [self saveImage:fileName];
    [self saveImageToLibrary];
}




@end
