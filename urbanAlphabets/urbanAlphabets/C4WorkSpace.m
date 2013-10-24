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
    [cropPhoto setup];
    [self.canvas addSubview:cropPhoto.canvas];
    cropPhoto.canvas.hidden=YES;
    
    //assign photo
    assignPhoto= [AssignPhotoLetter new];
    assignPhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    assignPhoto.canvas.userInteractionEnabled = YES;
    [assignPhoto setup];
    [self.canvas addSubview:assignPhoto.canvas];
    assignPhoto.canvas.hidden=YES;
    [self listenFor:@"goToTakePhoto" andRunMethod:@"goToTakePhoto"];
    [self listenFor:@"goToCropPhoto" andRunMethod:@"goToCropPhoto"];
    [self listenFor:@"goToAssignPhoto" andRunMethod:@"goToAssignPhoto"];
}

-(void)goToTakePhoto{
    [takePhoto resetCounter];
    C4Log(@"TakePhoto");
    takePhoto.canvas.hidden=NO;
    cropPhoto.canvas.hidden=YES;
    assignPhoto.canvas.hidden=YES;
}


-(void)goToCropPhoto{
    C4Log(@"CropPhoto");
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=NO;
    assignPhoto.canvas.hidden=YES;
    [self postNotification:@"getPhoto"];
}

-(void)goToAssignPhoto{
    C4Log(@"AssignPhoto");
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignPhoto.canvas.hidden=NO;
}


@end
