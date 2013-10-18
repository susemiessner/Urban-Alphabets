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

@implementation CropPhoto{
    //common variables
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    UIColor *overlayColor;
    
    
    C4Image *okButtonImage;
    TakePhoto *takePhoto;
    
}
-(void) setup{
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    buttonColor= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    overlayColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5];
    
    //IMAGE AS BUTTON
    okButtonImage=[C4Image imageNamed:@"icons-20.png"];
    okButtonImage.height=NavBarHeight;
    okButtonImage.center=CGPointMake(self.canvas.width/2, self.canvas.height-NavBarHeight/2);
    [self.canvas addImage:okButtonImage];
    [self listenFor:@"touchesBegan" fromObject:okButtonImage andRunMethod:@"goToTakePhoto"];
}
-(void)goToTakePhoto {
    //remove the current objects
    [okButtonImage removeFromSuperview];
    
    //set up the new view
    C4Log(@"TakePhoto!");
    takePhoto= [TakePhoto new];
    takePhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    takePhoto.canvas.userInteractionEnabled = YES;
    [takePhoto setup];
    takePhoto.mainCanvas=self.canvas;
    [self.canvas addSubview:takePhoto.canvas];
    
}





@end
