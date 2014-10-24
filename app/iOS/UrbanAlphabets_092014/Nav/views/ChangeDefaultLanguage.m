//
//  ChangeDefaultLanguage.m
//  ualphabets
//
//  Created by Suse on 29/06/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import "ChangeDefaultLanguage.h"
#import "BottomNavBar.h"
#import "C4WorkSpace.h"
#import "Settings.h"

@interface ChangeDefaultLanguage (){
    C4WorkSpace *workspace;
    Settings *settings;
    
    NSMutableArray *shapesForBackground;
    NSArray *languages; //all languages available
    NSMutableArray *languageLabels; //for all texts
    UIImageView *checkedIcon;
    int elementNoChosen;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite) NSString *defaultLanguage;
@end

@implementation ChangeDefaultLanguage
-(void) setupWithLanguage: (NSString*)passedLanguage{
    self.title=@"Change default language";
    self.defaultLanguage=passedLanguage;
    
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    shapesForBackground=[[NSMutableArray alloc]init];
    languageLabels=[[NSMutableArray alloc]init];
    
    
    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45)];
    [self.view addSubview:self.bottomNavBar];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"changeLanguage"];
    UITapGestureRecognizer *okButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLanguage)];
    okButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:okButtonRecognizer];
    
    
}
-(void)grabLanguagesViaNavigationController{
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    languages=workspace.languages;
    
    
    //content
    int selectedLanguage=20;
    int heightLabel=46;
    for (int i=0; i<[languages count]; i++) {
        //underlying shape
        float height=46.203;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*height;
        UIView *shape=[[UIView alloc]initWithFrame:CGRectMake(0, yPos, [[UIScreen mainScreen] bounds].size.width, height)];
        shape.layer.borderWidth=1.0f;
        shape.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        [shape setBackgroundColor:UA_NAV_CTRL_COLOR];
        
        UITapGestureRecognizer *languageTabbedRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(languageChanged:)];
        languageTabbedRecognizer.numberOfTapsRequired = 1;
        [shape addGestureRecognizer:languageTabbedRecognizer];

        
        if ([[languages objectAtIndex:i ] isEqualToString: self.defaultLanguage]) {
            [shape setBackgroundColor:UA_HIGHLIGHT_COLOR];
            selectedLanguage=i;
        }
        [shapesForBackground addObject:shape];
        shape.userInteractionEnabled=YES;
        [self.view addSubview:shape];
        
        float yPosLabel=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*heightLabel;
        
        //text label
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(100, yPosLabel, 200, shape.bounds.size.height) ];
        [label setText:[languages objectAtIndex:i]];
        [label setFont:UA_NORMAL_FONT];
        [label setTextColor:UA_TYPE_COLOR];
        label.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *languageChangedRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(languageChanged:)];
        languageChangedRecognizer.numberOfTapsRequired = 1;
        [label addGestureRecognizer:languageChangedRecognizer];
        
        [self.view addSubview:label];
        [languageLabels addObject:label];
    }
    //√icon only 1x
    checkedIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(selectedLanguage)*heightLabel+2, 46, 46)];
    checkedIcon.image=UA_ICON_CHECKED;
    [self.view addSubview:checkedIcon];
}
-(void)updateLanguage{
    id obj=[self.navigationController.viewControllers objectAtIndex:1];
    settings=(Settings*)obj;
    [settings updateDefaultLanguage];
}
-(void)changeLanguage{
    self.defaultLanguage=[languages objectAtIndex:elementNoChosen];
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    workspace.defaultLanguage=self.defaultLanguage;
    
    [workspace writeAlphabetsUserDefaults];
    [self updateLanguage];
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)languageChanged:(UITapGestureRecognizer *)notification{
    UIView *clickedObject = notification.view;
    //figure out which object was clicked
    float yPos=clickedObject.frame.origin.y;
    yPos=yPos-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT;
    float elementNumber=yPos/clickedObject.frame.size.height;
    elementNoChosen=(int)lroundf(elementNumber);
    for (int i=0; i<[shapesForBackground count]; i++) {
        UIView *shape=[shapesForBackground objectAtIndex:i];
        if (i==elementNoChosen) {
            [shape setBackgroundColor:UA_HIGHLIGHT_COLOR];
        } else {
            [shape setBackgroundColor:UA_NAV_CTRL_COLOR];
        }
    }
    [checkedIcon setFrame: CGRectMake(+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(elementNumber)*clickedObject.frame.size.height+2, 46,46)];
}
//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
