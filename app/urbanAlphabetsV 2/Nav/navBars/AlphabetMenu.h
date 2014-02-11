//
//  AlphabetMenu.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//


@interface AlphabetMenu : UIView
@property (nonatomic) UIView *cancelShape, *myAlphabetsShape, *myPostcardsShape, *writePostcardShape, *saveAlphabetShape, *shareAlphabetShape, *alphabetInfoShape;
@property (nonatomic) UILabel *cancelLabel, *myAlphabetsLabel, *myPostcardsLabel, *writePostcardLabel, *saveAlphabetLabel, *shareAlphabetLabel, *alphabetInfoLabel;
@property (nonatomic) UIImageView *backButton, *myAlphabetsIcon, *myPostcardsIcon, *writePostcardIcon, *saveAlphabetIcon, *shareAlphabetIcon, *alphabetInfoIcon;
@property (readwrite, strong) NSString *previousView;
- (id)initWithFrame:(CGRect)frame ;
@end
