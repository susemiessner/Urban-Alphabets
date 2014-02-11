//
//  BottomNavBar.m
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "BottomNavBar.h"

@interface BottomNavBar ()
@end

@implementation BottomNavBar

//--------------------------------------------------
//FOR 3 ICONS IN BAR
//--------------------------------------------------
- (id)initWithFrame:(CGRect)frame leftIcon:(C4Image*)leftIcon withFrame:(CGRect)leftFrame centerIcon:(C4Image*)centerIcon withFrame:(CGRect)centerFrame rightIcon:(C4Image*)rightIcon withFrame:(CGRect)rightFrame{
    self = [super initWithFrame:frame];
    if (self) {
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        [self rect:self.frame];
        self.fillColor=UA_NAV_BAR_COLOR;
        self.lineWidth=0;
        
        //--------------------------------------------------
        //LEFT
        //--------------------------------------------------
        self.leftImage=[C4Image imageWithImage:leftIcon];
        self.leftImage.frame= leftFrame;
        [self addImage:self.leftImage];

        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
        self.centerImage=[C4Image imageWithImage:centerIcon];
        self.centerImage.frame= centerFrame;
        [self addImage:self.centerImage];

        //--------------------------------------------------
        //RIGHT
        //--------------------------------------------------
        self.rightImage=[C4Image imageWithImage:rightIcon];
        self.rightImage.frame= rightFrame;
        [self addImage:self.rightImage];

        
        [self fitToFrameThree:self.frame];

    }
    return self;
}

-(void)fitToFrameThree:(CGRect)frame {
    self.frame = frame;
    self.leftImage.center=CGPointMake(self.leftImage.width/2+5, self.height/2);
    self.centerImage.center=CGPointMake(self.width/2, self.height/2);
    self.rightImage.center=CGPointMake(self.width-(self.rightImage.width/2+5), self.height/2);

}
//--------------------------------------------------
//FOR 2 ICONS IN BAR: LEFT AND CENTER
//--------------------------------------------------
- (id)initWithFrame:(CGRect)frame leftIcon:(C4Image*)leftIcon withFrame:(CGRect)leftFrame  centerIcon:(C4Image*)centerIcon withFrame:(CGRect)centerFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        [self rect:self.frame];
        self.fillColor=UA_NAV_BAR_COLOR;
        self.lineWidth=0;
        
        //--------------------------------------------------
        //LEFT
        //--------------------------------------------------
        self.leftImage=[C4Image imageWithImage:leftIcon];
        self.leftImage.frame= leftFrame;
        [self addImage:self.leftImage];

        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
        self.centerImage=[C4Image imageWithImage:centerIcon];
        self.centerImage.frame= centerFrame;
        [self addImage:self.centerImage];
        
        
        [self fitToFrameTWO:self.frame];
        
    }
    return self;
}

-(void)fitToFrameTWO:(CGRect)frame {
    self.frame = frame;
    self.leftImage.center=CGPointMake(self.leftImage.width/2+5, self.height/2);
    self.centerImage.center=CGPointMake(self.width/2, self.height/2);
    
}
//--------------------------------------------------
//FOR 1 ICON IN BAR:  CENTER
//--------------------------------------------------
- (id)initWithFrame:(CGRect)frame  centerIcon:(C4Image*)centerIcon withFrame:(CGRect)centerFrame 
{
    self = [super initWithFrame:frame];
    if (self) {
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        [self rect:self.frame];
        self.fillColor=UA_NAV_BAR_COLOR;
        self.lineWidth=0;
        
        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
        self.centerImage=[C4Image imageWithImage:centerIcon];
        self.centerImage.frame= centerFrame;
        [self addImage:self.centerImage];
        
        [self fitToFrameONE:self.frame];
        
    }
    return self;
}

-(void)fitToFrameONE:(CGRect)frame {
    self.frame = frame;
    self.centerImage.center=CGPointMake(self.width/2, self.height/2);
    
}


@end
