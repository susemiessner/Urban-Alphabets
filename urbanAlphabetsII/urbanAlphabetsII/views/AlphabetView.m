//
//  AlphabetView.m
//  urbanAlphabetsII
//
//  Created by Suse on 28/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AlphabetView.h"

@interface AlphabetView ()

@end

@implementation AlphabetView
-(void)transferVaribles:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault darkenColor:(UIColor*)darkenColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault iconMenu:(C4Image*)iconMenuDefault iconTakePhoto:(C4Image*)iconTakePhotoDefault iconAlphabetInfo:(C4Image*)iconAlphabetInfoDefault iconShareAlphabet:(C4Image*)iconShareAlphabetDefault iconWritePostcard:(C4Image*)iconWritePostcardDefault iconMyPostcards:(C4Image*)iconMyPostcardsDefault iconMyAlphabets:(C4Image*)iconMyAlphabetsDefault currentAlphabet: (NSMutableArray*)defaultAlphabet{

    //nav bar heights
    topBarFromTop=TopBarFromTopDefault;
    topBarHeight=TopNavBarHeightDefault;
    bottomBarHeight=BottomBarHeightDefault;
    
    //colors
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    typeColor=typeColorDefault;
    darkenColor=darkenColorDefault;
    
    //fonts
    fatFont=fatFontDefault;
    normalFont=normalFontDefault;
    
    //icons
    iconClose=iconCloseDefault;
    iconBack=iconBackDefault;
    iconMenu=iconMenuDefault;
    iconTakePhoto=iconTakePhotoDefault;
    iconAlphabetInfo=iconAlphabetInfoDefault;
    iconShareAlphabet=iconShareAlphabetDefault;
    iconWritePostcard=iconWritePostcardDefault;
    iconMyPostcards=iconMyPostcardsDefault;
    iconMyAlphabets=iconMyAlphabetsDefault;
    
    currentAlphabet=defaultAlphabet;
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
    titleLabel = [C4Label labelWithText:@"Untitled" font:fatFont];
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
    
    //test navigation towards take photo
    takePhoto=[C4Label labelWithText:@"take Photo" font: normalFont];
    takePhoto.center=CGPointMake(self.canvas.width-(takePhoto.width/2+5), topNavBar.center.y);
    [self.canvas addLabel:takePhoto ];
    [self listenFor:@"touchesBegan" fromObject:takePhoto andRunMethod:@"goToTakePhoto"];

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
    //menu button in center
    //--------------------------------------------------
    menuButtonImage=iconMenu;
    menuButtonImage.width=45;
    menuButtonImage.center=bottomNavBar.center;
    [self.canvas addImage:menuButtonImage];
    [self listenFor:@"touchesBegan" fromObject:menuButtonImage andRunMethod:@"openMenu"];
    
    //--------------------------------------------------
    //TakePhotoButton on the left
    //--------------------------------------------------
    takePhotoButton=iconTakePhoto;
    takePhotoButton.width=60;
    takePhotoButton.center=CGPointMake(takePhotoButton.width/2+5, bottomNavBar.center.y);
    [self.canvas addImage:takePhotoButton];
    [self listenFor:@"touchesBegan" fromObject:takePhotoButton andRunMethod:@"goToTakePhoto"];
}
-(void)drawCurrentAlphabet: (NSMutableArray*)passedAlphabet{
    
    currentAlphabet=[passedAlphabet mutableCopy];
    C4Log(@"currentAlphabetLength: %i", [currentAlphabet count]);
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (NSUInteger i=0; i<[currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=2+topBarFromTop+topBarHeight+yMultiplier*imageHeight;
        C4Image *image=[currentAlphabet objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        [self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"openLetterView"];
    }
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

-(void)removeFromView{
    [defaultRect removeFromSuperview];
    [topNavBar removeFromSuperview];
    [titleLabel removeFromSuperview];
    
    [backLabel removeFromSuperview];
    [backButtonImage removeFromSuperview];
    [navigateBackRect removeFromSuperview];
    
    [bottomNavBar removeFromSuperview];
    [menuButtonImage removeFromSuperview];
    [takePhotoButton removeFromSuperview];
    
    for (int i=0; i<[currentAlphabet count]; i++) {
        C4Image *image=[currentAlphabet objectAtIndex:i];
        [image removeFromSuperview];
        
    }
    for (int i=0; i<[greyRectArray count]; i++) {
        C4Shape *shape=[greyRectArray objectAtIndex:i];
        [shape removeFromSuperview];
    }
    
    //test label
    [takePhoto removeFromSuperview];


}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)openMenu{
    C4Log(@"openMenu");
    [self removeFromView];

}

-(void) navigateBack{
    C4Log(@"navigating back");
    [self removeFromView];
    [self postNotification:@"navigatingBackBetweenAlphabet+AssignLetter"];
    //[self postNotification:@"goToAssignPhoto"];
}
-(void) goToTakePhoto{
    C4Log(@"goToTakePhoto");
    [self removeFromView];
    [self postNotification:@"goToTakePhoto"];
}
-(void)openLetterView{
    C4Log(@"open LetterView");
}
@end
