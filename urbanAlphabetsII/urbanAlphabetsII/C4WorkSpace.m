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
    [self loadDefaultAlphabet];
    
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
    [takePhoto cameraSetup];
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

    [self.canvas addSubview:assignLetter.canvas ];
    assignLetter.canvas.hidden=YES;
}
-(void)loadDefaultAlphabet{
    NSArray *finnishAlphabet=[NSArray arrayWithObjects:
                                     //first row
                                     [C4Image imageNamed:@"letter_A.png"],
                                     [C4Image imageNamed:@"letter_B.png"],
                                     [C4Image imageNamed:@"letter_C.png"],
                                     [C4Image imageNamed:@"letter_D.png"],
                                     [C4Image imageNamed:@"letter_E.png"],
                                     [C4Image imageNamed:@"letter_F.png"],
                                     //second row
                                     [C4Image imageNamed:@"letter_G.png"],
                                     [C4Image imageNamed:@"letter_H.png"],
                                     [C4Image imageNamed:@"letter_I.png"],
                                     [C4Image imageNamed:@"letter_J.png"],
                                     [C4Image imageNamed:@"letter_K.png"],
                                     [C4Image imageNamed:@"letter_L.png"],
                                     
                                     [C4Image imageNamed:@"letter_M.png"],
                                     [C4Image imageNamed:@"letter_N.png"],
                                     [C4Image imageNamed:@"letter_O.png"],
                                     [C4Image imageNamed:@"letter_P.png"],
                                     [C4Image imageNamed:@"letter_Q.png"],
                                     [C4Image imageNamed:@"letter_R.png"],
                                     
                                     [C4Image imageNamed:@"letter_S.png"],
                                     [C4Image imageNamed:@"letter_T.png"],
                                     [C4Image imageNamed:@"letter_U.png"],
                                     [C4Image imageNamed:@"letter_V.png"],
                                     [C4Image imageNamed:@"letter_W.png"],
                                     [C4Image imageNamed:@"letter_X.png"],
                                     
                                     [C4Image imageNamed:@"letter_Y.png"],
                                     [C4Image imageNamed:@"letter_Z.png"],
                                     [C4Image imageNamed:@"letter_Ä.png"],
                                     [C4Image imageNamed:@"letter_Ö.png"],
                                     [C4Image imageNamed:@"letter_Å.png"],
                                     [C4Image imageNamed:@"letter_.png"],//.
                                     
                                     [C4Image imageNamed:@"letter_!.png"],
                                     [C4Image imageNamed:@"letter_-.png"],//?
                                     [C4Image imageNamed:@"letter_0.png"],
                                     [C4Image imageNamed:@"letter_1.png"],
                                     [C4Image imageNamed:@"letter_2.png"],
                                     [C4Image imageNamed:@"letter_3.png"],
                                     
                                     [C4Image imageNamed:@"letter_4.png"],
                                     [C4Image imageNamed:@"letter_5.png"],
                                     [C4Image imageNamed:@"letter_6.png"],
                                     [C4Image imageNamed:@"letter_7.png"],
                                     [C4Image imageNamed:@"letter_8.png"],
                                     [C4Image imageNamed:@"letter_9.png"],
                                     nil];
    //C4Log(@"finnish alphabet length: %i", [finnishAlphabet count]);
    currentAlphabet=[[NSMutableArray alloc]init];
    for (int i=0; i<[finnishAlphabet count]; i++) {
        C4Image *currentImage=[finnishAlphabet objectAtIndex:i];
        [currentAlphabet addObject:currentImage];
    }
    C4Log(@"current alphabet length: %i", [currentAlphabet count]);

}


//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToTakePhoto{
    [takePhoto resetCounter];
    [takePhoto setup];

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
    [assignLetter setup];
    [assignLetter drawCurrentAlphabet:currentAlphabet];
    [assignLetter drawCroppedPhoto:cropPhoto.croppedPhoto];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=NO;
}

@end
