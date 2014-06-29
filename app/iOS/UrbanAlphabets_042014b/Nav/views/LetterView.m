//
//  LetterView.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "LetterView.h"
#import "BottomNavBar.h"

@interface LetterView (){
    C4WorkSpace *alphabetView;
    NSInteger currentLetter;
    UIImageView *currentImage; //the image currently displayed
    UIImageView *currentImageView;
    
    float letterWidth;
    float letterHeight;
    float letterFromLeft;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@end

@implementation LetterView
-(void)setupWithLetterNo: (int)chosenNumber currentAlphabet:(NSMutableArray*)passedAlphabet{
    self.title=@"Letter View";
    self.navigationItem.hidesBackButton = YES;
    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
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
    
    //check which phone
    letterWidth=[[UIScreen mainScreen] bounds].size.width;
    letterHeight=letterWidth/0.82;
    letterFromLeft=0;
    if ( UA_IPHONE_4_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
      //if ( UA_IPHONE_5_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
        letterHeight=[[UIScreen mainScreen] bounds].size.height-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT-self.bottomNavBar.frame.size.height;
        letterWidth=letterWidth*0.82;
        letterFromLeft=([[UIScreen mainScreen] bounds].size.width-letterWidth)/2;
    }
    
    //THE LETTER
    self.currentAlphabet=[passedAlphabet mutableCopy];
    currentLetter=chosenNumber;
    currentImage=[self.currentAlphabet objectAtIndex:currentLetter];
    currentImageView=[[UIImageView alloc] initWithFrame:CGRectMake(letterFromLeft, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE, letterWidth, letterHeight)];
    currentImageView.image=currentImage.image;
    currentImageView.userInteractionEnabled=YES;
    [self.view addSubview:currentImageView];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goForward)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [currentImageView addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goBackward)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [currentImageView addGestureRecognizer:swipeRightRecognizer];
    
}
-(void)displayLetter:(int)chosenNumber{
    currentLetter=chosenNumber;
    currentImage=[self.currentAlphabet objectAtIndex:currentLetter];
    currentImageView.image=[currentImage.image copy];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) goToAlphabetsView{
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1];
    alphabetView=(C4WorkSpace*)obj;
    //[alphabetView redrawAlphabet];
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void) goForward{
    [currentImage removeFromSuperview];
    currentLetter++;
    if (currentLetter>=[self.currentAlphabet count]) {
        currentLetter=0;
    }
    [self displayLetter:(int)currentLetter];
}
-(void) goBackward{
    [currentImage removeFromSuperview];
    currentLetter--;
    if (currentLetter<=0) {
        currentLetter=[self.currentAlphabet count]-1;
    }
    [self displayLetter:(int)currentLetter];
}


@end
