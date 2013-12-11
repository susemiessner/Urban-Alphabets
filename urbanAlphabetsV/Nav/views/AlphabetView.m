//
//  AlphabetView.m
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "AlphabetView.h"
#import "BottomNavBar.h"
#import "TakePhoto.h"

@interface AlphabetView (){
    TakePhoto *takePhoto;
    NSMutableArray *greyRectArray;
    NSString *currentLanguage;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@end

@implementation AlphabetView

-(void )setup:(NSMutableArray*)passedAlphabet  {
    self.title=@"Alphabet View";
    self.currentAlphabet=[passedAlphabet mutableCopy];
    currentLanguage=@"Finnish";

    
    
    
    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 60, 30)  centerIcon:UA_ICON_MENU withFrame:CGRectMake(0, 0, 45, 45)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToTakePhoto"];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"openMenu"];
    
    [self initGreyGrid];
    [self drawCurrentAlphabet];
    
}
-(void)initGreyGrid{
    float imageWidth=53.53;
    float imageHeight=65.1;
    greyRectArray=[[NSMutableArray alloc]init];
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=UA_NAV_CTRL_COLOR;
        greyRect.lineWidth=2;
        greyRect.strokeColor=UA_NAV_BAR_COLOR;
        [greyRectArray addObject:greyRect];
        [self.canvas addShape:greyRect];
    }
}
-(void)drawCurrentAlphabet{
    
    //C4Log(@"currentAlphabetLength: %i", [self.currentAlphabet count]);
    C4Log(@"drawing the alphabet");
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        C4Image *image=[self.currentAlphabet objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        //[self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"tappedLetter:"];
    }
}
-(void)goToTakePhoto{
    takePhoto = [[TakePhoto alloc] initWithNibName:@"TakePhoto" bundle:[NSBundle mainBundle]];
    [takePhoto cameraSetup];
    [takePhoto setup];
    [self.navigationController pushViewController:takePhoto animated:YES];

}

@end
