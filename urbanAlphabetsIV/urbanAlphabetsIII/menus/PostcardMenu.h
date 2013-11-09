//
//  PostcardMenu.h
//  urbanAlphabetsIII
//
//  Created by Suse on 08/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4Shape.h"

@interface PostcardMenu : C4Shape
@property (nonatomic) C4Shape *cancelShape, *myAlphabetsShape, *myPostcardsShape, *writePostcardShape, *savePostcardShape, *sharePostcardShape, *postcardInfoShape;
@property (nonatomic) C4Label *cancelLabel, *myAlphabetsLabel, *myPostcardsLabel, *writePostcardLabel, *savePostcardLabel, *sharePostcardLabel, *postcardInfoLabel;
@property (nonatomic) C4Image *backButton, *myAlphabetsIcon, *myPostcardsIcon, *writePostcardIcon, *savePostcardIcon, *sharePostcardIcon, *postcardInfoIcon;
@property (readwrite, strong) NSString *previousView;
- (id)initWithFrame:(CGRect)frame;
@end
