//
//  LetterView.m
//  urbanAlphabetsII
//
//  Created by Suse on 29/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "LetterView.h"

@interface LetterView ()

@end

@implementation LetterView

-(void)transferVariables:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconAlphabet:(C4Image*)iconAlphabetDefault iconArrowForward:(C4Image*)iconArrowForwardDefault iconArrowBack:(C4Image*)iconArrowBackwardDefault currentAlphabet: (NSMutableArray*)transferredAlphabet{
    
    //nav bar heights
    topBarFromTop=TopBarFromTopDefault;
    topBarHeight=TopNavBarHeightDefault;
    bottomBarHeight=BottomBarHeightDefault;
    
    //colors
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    typeColor=typeColorDefault;
   
    
    //fonts
    fatFont=fatFontDefault;
    normalFont=normalFontDefault;
    
    //icons
    iconClose=iconCloseDefault;
    iconAlphabet=iconAlphabetDefault;
    iconArrowForward=iconArrowForwardDefault;
    iconArrowBack=iconArrowBackwardDefault;
    
    currentAlphabet=transferredAlphabet;

}
-(void)setup{
    [self topBarSetup];
    [self bottomBarSetup];
}
-(void)topBarSetup{
    //--------------------
    //white rect under top bar
    //--------------------
    defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, topBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    
    //--------------------
    //top bar
    //--------------------
    topNavBar=[C4Shape rect:CGRectMake(0, topBarFromTop, self.canvas.width, topBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    //title in center
    titleLabel = [C4Label labelWithText:@"Untitled" font:fatFont];
    titleLabel.center=topNavBar.center;
    [self.canvas addLabel:titleLabel];
    
        
    //--------------------
    //RIGHT
    //--------------------
    //close icon
    closeButtonImage=iconClose;
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    [self.canvas addImage:closeButtonImage];
    
    //invisible rect for navigation
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, topBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    [self.canvas addShape:closeRect];
    [self listenFor:@"touchesBegan" fromObject:closeRect andRunMethod:@"goToAlphabetsView"];
}
-(void)bottomBarSetup{
    //--------------------------------------------------
    //underlying rect
    //--------------------------------------------------
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(bottomBarHeight), self.canvas.width, bottomBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];
    
    //--------------------------------------------------
    //BUTTON Alphabet (CENTER)
    //--------------------------------------------------
    alphabetButton=iconAlphabet;
    alphabetButton.width=80;
    alphabetButton.center=bottomNavBar.center;
    [self.canvas addImage:alphabetButton];
    [self listenFor:@"touchesBegan" fromObject:alphabetButton andRunMethod:@"goToAlphabetsView"];
    
    //--------------------------------------------------
    //BUTTON Forward (RIGHT)
    //--------------------------------------------------
    forwardButton=iconArrowForward;
    forwardButton.width=75;
    forwardButton.center=CGPointMake(self.canvas.width-(forwardButton.width/2+5), bottomNavBar.center.y);
    [self.canvas addImage:forwardButton];
    [self listenFor:@"touchesBegan" fromObject:forwardButton andRunMethod:@"goForward"];

    
    //--------------------------------------------------
    //BUTTON Backward (LEFT)
    //--------------------------------------------------
    backwardButton=iconArrowBack;
    backwardButton.width=75;
    backwardButton.center=CGPointMake(backwardButton.width/2+5, bottomNavBar.center.y);
    [self.canvas addImage:backwardButton];
    [self listenFor:@"touchesBegan" fromObject:backwardButton andRunMethod:@"goBackward"];
    
}
-(void)displayLetter:(int)letterToDisplay currentAlphabet:(NSMutableArray*)transferredAlphabet{
    currentAlphabet=transferredAlphabet;
    currentLetter=letterToDisplay;
    currentImage=[currentAlphabet objectAtIndex:currentLetter];
    currentImage.width=self.canvas.width;
    currentImage.center=self.canvas.center;
    [self.canvas addImage:currentImage];
    
}
-(void)removeFromView{
    //top bar
    [defaultRect removeFromSuperview];
    [topNavBar removeFromSuperview];
    [titleLabel removeFromSuperview];
    //bottom bar
    [bottomNavBar removeFromSuperview];
    [alphabetButton removeFromSuperview];
    [forwardButton removeFromSuperview];
    [backwardButton removeFromSuperview];
    
    [currentImage removeFromSuperview];
    
    [self stopListeningFor:@"touchesBegan" objects:@[closeRect,alphabetButton, forwardButton ,backwardButton]];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) goToAlphabetsView{
    C4Log(@"going to Alphabetsview");
    [self postNotification:@"goToAlphabetsView"];
    
    [self removeFromView];
}
-(void) goForward{
    [currentImage removeFromSuperview];
    currentLetter++;
    if (currentLetter>=[currentAlphabet count]) {
        currentLetter=0;
    }
    [self displayLetter:currentLetter currentAlphabet:currentAlphabet];
}
-(void) goBackward{
    [currentImage removeFromSuperview];
    currentLetter--;
    if (currentLetter<=0) {
        currentLetter=[currentAlphabet count]-1;
    }
    [self displayLetter:currentLetter currentAlphabet:currentAlphabet];
}
@end
