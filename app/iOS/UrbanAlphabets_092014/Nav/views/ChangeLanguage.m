//
//  ChangeLanguage.m
//  UrbanAlphabets
//
//  Created by Suse on 12/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "ChangeLanguage.h"
#import "BottomNavBar.h"
#import "C4WorkSpace.h"
#import "AlphabetInfo.h"

@interface ChangeLanguage (){
    C4WorkSpace *workspace;
    AlphabetInfo *alphabetInfo;
    
    NSString *alphabetName;
    
    NSMutableArray *shapesForBackground;
    NSArray *languages; //all languages available
    NSMutableArray *languageLabels; //for all texts
    UIImageView *checkedIcon;
    int elementNoChosen;
    //images loaded from documents directory
    UIImageView *loadedImage;
    int letterToChange;
    
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite) NSString *currentLanguage;
@property (readwrite) NSString *chosenLanguage;
@end

@implementation ChangeLanguage
-(void) setupWithLanguage: (NSString*)passedLanguage Name:(NSString*)passedName {
    self.title=@"Change Language";
    alphabetName=passedName;
    self.currentLanguage=passedLanguage;
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
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 80, 40)];
    [self.view addSubview:self.bottomNavBar];
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
        
        if ([[languages objectAtIndex:i ] isEqualToString: self.currentLanguage]) {
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
-(void)changeLanguage{
    self.chosenLanguage=[languages objectAtIndex:elementNoChosen];
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    
    workspace=(C4WorkSpace*)obj;
    workspace.currentLanguage=self.chosenLanguage;
    workspace.oldLanguage=self.currentLanguage;
    for (int i=0; i<[workspace.myAlphabets count]; i++) {
        if ([[workspace.myAlphabets objectAtIndex:i]isEqualToString:alphabetName]) {
            [workspace.myAlphabetsLanguages replaceObjectAtIndex:i withObject: workspace.currentLanguage];
        }
    }

    [self updateLanguage];
    
    obj=[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    alphabetInfo=(AlphabetInfo*)obj;
    [alphabetInfo changeLanguage];
    
    [self.navigationController popViewControllerAnimated:NO];
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
    } else if([workspace.currentLanguage isEqualToString:@"Latvian"]){
        letterToAdd=[workspace.latvian objectAtIndex:number];
    }
    
    NSString *filePath=[[path stringByAppendingPathComponent:letterToAdd] stringByAppendingString:@".jpg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *img = [UIImage imageWithData:imageData];
        
        loadedImage=[[UIImageView alloc]initWithImage:img];
    }else{
        if ([letterToAdd isEqualToString:@"?"]) {
            letterToAdd=@"-";
        }else if([letterToAdd isEqualToString:@"."]){
            letterToAdd=@"";
        }else if([letterToAdd isEqualToString:@"$"]){
            letterToAdd=@"dollar";
        }
        NSString *filepath=@"letter_";
        filepath=[filepath stringByAppendingString:letterToAdd];
        loadedImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:filepath]];
    }
}
-(void)updateLanguage{
    letterToChange=0;
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
    if ([workspace.currentLanguage isEqual:@"English/Portugese"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
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
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"English/Portugese"]) {
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
    if ([workspace.currentLanguage isEqual:@"English/Portugese"] && [workspace.oldLanguage isEqual:@"German"]) {
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
    if ([workspace.currentLanguage isEqual:@"English/Portugese"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
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
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"English/Portugese"]) {
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
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"English/Portugese"]) {
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
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"English/Portugese"]) {
        //insert spanishN
        letterToChange=26;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //+ is going to position 27
        //delete $
        [workspace.currentAlphabet removeObjectAtIndex:28];
    }
    //Spanish>English
    if ([workspace.currentLanguage isEqual:@"English/Portugese"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
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
    //LATVIAN
    //-------------------------------
    //>> Finnish, Swedish, German, Danish, Norwegian, English > Latvian
    if ([workspace.currentLanguage isEqual:@"Latvian"] && ([workspace.oldLanguage isEqual:@"Finnish/Swedish"]||[workspace.oldLanguage isEqual:@"German"] ||[workspace.oldLanguage isEqual:@"Danish/Norwegian"] || [workspace.oldLanguage isEqual:@"English/Portugese"]|| [workspace.oldLanguage isEqual:@"Spanish"])) {
        //remove 0
        letterToChange=32;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove ?
        letterToChange=31;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove !
        letterToChange=30;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove .
        letterToChange=29;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove Å
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove Ö
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove Ä
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove Y
        letterToChange=24;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove X
        letterToChange=23;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove W
        letterToChange=22;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //remove Q
        letterToChange=16;
        [workspace.currentAlphabet removeObjectAtIndex:16];
        
        //Add LatvA
        letterToChange=1;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvB
        letterToChange=4;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvE
        letterToChange=7;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvG
        letterToChange=10;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvI
        letterToChange=13;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvK
        letterToChange=16;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvL
        letterToChange=18;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvN
        letterToChange=21;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvS
        letterToChange=26;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvU
        letterToChange=29;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //Add LatvZ
        letterToChange=32;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    //Latvian > Finnish
    if (([workspace.currentLanguage isEqual:@"Finnish/Swedish"]||[workspace.currentLanguage isEqual:@"German"] ||[workspace.currentLanguage isEqual:@"Danish/Norwegian"] || [workspace.currentLanguage isEqual:@"English/Portugese"]|| [workspace.currentLanguage isEqual:@"Spanish"]) && [workspace.oldLanguage isEqual:@"Latvian"]){
        //LatvZ
        letterToChange=32;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvU
        letterToChange=29;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvS
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvN
        letterToChange=21;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvL
        letterToChange=18;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvK
        letterToChange=16;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvI
        letterToChange=13;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvG
        letterToChange=10;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvE
        letterToChange=7;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvB
        letterToChange=4;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvA
        letterToChange=1;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        
        //add Q
        letterToChange=16;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add W
        letterToChange=22;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add X
        letterToChange=23;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add Y
        letterToChange=24;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add Ä
        letterToChange=26;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add Ö
        letterToChange=27;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add Å
        //if ([workspace.currentLanguage isEqualToString:@"Finnish"]) {
            letterToChange=28;
            [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
            [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //}
        //add .
        letterToChange=29;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add !
        letterToChange=30;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add ?
        letterToChange=31;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //add0
        letterToChange=32;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
    }
    
    //-------------------------------
    //RUSSIAN
    //-------------------------------
    //Finnish,German,English,Norwegian>Russian
    if ([workspace.currentLanguage isEqual:@"Russian"] && ([workspace.oldLanguage isEqual:@"Finnish/Swedish"]||[workspace.oldLanguage isEqual:@"German"] ||[workspace.oldLanguage isEqual:@"Danish/Norwegian"] || [workspace.oldLanguage isEqual:@"English/Portugese"]|| [workspace.oldLanguage isEqual:@"Spanish"])) {
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
    if ( ([workspace.currentLanguage isEqual:@"Finnish/Swedish"]||[workspace.currentLanguage isEqual:@"German"] ||[workspace.currentLanguage isEqual:@"Danish/Norwegian"] || [workspace.currentLanguage isEqual:@"English/Portugese"]|| [workspace.currentLanguage isEqual:@"Spanish"]) && [workspace.oldLanguage isEqual:@"Russian"]) {
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
    //Latvian > Russian
    if ([workspace.currentLanguage isEqual:@"Russian"] && ([workspace.oldLanguage isEqual:@"Latvian"])){
        //LatvZ
        letterToChange=32;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //Z
        letterToChange=31;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //V
        letterToChange=30;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvU
        letterToChange=29;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //U
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvS
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //S
        letterToChange=25;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //R
        letterToChange=24;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvN
        letterToChange=21;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //N
        letterToChange=20;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvL
        letterToChange=18;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //L
        letterToChange=17;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvK
        letterToChange=16;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //J
        letterToChange=14;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvI
        letterToChange=13;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //I
        letterToChange=12;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //Latv G
        letterToChange=10;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //G
        letterToChange=9;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //F
        letterToChange=8;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvE
        letterToChange=7;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //D
        letterToChange=5;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvC
        letterToChange=4;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //LatvA
        letterToChange=1;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        
        //shift C into right
        [workspace.currentAlphabet insertObject:[workspace.currentAlphabet objectAtIndex:2] atIndex:9];
        [workspace.currentAlphabet removeObjectAtIndex:2];
        //shift H into right place
        [workspace.currentAlphabet insertObject:[workspace.currentAlphabet objectAtIndex:3] atIndex:6];
        [workspace.currentAlphabet removeObjectAtIndex:3];
        
        //now add the russian letters
        letterToChange=1;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=3;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=4;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=6;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=7;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=8;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=9;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=10;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=12;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=16;
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
        letterToChange=23;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=24;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=25;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
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
        letterToChange=32;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];

    }
    //Russian > Latvian
    if ([workspace.currentLanguage isEqual:@"Latvian"] && ([workspace.oldLanguage isEqual:@"Russian"])){
        //remove
        letterToChange=32;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=31;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=30;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=29;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=28;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=27;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=26;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=25;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=24;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=23;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=22;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=21;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=20;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=16;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=12;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=10;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=9;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=8;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=7;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=6;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=4;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=3;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        letterToChange=1;
        [workspace.currentAlphabet removeObjectAtIndex:letterToChange];
        //copy into right places
        //shift H into right place
        [workspace.currentAlphabet insertObject:[workspace.currentAlphabet objectAtIndex:5] atIndex:3];
        [workspace.currentAlphabet removeObjectAtIndex:6];
        //shift C into right
        [workspace.currentAlphabet insertObject:[workspace.currentAlphabet objectAtIndex:8] atIndex:2];
        [workspace.currentAlphabet removeObjectAtIndex:9];
        
        // add missing letters
        //latvA
        letterToChange=1;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //latvC
        letterToChange=4;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //D
        letterToChange=5;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //latvE
        letterToChange=7;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //F
        letterToChange=8;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //G
        letterToChange=9;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //LatvG
        letterToChange=10;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //I
        letterToChange=12;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //LatvI
        letterToChange=13;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //J
        letterToChange=14;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //LatvK
        letterToChange=16;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //L
        letterToChange=17;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        //LatvL
        letterToChange=18;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=20;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=21;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=24;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=25;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];
        letterToChange=26;
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
        letterToChange=32;
        [self checkIfLetterExistsInDocumentsDirectory:letterToChange];
        [workspace.currentAlphabet insertObject:loadedImage atIndex:letterToChange];

    }

}


@end
