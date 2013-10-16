//
//  CropPhoto.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "CropPhoto.h"
#define NavBarHeight 42
#define TopBarFromTop 20

@interface CropPhoto ()

@end

@implementation CropPhoto{
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *cropPhoto;
    
    UIColor *navBarColor;
}
-(void) setup{
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1.0];
    
    
    topNavBar=[C4Shape rect:CGRectMake(0, TopBarFromTop, self.canvas.width, TopBarFromTop+NavBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    cropPhoto = [C4Label labelWithText:@"Crop Photo" font:fatFont];
    cropPhoto.center=topNavBar.center;
    [self.canvas addLabel:cropPhoto];
}


@end
