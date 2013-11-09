//
//  ChangeLanguage.m
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "ChangeLanguage.h"

@interface ChangeLanguage (){
    NSMutableArray *shapesForBackground;
    NSArray *languages; //all languages available
    NSMutableArray *languageLabels; //for all texts
    C4Image *checkedIcon;
    int elementNoChosen;

}
@property (nonatomic) TopNavBar *topNavBar;
@property (nonatomic) BottomNavBar *bottomNavBar;
@end

@implementation ChangeLanguage

-(void) setupWithLanguage: (NSString*)passedLanguage {
    self.currentLanguage=passedLanguage;
    
    languages=[NSArray arrayWithObjects:@"Danish/Norwegian", @"English", @"Finnish/Swedish", @"German", @"Russian", nil];
    shapesForBackground=[[NSMutableArray alloc]init];
    languageLabels=[[NSMutableArray alloc]init];

    //top nav bar
    CGRect topBarFrame = CGRectMake(0, UA_TOP_WHITE, self.canvas.width, UA_TOP_BAR_HEIGHT);
    self.topNavBar = [[TopNavBar alloc] initWithFrame:topBarFrame text:@"Choose Language" lastView:@"AlphabetInfo"];
    [self.canvas addShape:self.topNavBar];

    //bottomNavbar WITH 1 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame centerIcon:[C4Image imageNamed:@"icon_OK"] withFrame:CGRectMake(0, 0, 90, 45)];
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
    checkedIcon=[C4Image imageNamed:@"icon_checked"];
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
-(void)removeFromView{
    [self.topNavBar removeFromSuperview];
    [self.bottomNavBar removeFromSuperview];
    
    //content
    [checkedIcon removeFromSuperview];
    for (int i=0; i<[languageLabels count]; i++) {
        C4Label *currentLabel=[languageLabels objectAtIndex:i];
        [currentLabel removeFromSuperview];
    }
    for (int i=0; i<[shapesForBackground count]; i++) {
        C4Shape *shape=[shapesForBackground objectAtIndex:i];
        [shape removeFromSuperview];
        [self stopListeningFor:@"touchesBegan" object:shape];
    }

}

-(void)changeLanguage{
    C4Log(@"changeLanguage");
    self.chosenLanguage=[languages objectAtIndex:elementNoChosen];
    C4Log(@"chosenLanguage:%@", self.chosenLanguage);
    [self postNotification:@"languageChanged"];
    [self postNotification:@"goToAlphabetInfo"];
    [self removeFromView];
}
@end
