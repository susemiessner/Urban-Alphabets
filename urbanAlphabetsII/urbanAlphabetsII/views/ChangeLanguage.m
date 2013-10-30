//
//  ChangeLanguage.m
//  urbanAlphabetsII
//
//  Created by Suse on 30/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "ChangeLanguage.h"


@implementation ChangeLanguage

-(void)transferVariables:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault highlightColor:(UIColor*)highlightColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault backImage:(C4Image*)iconBackDefault iconClose:(C4Image*)iconCloseDefault iconChecked:(C4Image*)iconCheckedDefault iconOk:(C4Image*)iconOkDefault currentLanguage:(NSString*)currentLanguageDefault{
    
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
    iconChecked=iconCheckedDefault;
    iconOk=iconOkDefault;
    
    currentLanguage=currentLanguageDefault;
    
    languages=[NSArray arrayWithObjects:@"Danish/Norwegian", @"English", @"Finnish/Swedish", @"German", @"Russian", nil];
    shapesForBackground=[[NSMutableArray alloc]init];
    for (int i=0; i<[languages count]; i++) {
        float height=46.203;
        float yPos=topBarFromTop+topBarHeight+i*height;
        C4Shape *shape=[C4Shape rect:CGRectMake(0, yPos, self.canvas.width, height)];
        shape.lineWidth=2;
        shape.strokeColor=navBarColor;
        shape.fillColor=navigationColor;
        [shapesForBackground addObject:shape];
    }
   
}
-(void)setup{
    [self topBarSetup];
    [self bottomBarSetup];
    [self contentSetup];
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
    titleLabel = [C4Label labelWithText:@"Change Language" font:fatFont];
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
    //--------------------------------------------------
    //RIGHT
    //--------------------------------------------------
    //close icon
    closeButtonImage=iconClose;
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    [self.canvas addImage:closeButtonImage];
    
    //invisible rect to interact with
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, topBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    [self.canvas addShape:closeRect];
    [self listenFor:@"touchesBegan" fromObject:closeRect andRunMethod:@"navigateBack"];
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
    //BUTTON CENTER> ok
    //--------------------------------------------------
    okButton=iconOk;
    okButton.width= 80;
    okButton.center=bottomNavBar.center;
    [self.canvas addImage:okButton];
    [self listenFor:@"touchesBegan" fromObject:okButton andRunMethod:@"changeLanguage"];
}
-(void)contentSetup{
    int selectedLanguage=10;
    int height=0;
     //C4Log(@"languagesArray length:%i", [languages count]);
     //C4Log(@"   shapesArray length:%i", [shapesForBackground count]);
    for (int i=0; i<[languages count]; i++) {
        
        //underlying shape
        C4Shape *shape=[shapesForBackground objectAtIndex:i];
        if ([languages objectAtIndex:i ] == currentLanguage) {
            shape.fillColor=highlightColor;
            selectedLanguage=i;
            height=shape.height;
        }
        [self.canvas addShape:shape];
        
        //text label
        C4Label *label=[C4Label labelWithText:[languages objectAtIndex:i] font:normalFont];
        label.textColor=typeColor;
        float height=46.203;
        float yPos=topBarFromTop+topBarHeight+i*height+label.height/2+4;
        label.origin=CGPointMake(49.485, yPos);
        [self.canvas addLabel:label];
        //[self listenFor:@"touchesBegan" fromObjects:@[shape,label] andRunMethod:@"languageChanged:"];
        [self listenFor:@"touchesBegan" fromObject:shape andRunMethod:@"languageChanged:"];
    }
    
    //√icon only 1x
    checkedIcon=iconChecked;
    checkedIcon.width= 35;
    checkedIcon.center=CGPointMake(checkedIcon.width/2+5, topBarFromTop+topBarHeight+(selectedLanguage+1)*height-height/2);
    [self.canvas addImage:checkedIcon];
    
}
-(void)languageChanged:(NSNotification *)notification{
    C4Shape *clickedObject = (C4Shape *)[notification object];
    //figure out which object was clicked
    float yPos=clickedObject.origin.y;
    //C4Log("clicked Object y:%f", yPos);
    yPos=yPos-topBarFromTop-topBarHeight;
    float elementNumber=yPos/clickedObject.height;
    elementNoChosen=lroundf(elementNumber);
    //C4Log(@"elementNumber:%f", elementNumber);
    //C4Log(@"elementno:    %i", elementNo);
    for (int i=0; i<[shapesForBackground count]; i++) {
        C4Shape *shape=[shapesForBackground objectAtIndex:i];
        
        if (i==elementNoChosen) {
            shape.fillColor=highlightColor;
            //C4Log(@"i=%i",i);
        } else {
            shape.fillColor=navigationColor;
        }
    }
    checkedIcon.center=CGPointMake(checkedIcon.width/2+5, topBarFromTop+topBarHeight+(elementNumber+1)*clickedObject.height-clickedObject.height/2);
    
}
-(void)removeFromView{
    //top
    [defaultRect removeFromSuperview];
    [topNavBar removeFromSuperview];
    [titleLabel removeFromSuperview];
    
    [backLabel removeFromSuperview];
    [backButtonImage removeFromSuperview];
    [navigateBackRect removeFromSuperview];
    
    [closeButtonImage removeFromSuperview];
    [closeRect removeFromSuperview];
    
    //bottom
    [bottomNavBar removeFromSuperview];
    [okButton removeFromSuperview];
    
    //content
    [checkedIcon removeFromSuperview];
    
    [self stopListeningFor:@"touchesBegan" objects:@[navigateBackRect,closeRect, okButton]];
    for (int i=0; i<[shapesForBackground count]; i++) {
        C4Shape *shape=[shapesForBackground objectAtIndex:i];
        [self stopListeningFor:@"touchesBegan" object:shape];
    }
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)navigateBack{
    C4Log(@"navigateBack");
    [self postNotification:@"goToAlphabetInfo"];
    [self removeFromView];
}
-(void)changeLanguage{
    C4Log(@"changeLanguage");
    self.chosenLanguage=[languages objectAtIndex:elementNoChosen];
    C4Log(@"chosenLanguage:%@", self.chosenLanguage);
    [self postNotification:@"languageChanged"];
    [self postNotification:@"goToAlphabetInfo"];
    [self removeFromView];
}
@end
