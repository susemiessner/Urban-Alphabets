//
//  AddAlphabet.m
//  UrbanAlphabets
//
//  Created by Suse on 09/01/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import "AddAlphabet.h"
#import "C4WorkSpace.h"
#import "BottomNavBar.h"

@interface AddAlphabet (){
    C4WorkSpace *workspace;
    int notificationCounter; //to make sure the ok button is only added 1x
    
    //the new alphabet name
    UITextView *textInput;
    NSString *name;
    
    //for the languages
    NSMutableArray *shapesForBackground;
    NSMutableArray *languageLabels; //for all texts
    UIImageView *checkedIcon;
    int elementNoChosen;
    float firstShapeY;
    //magic for dismissing the keyboard
    UITapGestureRecognizer * tapGesture;
    UIView *navigation;
    
    float height;
    UIImageView *loadedImage;
    
    int letterToChange;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@end

@implementation AddAlphabet

-(void) setup{
    self.title=@"Add New Alphabet";
    name=@" "; //default new alphabet name
    notificationCounter=0;
    
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //bottom bar
    CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45) ];
    [self.view addSubview:self.bottomNavBar];
    self.bottomNavBar.centerImageView.hidden=YES;
    
    shapesForBackground = [[NSMutableArray alloc] init];
}
-(void)grabCurrentLanguageViaNavigationController {
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    
    //name label
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 100, 20) ];
    [nameLabel setText:@"Name:"];
    [nameLabel setFont:UA_NORMAL_FONT];
    [self.view addSubview:nameLabel];
    
    //text field
    CGRect textViewFrame = CGRectMake(nameLabel.frame.size.width, nameLabel.frame.origin.y, [[UIScreen mainScreen] bounds].size.width-40-nameLabel.frame.size.width, nameLabel.frame.size.height+5);
    textInput = [[UITextView alloc] initWithFrame:textViewFrame];
    textInput.returnKeyType = UIReturnKeyDone;
    textInput.layer.borderWidth=1.0f;
    textInput.layer.borderColor=[UA_OVERLAY_COLOR CGColor];
    [textInput becomeFirstResponder];
    textInput.delegate = self;
    [self.view addSubview:textInput];
    //magic for dismissing the keyboard
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
    
    //language label
    UILabel *languageLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, nameLabel.frame.origin.y+40, 100, 20) ];
    [languageLabel setText:@"Language:"];
    [languageLabel setFont:UA_NORMAL_FONT];
    [self.view addSubview:languageLabel];
    
    //available languages
    firstShapeY=languageLabel.frame.origin.y+languageLabel.frame.size.height+10;
    for (int i=0; i<[workspace.languages count]; i++) {
        //underlying shape
        height=35.203;
        float yPos=i*height+firstShapeY;
        UIView *shape=[[UIView alloc]initWithFrame:CGRectMake(0, yPos, [[UIScreen mainScreen] bounds].size.width, height)];
        shape.layer.borderWidth=1.0f;
        shape.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        [shape setBackgroundColor:UA_NAV_CTRL_COLOR];
        [shapesForBackground addObject:shape];
        shape.userInteractionEnabled=YES;
        [self.view addSubview:shape];
        
        //text label
        float heightLabel=height;
        float yPosLabel=i*heightLabel+4+languageLabel.frame.origin.y+languageLabel.frame.size.height+10+heightLabel/2-13;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(75, yPosLabel, 300, 20)];
        [label setText:[workspace.languages objectAtIndex:i]];
        [label setFont:UA_NORMAL_FONT];
        [label setTextColor:UA_TYPE_COLOR];
        [self.view addSubview:label];
        [languageLabels addObject:label];
        
        UITapGestureRecognizer *shapeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(languageChanged:)];
        shapeRecognizer.numberOfTapsRequired = 1;
        [shape addGestureRecognizer:shapeRecognizer];
        
        UITapGestureRecognizer *labelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(languageChanged:)];
        labelRecognizer.numberOfTapsRequired = 1;
        [label addGestureRecognizer:labelRecognizer];
    }
    //√icon only 1x
    checkedIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, -50, 30, 30)];
    checkedIcon.image=UA_ICON_CHECKED;
    [self.view addSubview:checkedIcon];
}
-(void)languageChanged:(UIGestureRecognizer *)notification{
    UIView *clickedObject = (UIView *)notification.view;
    //figure out which object was clicked
    float yPos=clickedObject.frame.origin.y;
    float firstYPos=firstShapeY;
    yPos=yPos-firstYPos;
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
    //checkedIcon.center=CGPointMake(checkedIcon.width/2+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(elementNumber+1)*clickedObject.height-clickedObject.height/2);
    [checkedIcon setFrame: CGRectMake(5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(elementNumber-1)*height+firstShapeY-22, 30,30)];
    
    if (elementNoChosen<[workspace.languages count] && ![name isEqual:@" "] && notificationCounter<1) {
        self.bottomNavBar.centerImageView.hidden=NO;
        UIView *shape=[[UIView alloc] initWithFrame:CGRectMake(self.bottomNavBar.centerImageView.frame.origin.x-20, self.bottomNavBar.frame.origin.y-10, self.bottomNavBar.centerImage.size.width+40, self.bottomNavBar.centerImage.size.height+20)];
        shape.layer.borderWidth=1.0f;
        shape.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        [shape setBackgroundColor:UA_NAV_CTRL_COLOR];
        [self.view addSubview:shape];
        
        //[self listenFor:@"touchesBegan" fromObject:shape andRunMethod:@"addAlphabet"];
        UITapGestureRecognizer *okButtonRecognizerRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAlphabet)];
        okButtonRecognizerRecognizer.numberOfTapsRequired = 1;
        [shape addGestureRecognizer:okButtonRecognizerRecognizer];
        notificationCounter++;
    }
}
-(void)addAlphabet{
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    
    //add new alphabet to my alphabets
    [workspace.myAlphabets addObject:name];
    //add a new language to languages array (so u can reload correctly later)
    [workspace.myAlphabetsLanguages addObject: [workspace.languages objectAtIndex:elementNoChosen]];

    //set alphabet name to new one
    workspace.alphabetName=name;
    //set current language to language chosen
    workspace.currentLanguage=[workspace.languages objectAtIndex:elementNoChosen];
    //set old language to Finnish/swedish > the default one
    workspace.oldLanguage=@"Finnish/Swedish";
    //set it to the right language
    [workspace loadDefaultAlphabet];
    //[self updateLanguage];
    
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    //delete oldest alphabet if more than a certain number are added (so we don't need a scroll view here)
    if ([workspace.myAlphabets count]>8) {
        [workspace.myAlphabets removeObjectAtIndex:0];
        [workspace.myAlphabetsLanguages removeObjectAtIndex:0];
    }
}
-(void)checkIfLetterExistsInDocumentsDirectory:(int)number{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path= [[paths objectAtIndex:0] stringByAppendingString:@"/"];
    path=[path stringByAppendingPathComponent:workspace.alphabetName];
    
    NSString *letterToAdd=@" ";
    if ([workspace.currentLanguage isEqualToString:@"Finnish/Swedish"]) {
        letterToAdd=[workspace.finnish objectAtIndex:number];
    }else if([workspace.currentLanguage isEqualToString:@"German"]){
        letterToAdd=[workspace.german objectAtIndex:number];
    }else if([workspace.currentLanguage isEqualToString:@"English/Portugese"]){
        letterToAdd=[workspace.english objectAtIndex:number];
    }else if([workspace.currentLanguage isEqualToString:@"Danish/Norwegian"]){
        letterToAdd=[workspace.danish objectAtIndex:number];
    }else if([workspace.currentLanguage isEqualToString:@"Spanish"]){
        letterToAdd=[workspace.spanish objectAtIndex:number];
    }else if([workspace.currentLanguage isEqualToString:@"Russian"]){
        letterToAdd=[workspace.russian objectAtIndex:number];
    }
    
    NSString *filePath=[[path stringByAppendingPathComponent:letterToAdd] stringByAppendingString:@".jpg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *img = [UIImage imageWithData:imageData];
        
        loadedImage=[[UIImageView alloc]initWithImage:img];
    }
    else{
        if ([letterToAdd isEqualToString:@"?"]) {
            letterToAdd=@"-";
        }else if([letterToAdd isEqualToString:@"."]){
            letterToAdd=@"";
        }
        NSString *filepath=@"letter_";
        filepath=[filepath stringByAppendingString:letterToAdd];
        filepath=[filepath stringByAppendingString:@".png"];
        loadedImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:filepath]];
        
    }
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)hideKeyBoard {
    [textInput resignFirstResponder];
}
//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------

#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{}
- (void)textViewDidEndEditing:(UITextView *)textView{
    name=textView.text;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > 140){//140 characters are in the textView
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
