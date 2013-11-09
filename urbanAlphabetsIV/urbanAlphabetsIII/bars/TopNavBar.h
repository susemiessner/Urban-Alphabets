//
//  TopNavBar.h
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface TopNavBar : C4Shape
@property (nonatomic) C4Label *titleLabel, *backLabel;
@property (nonatomic) C4Image *backButton, *closeButton;
- (id)initWithFrame:(CGRect)frame text:(NSString*)titleText lastView:(NSString*)lastView;
- (id)initWithFrame:(CGRect)frame text:(NSString*)titleText; //without navigation function
@end
