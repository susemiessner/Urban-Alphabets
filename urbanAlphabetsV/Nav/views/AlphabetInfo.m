//
//  AlphabetInfo.m
//  UrbanAlphabets
//
//  Created by Suse on 12/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "AlphabetInfo.h"
#import "ChangeLanguage.h"
#import "C4WorkSpace.h"

@interface AlphabetInfo (){
    ChangeLanguage *changeLanguageView;
    C4WorkSpace *workspace;
    //labels for the actual info
    C4Label *nameLabel;
    C4Label *alphabetName;
    C4Label *languageLabel;
    C4Label *language;
    C4Label *changeLanguage;
    
}

@property (nonatomic) BottomNavBar *bottomNavBar;
@end

@implementation AlphabetInfo
-(void)setup {
    self.title=@"Alphabet Info";
    
    //self.currentLanguage=theLanguage;
    
    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_ALPHABET withFrame:CGRectMake(0, 0, 80, 40)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"goToAlphabetView"];
    
    
    
    
}

-(void)grabCurrentLanguageViaNavigationController {
    C4Log(@"%d",[self.navigationController.viewControllers count]);
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    C4Log(@"obj:%@", obj);
    workspace=(C4WorkSpace*)obj;
    C4Log(@"workspace: %@", workspace);
    
    self.currentLanguage=workspace.currentLanguage;
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
-(void)changeLanguage{
    language.text=workspace.currentLanguage;

}

//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------

-(void)goToChangeLanguage{
    C4Log(@"goToChangeLanguage");
    
    changeLanguageView=[[ChangeLanguage alloc]initWithNibName:@"ChangeLanguage" bundle:[NSBundle mainBundle]];
    C4Log(@"currentLanguage:%@", self.currentLanguage);
    [changeLanguageView setupWithLanguage:self.currentLanguage];
    [self.navigationController pushViewController:changeLanguageView animated:YES];
}
-(void)goToAlphabetView{
    C4Log(@"goToAlphabetView");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
