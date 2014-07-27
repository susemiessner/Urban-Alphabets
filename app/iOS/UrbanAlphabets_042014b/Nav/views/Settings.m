//
//  Settings.m
//  ualphabets
//
//  Created by Suse on 27/06/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import "Settings.h"
#import "C4WorkSpace.h"
#import "ChangeDefaultLanguage.h"

@interface Settings (){
    UILabel *usernameLabel, *changeUsername, *defaultLanguageLabel, *language, *changeLanguage;
    UITextView *usernameField;
    C4WorkSpace *workspace;
    ChangeDefaultLanguage *changeDefaultLanguage;

}
@property (nonatomic) BottomNavBar *bottomNavBar;

@end

@implementation Settings

-(void)setup {
    self.title=@"Settings";
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_ALPHABET withFrame:CGRectMake(0, 0, 80, 40)];
    [self.view addSubview:self.bottomNavBar];
    UITapGestureRecognizer *alphabetButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAlphabetView)];
    alphabetButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:alphabetButtonRecognizer];
}
-(void)grabCurrentUsernameViaNavigationController{
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    self.userName=workspace.userName;
    self.defaultLanguage=workspace.defaultLanguage;
    //setup the info
    int yPos =UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+50;
    int lineHeight=40;
    int firstColumX=30;
    int secondColumX=firstColumX+100;
    
    usernameLabel=[[UILabel alloc]initWithFrame:CGRectMake(firstColumX, yPos, 200, 20)];
    [usernameLabel setText:@"Name:"];
    [usernameLabel setFont:UA_NORMAL_FONT];
    [usernameLabel setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:usernameLabel];
    usernameLabel.userInteractionEnabled=YES;
    
    //add text field
    CGRect textViewFrame = CGRectMake(secondColumX-3, yPos-10, 200, 30);
    usernameField = [[UITextView alloc] initWithFrame:textViewFrame];
    usernameField.text=self.userName;
    usernameField.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    usernameField.textColor=UA_TYPE_COLOR;
    usernameField.returnKeyType = UIReturnKeyDone;
    usernameField.delegate = self;
    [self.view addSubview:usernameField];
    
    
    yPos+=lineHeight-15;
    changeUsername=[[UILabel alloc]initWithFrame:CGRectMake(secondColumX, yPos, 100, 20)];
    [changeUsername setText:@"(change)"];
    [changeUsername setFont:UA_NORMAL_FONT];
    [changeUsername setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:changeUsername];
    changeUsername.userInteractionEnabled=YES;
    
    //default language
    yPos+=lineHeight;
    defaultLanguageLabel=[[UILabel alloc]initWithFrame:CGRectMake(firstColumX, yPos, 100, 40)];
    defaultLanguageLabel.numberOfLines=0;
    [defaultLanguageLabel setText:@"Default \nlanguage:"];
    [defaultLanguageLabel setFont:UA_NORMAL_FONT];
    [defaultLanguageLabel setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:defaultLanguageLabel];
    defaultLanguageLabel.userInteractionEnabled=YES;
    
    language=[[UILabel alloc]initWithFrame:CGRectMake(secondColumX, yPos+21, 200, 20)];
    [language setText:self.defaultLanguage];
    [language setFont:UA_NORMAL_FONT];
    [language setTextColor:UA_TYPE_COLOR];
    [self.view addSubview:language];
    language.userInteractionEnabled=YES;
    
    int xPosChange=secondColumX+language.frame.size.width+5;
    if (xPosChange+changeLanguage.frame.size.width > [[UIScreen mainScreen] bounds].size.width) {
        xPosChange=secondColumX;
        yPos+=lineHeight-15;
    }
    changeLanguage=[[UILabel alloc]initWithFrame:CGRectMake(xPosChange, yPos+21, 100, 20)];
    [changeLanguage setText:@"(change)"];
    [changeLanguage setFont:UA_NORMAL_FONT];
    [changeLanguage setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:changeLanguage];
    changeLanguage.userInteractionEnabled=YES;
    
    //gesture recognizers
    
    //username
    UITapGestureRecognizer *usernameLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUsername)];
    usernameLabelRecognizer.numberOfTapsRequired = 1;
    [usernameLabel addGestureRecognizer:usernameLabelRecognizer];
    UITapGestureRecognizer *usernameRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUsername)];
    usernameRecognizer.numberOfTapsRequired = 1;
    [usernameField addGestureRecognizer:usernameRecognizer];
    UITapGestureRecognizer *changeUsernameRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUsername)];
    changeUsernameRecognizer.numberOfTapsRequired = 1;
    [changeUsername addGestureRecognizer:changeUsernameRecognizer];
    
    //change default Language
    UITapGestureRecognizer *defaultLanguageLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDefaultLanguage)];
    defaultLanguageLabelRecognizer.numberOfTapsRequired = 1;
    [defaultLanguageLabel addGestureRecognizer:defaultLanguageLabelRecognizer];
    UITapGestureRecognizer *defaultLanguageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDefaultLanguage)];
    defaultLanguageRecognizer.numberOfTapsRequired = 1;
    [language addGestureRecognizer:defaultLanguageRecognizer];
    UITapGestureRecognizer *changeDefaultLanguageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDefaultLanguage)];
    changeDefaultLanguageRecognizer.numberOfTapsRequired = 1;
    [changeLanguage addGestureRecognizer:changeDefaultLanguageRecognizer];
    
}
-(void)goToAlphabetView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)changeUsername{
    [usernameField becomeFirstResponder];
}
-(void)changeDefaultLanguage{
    //prepare next view and go there
    changeDefaultLanguage=[[ChangeDefaultLanguage alloc]initWithNibName:@"ChangeDefaultLanguage" bundle:[NSBundle mainBundle]];
    [changeDefaultLanguage setupWithLanguage:self.defaultLanguage];
    [self.navigationController pushViewController:changeDefaultLanguage animated:NO];
    [changeDefaultLanguage grabLanguagesViaNavigationController];
}
-(void)updateDefaultLanguage{
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    self.defaultLanguage=workspace.defaultLanguage;

    [language setText:self.defaultLanguage];
}

//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{ }

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.userName=textView.text;
    
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    workspace.userName=self.userName;
    [workspace saveUsernameToUserDefaults];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 50){//140 characters are in the textView
        if (location != NSNotFound){ //Did not find any newline characters
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){ //Did not find any newline characters
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
}

@end
