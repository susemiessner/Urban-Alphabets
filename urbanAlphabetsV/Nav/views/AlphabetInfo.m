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
    C4Label *nameLabel;
    C4Label *alphabetName;
    C4Label *languageLabel;
    C4Label *language;
    C4Label *changeLanguage;
    C4Label *changeAlphabetName;
    C4Label *resetLabel;
    C4Label *deleteLabel;
    
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
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
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
    [self.view addSubview:textViewTest];
    
    alphabetName=[C4Label labelWithText:currentAlphabetName font:UA_NORMAL_FONT];
    alphabetName.textColor=UA_TYPE_COLOR;
    alphabetName.origin=CGPointMake(secondColumX, yPos);
    
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
    
    yPos+=lineHeight+30;
    //reset the alphabet
    resetLabel=[C4Label labelWithText:@"Reset Alphabet" font: UA_NORMAL_FONT];
    resetLabel.textColor=UA_GREY_TYPE_COLOR;
    resetLabel.origin=CGPointMake(firstColumX, yPos);
    [self.canvas addLabel:resetLabel];
    
    yPos+=lineHeight;
    //delete the alphabet
    deleteLabel=[C4Label labelWithText:@"Delete Alphabet" font: UA_NORMAL_FONT];
    deleteLabel.textColor=UA_GREY_TYPE_COLOR;
    deleteLabel.origin=CGPointMake(firstColumX, yPos);
    [self.canvas addLabel:deleteLabel];
    
    [self listenFor:@"touchesBegan" fromObjects:@[languageLabel,language,changeLanguage] andRunMethod:@"goToChangeLanguage"];
    [self listenFor:@"touchesBegan" fromObjects:@[nameLabel,alphabetName,changeAlphabetName] andRunMethod:@"changeAlphabetName"];
    [self listenFor:@"touchesBegan" fromObject:resetLabel andRunMethod:@"resetAlphabet"];
    [self listenFor:@"touchesBegan" fromObject:deleteLabel andRunMethod:@"deleteAlphabet"];
}
-(void)resetAlphabet{
    [workspace.currentAlphabet removeAllObjects];
    [workspace loadDefaultAlphabet];
    [self updateLanguage];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)deleteAlphabet{
    //delete from the arrays
    for (int i=0; i< [workspace.myAlphabets count]; i++) {
        NSString *name=[workspace.myAlphabets objectAtIndex:i];
        if ([name isEqualToString: workspace.alphabetName]) {
            if ([workspace.myAlphabets count]>1) {
                //delete from arrays
                [workspace.myAlphabets removeObjectAtIndex:i];
                [workspace.myAlphabetsLanguages removeObjectAtIndex: i];
                //change name of current alphabet
                workspace.alphabetName=[workspace.myAlphabets objectAtIndex:0];
                workspace.currentLanguage=[workspace.myAlphabetsLanguages objectAtIndex:0];
                //load first alphabet in array
                NSString *path= [[workspace documentsDirectory] stringByAppendingString:@"/"];
                path=[path stringByAppendingPathComponent:workspace.alphabetName];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
                    workspace.currentAlphabet=[[NSMutableArray alloc]init];
                    for (int i=0; i<42; i++) {
                        NSString *filePath=[[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", i]] stringByAppendingString:@".jpg"];
                        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
                        UIImage *img = [UIImage imageWithData:imageData];
                        C4Image *image=[C4Image imageWithUIImage:img];
                        [workspace.currentAlphabet addObject:image];
                    }
                }
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
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //Finnish>Danish
    if ([self.currentLanguage isEqual:@"Danish/Norwegian"]) {
        //change Ä to AE
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö to danishO
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
    }
    //Finnish>English
    if ([self.currentLanguage isEqual:@"English"] ) {
        //change Ä to +
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_+.png"] atIndex:26];
        //change Ö to $
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_$.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_,.png"] atIndex:28];
    }
    //Finnish>Spanish
    if ([self.currentLanguage isEqual:@"Spanish"]) {
        //change Ä to +
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_spanishN.png"] atIndex:26];
        //change Ö to $
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_+.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_,.png"] atIndex:28];
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
}
-(void)changeAlphabetName{
    [textViewTest becomeFirstResponder];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------

-(void)goToChangeLanguage{
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
