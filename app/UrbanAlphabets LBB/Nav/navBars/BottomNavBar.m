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
        [self setBackgroundColor:UA_NAV_BAR_COLOR];
        
        //--------------------------------------------------
        //LEFT
        //--------------------------------------------------
        self.leftImage=leftIcon;
        self.leftImageView=[[UIImageView alloc]initWithFrame: leftFrame];
        self.leftImageView.image=self.leftImage;
        self.leftImageView.userInteractionEnabled=YES;
       [self addSubview:self.leftImageView];
        
        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
        self.centerImage=centerIcon;
        self.centerImageView=[[UIImageView alloc]initWithFrame:centerFrame];
        self.centerImageView.image=self.centerImage;
        self.centerImageView.userInteractionEnabled=YES;

        [self addSubview:self.centerImageView];
        //--------------------------------------------------
        //RIGHT
        //--------------------------------------------------
        self.rightImage=rightIcon;
        self.rightImageView=[[UIImageView alloc]initWithFrame:rightFrame];
        self.rightImageView.image=self.rightImage;
        self.rightImageView.userInteractionEnabled=YES;
        [self addSubview:self.rightImageView];

        
        [self fitToFrameThree:self.frame];

    }
    return self;
}

-(void)fitToFrameThree:(CGRect)frame {
    [self.leftImageView setFrame:CGRectMake(5, self.frame.size.height/2-self.leftImageView.frame.size.height/2, self.leftImageView.frame.size.width, self.leftImageView.frame.size.height)];
    [self.centerImageView setFrame:CGRectMake(self.frame.size.width/2-self.centerImageView.frame.size.width/2, self.frame.size.height/2-self.centerImageView.frame.size.height/2, self.centerImageView.frame.size.width, self.centerImageView.frame.size.height)];
    [self.rightImageView setFrame:CGRectMake(self.frame.size.width-(self.rightImageView.frame.size.width+5), self.frame.size.height/2-self.rightImageView.frame.size.height/2, self.rightImageView.frame.size.width, self.rightImageView.frame.size.height)];
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
        [self setBackgroundColor:UA_NAV_BAR_COLOR];
        
        //--------------------------------------------------
        //LEFT
        //--------------------------------------------------
        self.leftImage=leftIcon;
        self.leftImageView=[[UIImageView alloc]initWithFrame: leftFrame];
        self.leftImageView.image=self.leftImage;
        self.leftImageView.userInteractionEnabled=YES;
        [self addSubview:self.leftImageView];
        
        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
        self.centerImage=centerIcon;
        self.centerImageView=[[UIImageView alloc]initWithFrame:centerFrame];
        self.centerImageView.image=self.centerImage;
        self.centerImageView.userInteractionEnabled=YES;
        [self addSubview:self.centerImageView];
        
        [self fitToFrameTWO:self.frame];
        
    }
    return self;
}

-(void)fitToFrameTWO:(CGRect)frame {
    [self.leftImageView setFrame:CGRectMake(5, self.frame.size.height/2-self.leftImageView.frame.size.height/2, self.leftImageView.frame.size.width, self.leftImageView.frame.size.height)];
    [self.centerImageView setFrame:CGRectMake(self.frame.size.width/2-self.centerImageView.frame.size.width/2, self.frame.size.height/2-self.centerImageView.frame.size.height/2, self.centerImageView.frame.size.width, self.centerImageView.frame.size.height)];
    
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
        [self setBackgroundColor:UA_NAV_BAR_COLOR];
        
        //--------------------------------------------------
        //CENTER
        //--------------------------------------------------
        self.centerImage=centerIcon;
        self.centerImageView=[[UIImageView alloc]initWithFrame:centerFrame];
        self.centerImageView.image=self.centerImage;
        self.centerImageView.userInteractionEnabled=YES;
        [self addSubview:self.centerImageView];
        
        [self fitToFrameONE:self.frame];
        
    }
    return self;
}

-(void)fitToFrameONE:(CGRect)frame {
    [self.centerImageView setFrame:CGRectMake(self.frame.size.width/2-self.centerImageView.frame.size.width/2, self.frame.size.height/2-self.centerImageView.frame.size.height/2, self.centerImageView.frame.size.width, self.centerImageView.frame.size.height)];
}


@end
