//
//  AlphabetInfo.m
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AlphabetInfo.h"

@interface AlphabetInfo (){
    //labels for the actual info
    C4Label *nameLabel;
    C4Label *alphabetName;
    C4Label *languageLabel;
    C4Label *language;
    C4Label *changeLanguage;

}
@property (nonatomic) TopNavBar *topNavBar;
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (nonatomic) NSString *currentLanguage;
@end

@implementation AlphabetInfo

-(void)setupWithLanguage:(NSString*)theLanguage {
    self.currentLanguage=theLanguage;
    //top nav bar
    CGRect topBarFrame = CGRectMake(0, UA_TOP_WHITE, self.canvas.width, UA_TOP_BAR_HEIGHT);
    self.topNavBar = [[TopNavBar alloc] initWithFrame:topBarFrame text:@"Alphabet info" lastView:@"AlphabetView"];
    [self.canvas addShape:self.topNavBar];
 
    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:[C4Image imageNamed:@"icon_Alphabet"] withFrame:CGRectMake(0, 0, 80, 40)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"goToAlphabetView"];
    
    
    //setup the info
    int yPos =UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+50;
    int lineHeight=40;
    int firstColumX=30;
    int secondColumX=firstColumX+100;
    
    nameLabel=[C4Label labelWithText:@"Name:" font:UA_NORMAL_FONT];
    nameLabel.textColor=UA_GREY_TYPE_COLOR;
    nameLabel.origin=CGPointMake(firstColumX, yPos);
    [self.canvas addLabel:nameLabel];
    
    alphabetName=[C4Label labelWithText:@"Untitled" font:UA_NORMAL_FONT];
    alphabetName.textColor=UA_TYPE_COLOR;
    alphabetName.origin=CGPointMake(secondColumX, yPos);
    [self.canvas addLabel:alphabetName];
    
    yPos+=lineHeight;
    
    languageLabel=[C4Label labelWithText:@"Language:" font:UA_NORMAL_FONT];
    languageLabel.textColor=UA_GREY_TYPE_COLOR;
    languageLabel.origin=CGPointMake(firstColumX, yPos);
    [self.canvas addLabel:languageLabel];
    
    language=[C4Label labelWithText:self.currentLanguage font: UA_NORMAL_FONT];
    language.textColor=UA_TYPE_COLOR;
    language.origin=CGPointMake(secondColumX, yPos);
    [self.canvas addLabel:language];
    
    int xPosChange=secondColumX+language.width+5;
    
    changeLanguage=[C4Label labelWithText:@"(change)" font:UA_NORMAL_FONT];
    
    if (xPosChange+changeLanguage.width > self.canvas.width) {
        xPosChange=secondColumX;
        yPos+=lineHeight-15;
    }
    
    changeLanguage.textColor=UA_GREY_TYPE_COLOR;
    changeLanguage.origin=CGPointMake(xPosChange, yPos);
    [self.canvas addLabel:changeLanguage];
    
    [self listenFor:@"touchesBegan" fromObjects:@[languageLabel,language,changeLanguage] andRunMethod:@"goToChangeLanguage"];

}
//------------------------------------------------------------------------
//REMOVE FROM VIEW
//------------------------------------------------------------------------
-(void)removeFromView{
    [self.topNavBar removeFromSuperview];
    [self.bottomNavBar removeFromSuperview];
    
    [nameLabel removeFromSuperview];
    [alphabetName removeFromSuperview];
    [languageLabel removeFromSuperview];
    [language removeFromSuperview];
    [changeLanguage removeFromSuperview];

}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToAlphabetView{
    [self postNotification:@"goToAlphabetsView"];
    [self removeFromView];
}

-(void)goToChangeLanguage{
    C4Log(@"goToChangeLanguage");
    [self removeFromView];
    [self postNotification:@"goToChangeLanguage"];
}
@end
