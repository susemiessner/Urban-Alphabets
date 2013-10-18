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
    takePhoto= [TakePhoto new];
    takePhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    takePhoto.canvas.userInteractionEnabled = YES;
    [takePhoto setup];
    takePhoto.mainCanvas=self.canvas;
    [self.canvas addSubview:takePhoto.canvas];
    
    
    //currentView = (C4View *)takePhoto.canvas ;
    
}


@end
