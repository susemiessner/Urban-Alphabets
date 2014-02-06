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
    UIImageView *currentImage; //the image currently displayed
    UIImageView *currentImageView;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@end

@implementation LetterView
-(void)setupWithLetterNo: (int)chosenNumber currentAlphabet:(NSMutableArray*)passedAlphabet{
    self.title=@"Letter View";
    self.navigationItem.hidesBackButton = YES;
    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.view.frame.size.height-UA_BOTTOM_BAR_HEIGHT, self.view.frame.size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_ARROW_BACKWARD withFrame:CGRectMake(0, 0, 70, 35) centerIcon:UA_ICON_ALPHABET withFrame:CGRectMake(0, 0, 80, 45) rightIcon:UA_ICON_ARROW_FORWARD withFrame:CGRectMake(0, 0, 70, 35)];
    [self.view addSubview:self.bottomNavBar];
    
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goBackward"];
    UITapGestureRecognizer *backButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackward)];
    backButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.leftImageView addGestureRecognizer:backButtonRecognizer];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.rightImage andRunMethod:@"goForward"];
    UITapGestureRecognizer *forwardButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goForward)];
    forwardButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.rightImageView addGestureRecognizer:forwardButtonRecognizer];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"goToAlphabetsView"];
    UITapGestureRecognizer *abcButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAlphabetsView)];
    abcButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:abcButtonRecognizer];
    
    //THE LETTER
    self.currentAlphabet=[passedAlphabet mutableCopy];
    currentLetter=chosenNumber;
    currentImage=[self.currentAlphabet objectAtIndex:currentLetter];
    //NSLog(@"currentImage: %@", currentImage);
    currentImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE, self.view.frame.size.width, self.view.frame.size.width/0.82)];
    currentImageView.image=currentImage.image;
    //int maxHeight=self.view.frame.size.height-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT-self.bottomNavBar.frame.size.height;
    [self.view addSubview:currentImageView];
}
-(void)displayLetter:(int)chosenNumber{
    //NSLog(@"currentImage: %@", currentImage);
    currentLetter=chosenNumber;
    currentImage=[self.currentAlphabet objectAtIndex:currentLetter];
    currentImageView.image=[currentImage.image copy];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) goToAlphabetsView{
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    alphabetView=(AlphabetView*)obj;
    [alphabetView redrawAlphabet];
    [self.navigationController popViewControllerAnimated:NO];

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
