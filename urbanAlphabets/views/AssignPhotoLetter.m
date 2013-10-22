//
//  AssignPhotoLetter.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/21/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "AssignPhotoLetter.h"
#define NavBarHeight 42
#define TopBarFromTop 20

@interface AssignPhotoLetter ()

@end

@implementation AssignPhotoLetter

-(void)setup:(C4Image *)image{//passing on the image just taken
    photoTaken=image;
    navBarColor=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    buttonColor= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    overlayColor=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5];
    
    [self topBarSetup];
    [self bottomBarSetup];
    
}

-(void)topBarSetup{
    //white rect under top bar that stays
    defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, TopBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    
    
    //navigation bar
    topNavBar=[C4Shape rect:CGRectMake(0, TopBarFromTop, self.canvas.width, NavBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    takePhoto = [C4Label labelWithText:@"Assign photo letter" font:fatFont];
    takePhoto.center=topNavBar.center;
    [self.canvas addLabel:takePhoto];
}
-(void) bottomBarSetup{
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(NavBarHeight), self.canvas.width, NavBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];
    //[self loadLastImage];
  
}
-(void)loadLastImage{
    NSString *workSpacePath=[[self documentsDirectory] stringByAppendingPathComponent:@"awesomeshot2013-10-21 13/31/58 +0000.jpg"];
    //C4Log(@"documents directory: %s", [self documentsDirectory]);
    //C4Log(@"workSpacePath: %s", workSpacePath);
    C4Image *myimage=[[C4Image alloc] initWithFrame:CGRectMake(0,0,20,20)];
    myimage.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
    [self.canvas addImage:myimage];

    
}

-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}


@end
