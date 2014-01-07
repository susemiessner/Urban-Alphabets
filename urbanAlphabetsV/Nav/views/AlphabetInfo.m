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
    C4Label *changeAlphabetName;
    
    //to change the alphabet Name
    UITextView *textViewTest;
    NSString *newCharacter;
    NSString *currentAlphabetName;
}

@property (nonatomic) BottomNavBar *bottomNavBar;
@end

@implementation AlphabetInfo
-(void)setup {
    self.title=@"Alphabet Info";
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_ALPHABET withFrame:CGRectMake(0, 0, 80, 40)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"goToAlphabetView"];
  
}

-(void)grabCurrentLanguageViaNavigationController {
    C4Log(@"%d",[self.navigationController.viewControllers count]);
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    //C4Log(@"obj:%@", obj);
    workspace=(C4WorkSpace*)obj;
    //C4Log(@"workspace: %@", workspace);
    
    self.currentLanguage=workspace.currentLanguage;
    currentAlphabetName=workspace.alphabetName;
    //setup the info
    int yPos =UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+50;
    int lineHeight=40;
    int firstColumX=30;
    int secondColumX=firstColumX+100;
    
    nameLabel=[C4Label labelWithText:@"Name:" font:UA_NORMAL_FONT];
    nameLabel.textColor=UA_GREY_TYPE_COLOR;
    nameLabel.origin=CGPointMake(firstColumX, yPos);
    [self.canvas addLabel:nameLabel];
    
    
    //add text field
    CGRect textViewFrame = CGRectMake(secondColumX-3, yPos-10, 100, 124.0f);
    textViewTest = [[UITextView alloc] initWithFrame:textViewFrame];
    textViewTest.text=currentAlphabetName;
    textViewTest.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    textViewTest.textColor=UA_TYPE_COLOR;
    textViewTest.returnKeyType = UIReturnKeyDone;
    
    textViewTest.delegate = self;
    //textViewTest.hidden=true;
    
    [self.view addSubview:textViewTest];
    NSLog(@"setupTextFieldDone");
    
    alphabetName=[C4Label labelWithText:currentAlphabetName font:UA_NORMAL_FONT];
    alphabetName.textColor=UA_TYPE_COLOR;
    alphabetName.origin=CGPointMake(secondColumX, yPos);
    //[self.canvas addLabel:alphabetName];
    
    yPos+=lineHeight-15;
    
    changeAlphabetName=[C4Label labelWithText:@"(change)" font:UA_NORMAL_FONT];
    changeAlphabetName.textColor=UA_GREY_TYPE_COLOR;
    changeAlphabetName.origin=CGPointMake(secondColumX, yPos);
    [self.canvas addLabel:changeAlphabetName];
    
    
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
    [self listenFor:@"touchesBegan" fromObjects:@[nameLabel,alphabetName,changeAlphabetName] andRunMethod:@"changeAlphabetName"];
}
//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeLanguage{
    language.text=workspace.currentLanguage;

}
-(void)changeAlphabetName{
    C4Log(@"changing Alphabet Name");
    [textViewTest becomeFirstResponder];
    //[nameField becomeFirstResponder];
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
//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------

#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView becomes active, or is the First Responder
     --*/
    
    NSLog(@"textViewDidBeginEditing:");
    //textView.textColor = UA_OVERLAY_COLOR;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView is no longer active
     --*/
    NSLog(@"textViewDidEndEditing:");
    workspace.alphabetName=textView.text;
    C4Log(workspace.alphabetName);
    
    //rename folder in documents directory instead of making a new one later
    /*NSString *newDirectoryName = workspace.alphabetName;
    NSString *oldPath = currentAlphabetName;
    NSString *newPath = [[oldPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newDirectoryName];
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        // handle error
    }*/
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // NSLog(@"textView:shouldChangeTextInRange:replacementText:");
    
    // NSLog(@"textView.text.length -- %lu",(unsigned long)textView.text.length);
    //NSLog(@"text.length          -- %lu",(unsigned long)text.length);
    //NSLog(@"text                 -- '%@'", text);
    NSLog(@"textView.text        -- '%@'", textView.text);
    
    newCharacter=text;
    //self.entireText=textView.text;
    
    
    /*--
     * This method is called just before text in the textView is displayed
     * This is a good place to disallow certain characters
     * Limit textView to 140 characters
     * Resign keypad if done button pressed comparing the incoming text against the newlineCharacterSet
     * Return YES to update the textView otherwise return NO
     --*/

    
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

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange:");
    //This method is called when the user makes a change to the text in the textview
}

@end
