
#import "C4Workspace.h"
//all the default variables
#define TopBarFromTopDefault 20.558
#define TopNavBarHeightDefault 44
#define BottomBarHeightDefault 49


@implementation C4WorkSpace

-(void)setup {
    //setup all the default variables
    navBarColorDefault=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    navigationColorDefault=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    buttonColorDefault= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColorDefault=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    overlayColorDefault=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5];
    highlightColorDefault=[UIColor colorWithRed:0.757 green:0.964 blue:0.617 alpha:0.5];
    
    [self createViews];
}

-(void) createViews{
    //setting up initial view >> TakePhoto
    takePhoto= [TakePhoto new];
    takePhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    takePhoto.canvas.userInteractionEnabled = YES;
    [takePhoto setupDefaultBottomBarHeight: BottomBarHeightDefault defaultNavBarHeight:TopNavBarHeightDefault defaultTopBarFromTop: TopBarFromTopDefault NavBarColor:navBarColorDefault NavigationColor:navigationColorDefault ButtonColor:buttonColorDefault TypeColor:typeColorDefault];
    [self.canvas addSubview:takePhoto.canvas];
    
    C4Log(@"canvas width %f", self.canvas.width);
    C4Log(@"canvas height %f", self.canvas.height);
    
    //crop photo
    cropPhoto= [CropPhoto new];
    cropPhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    cropPhoto.canvas.userInteractionEnabled = YES;
    [cropPhoto setupDefaultBottomBarHeight: BottomBarHeightDefault defaultNavBarHeight:TopNavBarHeightDefault defaultTopBarFromTop: TopBarFromTopDefault NavBarColor:navBarColorDefault NavigationColor:navigationColorDefault ButtonColor:buttonColorDefault TypeColor:typeColorDefault OverlayColor:overlayColorDefault];
    [self.canvas addSubview:cropPhoto.canvas];
    cropPhoto.canvas.hidden=YES;
    
    //assign photo
    assignPhoto= [AssignPhotoLetter new];
    assignPhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    assignPhoto.canvas.userInteractionEnabled = YES;
    [assignPhoto setupDefaultBottomBarHeight: BottomBarHeightDefault defaultNavBarHeight:TopNavBarHeightDefault defaultTopBarFromTop: TopBarFromTopDefault NavBarColor:navBarColorDefault NavigationColor:navigationColorDefault ButtonColor:buttonColorDefault TypeColor:typeColorDefault highlightColor:highlightColorDefault];
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
