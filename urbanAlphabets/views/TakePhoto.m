//
//  TakePhoto.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "TakePhoto.h"
#define NavBarHeight 42
#define TopBarFromTop 20

@interface TakePhoto ()

@end

@implementation TakePhoto {
    //common variables
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *takePhoto;
    
    
    
    //camera
    C4Camera *cam;
    //bool imageWasCaptured;
    
    //bottom Toolbar
    C4Shape *bottomNavBar;
    C4Button *takePhotoButton;
}
-(void) setup{
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    buttonColor= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    
    [self topBarSetup];
    [self bottomBarSetup];
    [self cameraSetup];
    
}
-(void)topBarSetup{
    topNavBar=[C4Shape rect:CGRectMake(0, TopBarFromTop, self.canvas.width, NavBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    takePhoto = [C4Label labelWithText:@"Take Photo" font:fatFont];
    takePhoto.center=topNavBar.center;
    [self.canvas addLabel:takePhoto];}

-(void)cameraSetup{
    cam = [C4Camera cameraWithFrame:CGRectMake(0,TopBarFromTop+NavBarHeight, self.canvas.width, self.canvas.height-(2*NavBarHeight+TopBarFromTop))];
    [self.canvas addCamera:cam];
    [cam initCapture];
    //tapping to take image
    [self addGesture:TAP name:@"capture" action:@"capturedImage"];
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    //[self listenFor:@"imageWasCaptured" fromObject:@"putCapturedImageOnCanvas"];
}
-(void) bottomBarSetup{
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(NavBarHeight), self.canvas.width, NavBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];
    
    takePhotoButton=[UIButton buttonWithType: ROUNDEDRECT];
    [takePhotoButton setTitle:@"TakePhoto" forState:UIControlStateNormal];
    takePhotoButton.frame=CGRectMake(self.canvas.width/2-50, self.canvas.height-(NavBarHeight), 100, NavBarHeight);
    takePhotoButton.backgroundColor=buttonColor;
    takePhotoButton.tintColor=typeColor;
    //[takePhotoButton runMethod:@"takingPhoto" target:self forEvent:TOUCHUPINSIDE];
    [self.canvas addSubview:takePhotoButton];
    
}

-(void) takingPhoto{
    [cam captureImage];
}
-(void) captureImage{
    [cam captureImage];
}
-(void)putCapturedImageOnCanvas{
    C4Image *img = cam.capturedImage;
    img.width=240;
    img.center=CGPointMake(self.canvas.width*2/3, self.canvas.center.y);
    
}



@end
