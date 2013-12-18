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
    
    
    languages=[NSArray arrayWithObjects:@"Danish/Norwegian", @"English", @"Finnish/Swedish", @"German", @"Russian", nil];
    shapesForBackground=[[NSMutableArray alloc]init];
    languageLabels=[[NSMutableArray alloc]init];
    
    
    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"changeLanguage"];
    
    //content
    int selectedLanguage=10;
    for (int i=0; i<[languages count]; i++) {
        //underlying shape
        float height=46.203;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*height;
        C4Shape *shape=[C4Shape rect:CGRectMake(0, yPos, self.canvas.width, height)];
        shape.lineWidth=2;
        shape.strokeColor=UA_NAV_BAR_COLOR;
        shape.fillColor=UA_NAV_CTRL_COLOR;
        
        if ([languages objectAtIndex:i ] == self.currentLanguage) {
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
    //C4Log("clicked Object y:%f", yPos);
    yPos=yPos-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT;
    float elementNumber=yPos/clickedObject.height;
    elementNoChosen=lroundf(elementNumber);
    //C4Log(@"elementNumber:%f", elementNumber);
    //C4Log(@"elementno:    %i", elementNo);
    for (int i=0; i<[shapesForBackground count]; i++) {
        C4Shape *shape=[shapesForBackground objectAtIndex:i];
        
        if (i==elementNoChosen) {
            shape.fillColor=UA_HIGHLIGHT_COLOR;
            //C4Log(@"i=%i",i);
        } else {
            shape.fillColor=UA_NAV_CTRL_COLOR;
        }
    }
    checkedIcon.center=CGPointMake(checkedIcon.width/2+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(elementNumber+1)*clickedObject.height-clickedObject.height/2);
    //C4Log(@"clickedObjectHeight: %f",clickedObject.height );
    
}
//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeLanguage{
    C4Log(@"changeLanguage");
    self.chosenLanguage=[languages objectAtIndex:elementNoChosen];
    C4Log(@"chosenLanguage:%@", self.chosenLanguage);
    
    //C4Log(@"%d",[self.navigationController.viewControllers count]);
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    C4Log(@"obj:%@", obj);
    workspace=(C4WorkSpace*)obj;
    C4Log(@"workspace: %@", workspace);
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
        C4Log(@"change Finnish to German");
        //change Å to Ü
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //Finnish>Danish
    if ([workspace.currentLanguage isEqual:@"Danish/Norwegian"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
        C4Log(@"change Finnish to Danish");
        //change Ä to AE
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö to danishO
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
    }
    //Finnish>English
    if ([workspace.currentLanguage isEqual:@"English"] && [workspace.oldLanguage isEqual:@"Finnish/Swedish"]) {
        C4Log(@"change Finnish to English");
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
        C4Log(@"change German to Finnish");
        //change Ü to Å
        [workspace.currentAlphabet removeObjectAtIndex:28];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //Danish/Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"Danish/Norwegian"]) {
        C4Log(@"change Danish to Finnish");
        //change Ä to AE
        [workspace.currentAlphabet removeObjectAtIndex:26];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö to danishO
        [workspace.currentAlphabet removeObjectAtIndex:27];
        [workspace.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
    }
    //English>Finnish
    if ([workspace.currentLanguage isEqual:@"Finnish/Swedish"] && [workspace.oldLanguage isEqual:@"English"]) {
        C4Log(@"change English to Finnish");
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
        C4Log(@"change Finnish to English");
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
        C4Log(@"change Finnish to English");
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
        C4Log(@"change English to German");
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
        C4Log(@"change English to Danish");
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
        C4Log(@"change English to Danish");
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
        C4Log(@"change Danish to German");
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
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3];
    C4Log(@"obj:%@", obj);
    alphabetView=(AlphabetView*)obj;
    C4Log(@"alphabetView: %@", alphabetView);
    [alphabetView redrawAlphabet];


}


@end
