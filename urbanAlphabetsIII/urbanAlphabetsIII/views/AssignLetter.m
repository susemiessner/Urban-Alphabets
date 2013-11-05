//
//  AssignLetter.m
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AssignLetter.h"

@interface AssignLetter (){
    int notificationCounter; //to make sure Ok button is only added 1x

}
@property (nonatomic) TopNavBar *topNavBar;
@property (nonatomic) BottomNavBar *bottomNavBar;
@end

@implementation AssignLetter

-(void)setup:(C4Image*)croppedImage withAlphabet:(NSMutableArray*)currentAlphabetPassed{
    //top nav bar
    CGRect topBarFrame = CGRectMake(0, UA_TOP_WHITE, self.canvas.width, UA_TOP_BAR_HEIGHT);
    self.topNavBar = [[TopNavBar alloc] initWithFrame:topBarFrame text:@"Assign photo letter" lastView:@"CropPhoto"];
    [self.canvas addShape:self.topNavBar];
    
    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:croppedImage withFrame:CGRectMake(0, 0, 32.788, 40.022) centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45) rightIcon:UA_ICON_SETTINGS withFrame:CGRectMake(0, 0, 30.017, 30.017)];
    [self.canvas addShape:self.bottomNavBar];
    self.bottomNavBar.centerImage.hidden=YES;
    
    [self drawCurrentAlphabet:currentAlphabetPassed];

}
-(void)drawCurrentAlphabet: (NSMutableArray*)currentAlphabetPassed{
    notificationCounter=0; //to make sure ok button is only added 1x
    
    self.currentAlphabet=[currentAlphabetPassed mutableCopy];
    //C4Log(@"currentAlphabetLength: %i", [self.currentAlphabet count]);
    C4Log(@"drawing the alphabet");
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=2+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        C4Image *image=[self.currentAlphabet objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        //[self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"highlightLetter:"];
    }
}
@end
