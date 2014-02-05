//
//  LetterView.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "LetterView.h"
#import "BottomNavBar.h"
#import "AlphabetView.h"

@interface LetterView (){
    AlphabetView *alphabetView;
    NSInteger currentLetter;
    UIImage *currentImage; //the image currently displayed
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@end

@implementation LetterView
-(void)setupWithLetterNo: (int)chosenNumber currentAlphabet:(NSMutableArray*)passedAlphabet{
    self.title=@"Letter View";
    self.navigationItem.hidesBackButton = YES;
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
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) goToAlphabetsView{
    [self.navigationController popViewControllerAnimated:NO];
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1];
    alphabetView=(AlphabetView*)obj;
    [alphabetView redrawAlphabet];
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
