//
//  TakePhoto.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "TakePhoto.h"
#define TopNavBarHeight 42
#define TopBarFromTop 20.558
#define BottomNavBarHeight 49


@implementation TakePhoto
-(void) setup{
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    navigationColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    buttonColor= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    
    [self topBarSetup];
    [self bottomBarSetup];
    [self cameraSetup];
        
}
-(void)topBarSetup{
    topNavBar=[C4Shape rect:CGRectMake(0, TopBarFromTop, self.canvas.width, TopNavBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    takePhoto = [C4Label labelWithText:@"Add Photo Letter" font:fatFont];
    takePhoto.center=topNavBar.center;
    [self.canvas addLabel:takePhoto];
    
    normalFont =[C4Font fontWithName:@"HelveticaNeue" size:17];
    backLabel=[C4Label labelWithText:@"Back" font: normalFont];
    backLabel.center=CGPointMake(40, topNavBar.center.y);
    [self.canvas addLabel:backLabel];
    
    backButtonImage=[C4Image imageNamed:@"icon_back.png"];
    backButtonImage.width= 12.2;
    backButtonImage.center=CGPointMake(10, topNavBar.center.y);
    [self.canvas addImage:backButtonImage];
    
    navigateBackRect=[C4Shape rect: CGRectMake(0, TopBarFromTop, 60, topNavBar.height)];
    navigateBackRect.fillColor=navigationColor;
    navigateBackRect.lineWidth=0;
    [self.canvas addShape:navigateBackRect];
    [self listenFor:@"touchesBegan" fromObject:navigateBackRect andRunMethod:@"navigateBack"];
    
    closeButtonImage=[C4Image imageNamed:@"icons_close.png"];
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    [self.canvas addImage:closeButtonImage];
    
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, TopBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    [self.canvas addShape:closeRect];
    [self listenFor:@"touchesBegan" fromObject:closeRect andRunMethod:@"goToAlphabetsView"];
    
    
}

-(void)cameraSetup{
    cam = [C4Camera cameraWithFrame:CGRectMake(0,TopBarFromTop+TopNavBarHeight, self.canvas.width, self.canvas.height-(TopNavBarHeight+BottomNavBarHeight+TopBarFromTop))];
    cam.cameraPosition = CAMERABACK;
    [self.canvas addCamera:cam];
    [cam initCapture];
    counter=0;
}
-(void) bottomBarSetup{
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(BottomNavBarHeight), self.canvas.width, BottomNavBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];

    //Take PhotoButton
    photoButtonImage=[C4Image imageNamed:@"icons-02.png"];
    photoButtonImage.height=45;
    photoButtonImage.width=90;
    photoButtonImage.center=CGPointMake(self.canvas.width/2, self.canvas.height-BottomNavBarHeight/2);
    [self.canvas addImage:photoButtonImage];
    
    [self listenFor:@"touchesBegan" fromObject:photoButtonImage andRunMethod:@"captureImage"];
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"goToCropPhoto"];
}
-(void)goToCropPhoto {
    if (counter==0) {
        img = cam.capturedImage;
        //img.zPosition=10000;
        //[self.canvas addImage:img];
        //C4Log(@"image:%@",img);
        
        [self postNotification:@"goToCropPhoto"];
        //img=[C4Image imageNamed:@"image.jpg"];
        cropPhoto=[CropPhoto new];
        [cropPhoto sendPhoto:img];
        counter++;
    }
}
-(void) captureImage{
    [cam captureImage];
    C4Log(@"capturing image");
}
-(void) navigateBack{
    C4Log(@"navigating back");

}
-(void) goToAlphabetsView{
    C4Log(@"going to Alphabetsview");
}
-(void)resetCounter{
    counter=0;
}



@end
