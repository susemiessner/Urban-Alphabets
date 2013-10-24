//
//  C4WorkSpace.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//

#import "C4Workspace.h"

#define bottomBarHeight 42
#define NavBarHeight 42
#define TopBarFromTop 20

@implementation C4WorkSpace

-(void)setup {
    [self createViews];
}

-(void) createViews{
    //setting up initial view >> TakePhoto
    takePhoto= [TakePhoto new];
    takePhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    takePhoto.canvas.userInteractionEnabled = YES;
    [takePhoto setup];
    [self.canvas addSubview:takePhoto.canvas];
    
    C4Log(@"canvas width %f", self.canvas.width);
    C4Log(@"canvas height %f", self.canvas.height);
    
    //crop photo
    cropPhoto= [CropPhoto new];
    cropPhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    cropPhoto.canvas.userInteractionEnabled = YES;
    //[cropPhoto setup];
    [self.canvas addSubview:cropPhoto.canvas];
    cropPhoto.canvas.hidden=YES;
    
    [self listenFor:@"goToCropPhoto" andRunMethod:@"goToCropPhoto"];
}
-(void)goToCropPhoto{
    C4Log(@"CropPhoto");
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=NO;
    [self postNotification:@"getPhoto"];
}


@end
