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
        
        //[self listenFor:@"touchesBegan" fromObject:shape andRunMethod:@"alphabetChanged:"];
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
    //checkedIcon.hidden=true;
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
    //set current alphabet to new alphabet
    [workspace loadDefaultAlphabet];
    //set current language to language chosen
    workspace.currentLanguage=[workspace.languages objectAtIndex:elementNoChosen];
    //set old language to Finnish/swedish > the default one
    workspace.oldLanguage=@"Finnish/Swedish";
    //set it to the right language
    [workspace loadDefaultAlphabet];
    [self updateLanguage];
    
    
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
    }else if([workspace.currentLanguage isEqualToString:@"English"]){
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

-(void)updateLanguage{
    //this is a copy of update language from change language view
     int letterToChange=0;
    //Finnish>german
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
        //change Å to Ü
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Finnish>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
        //change Ä to AE
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to danishO
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Finnish>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
        //change Ä to +
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to $
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //German>Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"German"]) {
        //change Ü to Å
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Danish/Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
        //change Ä to AE
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to danishO
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //English>Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"English"]) {
        //change Ä to +
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to $
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //German>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"German"]) {
        //change Ä to +
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to $
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Danish>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
        //change Ä to +
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to $
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //English>German
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"English"]) {
        //change Ä
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //English>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"English"]) {
        //change Ä
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //German>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"German"]) {
        //change Ä
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Danish>German
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
        //change Ä
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to Ü
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //-------------------------------
    //SPANISH
    //-------------------------------
    //English>Spanish
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"English"]) {
        //insert spanishN
        letterToChange=26;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //+ is going to position 27
        //delete $
        [workspace.currentAlphabet removeObjectAtIndex:28];
    }
    //Spanish>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
        //delete spanishN
        [workspace.currentAlphabet removeObjectAtIndex:26];
        //insert $
        letterToChange=27;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Finnish>Spanish
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
        //change Ä to +
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to $
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Spanish>Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
        //change Ä to +
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //[workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Ä.png"] atIndex:26];
        
        //change Ö to $
        //[workspace.currentAlphabet removeObjectAtIndex:27];
        //[workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Ö.png"] atIndex:27];
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //[workspace.currentAlphabet removeObjectAtIndex:28];
        //[workspace.currentAlphabet insertObject:[UIImage imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //Danish>Spanish
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
        //change Ä to +
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to $
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Spanish>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
        //change Ä
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //German>Spanish
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"German"]) {
        //change Ä to +
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö to $
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Spanish>German
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
        //change Ä
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Ö
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change Å to ,
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //-------------------------------
    //RUSSIAN
    //-------------------------------
    //Finnish,German,English,Norwegian>Russian
    if ([workspace.currentLanguage isEqual:@"Russian"] && ([workspace.oldLanguage isEqual:@"Finnish/Swedish"]||[workspace.oldLanguage isEqual:@"German"] ||[workspace.oldLanguage isEqual:@"Danish/Norwegian"] || [workspace.oldLanguage isEqual:@"English"]|| [workspace.oldLanguage isEqual:@"Spanish"])) {
        //change RusB
        letterToChange=1;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //copy c to right position (17)
        [workspace.currentAlphabet insertObject:[workspace.currentAlphabet objectAtIndex:3] atIndex:17];
        //remove C
        [workspace.currentAlphabet removeObjectAtIndex:3];
        //change RusG
        letterToChange=3;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        //change RusD
        letterToChange=4;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusJo
        letterToChange=6;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusSche
        letterToChange=7;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusSe
        letterToChange=8;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusI
        letterToChange=9;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusIkratkoje
        letterToChange=10;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusL
        letterToChange=12;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusN
        letterToChange=14;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //insert rus p
        letterToChange=16;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //shift T into right position
        [workspace.currentAlphabet removeObjectAtIndex:19];
        [workspace.currentAlphabet removeObjectAtIndex:20];
        [workspace.currentAlphabet removeObjectAtIndex:21];
        [workspace.currentAlphabet removeObjectAtIndex:19];
        //copy X /RusCha into right position
        letterToChange=22;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:25];
        //shift Y /RusU into right position
        [workspace.currentAlphabet removeObjectAtIndex:20];
        [workspace.currentAlphabet removeObjectAtIndex:20];
        [workspace.currentAlphabet removeObjectAtIndex:20];
        //change RusF
        letterToChange=21;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusZ
        letterToChange=23;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusTsche
        letterToChange=24;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusScha
        letterToChange=25;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusTscheScha
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusMjachkiSnak
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //change RusUi
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add RusE
        letterToChange=29;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add RusJu
        letterToChange=30;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add RusJa
        letterToChange=31;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Russian>Finnish,German,English,Norwegian
    if ( ([workspace.currentLanguage isEqual:@"Finnish/Swedish"]||[workspace.currentLanguage isEqual:@"German"] ||[workspace.currentLanguage isEqual:@"Danish/Norwegian"] || [workspace.currentLanguage isEqual:@"English"]|| [workspace.currentLanguage isEqual:@"Spanish"]) && [workspace.oldLanguage isEqual:@"Russian"]) {
        [workspace.currentAlphabet removeObjectAtIndex:31]; //RusJa
        [workspace.currentAlphabet removeObjectAtIndex:30];
        [workspace.currentAlphabet removeObjectAtIndex:29];
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet removeObjectAtIndex:25];
        [workspace.currentAlphabet removeObjectAtIndex:24];
        [workspace.currentAlphabet removeObjectAtIndex:23];
        
        [workspace.currentAlphabet removeObjectAtIndex:21];
        
        
        [workspace.currentAlphabet removeObjectAtIndex:16];
        
        [workspace.currentAlphabet removeObjectAtIndex:12];
        
        [workspace.currentAlphabet removeObjectAtIndex:10];
        [workspace.currentAlphabet removeObjectAtIndex:9];
        [workspace.currentAlphabet removeObjectAtIndex:8];
        [workspace.currentAlphabet removeObjectAtIndex:7];
        [workspace.currentAlphabet removeObjectAtIndex:6];
        
        [workspace.currentAlphabet removeObjectAtIndex:4];
        [workspace.currentAlphabet removeObjectAtIndex:3];
        [workspace.currentAlphabet removeObjectAtIndex:1];
        //copy RusS to C
        UIImage *image=[workspace.currentAlphabet objectAtIndex:8];
        [workspace.currentAlphabet insertObject:image atIndex:2];
        [workspace.currentAlphabet removeObjectAtIndex:9];
        //copy RusN to H
        image=[workspace.currentAlphabet objectAtIndex:6];
        [workspace.currentAlphabet insertObject:image atIndex:4];
        [workspace.currentAlphabet removeObjectAtIndex:7];
        //change order of y and x
        image=[workspace.currentAlphabet objectAtIndex:11];
        [workspace.currentAlphabet insertObject:image atIndex:10];
        [workspace.currentAlphabet removeObjectAtIndex:12];
        
        //insert objects needed
        letterToChange=3;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=5;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=6;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=8;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=9;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=11;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=13;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=16;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=17;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=18;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=20;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=21;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=22;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=25;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        
        //now special letters for all languages
        letterToChange=26;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=27;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=28;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=29;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=30;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        
        letterToChange=31;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
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
