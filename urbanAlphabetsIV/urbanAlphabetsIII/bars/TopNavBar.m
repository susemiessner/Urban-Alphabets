//
//  TopNavBar.m
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "TopNavBar.h"

@interface TopNavBar ()

@property (readwrite, strong) NSString *previousView;
@end

@implementation TopNavBar
//with navigation
- (id)initWithFrame:(CGRect)frame text:(NSString*)titleText lastView:(NSString*)lastView
{
    self = [super initWithFrame:frame];
    if (self) {
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        [self rect:self.frame];
        self.fillColor=UA_NAV_BAR_COLOR;
        self.lineWidth=0;
        
        //center label
        self.titleLabel = [C4Label labelWithText:titleText font:UA_FAT_FONT];
        [self addLabel:self.titleLabel];        //add the label to the nav bar
        
        //--------------------------------------------------
        //LEFT
        //--------------------------------------------------
        //back text
        self.backLabel=[C4Label labelWithText:@"Back" font:UA_NORMAL_FONT];
        [self addLabel:self.backLabel];
        
        //back icon
        self.backButton = [C4Image imageWithImage:[C4Image imageNamed:@"icon_back1"]];
        self.backButton.frame = CGRectMake(0, 0, 12.2, 20.2);
        [self addImage:self.backButton];
        
        //--------------------------------------------------
        //RIGHT
        //--------------------------------------------------
        //close icon
        self.closeButton=[C4Image imageWithImage:[C4Image imageNamed:@"icon_Close"]];
        self.closeButton.frame= CGRectMake(0, 0, 25, 25);
        [self addImage:self.closeButton];
        
        
        [self listenFor:@"touchesBegan" fromObjects:@[self.backLabel, self.backButton] andRunMethod:@"goBack"];
        [self listenFor:@"touchesBegan" fromObject:self.closeButton andRunMethod:@"goToAlphabetView"];
        [self fitToFrame:self.frame];
        
        self.previousView=lastView;
    }
    return self;
}


-(void)fitToFrame:(CGRect)frame {
    self.frame = frame;
    self.titleLabel.center = CGPointMake(self.width / 2.0f, self.height/2.0f);
    self.backLabel.center=CGPointMake(44, self.height / 2.0f);
    self.backButton.center=CGPointMake(10, self.height / 2.0f);
    self.closeButton.center=CGPointMake(self.width-self.closeButton.width/2-5, self.height/2);
}
-(void)goBack{
    self.backButton.backgroundColor=UA_HIGHLIGHT_COLOR;
    self.backLabel.backgroundColor=UA_HIGHLIGHT_COLOR;
    C4Log(@"navigating back");
    [self postNotification:@"hideAlphabetView"];
    C4Log(@"toView %@",self.previousView);
    if ([self.previousView isEqual:@"TakePhoto"]) {
        [self postNotification:@"previousView_TakePhoto"];
        [self postNotification:@"goToTakePhoto"];
    } else if ([self.previousView isEqual:@"CropPhoto"]) {
        [self postNotification:@"previousView_CropPhoto"];
        [self postNotification:@"goToCropPhoto"];
    } else if ([self.previousView isEqual:@"AssignLetter"]) {
        [self postNotification:@"previousView_AssignLetter"];
        [self postNotification:@"goToAssignLetter"];
    }else if ([self.previousView isEqual:@"AlphabetView"]) {
        [self postNotification:@"previousView_AlphabetView"];
        [self postNotification:@"goToAlphabetsView"];
    }else if ([self.previousView isEqual:@"AlphabetInfo"]) {
        [self postNotification:@"previousView_AlphabetInfo"];
        [self postNotification:@"goToAlphabetInfo"];
    }else if ([self.previousView isEqual:@"WritePostcard"]) {
        [self postNotification:@"previousView_WritePostcard"];
        [self postNotification:@"goToWritePostcard"];
    }else if([self.previousView isEqual:@"LetterView"]){
        [self postNotification:@"previousView_LetterView"];
        [self postNotification:@"goToLetterView"];
    }else if([self.previousView isEqual:@"AlphabetInfo"]){
        [self postNotification:@"previousView_AlphabetInfo"];
        [self postNotification:@"goToAlphabetInfo"];
    }else if([self.previousView isEqual:@"ChangeLanguage"]){
        [self postNotification:@"previousView_ChangeLanguage"];
        [self postNotification:@"goToChangeLanguage"];
    }
    
}
-(void)goToAlphabetView{
    C4Log(@"goToAlphabetView");
    self.closeButton.backgroundColor=UA_HIGHLIGHT_COLOR;
    [self postNotification:@"goToAlphabetsView"];

}
//without navigation
- (id)initWithFrame:(CGRect)frame text:(NSString*)titleText
{
    self = [super initWithFrame:frame];
    if (self) {
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        [self rect:self.frame];
        self.fillColor=UA_NAV_BAR_COLOR;
        self.lineWidth=0;
        
        //center label
        self.titleLabel = [C4Label labelWithText:titleText font:UA_FAT_FONT];
        [self addLabel:self.titleLabel];        //add the label to the nav bar
        
        self.titleLabel.center = CGPointMake(self.width / 2.0f, self.height/2.0f);
        
    }
    return self;
}


@end
