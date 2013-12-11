//
//  BottomNavBar.h
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface BottomNavBar : C4Shape
@property (readwrite, nonatomic) C4Image *centerImage, *leftImage, *rightImage;

//3 icons
- (id)initWithFrame:(CGRect)frame leftIcon:(C4Image*)leftIcon withFrame:(CGRect)leftFrame centerIcon:(C4Image*)centerIcon withFrame:(CGRect)centerFrame rightIcon:(C4Image*)rightIcon withFrame:(CGRect)rightFrame;
//2 icons (left and center)
- (id)initWithFrame:(CGRect)frame leftIcon:(C4Image*)leftIcon withFrame:(CGRect)leftFrame  centerIcon:(C4Image*)centerIcon withFrame:(CGRect)centerFrame ;
//1 icon (center)
- (id)initWithFrame:(CGRect)frame  centerIcon:(C4Image*)centerIcon withFrame:(CGRect)centerFrame ;
@end
