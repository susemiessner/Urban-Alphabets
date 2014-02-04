//
//  PostcardMenu.h
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4Shape.h"

@interface PostcardMenu : C4Shape
@property (nonatomic) C4Shape *cancelShape, *myAlphabetsShape, *myPostcardsShape, *writePostcardShape, *savePostcardShape, *sharePostcardShape, *postcardInfoShape;
@property (nonatomic) C4Label *cancelLabel, *myAlphabetsLabel, *myPostcardsLabel, *writePostcardLabel, *savePostcardLabel, *sharePostcardLabel, *postcardInfoLabel;
@property (nonatomic) C4Image *backButton, *myAlphabetsIcon, *myPostcardsIcon, *writePostcardIcon, *savePostcardIcon, *sharePostcardIcon, *postcardInfoIcon;
@property (readwrite, strong) NSString *previousView;
- (id)initWithFrame:(CGRect)frame;
@end
