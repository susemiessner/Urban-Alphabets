//
//  AlphabetMenu.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4Shape.h"

@interface AlphabetMenu : C4Shape
@property (nonatomic) C4Shape *cancelShape, *myAlphabetsShape, *myPostcardsShape, *writePostcardShape, *saveAlphabetShape, *shareAlphabetShape, *alphabetInfoShape;
@property (nonatomic) C4Label *cancelLabel, *myAlphabetsLabel, *myPostcardsLabel, *writePostcardLabel, *saveAlphabetLabel, *shareAlphabetLabel, *alphabetInfoLabel;
@property (nonatomic) C4Image *backButton, *myAlphabetsIcon, *myPostcardsIcon, *writePostcardIcon, *saveAlphabetIcon, *shareAlphabetIcon, *alphabetInfoIcon;
@property (readwrite, strong) NSString *previousView;
- (id)initWithFrame:(CGRect)frame text:(NSString*)titleText lastView:(NSString*)lastView;
@end
