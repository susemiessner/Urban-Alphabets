//
//  TakePhoto.m
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "TakePhoto.h"

@interface TakePhoto ()
@property (nonatomic) TopNavBar *topNavBar;
@property (nonatomic) BottomNavBar *bottomNavBar;

@end

@implementation TakePhoto
-(void)setupWithPreviousView{
    
    //top nav bar
    CGRect topBarFrame = CGRectMake(0, UA_TOP_WHITE, self.canvas.width, UA_TOP_BAR_HEIGHT);
    self.topNavBar = [[TopNavBar alloc] initWithFrame:topBarFrame text:@"Take Photo" lastView:@"TakePhoto"];
    [self.canvas addShape:self.topNavBar];

    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:[C4Image imageNamed:@"icon_PhotoLibrary"] withFrame:CGRectMake(0, 0, 45, 22.5) centerIcon:[C4Image imageNamed:@"icon_TakePhoto"] withFrame:CGRectMake(0, 0, 90, 45)];
    [self.canvas addShape:self.bottomNavBar];
    //take photo button
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"captureImage"];
    //photo library button
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToPhotoLibrary"];

    
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"goToCropPhoto"];
    counter=0;

}
-(void)cameraSetup{
    cam = [C4Camera cameraWithFrame:CGRectMake(0,UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, self.canvas.width, self.canvas.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT))];
    cam.cameraPosition = CAMERABACK;
    [self.canvas addCamera:cam];
    [cam initCapture];
    
}
-(void)captureImage{
    self.bottomNavBar.centerImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    [cam captureImage];
    C4Log(@"capturing image");
}
//--------------------------------------------------
//REMOVE STUFF FROM BEING DISPLAYED
//--------------------------------------------------
-(void)removeFromView{
    [self.topNavBar removeFromSuperview];
    [self.bottomNavBar removeFromSuperview];
}
//--------------------------------------------------
//NAVIGATION FUNCTIONS
//--------------------------------------------------
-(void)goToPhotoLibrary{
    self.bottomNavBar.leftImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    C4Log(@"goToPhotoLibrary");
}
-(void)goToCropPhoto{
    if (counter==0) {
        self.img = cam.capturedImage;
        [self removeFromView];
        C4Log(@"go to CropPhoto");
        [self postNotification:@"previousView_TakePhoto"];
        [self postNotification:@"goToCropPhoto"];
    }
    counter++;
}
@end
