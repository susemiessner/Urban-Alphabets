//
//  AssignLetter.m
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AssignLetter.h"

@interface AssignLetter ()

@end

@implementation AssignLetter

-(void)transferVariables:(int) number topBarFroTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault highlightColor:(UIColor*)highlightColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault iconOk:(C4Image*)iconOkDefault iconSettings:(C4Image*)iconSettingsDefault{
    //nav bar heights
    topBarFromTop=TopBarFromTopDefault;
    topBarHeight=TopNavBarHeightDefault;
    bottomBarHeight=BottomBarHeightDefault;
    //colors
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    typeColor=typeColorDefault;
    highlightColor=highlightColorDefault;
    //fonts
    fatFont=fatFontDefault;
    normalFont=normalFontDefault;
    //icons
    iconClose=iconCloseDefault;
    iconBack=iconBackDefault;
    iconOk=iconOkDefault;
    iconSettings=iconSettingsDefault;

}
-(void)setup{
    [self topBarSetup];
    [self bottomBarSetup];
    [self greyGrid];
}
-(void)topBarSetup{
    //--------------------
    //white rect under top bar
    //--------------------
    defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, topBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    
    //--------------------
    //top bar
    //--------------------
    topNavBar=[C4Shape rect:CGRectMake(0, topBarFromTop, self.canvas.width, topBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    //title in center
    titleLabel = [C4Label labelWithText:@"Assign photo letter" font:fatFont];
    titleLabel.center=topNavBar.center;
    [self.canvas addLabel:titleLabel];
    
    //--------------------
    //LEFT
    //--------------------
    //back text
    backLabel=[C4Label labelWithText:@"Back" font: normalFont];
    backLabel.center=CGPointMake(40, topNavBar.center.y);
    [self.canvas addLabel:backLabel];
    
    //back icon
    backButtonImage=iconBack;
    backButtonImage.width= 12.2;
    backButtonImage.center=CGPointMake(10, topNavBar.center.y);
    [self.canvas addImage:backButtonImage];
    
    //invisible rect for navigation
    navigateBackRect=[C4Shape rect: CGRectMake(0, topBarFromTop, 60, topNavBar.height)];
    navigateBackRect.fillColor=navigationColor;
    navigateBackRect.lineWidth=0;
    [self.canvas addShape:navigateBackRect];
    [self listenFor:@"touchesBegan" fromObject:navigateBackRect andRunMethod:@"navigateBack"];

    //--------------------
    //RIGHT
    //--------------------
    //close icon
    closeButtonImage=iconClose;
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    [self.canvas addImage:closeButtonImage];
    
    //invisible rect for navigation
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, topBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
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
    //BUTTON RIGHT (SETTINGS)
    //--------------------------------------------------
    settingsButtonImage=iconSettings;
    settingsButtonImage.width=30.017;
    settingsButtonImage.center=CGPointMake(self.canvas.width-settingsButtonImage.width/2-5, bottomNavBar.center.y);
    [self.canvas addImage:settingsButtonImage];
    [self listenFor:@"touchesBegan" fromObject:settingsButtonImage andRunMethod:@"goToSettings"];

}
-(void)drawCurrentAlphabet: (NSMutableArray*)currentAlphabetPassed{
    notificationCounter=0; //to make sure ok button is only added 1x
    
    self.currentAlphabet=[currentAlphabetPassed mutableCopy];
    //C4Log(@"currentAlphabetLength: %i", [self.currentAlphabet count]);
    C4Log(@"drawing the alphabet");
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=2+topBarFromTop+topBarHeight+yMultiplier*imageHeight;
        C4Image *image=[self.currentAlphabet objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        [self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"highlightLetter:"];
    }
}
-(void)highlightLetter:(NSNotification *)notification {
    
    for (int i=0; i<[self.currentAlphabet count]; i++) {
        currentImage= self.currentAlphabet[i];
        currentImage.backgroundColor=navigationColor;
    }
    
    currentImage = (C4Image *)notification.object;
    C4Log(@"currentImage x:%f",currentImage.origin.x);
    chosenImage=CGPointMake(currentImage.origin.x, currentImage.origin.y);
    currentImage.backgroundColor= highlightColor;
    
    
    //making sure that the "OK" button is only added ones not every time the person clicks on a new letter
    if (notificationCounter==0) {
        //add Ok button
        okButtonImage=[C4Image imageNamed:@"icon_OK.png"];
        okButtonImage.height=45;
        okButtonImage.width=90;
        okButtonImage.center=bottomNavBar.center;
        [self.canvas addImage:okButtonImage];
        [self listenFor:@"touchesBegan" fromObject:okButtonImage andRunMethod:@"goToAlphabetsViewAddingImageToAlphabet"];
    }
    notificationCounter++;
    
}
-(void)greyGrid{
    float imageWidth=53.53;
    float imageHeight=65.1;
    greyRectArray=[[NSMutableArray alloc]init];
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i
                         )%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=2+topBarFromTop+topBarHeight+yMultiplier*imageHeight;
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=navigationColor;
        greyRect.lineWidth=2;
        greyRect.strokeColor=navBarColor;
        [greyRectArray addObject:greyRect];
        [self.canvas addShape:greyRect];
    }
    //C4Log(@"greyRect Array length:%i",[greyRectArray count]);
}
-(void)drawCroppedPhoto:(C4Image*)croppedPhoto{
    croppedImage=croppedPhoto;
    C4Log(@"drawing cropped Photo");
    croppedImage.width=32.788;
    croppedImage.height=40.422;
    croppedImage.center=CGPointMake(croppedImage.width/2+5, bottomNavBar.center.y);
    [self.canvas addImage:croppedImage];
}
-(void)removeFromView{
    //top bar
    [defaultRect removeFromSuperview];
    [topNavBar removeFromSuperview];
    [titleLabel removeFromSuperview];
    //left
    [backLabel removeFromSuperview];
    [backButtonImage removeFromSuperview];
    [navigateBackRect removeFromSuperview];
    //right
    [closeButtonImage removeFromSuperview];
    [closeRect removeFromSuperview];
    
    //bottom bar
    [bottomNavBar removeFromSuperview];
    [okButtonImage removeFromSuperview];
    [settingsButtonImage removeFromSuperview];
    [croppedImage removeFromSuperview];
    
    //highlighted image
    [currentImage removeFromSuperview];
    
    for (int i=0; i<[self.currentAlphabet count]; i++) {
        C4Image *image=[self.currentAlphabet objectAtIndex:i];
        [image removeFromSuperview];
        [self stopListeningFor:@"touchesBegan" object:image];
    }
    for (int i=0; i<[greyRectArray count]; i++) {
        C4Shape *shape=[greyRectArray objectAtIndex:i];
        [shape removeFromSuperview];
    }
    [self stopListeningFor:@"touchesBegan" objects:@[navigateBackRect, closeRect, settingsButtonImage, okButtonImage]];
}

//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) navigateBack{
    C4Log(@"navigating back");
    [self removeFromView];
    [self postNotification:@"goToCropPhoto"];
}
-(void) goToAlphabetsView{
    C4Log(@"going to Alphabetsview");
    [self postNotification:@"goToAlphabetsView"];
    
    [self removeFromView];
}

-(void) goToAlphabetsViewAddingImageToAlphabet{
    //--------------------------------------------------
    //which image was chosen
    //--------------------------------------------------
    

    C4Log(@"going to Alphabetsview");
    float imageWidth=53.53;
    float imageHeight=65.1;
    float i=chosenImage.x/imageWidth;
    //C4Log(@"i:%i", i);
    float j=chosenImage.y/imageHeight;
    //C4Log(@"j:%i", j);
    
    self.chosenImageNumberInArray=((j-1)*6)+i;
    //C4Log(@"chosenImageNo:%i",chosenImageNumberInArray);

    //C4Log(@"currentAlphabet length (before removing): %i", [self.currentAlphabet count]);
    [self.currentAlphabet removeObjectAtIndex:self.chosenImageNumberInArray];
    //C4Log(@"currentAlphabet length (after removing) : %i", [self.currentAlphabet count]);
    [self.currentAlphabet insertObject:croppedImage atIndex:self.chosenImageNumberInArray];
    //C4Log(@"currentAlphabet length (after inserting): %i", [self.currentAlphabet count]);

    //ending here

    [self postNotification:@"currentAlphabetChanged"];
    
    [self removeFromView];
    [self postNotification:@"goToAlphabetsView"];
}
-(void)goToSettings{
    C4Log(@"go to Settings");
    [self removeFromView];

}


@end
