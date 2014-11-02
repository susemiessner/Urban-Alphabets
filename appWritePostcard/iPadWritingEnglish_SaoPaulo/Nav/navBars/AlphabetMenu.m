//
//  AlphabetMenu.m
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AlphabetMenu.h"


@implementation AlphabetMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float sideMargin=8.2;
        float smallMargin=1.0;
        float width=self.frame.size.width-2*sideMargin;
        float height=42.45;
        int menuIconNo=1;
        
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        [self setBackgroundColor:UA_OVERLAY_COLOR];
        
        //--------------------------------------------------
        //CANCEL
        //--------------------------------------------------
        //cancelShape
        
        self.cancelShape=[[UIView alloc]initWithFrame:CGRectMake(sideMargin, self.frame.size.height-(sideMargin+height), width, height)];
        [self.cancelShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview: self.cancelShape];
        
        //cancel Label
        self.cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.cancelShape.frame.origin.x, self.cancelShape.frame.origin.y, self.cancelShape.frame.size.width, self.cancelShape.frame.size.height)];
        [self.cancelLabel setText:@"Cancel"];
        [self.cancelLabel setFont:UA_FAT_FONT];
        [self.cancelLabel setTextAlignment:NSTextAlignmentCenter];
        self.cancelLabel.center=self.cancelShape.center;
        [self addSubview: self.cancelLabel];
        
        self.cancelShape.userInteractionEnabled=YES;
        self.cancelLabel.userInteractionEnabled=YES;
        
        //--------------------------------------------------
        //SETTINGS
        //--------------------------------------------------
        menuIconNo+=1;

        //shape
        self.settingsShape=[[UIView alloc] initWithFrame:CGRectMake(sideMargin, self.self.frame.size.height-(sideMargin*2+height*menuIconNo), width, height)];
        [self.settingsShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview:self.settingsShape];
        
        //label
        self.settingsLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.settingsShape.frame.origin.x+100, self.settingsShape.frame.origin.y, self.settingsShape.frame.size.width, self.settingsShape.frame.size.height)];
        [self.settingsLabel setText:@"Settings"];
        [self.settingsLabel setFont:UA_NORMAL_FONT];
        [self addSubview: self.settingsLabel];
        
        
        //image
        self.settingsIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.settingsShape.frame.origin.x+3+15, self.settingsShape.frame.origin.y+2, 40, 40)];
        self.settingsIcon.image=UA_ICON_SETTINGS;
        [self addSubview:self.settingsIcon];
        
        self.settingsShape.userInteractionEnabled=YES;
        self.settingsLabel.userInteractionEnabled=YES;
        self.settingsIcon.userInteractionEnabled=YES;
        
        
        //--------------------------------------------------
        //MY ALPHABETS
        //--------------------------------------------------
        menuIconNo+=1;

        //shape
        self.myAlphabetsShape=[[UIView alloc] initWithFrame:CGRectMake(sideMargin, self.self.frame.size.height-(sideMargin*2+height*menuIconNo+smallMargin), width, height)];
        [self.myAlphabetsShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview:self.myAlphabetsShape];
        
        //label
        self.myAlphabetsLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.myAlphabetsShape.frame.origin.x+100, self.myAlphabetsShape.frame.origin.y, self.myAlphabetsShape.frame.size.width, self.myAlphabetsShape.frame.size.height)];
        [self.myAlphabetsLabel setText:@"My Alphabets"];
        [self.myAlphabetsLabel setFont:UA_NORMAL_FONT];
        [self addSubview: self.myAlphabetsLabel];
        
        
        //image
        self.myAlphabetsIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.myAlphabetsShape.frame.origin.x+3, self.myAlphabetsShape.frame.origin.y+2, 70, 35)];
        self.myAlphabetsIcon.image=UA_ICON_MY_ALPHABETS;
        [self addSubview:self.myAlphabetsIcon];
        
        self.myAlphabetsShape.userInteractionEnabled=YES;
        self.myAlphabetsLabel.userInteractionEnabled=YES;
        self.myAlphabetsIcon.userInteractionEnabled=YES;
        
        //--------------------------------------------------
        //WRITE POSTCARD
        //--------------------------------------------------
        menuIconNo+=1;

        self.writePostcardShape=[[UIView alloc]initWithFrame:CGRectMake(sideMargin, self.frame.size.height-(sideMargin*2+height*menuIconNo+smallMargin*(menuIconNo-2)), width, height)];
        [self.writePostcardShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview:self.writePostcardShape];
        
        self.writePostcardLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.writePostcardShape.frame.origin.x+100, self.writePostcardShape.frame.origin.y, self.writePostcardShape.frame.size.width, self.writePostcardShape.frame.size.height) ];
        [self.writePostcardLabel setText:@"Write Postcard"];
        [self.writePostcardLabel setFont:UA_NORMAL_FONT];
        [self addSubview:self.writePostcardLabel];
        
        self.writePostcardIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.writePostcardShape.frame.origin.x+3, self.writePostcardShape.frame.origin.y+2, 70, 35)];
        
        self.writePostcardIcon.image=UA_ICON_POSTCARD;
        [self addSubview:self.writePostcardIcon];
        
        self.writePostcardShape.userInteractionEnabled=YES;
        self.writePostcardLabel.userInteractionEnabled=YES;
        self.writePostcardIcon.userInteractionEnabled=YES;
        //--------------------------------------------------
        //SAVE ALPHABET
        //--------------------------------------------------
        menuIconNo+=1;

        self.saveAlphabetShape=[[UIView alloc]initWithFrame:CGRectMake(sideMargin, self.frame.size.height-(sideMargin*2+height*menuIconNo+smallMargin*(menuIconNo-2)), width, height)];
        [self.saveAlphabetShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview:self.saveAlphabetShape];
        
        self.saveAlphabetLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.saveAlphabetShape.frame.origin.x+100, self.saveAlphabetShape.frame.origin.y, self.saveAlphabetShape.frame.size.width-100, self.saveAlphabetShape.frame.size.height)];
        [self.saveAlphabetLabel setText:@"Save Alphabet" ];
        [self.saveAlphabetLabel setFont:UA_NORMAL_FONT];
        [self addSubview:self.saveAlphabetLabel];
        
        self.saveAlphabetIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.saveAlphabetShape.frame.origin.x+3+15, self.saveAlphabetShape.frame.origin.y+2, 40, 40)];
        self.saveAlphabetIcon.image=UA_ICON_SAVE;
        [self addSubview:self.saveAlphabetIcon];
        
        self.saveAlphabetShape.userInteractionEnabled=YES;
        self.saveAlphabetLabel.userInteractionEnabled=YES;
        self.saveAlphabetIcon.userInteractionEnabled=YES;

        //--------------------------------------------------
        //SHARE ALPHABET
        //--------------------------------------------------
        menuIconNo+=1;

        self.shareAlphabetShape=[[UIView alloc]initWithFrame:CGRectMake(sideMargin, self.frame.size.height-(sideMargin*2+height*menuIconNo+smallMargin*(menuIconNo-2)), width, height)];
        [self.shareAlphabetShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview:self.shareAlphabetShape];
        
        self.shareAlphabetLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.shareAlphabetShape.frame.origin.x+100, self.shareAlphabetShape.frame.origin.y, self.shareAlphabetShape.frame.size.width, self.shareAlphabetShape.frame.size.height)];
        [self.shareAlphabetLabel setText:@"Share Alphabet"];
        [self.shareAlphabetLabel setFont:UA_NORMAL_FONT];
        [self addSubview:self.shareAlphabetLabel];
        
        self.shareAlphabetIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.shareAlphabetShape.frame.origin.x+5, self.shareAlphabetShape.frame.origin.y+3, 70, 35)];
        self.shareAlphabetIcon.image=UA_ICON_SHARE_ALPHABET;
        [self addSubview:self.shareAlphabetIcon];
        
        self.shareAlphabetShape.userInteractionEnabled=YES;
        self.shareAlphabetLabel.userInteractionEnabled=YES;
        self.shareAlphabetIcon.userInteractionEnabled=YES;
        
        //--------------------------------------------------
        //ALPHABET INFO
        //--------------------------------------------------
        menuIconNo+=1;

        self.alphabetInfoShape=[[UIView alloc] initWithFrame:CGRectMake(sideMargin, self.frame.size.height-(sideMargin*2+height*menuIconNo+smallMargin*(menuIconNo-2)), width, height)];
        [self.alphabetInfoShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview:self.alphabetInfoShape];
        
        self.alphabetInfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.alphabetInfoShape.frame.origin.x+100, self.alphabetInfoShape.frame.origin.y, self.alphabetInfoShape.frame.size.width, self.alphabetInfoShape.frame.size.height)];
        [self.alphabetInfoLabel setText:@"Alphabet info"];
        [self.alphabetInfoLabel setFont:UA_NORMAL_FONT];
        [self addSubview:self.alphabetInfoLabel];
        
        self.alphabetInfoIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.alphabetInfoShape.frame.origin.x+5+15, self.alphabetInfoShape.frame.origin.y+3, 40, 40)];
        self.alphabetInfoIcon.image=UA_ICON_INFO;
        
        self.alphabetInfoIcon.userInteractionEnabled=YES;
        self.alphabetInfoLabel.userInteractionEnabled=YES;
        self.alphabetInfoShape.userInteractionEnabled=YES;
        [self addSubview:self.alphabetInfoIcon];
        
    }
    return self;
}

-(void)fitToFrame:(CGRect)frame {
    self.frame = frame;
    //self.backButton.center=CGPointMake(10, self.height / 2.0f);
}


@end
