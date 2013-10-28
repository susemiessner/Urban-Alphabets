//
//  TakePhoto.m
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "TakePhoto.h"

@interface TakePhoto ()

@end

@implementation TakePhoto
-(void)transferVariables:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconTakePhoto:(C4Image*)iconTakePhotoDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault{
    //nav bar heights
    topBarFromTop=TopBarFromTopDefault;
    topBarHeight=TopNavBarHeightDefault;
    bottomBarHeight=BottomBarHeightDefault;
    //colors
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    typeColor=typeColorDefault;
    //fonts
    fatFont=fatFontDefault;
    normalFont=normalFontDefault;
    //icons
    iconTakePhoto=iconTakePhotoDefault;
    iconClose=iconCloseDefault;
    backButtonImage=iconBackDefault;

}
-(void)setup{
    [self topBarSetup];
    [self bottomBarSetup];
    //[self cameraSetup];
}
-(void)topBarSetup{
    //--------------------------------------------------
    //underlying rect
    //--------------------------------------------------
    topNavBar=[C4Shape rect:CGRectMake(0, topBarFromTop, self.canvas.width, topBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    //center label
    titleLabel = [C4Label labelWithText:@"Add Photo Letter" font:fatFont];
    titleLabel.center=topNavBar.center;
    [self.canvas addLabel:titleLabel];
    
    //--------------------------------------------------
    //LEFT
    //--------------------------------------------------
    //back text
    backLabel=[C4Label labelWithText:@"Back" font: normalFont];
    backLabel.center=CGPointMake(40, topNavBar.center.y);
    [self.canvas addLabel:backLabel];
    
    //back icon
    //backButtonImage=iconBack;
    backButtonImage.width= 12.2;
    backButtonImage.center=CGPointMake(10, topNavBar.center.y);
    [self.canvas addImage:backButtonImage];

    //invisible rect to interact with
    navigateBackRect=[C4Shape rect: CGRectMake(0, topBarFromTop, 60, topNavBar.height)];
    navigateBackRect.fillColor=navigationColor;
    navigateBackRect.lineWidth=0;
    [self.canvas addShape:navigateBackRect];
    [self listenFor:@"touchesBegan" fromObject:navigateBackRect andRunMethod:@"navigateBack"];
    
    //--------------------------------------------------
    //RIGHT
    //--------------------------------------------------
    //close icon
    closeButtonImage=iconClose;
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    //closeButtonImage.zPosition=2;
    [self.canvas addImage:closeButtonImage];
    
    //invisible rect to interact with
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, topBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
   // closeRect.zPosition=3;
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
    photoButtonImage=iconTakePhoto;
    photoButtonImage.height=45;
    photoButtonImage.width=90;
    photoButtonImage.center=CGPointMake(self.canvas.width/2, self.canvas.height-bottomBarHeight/2);
    [self.canvas addImage:photoButtonImage];
    //gestures to take the photo
    [self listenFor:@"touchesBegan" fromObject:photoButtonImage andRunMethod:@"captureImage"];
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"goToCropPhoto"];
}
-(void)cameraSetup{
    cam = [C4Camera cameraWithFrame:CGRectMake(0,topBarFromTop+topBarHeight, self.canvas.width, self.canvas.height-(topBarHeight+bottomBarHeight+topBarFromTop))];
    cam.cameraPosition = CAMERABACK;
    [self.canvas addCamera:cam];
    [cam initCapture];
    counter=0;
}
-(void) captureImage{
    [cam captureImage];
    C4Log(@"capturing image");
}
-(void)resetCounter{
    counter=0;
}
//------------------------------------------------------------------------
//REMOVE ALL ELEMENTS FROM VIEW WHEN NAVIGATING SOMEWHERE ELSE
//------------------------------------------------------------------------
-(void)removeFromView{
    [topNavBar removeFromSuperview];
    [titleLabel removeFromSuperview];
    [backLabel removeFromSuperview];
    [backButtonImage removeFromSuperview];
    [navigateBackRect removeFromSuperview];
    [closeButtonImage removeFromSuperview];
    [closeRect removeFromSuperview];
    [bottomNavBar removeFromSuperview];
    [photoButtonImage removeFromSuperview];
    //[cam removeFromSuperview];
    [self.img removeFromSuperview];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToCropPhoto{
    if (counter==0) {
        self.img = cam.capturedImage;
        [self removeFromView];
        C4Log(@"go to CropPhoto");
        [self postNotification:@"goToCropPhoto"];
        //[self removeFromView];
    }
    counter++;
}
-(void) navigateBack{
    C4Log(@"navigating back");
    //[self removeFromView];
}

-(void) goToAlphabetsView{
    C4Log(@"going to Alphabetsview");
    [self postNotification:@"goToAlphabetsView"];
    //[self removeFromView];
}
@end
