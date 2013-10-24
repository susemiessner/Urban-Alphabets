//
//  AssignPhotoLetter.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/21/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "AssignPhotoLetter.h"
#define TopNavBarHeight 42
#define TopBarFromTop 20.558
#define BottomNavBarHeight 49


@implementation AssignPhotoLetter

-(void)setup/*:(C4Image *)image*/{//passing on the image just taken
    //croppedPhoto=image;
    croppedPhoto=[C4Image imageNamed:@"image.jpg"];
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    buttonColor= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    overlayColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5];
    navigationColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [self topBarSetup];
    [self bottomBarSetup];
    
    [self greyGrid];
    [self drawDefaultLetters];
    notificationCounter=0;
    
}

-(void)topBarSetup{
    
    //white rect under top bar that stays
    defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, TopBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    
    
    //navigation bar
    topNavBar=[C4Shape rect:CGRectMake(0, TopBarFromTop, self.canvas.width, TopNavBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    takePhoto = [C4Label labelWithText:@"Assign photo letter" font:fatFont];
    takePhoto.center=topNavBar.center;
    [self.canvas addLabel:takePhoto];
    
    //upper left
    normalFont =[C4Font fontWithName:@"HelveticaNeue" size:17];
    backLabel=[C4Label labelWithText:@"Back" font: normalFont];
    backLabel.center=CGPointMake(40, topNavBar.center.y);
    [self.canvas addLabel:backLabel];
    
    backButtonImage=[C4Image imageNamed:@"icon_back.png"];
    backButtonImage.width= 12.2;
    backButtonImage.center=CGPointMake(10, topNavBar.center.y);
    [self.canvas addImage:backButtonImage];
    
    navigateBackRect=[C4Shape rect: CGRectMake(0, TopBarFromTop, 60, topNavBar.height)];
    navigateBackRect.fillColor=navigationColor;
    navigateBackRect.lineWidth=0;
    [self.canvas addShape:navigateBackRect];
    [self listenFor:@"touchesBegan" fromObject:navigateBackRect andRunMethod:@"navigateBack"];
    //upper right
    closeButtonImage=[C4Image imageNamed:@"icons_close.png"];
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    [self.canvas addImage:closeButtonImage];
    
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, TopBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    [self.canvas addShape:closeRect];
    [self listenFor:@"touchesBegan" fromObject:closeRect andRunMethod:@"goToAlphabetsView"];

}
-(void) bottomBarSetup{
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(BottomNavBarHeight), self.canvas.width, BottomNavBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];
    [self drawCroppedImage];
}
-(void)drawCroppedImage{
    croppedPhoto.width=32.788;
    croppedPhoto.center=CGPointMake(croppedPhoto.width/2+5, bottomNavBar.center.y);
    [self.canvas addImage:croppedPhoto];
    C4Log(@"croppedPhotoWidth %f", croppedPhoto.width);
}
-(void)drawDefaultLetters{
    
    /*NSArray *finnishAlphabet=[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E",@"F", @"G", @"H", @"I", @"J",@"K", @"L", @"M", @"N", @"O",@"P", @"Q", @"R", @"S", @"T",@"U", @"V", @"W", @"X", @"Y",@"Z", @"Ä", @"Ö", @"Å", @".",@"!", @"?", @"0", @"1", @"2",@"3", @"4", @"5", @"6", @"6", @"8", @"9",nil];
    }*/
    NSArray *finnishLetters=[NSArray arrayWithObjects:
                    [C4Image imageNamed:@"letter_A.png"],
                    [C4Image imageNamed:@"letter_B.png"],
                    [C4Image imageNamed:@"letter_C.png"],
                    [C4Image imageNamed:@"letter_D.png"],
                    [C4Image imageNamed:@"letter_E.png"],
                    [C4Image imageNamed:@"letter_F.png"],
                    
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
    defaultLetters=finnishLetters;
    
    C4Log(@"arrayLength:%i", [defaultLetters count]);
    int imageWidth=53.53;
    int imageHeight=65.1;
    for (NSUInteger i=0; i<[defaultLetters count]; i++) {
        int xMultiplier=(i)%6;
        int yMultiplier= (i)/6;
        int xPos=xMultiplier*imageWidth;
        int yPos=2+TopBarFromTop+TopNavBarHeight+yMultiplier*imageHeight;
        C4Image *image=[defaultLetters objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        [self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"highlightLetter:"];
    }
}

-(void)greyGrid{
    int imageWidth=53.53;
    int imageHeight=65.1;

    for (NSUInteger i=0; i<42; i++) {
        int xMultiplier=(i)%6;
        int yMultiplier= (i)/6;
        int xPos=xMultiplier*imageWidth;
        int yPos=2+TopBarFromTop+TopNavBarHeight+yMultiplier*imageHeight;
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=navigationColor;
        greyRect.lineWidth=2;
        greyRect.strokeColor=navBarColor;
        [self.canvas addShape:greyRect];
    }
}
-(void)highlightLetter:(NSNotification *)notification {
    for (int i=0; i<[defaultLetters count]; i++) {
        C4Image *currentImage= defaultLetters[i];
        currentImage.backgroundColor=navigationColor;
    }
    
    C4Image *currentImage = (C4Image *)notification.object;
    currentImage.backgroundColor= [UIColor colorWithRed:0.757 green:0.964 blue:0.617 alpha:0.5];
    
    //making sure that the "OK" button is only added ones not every time the person clicks on a new letter
    if (notificationCounter==0) {
        //add Ok button
        okButtonImage=[C4Image imageNamed:@"icons-20.png"];
        okButtonImage.height=45;
        okButtonImage.width=90;
        okButtonImage.center=bottomNavBar.center;
        [self.canvas addImage:okButtonImage];
        [self listenFor:@"touchesBegan" fromObject:okButtonImage andRunMethod:@"goToCollection"];
    }
    notificationCounter++;
}

-(void)goToCollection{
    C4Log(@"goToCollection");
}
-(void) navigateBack{
    C4Log(@"navigating back");
    [self postNotification:@"goToCropPhoto"];
    
}

@end
