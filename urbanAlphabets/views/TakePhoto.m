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
    [self.canvas addLabel:takePhoto];
}

-(void)cameraSetup{
    cam = [C4Camera cameraWithFrame:CGRectMake(0,TopBarFromTop+NavBarHeight, self.canvas.width, self.canvas.height-(2*NavBarHeight+TopBarFromTop))];
    cam.cameraPosition = CAMERABACK;
    [self.canvas addCamera:cam];
    [cam initCapture];
    //tapping to take image
    [self addGesture:TAP name:@"capture" action:@"captureImage:"];
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    //[self listenFor:@"imageWasCaptured" fromObject:@"putCapturedImageOnCanvas"];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"putCapturedImageOnCanvas"];
}
-(void) bottomBarSetup{
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(NavBarHeight), self.canvas.width, NavBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];

    
    //IMAGE AS BUTTON
    C4Image *photoButtonImage=[C4Image imageNamed:@"icons-02.png"];
    photoButtonImage.height=NavBarHeight;
    photoButtonImage.center=CGPointMake(self.canvas.width/2, self.canvas.height-NavBarHeight/2);
    [self.canvas addImage:photoButtonImage];
    [photoButtonImage addGesture:TAP name:@"tap" action:@"tapped"];
    
}
-(void)tapped {
    C4Log(@"tapped!");
}


-(void) captureImage{
    [cam captureImage];
}

-(void)putCapturedImageOnCanvas{
    C4Image *img = cam.capturedImage;
    img.width=240;
    //    img.center=CGPointMake(self.canvas.width*2/3, self.canvas.center.y);
    img.center = CGPointMake(self.mainCanvas.center.x, self.mainCanvas.center.y);
    [self.mainCanvas addImage:img];
    [self.mainCanvas bringSubviewToFront:self.canvas];
}

@end
