//
//  C4WorkSpace.m
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//

#import "C4Workspace.h"

@implementation C4WorkSpace

-(void)setup {
    //setup all the default variables
    //>colors
    navBarColorDefault=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    navigationColorDefault=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    buttonColorDefault= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColorDefault=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    overlayColorDefault=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5];
    highlightColorDefault=[UIColor colorWithRed:0.757 green:0.964 blue:0.617 alpha:0.5];
    
    //>nav bar heights
    TopBarFromTopDefault=   20.558;
    TopNavBarHeightDefault= 44.0;
    BottomBarHeightDefault= 49;
    
    //>type/fonts
    fatFontDefault=     [C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    normalFontDefault=  [C4Font fontWithName:@"HelveticaNeue" size:17];
    
    //>icons
    iconTakePhoto=  [C4Image imageNamed:@"icon_TakePhoto.png"];
    iconClose=      [C4Image imageNamed:@"icon_Close.png"];
    iconBack=       [C4Image imageNamed:@"icon_back.png"];
    iconOk=         [C4Image imageNamed:@"icon_OK.png"];
    iconSettings=   [C4Image imageNamed:@"icon_Settings.png"];
    
    
    [self createViews];
    
    //the methods to listen for from all other canvasses
    [self listenFor:@"goToTakePhoto" andRunMethod:@"goToTakePhoto"];
    [self listenFor:@"goToCropPhoto" andRunMethod:@"goToCropPhoto"];
    [self listenFor:@"goToAssignPhoto" andRunMethod:@"goToAssignPhoto"];

}
-(void)createViews{
    //TakePhoto
    takePhoto= [TakePhoto new];
    takePhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    takePhoto.canvas.userInteractionEnabled = YES;
    [takePhoto transferVariables:1 topBarFromTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault fatFont:fatFontDefault normalFont:normalFontDefault iconTakePhoto:iconTakePhoto iconClose:iconClose iconBack:iconBack];
    [takePhoto setup];

    [self.canvas addSubview:takePhoto.canvas];
    
    //CropPhoto
    cropPhoto=[CropPhoto new];
    cropPhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    cropPhoto.canvas.userInteractionEnabled=YES;
    [cropPhoto transferVariables:1 topBarFroTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault overlayColor:overlayColorDefault fatFont:fatFontDefault normalFont:normalFontDefault iconClose:iconClose iconBack:iconBack iconOk:iconOk];
    [self.canvas addSubview:cropPhoto.canvas];
    cropPhoto.canvas.hidden= YES;
    
    //AssignPhoto
    assignLetter=[AssignLetter new];
    assignLetter.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    assignLetter.canvas.userInteractionEnabled=YES;
    [assignLetter transferVariables:1 topBarFroTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault highlightColor:highlightColorDefault fatFont:fatFontDefault normalFont:normalFontDefault iconClose:iconClose iconBack:iconBack iconOk:iconOk iconSettings:iconSettings];
    [assignLetter setup];

    [self.canvas addSubview:assignLetter.canvas ];
    assignLetter.canvas.hidden=YES;
}
-(void)goToTakePhoto{
    [takePhoto resetCounter];
    //[takePhoto setup];

    C4Log(@"TakePhoto");
    takePhoto.canvas.hidden=NO;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=YES;
}
-(void)goToCropPhoto{
    C4Log(@"going to CropPhoto");
    [cropPhoto displayImage:takePhoto.img];
    [cropPhoto setup];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=NO;
    assignLetter.canvas.hidden=YES;
}
-(void)goToAssignPhoto{
    C4Log(@"AssignPhoto");
    //[assignLetter setup];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=NO;
}

@end
