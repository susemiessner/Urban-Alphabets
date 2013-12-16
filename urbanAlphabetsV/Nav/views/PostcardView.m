//
//  PostcardView.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "PostcardView.h"
#import "SaveToDatabase.h"
#import "PostcardMenu.h"
@interface PostcardView (){
    SaveToDatabase *save;
    //saving image
    CGContextRef graphicsContext;

}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite) NSMutableArray  *postcardArray, *greyRectArray;
@property (nonatomic) PostcardMenu *menu;
@end

@implementation PostcardView

-(void)setupWithPostcard: (NSMutableArray*)postcardPassed Rect: (NSMutableArray*)postcardRect withLanguage:(NSString*)language withPostcardText:(NSString*)postcardText{
    self.title=@"Postcard";
    
    self.postcardArray=[[NSMutableArray alloc]init];
    self.postcardArray=[postcardPassed mutableCopy];
    self.greyRectArray=[[NSMutableArray alloc]init];
    self.greyRectArray=[postcardRect mutableCopy];
    C4Log(@"passed grey rect array:%i", [postcardRect count]);
    C4Log(@"self grey rect array: %i", [self.greyRectArray count]);
    self.currentLanguage=language;
    self.postcardText=postcardText;
    
    
    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 60, 30)  centerIcon:UA_ICON_MENU withFrame:CGRectMake(0, 0, 45, 45)];
    [self.canvas addShape:self.bottomNavBar];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToTakePhoto"];
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"openMenu"];
    
    //display the postcard
    
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (int i=0; i<[self.postcardArray count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        
        C4Image *image=[self.postcardArray objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
    }
    for (int i=0; i<[self.greyRectArray count]; i++) {
        C4Shape *greyRect=[self.greyRectArray objectAtIndex:i];
        greyRect.fillColor=UA_NAV_CTRL_COLOR;
        greyRect.lineWidth=2;
        greyRect.strokeColor=UA_NAV_BAR_COLOR;
        [self.canvas addShape:greyRect];
        
    }
}


@end
