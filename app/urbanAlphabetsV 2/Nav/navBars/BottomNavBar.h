//
//  BottomNavBar.h
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

//#import "C4CanvasController.h"

@interface BottomNavBar : UIView
@property (readwrite, nonatomic) UIImage *centerImage, *leftImage, *rightImage;
@property (readwrite, nonatomic) UIImageView *centerImageView, *leftImageView, *rightImageView;
//@property (readwrite, nonatomic) CGRect *barFrame;
//3 icons
- (id)initWithFrame:(CGRect)frame leftIcon:(UIImage*)leftIcon withFrame:(CGRect)leftFrame centerIcon:(UIImage*)centerIcon withFrame:(CGRect)centerFrame rightIcon:(UIImage*)rightIcon withFrame:(CGRect)rightFrame;
//2 icons (left and center)
- (id)initWithFrame:(CGRect)frame leftIcon:(UIImage*)leftIcon withFrame:(CGRect)leftFrame  centerIcon:(UIImage*)centerIcon withFrame:(CGRect)centerFrame ;
//1 icon (center)
- (id)initWithFrame:(CGRect)frame  centerIcon:(UIImage*)centerIcon withFrame:(CGRect)centerFrame ;
@end
