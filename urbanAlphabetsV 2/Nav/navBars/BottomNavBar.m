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
- (id)initWithFrame:(CGRect)frame leftIcon:(UIImage*)leftIcon withFrame:(CGRect)leftFrame centerIcon:(UIImage*)centerIcon withFrame:(CGRect)centerFrame rightIcon:(UIImage*)rightIcon withFrame:(CGRect)rightFrame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        self=[[UIView alloc]initWithFrame:frame];
        [self setBackgroundColor:UA_NAV_BAR_COLOR];
        
        //--------------------------------------------------
        //LEFT
        //--------------------------------------------------
        self.leftImage=leftIcon;
        self.leftImageView=[[UIImageView alloc]initWithFrame: leftFrame];
        [self addSubview:self.leftImageView];

        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
        self.centerImage=centerIcon;
        self.centerImageView=[[UIImageView alloc]initWithFrame:centerFrame];
        [self addSubview:self.centerImageView];

        //--------------------------------------------------
        //RIGHT
        //--------------------------------------------------
        self.rightImage=rightIcon;
        self.rightImageView=[[UIImageView alloc]initWithFrame:rightFrame];
        [self addSubview:self.rightImageView];

        
        //[self fitToFrameThree:self.frame];

    }
    return self;
}

-(void)fitToFrameThree:(CGRect)frame {
    self.frame = frame;
    self.leftImageView.center=CGPointMake(self.leftImage.size.width/2+5, self.frame.size.height/2);
    self.centerImageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.rightImageView.center=CGPointMake(self.frame.size.width-(self.rightImage.size.width/2+5), self.frame.size.height/2);
}
//--------------------------------------------------
//FOR 2 ICONS IN BAR: LEFT AND CENTER
//--------------------------------------------------
- (id)initWithFrame:(CGRect)frame leftIcon:(UIImage*)leftIcon withFrame:(CGRect)leftFrame  centerIcon:(UIImage*)centerIcon withFrame:(CGRect)centerFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        self=[[UIView alloc]initWithFrame:frame];
        [self setBackgroundColor:UA_NAV_BAR_COLOR];
        
        //--------------------------------------------------
        //LEFT
        //--------------------------------------------------
        self.leftImage=leftIcon;
        self.leftImageView=[[UIImageView alloc]initWithFrame: leftFrame];
        self.leftImageView.image=self.leftImage;
        [self addSubview:self.leftImageView];
        
        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
        self.centerImage=centerIcon;
        self.centerImageView=[[UIImageView alloc]initWithFrame:centerFrame];
        [self addSubview:self.centerImageView];
        
        //[self fitToFrameTWO:self.frame];
        
    }
    return self;
}

-(void)fitToFrameTWO:(CGRect)frame {
    self.frame = frame;
    /*[self.leftImageView setFrame:CGRectMake(self.leftImage.size.width/2+5, self.height/2, self.leftImage, )];
    
    self.leftImageView.center=CGPointMake(self.leftImage.size.width/2+5, self.height/2);
    self.centerImageView.center=CGPointMake(self.width/2, self.height/2);*/
    
}
//--------------------------------------------------
//FOR 1 ICON IN BAR:  CENTER
//--------------------------------------------------
- (id)initWithFrame:(CGRect)frame centerIcon:(UIImage*)centerIcon withFrame:(CGRect)centerFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        self=[[UIView alloc]initWithFrame:frame];
        [self setBackgroundColor:UA_NAV_BAR_COLOR];
        
        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
       centerFrame=CGRectMake(50, 50, 100, 100); //for testing
        self.centerImage=[UIImage imageNamed:@"icon_OK.png"]; //for testing
        //self.centerImage=centerIcon; >>this is the one that should be used
        self.centerImageView=[[UIImageView alloc]initWithFrame:centerFrame];
        self.centerImageView.image=self.centerImage;
        [self addSubview:self.centerImageView];
        
        //[self fitToFrameONE:self.frame];
        
    }
    return self;
}

-(void)fitToFrameONE:(CGRect)frame {
    //self.frame = frame;
    //[self.centerImageView setFrame:frame];
}


@end
