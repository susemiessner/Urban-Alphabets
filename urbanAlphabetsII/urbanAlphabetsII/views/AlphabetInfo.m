//
//  AlphabetInfo.m
//  urbanAlphabetsII
//
//  Created by Suse on 29/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AlphabetInfo.h"

@interface AlphabetInfo ()

@end

@implementation AlphabetInfo
-(void)transferVariables:(int) number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault greyType:(UIColor*)greyTypeDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault backImage:(C4Image*)iconBackDefault closeIcon:(C4Image*)iconCloseDefault alphabetIcon:(C4Image*)iconAlphabetDefault currentLanguage:(NSString*)currentLanguageDefault{
    
    //nav bar heights
    topBarFromTop=TopBarFromTopDefault;
    topBarHeight=TopNavBarHeightDefault;
    bottomBarHeight=BottomBarHeightDefault;
    
    //colors
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    typeColor=typeColorDefault;
    greyType=greyTypeDefault;
    
    //fonts
    fatFont=fatFontDefault;
    normalFont=normalFontDefault;
    
    //icons
    iconClose=iconCloseDefault;
    iconAlphabet=iconAlphabetDefault;
    iconBack=iconBackDefault;
    
    currentLanguage=currentLanguageDefault;
}
-(void)setup{
    [self topBarSetup];
    [self bottomBarSetup];
    [self addInfo];
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
    titleLabel = [C4Label labelWithText:@"Alphabet Info" font:fatFont];
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
    //closeButtonImage.zPosition=2;
    [self.canvas addImage:closeButtonImage];
    
    //invisible rect to interact with
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, topBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    // closeRect.zPosition=3;
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
    //BUTTON CENTER
    //--------------------------------------------------
    photoButtonImage=iconAlphabet;
    photoButtonImage.height=45;
    photoButtonImage.width=90;
    photoButtonImage.center=CGPointMake(self.canvas.width/2, self.canvas.height-bottomBarHeight/2);
    [self.canvas addImage:photoButtonImage];
    [self listenFor:@"touchesBegan" fromObject:photoButtonImage andRunMethod:@"goToAlphabetsView"];
}
-(void)addInfo{
    int yPos =topBarFromTop+topBarHeight+50;
    int lineHeight=40;
    int firstColumX=30;
    int secondColumX=firstColumX+100;

    nameLabel=[C4Label labelWithText:@"Name:" font:normalFont];
    nameLabel.textColor=greyType;
    nameLabel.origin=CGPointMake(firstColumX, yPos);
    [self.canvas addLabel:nameLabel];
    
    alphabetName=[C4Label labelWithText:@"Untitled" font:normalFont];
    alphabetName.textColor=typeColor;
    alphabetName.origin=CGPointMake(secondColumX, yPos);
    [self.canvas addLabel:alphabetName];
    
    yPos+=lineHeight;
    
    languageLabel=[C4Label labelWithText:@"Language:" font:normalFont];
    languageLabel.textColor=greyType;
    languageLabel.origin=CGPointMake(firstColumX, yPos);
    [self.canvas addLabel:languageLabel];
    
    language=[C4Label labelWithText:currentLanguage font: normalFont];
    language.textColor=typeColor;
    language.origin=CGPointMake(secondColumX, yPos);
    [self.canvas addLabel:language];
    
    int xPosChange=secondColumX+language.width+5;
    
    changeLanguage=[C4Label labelWithText:@"(change)" font:normalFont];
    
    if (xPosChange+changeLanguage.width > self.canvas.width) {
        xPosChange=secondColumX;
        yPos+=lineHeight-15;
    }
    
    changeLanguage.textColor=greyType;
    changeLanguage.origin=CGPointMake(xPosChange, yPos);
    [self.canvas addLabel:changeLanguage];
    
    [self listenFor:@"touchesBegan" fromObjects:@[languageLabel,language,changeLanguage] andRunMethod:@"goToChangeLanguage"];
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
    [photoButtonImage removeFromSuperview];
    
    //everything else
    [nameLabel removeFromSuperview];
    [alphabetName removeFromSuperview];
    [languageLabel removeFromSuperview];
    [language removeFromSuperview];
    [changeLanguage removeFromSuperview];
    
    [self stopListeningFor:@"touchesBegan" objects:@[navigateBackRect, closeRect, photoButtonImage, languageLabel,language,changeLanguage]];
}
-(void)currentLanguage:(NSString*)passedLanguage{
    currentLanguage=passedLanguage;
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------

-(void)navigateBack{
    C4Log(@"navigateBack");
    [self postNotification:@"goToAlphabetsView"];
    [self removeFromView];
}
-(void) goToAlphabetsView{
    C4Log(@"going to Alphabetsview");
    [self postNotification:@"goToAlphabetsView"];
    [self removeFromView];
}
-(void)goToChangeLanguage{
    C4Log(@"goToChangeLanguage");
    [self removeFromView];
    [self postNotification:@"goToChangeLanguage"];
}
@end
