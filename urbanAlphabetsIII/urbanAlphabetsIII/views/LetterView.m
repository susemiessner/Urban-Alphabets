//
//  LetterView.m
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "LetterView.h"

@interface LetterView (){
    NSInteger currentLetter;
    C4Image *currentImage; //the image currently displayed

}
@property (nonatomic) TopNavBar *topNavBar;
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@end

@implementation LetterView
-(void)setupWithLetterNo: (int)chosenNumber currentAlphabet:(NSMutableArray*)passedAlphabet{

    //top nav bar
    CGRect topBarFrame = CGRectMake(0, UA_TOP_WHITE, self.canvas.width, UA_TOP_BAR_HEIGHT);
    self.topNavBar = [[TopNavBar alloc] initWithFrame:topBarFrame text:@"Untitled"];
    [self.canvas addShape:self.topNavBar];
    
    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_ARROW_BACKWARD withFrame:CGRectMake(0, 0, 70, 35) centerIcon:UA_ICON_ALPHABET withFrame:CGRectMake(0, 0, 80, 45) rightIcon:UA_ICON_ARROW_FORWARD withFrame:CGRectMake(0, 0, 70, 35)];
    [self.canvas addShape:self.bottomNavBar];
    
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goBackward"];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.rightImage andRunMethod:@"goForward"];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"goToAlphabetsView"];

     //THE LETTER
    self.currentAlphabet=[passedAlphabet mutableCopy];
    [self displayLetter:chosenNumber];
}
-(void)displayLetter:(int)chosenNumber{
    currentLetter=chosenNumber;
    currentImage=[self.currentAlphabet objectAtIndex:currentLetter];
    currentImage.width=self.canvas.width;
    currentImage.center=self.canvas.center;
    [self.canvas addImage:currentImage];
    
}
-(void)removeFromView{
    [self.topNavBar removeFromSuperview];
    [self.bottomNavBar removeFromSuperview];
    [currentImage removeFromSuperview];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) goToAlphabetsView{
    C4Log(@"going to Alphabetsview");
    [self postNotification:@"previousView_LetterView"];
    [self postNotification:@"goToAlphabetsView"];

    [self removeFromView];
}

-(void) goForward{
    [currentImage removeFromSuperview];
    currentLetter++;
    if (currentLetter>=[self.currentAlphabet count]) {
        currentLetter=0;
    }
    [self displayLetter:currentLetter];
}
-(void) goBackward{
    [currentImage removeFromSuperview];
    currentLetter--;
    if (currentLetter<=0) {
        currentLetter=[self.currentAlphabet count]-1;
    }
    [self displayLetter:currentLetter];
}
@end
