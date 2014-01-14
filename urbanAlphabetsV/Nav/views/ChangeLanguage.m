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
#import "AlphabetView.h"

@interface ChangeLanguage (){
    C4WorkSpace *workspace;
    AlphabetInfo *alphabetInfo;
    AlphabetView *alphabetView;
    
    NSMutableArray *shapesForBackground;
    NSArray *languages; //all languages available
    NSMutableArray *languageLabels; //for all texts
    C4Image *checkedIcon;
    int elementNoChosen;

}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite) NSString *currentLanguage;
@property (readwrite) NSString *chosenLanguage;
@end

@implementation ChangeLanguage
-(void) setupWithLanguage: (NSString*)passedLanguage {
    self.title=@"Change Language";
    self.currentLanguage=passedLanguage;
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    languages=[NSArray arrayWithObjects:@"Danish/Norwegian", @"English", @"Finnish/Swedish", @"German", @"Russian", @"Spanish", nil];
    shapesForBackground=[[NSMutableArray alloc]init];
    languageLabels=[[NSMutableArray alloc]init];
    
    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"changeLanguage"];
    
    //content
    int selectedLanguage=20;
    for (int i=0; i<[languages count]; i++) {
        //underlying shape
        float height=46.203;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*height;
        C4Shape *shape=[C4Shape rect:CGRectMake(0, yPos, self.canvas.width, height)];
        shape.lineWidth=2;
        shape.strokeColor=UA_NAV_BAR_COLOR;
        shape.fillColor=UA_NAV_CTRL_COLOR;
        if ([[languages objectAtIndex:i ] isEqualToString: self.currentLanguage]) {
            shape.fillColor=UA_HIGHLIGHT_COLOR;
            selectedLanguage=i;
        }
        [shapesForBackground addObject:shape];
        [self.canvas addShape:shape];
        //text label
        C4Label *label=[C4Label labelWithText:[languages objectAtIndex:i] font:UA_NORMAL_FONT];
        label.textColor=UA_TYPE_COLOR;
        float heightLabel=46.203;
        float yPosLabel=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*heightLabel+label.height/2+4;
        label.origin=CGPointMake(49.485, yPosLabel);
        [self.canvas addLabel:label];
        [self listenFor:@"touchesBegan" fromObject:shape andRunMethod:@"languageChanged:"];
        [languageLabels addObject:label];
    }
    //√icon only 1x
    checkedIcon=UA_ICON_CHECKED;
    checkedIcon.width= 35;
    float height=46.202999;
    checkedIcon.center=CGPointMake(checkedIcon.width/2+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(selectedLanguage+1)*height-height/2);
    [self.canvas addImage:checkedIcon];
}
-(void)languageChanged:(NSNotification *)notification{
    C4Shape *clickedObject = (C4Shape *)[notification object];
    //figure out which object was clicked
    float yPos=clickedObject.origin.y;
    yPos=yPos-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT;
    float elementNumber=yPos/clickedObject.height;
    elementNoChosen=lroundf(elementNumber);
    for (int i=0; i<[shapesForBackground count]; i++) {
        C4Shape *shape=[shapesForBackground objectAtIndex:i];
        if (i==elementNoChosen) {
            shape.fillColor=UA_HIGHLIGHT_COLOR;
        } else {
            shape.fillColor=UA_NAV_CTRL_COLOR;
        }
    }
    checkedIcon.center=CGPointMake(checkedIcon.width/2+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(elementNumber+1)*clickedObject.height-clickedObject.height/2);
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
    [self updateLanguage];
    
    [self.navigationController popViewControllerAnimated:YES];
    obj=[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1];
    alphabetInfo=(AlphabetInfo*)obj;
    [alphabetInfo changeLanguage];
}
-(void)updateLanguage{
    //Finnish>german
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
        //change Å to Ü
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //Finnish>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
        //change Ä to AE
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö to danishO
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
    }
    //Finnish>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
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
    //German>Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"German"]) {
        //change Ü to Å
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //Danish/Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
        //change Ä to AE
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö to danishO
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
    }
    //English>Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"English"]) {
        //change Ä to +
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö to $
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //German>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"German"]) {
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
    //Danish>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
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
    //English>German
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"English"]) {
        //change Ä
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //English>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"English"]) {
        //change Ä
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //German>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"German"]) {
        //change Ä
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //Danish>German
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
        //change Ä
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //-------------------------------
    //SPANISH
    //-------------------------------
    //English>Spanish
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"English"]) {
        //insert spanishN
        //[workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_spanishN.png"] atIndex:26];
        //+ is going to position 27
        //delete $
        [workspace.currentAlphabet removeObjectAtIndex:28];
    }
    //Spanish>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
        //delete spanishN
        [workspace.currentAlphabet removeObjectAtIndex:26];
        //insert $
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_$.png"] atIndex:27];
    }
    //Finnish>Spanish
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
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
    //Spanish>Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
        //change Ä to +
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö to $
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //Danish>Spanish
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
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
    //Spanish>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
        //change Ä
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //German>Spanish
    if ([workspace.currentLanguage isEqual:@"Spanish"] && [workspace.oldLanguage isEqual:@"German"]) {
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
    //Spanish>German
    if ([workspace.currentLanguage isEqual:@"German"] && [workspace.oldLanguage isEqual:@"Spanish"]) {
        //change Ä
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
        //change Å to ,
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //-------------------------------
    //RUSSIAN
    //-------------------------------
    //Finnish,German,English,Norwegian>Russian
    if ([workspace.currentLanguage isEqual:@"Russian"] && ([workspace.oldLanguage isEqual:@"Finnish/Swedish"]||[workspace.oldLanguage isEqual:@"German"] ||[workspace.oldLanguage isEqual:@"Danish/Norwegian"] || [workspace.oldLanguage isEqual:@"English"]|| [workspace.oldLanguage isEqual:@"Spanish"])) {
        //change RusB
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusB.png"] atIndex:1];
        //copy c to right position (17)
        [workspace.currentAlphabet insertObject:[workspace.currentAlphabet objectAtIndex:3] atIndex:17];
        //remove C
        [workspace.currentAlphabet removeObjectAtIndex:3];
        //change RusG
        [workspace.currentAlphabet removeObjectAtIndex:3];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusG.png"] atIndex:3];
        //change RusD
        //[workspace.currentAlphabet removeObjectAtIndex:4];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusD.png"] atIndex:4];
        //change RusJo
        [workspace.currentAlphabet removeObjectAtIndex:6];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusJo.png"] atIndex:6];
        //change RusSche
        [workspace.currentAlphabet removeObjectAtIndex:7];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusSche.png"] atIndex:7];
        //change RusSe
        [workspace.currentAlphabet removeObjectAtIndex:8];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusSe.png"] atIndex:8];
        //change RusI
        [workspace.currentAlphabet removeObjectAtIndex:9];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusI.png"] atIndex:9];
        //change RusIkratkoje
        [workspace.currentAlphabet removeObjectAtIndex:10];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusIkratkoje.png"] atIndex:10];
        //change RusL
        [workspace.currentAlphabet removeObjectAtIndex:12];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusL.png"] atIndex:12];
        //change RusN
        [workspace.currentAlphabet removeObjectAtIndex:14];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusN.png"] atIndex:14];
        //insert rus p
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusP.png"] atIndex:16];
        //shift T into right position
        [workspace.currentAlphabet removeObjectAtIndex:19];
        [workspace.currentAlphabet removeObjectAtIndex:20];
        [workspace.currentAlphabet removeObjectAtIndex:21];
        [workspace.currentAlphabet removeObjectAtIndex:19];
        //copy X /RusCha into right position
        [workspace.currentAlphabet insertObject:[workspace.currentAlphabet objectAtIndex:22] atIndex:25];
        //shirt Y /RusU into right position
        [workspace.currentAlphabet removeObjectAtIndex:20];
        [workspace.currentAlphabet removeObjectAtIndex:20];
        [workspace.currentAlphabet removeObjectAtIndex:20];
        //change RusF
        [workspace.currentAlphabet removeObjectAtIndex:21];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusF.png"] atIndex:21];
        //change RusZ
        [workspace.currentAlphabet removeObjectAtIndex:23];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusZ.png"] atIndex:23];
        //change RusTsche
        [workspace.currentAlphabet removeObjectAtIndex:24];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusTsche.png"] atIndex:24];
        //change RusScha
        [workspace.currentAlphabet removeObjectAtIndex:25];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusScha.png"] atIndex:25];
        //change RusTscheScha
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusTschescha.png"] atIndex:26];
        //change RusMjachkiSnak
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusMjachkiSnak.png"] atIndex:27];
        //change RusUi
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusUi.png"] atIndex:28];
        //add RusE
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusE.png"] atIndex:29];
        //add RusJu
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusJu.png"] atIndex:30];
        //add RusJa
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_RusJa.png"] atIndex:31];
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
        C4Image *image=[workspace.currentAlphabet objectAtIndex:8];
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
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_D.png"] atIndex:3];//d
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_F.png"] atIndex:5];//F
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_G.png"] atIndex:6];//G
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_I.png"] atIndex:8];//I
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_J.png"] atIndex:9];//J
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_L.png"] atIndex:11];//L
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_N.png"] atIndex:13];//N
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Q.png"] atIndex:16];//Q
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_R.png"] atIndex:17];//R
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_S.png"] atIndex:18];//S
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_U.png"] atIndex:20];//U
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_V.png"] atIndex:21];//V
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_W.png"] atIndex:22];//W
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Z.png"] atIndex:25];//Z
        //now special letters for all languages
        if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"]) {
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
        } else if ([workspace.currentLanguage isEqual:@"German"]) {
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
        }else if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"]) {
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
        }else if ([workspace.currentLanguage isEqual:@"English"]) {
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_+.png"] atIndex:26];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_$.png"] atIndex:27];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_,.png"] atIndex:28];
        }else if ([workspace.currentLanguage isEqual:@"Spanish"]) {
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_spanishN.png"] atIndex:26];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_$.png"] atIndex:27];
            [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_,.png"] atIndex:28];
        }
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_.png"] atIndex:29];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_!.png"] atIndex:30];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_-.png"] atIndex:31];
    }
    //REDRAW THE ALPHABET WHEN READY
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3];
    alphabetView=(AlphabetView*)obj;
    [alphabetView redrawAlphabet];
}


@end
