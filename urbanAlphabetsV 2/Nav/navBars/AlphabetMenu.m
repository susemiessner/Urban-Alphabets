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
        float width=self.width-2*sideMargin;
        float height=42.45;
        float TextmarginFromLeft=103.11;

        
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        [self rect:self.frame];
        self.fillColor=UA_DARKEN_COLOR;
        self.lineWidth=0;
 
        
        
        //--------------------------------------------------
        //CANCEL
        //--------------------------------------------------
        //cancelShape
        self.cancelShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin+height), width, height)];
        self.cancelShape.fillColor=UA_WHITE_COLOR;
        self.cancelShape.lineWidth=0;
        [self addShape: self.cancelShape];
        
        //cancel Label
        self.cancelLabel=[C4Label labelWithText:@"Cancel" font:UA_FAT_FONT];
        self.cancelLabel.center=self.cancelShape.center;
        [self addLabel: self.cancelLabel];
        
        //--------------------------------------------------
        //MY ALPHABETS
        //--------------------------------------------------
        //shape
        self.myAlphabetsShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*2), width, height)];
        self.myAlphabetsShape.fillColor=UA_WHITE_COLOR;
        self.myAlphabetsShape.lineWidth=0;
        [self addShape:self.myAlphabetsShape];
        
        //label
        self.myAlphabetsLabel=[C4Label labelWithText:@"My Alphabets" font:UA_NORMAL_FONT];
        self.myAlphabetsLabel.origin=CGPointMake(TextmarginFromLeft, self.myAlphabetsShape.center.y-self.myAlphabetsLabel.height/2);
        [self addLabel:self.myAlphabetsLabel];
        
        //image
        self.myAlphabetsIcon=UA_ICON_MY_ALPHABETS;
        self.myAlphabetsIcon.width= 70;
        self.myAlphabetsIcon.center=CGPointMake(self.myAlphabetsShape.origin.x+self.myAlphabetsIcon.width/2+5, self.myAlphabetsShape.center.y);
        [self addImage:self.myAlphabetsIcon];
        //--------------------------------------------------
        //WRITE POSTCARD
        //--------------------------------------------------
        self.writePostcardShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*3+smallMargin), width, height)];
        self.writePostcardShape.fillColor=UA_WHITE_COLOR;
        self.writePostcardShape.lineWidth=0;
        [self addShape:self.writePostcardShape];
        
        self.writePostcardLabel=[C4Label labelWithText:@"Write Postcard" font:UA_NORMAL_FONT];
        self.writePostcardLabel.origin=CGPointMake(TextmarginFromLeft, self.writePostcardShape.center.y-self.writePostcardLabel.height/2);
        [self addLabel:self.writePostcardLabel];
        
        self.writePostcardIcon=UA_ICON_POSTCARD;
        self.writePostcardIcon.width= 70;
        self.writePostcardIcon.center=CGPointMake(self.writePostcardShape.origin.x+self.writePostcardIcon.width/2+5, self.writePostcardShape.center.y);
        [self addImage:self.writePostcardIcon];
        
        //--------------------------------------------------
        //SAVE ALPHABET
        //--------------------------------------------------
        self.saveAlphabetShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*4+smallMargin*2), width, height)];
        self.saveAlphabetShape.fillColor=UA_WHITE_COLOR;
        self.saveAlphabetShape.lineWidth=0;
        [self addShape:self.saveAlphabetShape];
        
        self.saveAlphabetLabel=[C4Label labelWithText:@"Save Alphabet" font:UA_NORMAL_FONT];
        self.saveAlphabetLabel.origin=CGPointMake(TextmarginFromLeft, self.saveAlphabetShape.center.y-self.saveAlphabetLabel.height/2);
        [self addLabel:self.saveAlphabetLabel];
        
        self.saveAlphabetIcon=UA_ICON_SAVE;
        self.saveAlphabetIcon.width= 40;
        self.saveAlphabetIcon.center=CGPointMake(self.saveAlphabetShape.origin.x+self.writePostcardIcon.width/2+5, self.saveAlphabetShape.center.y);
        [self addImage:self.saveAlphabetIcon];
        

        //--------------------------------------------------
        //SHARE ALPHABET
        //--------------------------------------------------
        self.shareAlphabetShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*5+smallMargin*3), width, height)];
        self.shareAlphabetShape.fillColor=UA_WHITE_COLOR;
        self.shareAlphabetShape.lineWidth=0;
        [self addShape:self.shareAlphabetShape];
        
        self.shareAlphabetLabel=[C4Label labelWithText:@"Share Alphabet" font:UA_NORMAL_FONT];
        self.shareAlphabetLabel.origin=CGPointMake(TextmarginFromLeft, self.shareAlphabetShape.center.y-self.shareAlphabetLabel.height/2);
        [self addLabel:self.shareAlphabetLabel];
        
        self.shareAlphabetIcon=UA_ICON_SHARE_ALPHABET;
        self.shareAlphabetIcon.width= 70;
        self.shareAlphabetIcon.center=CGPointMake(self.shareAlphabetShape.origin.x+self.shareAlphabetIcon.width/2+5, self.shareAlphabetShape.center.y);
        [self addImage:self.shareAlphabetIcon];

        //--------------------------------------------------
        //ALPHABET INFO
        //--------------------------------------------------
        self.alphabetInfoShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*6+smallMargin*4    ), width, height)];
        self.alphabetInfoShape.fillColor=UA_WHITE_COLOR;
        self.alphabetInfoShape.lineWidth=0;
        [self addShape:self.alphabetInfoShape];
        
        self.alphabetInfoLabel=[C4Label labelWithText:@"Alphabet info" font:UA_NORMAL_FONT];
        self.alphabetInfoLabel.origin=CGPointMake(TextmarginFromLeft, self.alphabetInfoShape.center.y-self.alphabetInfoLabel.height/2);
        [self addLabel:self.alphabetInfoLabel];
        
        self.alphabetInfoIcon=UA_ICON_INFO;
        self.alphabetInfoIcon.width= 38.676;
        self.alphabetInfoIcon.center=CGPointMake(self.alphabetInfoShape.origin.x+self.shareAlphabetIcon.width/2+5, self.alphabetInfoShape.center.y);
        [self addImage:self.alphabetInfoIcon];

    }
    return self;
}

-(void)fitToFrame:(CGRect)frame {
    self.frame = frame;
    self.backButton.center=CGPointMake(10, self.height / 2.0f);
}


@end
