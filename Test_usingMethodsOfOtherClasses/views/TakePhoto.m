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

@implementation TakePhoto
-(void) setup{
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    buttonColor= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    
    //Take PhotoButton
    photoButtonImage=[C4Image imageNamed:@"icons-02.png"];
    photoButtonImage.height=NavBarHeight;
    photoButtonImage.center=CGPointMake(self.canvas.width/2, self.canvas.height-NavBarHeight/2);
    [self.canvas addImage:photoButtonImage];
    [self listenFor:@"touchesBegan" fromObject:photoButtonImage andRunMethod:@"goToCropPhoto"];
    
    //mainWorkspace=[[C4WorkSpace alloc]init];
    
}

-(void)goToCropPhoto {
    //remove the current objects
    [photoButtonImage removeFromSuperview];
    
    //set up the new view
    C4Log(@"CropPhoto!");
    cropPhoto= [CropPhoto new];
    cropPhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    cropPhoto.canvas.userInteractionEnabled = YES;
    [cropPhoto setup];
    cropPhoto.mainCanvas=self.canvas;
    [self.canvas addSubview:cropPhoto.canvas];
    
}




@end
