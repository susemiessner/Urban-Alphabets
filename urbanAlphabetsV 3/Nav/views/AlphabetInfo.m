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
#import "AlphabetView.h"

@interface AlphabetInfo (){
    ChangeLanguage *changeLanguageView;
    C4WorkSpace *workspace;
    AlphabetView *alphabetView;
    //labels for the actual info
    UILabel *nameLabel;
    UILabel *alphabetName;
    UILabel *languageLabel;
    UILabel *language;
    UILabel *changeLanguage;
    UILabel *changeAlphabetName;
    UILabel *resetLabel;
    UILabel *deleteLabel;
    
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
    CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_ALPHABET withFrame:CGRectMake(0, 0, 80, 40)];
    [self.view addSubview:self.bottomNavBar];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"goToAlphabetView"];
    UITapGestureRecognizer *alphabetButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAlphabetView)];
    alphabetButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:alphabetButtonRecognizer];
}

-(void)grabCurrentLanguageViaNavigationController {
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    self.currentLanguage=workspace.currentLanguage;
    currentAlphabetName=workspace.alphabetName;
    //setup the info
    int yPos =UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+50;
    int lineHeight=40;
    int firstColumX=30;
    int secondColumX=firstColumX+100;
    
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(firstColumX, yPos, 200, 20)];
    [nameLabel setText:@"Name:"];
    [nameLabel setFont:UA_NORMAL_FONT];
    [nameLabel setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:nameLabel];
    nameLabel.userInteractionEnabled=YES;
    
    //add text field
    CGRect textViewFrame = CGRectMake(secondColumX-3, yPos-10, 200, 30);
    textViewTest = [[UITextView alloc] initWithFrame:textViewFrame];
    textViewTest.text=currentAlphabetName;
    textViewTest.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    textViewTest.textColor=UA_TYPE_COLOR;
    textViewTest.returnKeyType = UIReturnKeyDone;
    textViewTest.delegate = self;
    [self.view addSubview:textViewTest];
    
    
    yPos+=lineHeight-15;
    changeAlphabetName=[[UILabel alloc]initWithFrame:CGRectMake(secondColumX, yPos, 100, 20)];
    [changeAlphabetName setText:@"(change)"];
    [changeAlphabetName setFont:UA_NORMAL_FONT];
    [changeAlphabetName setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:changeAlphabetName];
    changeAlphabetName.userInteractionEnabled=YES;
    
    yPos+=lineHeight;
    languageLabel=[[UILabel alloc]initWithFrame:CGRectMake(firstColumX, yPos, 100, 20)];
    [languageLabel setText:@"Language:"];
    [languageLabel setFont:UA_NORMAL_FONT];
    [languageLabel setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:languageLabel];
    languageLabel.userInteractionEnabled=YES;
    
    language=[[UILabel alloc]initWithFrame:CGRectMake(secondColumX, yPos, 200, 20)];
    [language setText:self.currentLanguage];
    [language setFont:UA_NORMAL_FONT];
    [language setTextColor:UA_TYPE_COLOR];
    [self.view addSubview:language];
    language.userInteractionEnabled=YES;
    
    int xPosChange=secondColumX+language.frame.size.width+5;
    if (xPosChange+changeLanguage.frame.size.width > [[UIScreen mainScreen] bounds].size.width) {
        xPosChange=secondColumX;
        yPos+=lineHeight-15;
    }
    changeLanguage=[[UILabel alloc]initWithFrame:CGRectMake(xPosChange, yPos, 100, 20)];
    [changeLanguage setText:@"(change)"];
    [changeLanguage setFont:UA_NORMAL_FONT];
    [changeLanguage setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:changeLanguage];
    changeLanguage.userInteractionEnabled=YES;
   
    yPos+=lineHeight+30;
    //reset the alphabet
    resetLabel=[[UILabel alloc]initWithFrame:CGRectMake(firstColumX, yPos, 200, 20)];
    [resetLabel setText:@"Reset Alphabet"];
    [resetLabel setFont:UA_NORMAL_FONT];
    [resetLabel setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:resetLabel];
    resetLabel.userInteractionEnabled=YES;
    
    yPos+=lineHeight;
    //delete the alphabet
    deleteLabel=[[UILabel alloc]initWithFrame:CGRectMake(firstColumX, yPos, 200, 20)];
    [deleteLabel setText:@"Delete Alphabet"];
    [deleteLabel setFont:UA_NORMAL_FONT];
    [deleteLabel setTextColor:UA_GREY_TYPE_COLOR];
    [self.view addSubview:deleteLabel];
    deleteLabel.userInteractionEnabled=YES;
    
    //gesture recognizers
    //change language
    UITapGestureRecognizer *languageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToChangeLanguage)];
    languageRecognizer.numberOfTapsRequired = 1;
    [languageLabel addGestureRecognizer:languageRecognizer];
    UITapGestureRecognizer *changeLanguageLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToChangeLanguage)];
    changeLanguageLabelRecognizer.numberOfTapsRequired = 1;
    [language addGestureRecognizer:changeLanguageLabelRecognizer];
    UITapGestureRecognizer *changeLanguageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToChangeLanguage)];
    changeLanguageRecognizer.numberOfTapsRequired = 1;
    [changeLanguage addGestureRecognizer:changeLanguageRecognizer];
    //alphabetName
    UITapGestureRecognizer *nameLabelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAlphabetName)];
    nameLabelRecognizer.numberOfTapsRequired = 1;
    [nameLabel addGestureRecognizer:nameLabelRecognizer];
    UITapGestureRecognizer *changeAlphabetNameRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAlphabetName)];
    changeAlphabetNameRecognizer.numberOfTapsRequired = 1;
    [changeAlphabetName addGestureRecognizer:changeAlphabetNameRecognizer];
    //reset
    UITapGestureRecognizer *resetRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetAlphabet)];
    resetRecognizer.numberOfTapsRequired = 1;
    [resetLabel addGestureRecognizer:resetRecognizer];
    //delete
    UITapGestureRecognizer *deleteRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAlphabet)];
    deleteRecognizer.numberOfTapsRequired = 1;
    [deleteLabel addGestureRecognizer:deleteRecognizer];
}
-(void)resetAlphabet{
    NSLog(@"reset Alphabet");
    [workspace.currentAlphabet removeAllObjects];
    [workspace loadDefaultAlphabet];
    [self updateLanguage];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)deleteAlphabet{
    NSLog(@"deleteAlphabet");

    //delete from the arrays
    for (int i=0; i< [workspace.myAlphabets count]; i++) {
        NSString *name=[workspace.myAlphabets objectAtIndex:i];
        if ([name isEqualToString: workspace.alphabetName]) {
            if ([workspace.myAlphabets count]>1) {
                //delete from arrays
                [workspace.myAlphabets removeObjectAtIndex:i];
                [workspace.myAlphabetsLanguages removeObjectAtIndex: i];
                //change name of current alphabet to first one in the array
                workspace.alphabetName=[workspace.myAlphabets objectAtIndex:0];
                workspace.currentLanguage=[workspace.myAlphabetsLanguages objectAtIndex:0];
                //load first alphabet in array
                [workspace loadCorrectAlphabet];
            } else{ //if only one alphabet exists
                //empty arrays
                [workspace.myAlphabets removeAllObjects];
                [workspace.myAlphabetsLanguages removeAllObjects];
                //add untitled alphabet
                [workspace.myAlphabets addObject:@"Untitled"];
                [workspace.myAlphabetsLanguages addObject:@"Finnish/Swedish"];
                //load default alphabet
                [workspace loadDefaultAlphabet];
                
            }
        }
    }
    //write the nsuserdefaults new
    [workspace writeAlphabetsUserDefaults];
    //redraw the alphabet
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    alphabetView=(AlphabetView*)obj;
    [alphabetView redrawAlphabet];

    [self.navigationController popViewControllerAnimated:NO];
}
-(void)updateLanguage{
    //this is a copy of update language from change language view
    //Finnish>german
    if ([self.currentLanguage isEqual:@"German"]) {
        //change Å to Ü
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //Finnish>Danish
    if ([self.currentLanguage isEqual:@"Danish/Norwegian"]) {
        //change Ä to AE
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö to danishO
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_danisho.png"] atIndex:27];
    }
    //Finnish>English
    if ([self.currentLanguage isEqual:@"English"] ) {
        //change Ä to +
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_+.png"] atIndex:26];
        //change Ö to $
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_$.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_,.png"] atIndex:28];
    }
    //Finnish>Spanish
    if ([self.currentLanguage isEqual:@"Spanish"]) {
        //change Ä to +
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_spanishN.png"] atIndex:26];
        //change Ö to $
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_+.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_,.png"] atIndex:28];
    }

    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    alphabetView=(AlphabetView*)obj;
    [alphabetView redrawAlphabet];
 
}

//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)changeLanguage{
    language.text=workspace.currentLanguage;
    NSLog(@"language changed");
}
-(void)changeAlphabetName{
    [textViewTest becomeFirstResponder];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------

-(void)goToChangeLanguage{
    NSLog(@"change Language");
   changeLanguageView=[[ChangeLanguage alloc]initWithNibName:@"ChangeLanguage" bundle:[NSBundle mainBundle]];
    [changeLanguageView setupWithLanguage:self.currentLanguage];
    [self.navigationController pushViewController:changeLanguageView animated:NO];
}
-(void)goToAlphabetView{
    [self.navigationController popViewControllerAnimated:NO];
}
//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{ }

- (void)textViewDidEndEditing:(UITextView *)textView{
    workspace.alphabetName=textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    newCharacter=text;
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
- (void)textViewDidChange:(UITextView *)textView{}

@end
