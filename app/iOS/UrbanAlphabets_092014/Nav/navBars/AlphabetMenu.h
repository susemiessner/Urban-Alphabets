//
//  AlphabetMenu.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//


@interface AlphabetMenu : UIView
@property (nonatomic) UIView *cancelShape, *myAlphabetsShape, *myPostcardsShape, *writePostcardShape, *saveAlphabetShape, *shareAlphabetShape, *alphabetInfoShape, *settingsShape;
@property (nonatomic) UILabel *cancelLabel, *myAlphabetsLabel, *myPostcardsLabel, *writePostcardLabel, *saveAlphabetLabel, *shareAlphabetLabel, *alphabetInfoLabel, *settingsLabel;
@property (nonatomic) UIImageView *backButton, *myAlphabetsIcon, *myPostcardsIcon, *writePostcardIcon, *saveAlphabetIcon, *shareAlphabetIcon, *alphabetInfoIcon, *settingsIcon;
@property (readwrite, strong) NSString *previousView;
- (id)initWithFrame:(CGRect)frame andDevice: (NSString*)device;
-(void)setupPhone;
-(void)setupPad;

@end
