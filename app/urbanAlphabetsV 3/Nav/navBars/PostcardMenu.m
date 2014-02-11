//
//  PostcardMenu.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "PostcardMenu.h"

@implementation PostcardMenu
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float sideMargin=8.2;
        float smallMargin=1.0;
        float width=self.frame.size.width-2*sideMargin;
        float height=42.45;
        
        
        //--------------------------------------------------
        //underlying rect
        //--------------------------------------------------
        [self setBackgroundColor:UA_DARKEN_COLOR];
        
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
        //MY ALPHABETS
        //--------------------------------------------------
        //shape
        self.myAlphabetsShape=[[UIView alloc] initWithFrame:CGRectMake(sideMargin, self.self.frame.size.height-(sideMargin*2+height*2), width, height)];
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
        self.writePostcardShape=[[UIView alloc]initWithFrame:CGRectMake(sideMargin, self.frame.size.height-(sideMargin*2+height*3+smallMargin), width, height)];
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
        //SAVE POSTCARD
        //--------------------------------------------------
        self.savePostcardShape=[[UIView alloc]initWithFrame:CGRectMake(sideMargin, self.frame.size.height-(sideMargin*2+height*4+smallMargin*2), width, height)];
        [self.savePostcardShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview:self.savePostcardShape];
        
        self.savePostcardLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.savePostcardShape.frame.origin.x+100, self.savePostcardShape.frame.origin.y, self.savePostcardShape.frame.size.width-100, self.savePostcardShape.frame.size.height)];
        [self.savePostcardLabel setText:@"Save Postcard" ];
        [self.savePostcardLabel setFont:UA_NORMAL_FONT];
        [self addSubview:self.savePostcardLabel];
        
        self.savePostcardIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.savePostcardShape.frame.origin.x+3+15, self.savePostcardShape.frame.origin.y+2, 40, 40)];
        self.savePostcardIcon.image=UA_ICON_SAVE;
        [self addSubview:self.savePostcardIcon];
        
        self.savePostcardShape.userInteractionEnabled=YES;
        self.savePostcardLabel.userInteractionEnabled=YES;
        self.savePostcardIcon.userInteractionEnabled=YES;
        
        
        //--------------------------------------------------
        //SHARE POSTCARD
        //--------------------------------------------------
        self.sharePostcardShape=[[UIView alloc]initWithFrame:CGRectMake(sideMargin, self.frame.size.height-(sideMargin*2+height*5+smallMargin*3), width, height)];
        [self.sharePostcardShape setBackgroundColor:UA_WHITE_COLOR];
        [self addSubview:self.sharePostcardShape];
        
        self.sharePostcardLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.sharePostcardShape.frame.origin.x+100, self.sharePostcardShape.frame.origin.y, self.sharePostcardShape.frame.size.width, self.sharePostcardShape.frame.size.height)];
        [self.sharePostcardLabel setText:@"Share Postcard"];
        [self.sharePostcardLabel setFont:UA_NORMAL_FONT];
        [self addSubview:self.sharePostcardLabel];
        
        self.sharePostcardIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.sharePostcardShape.frame.origin.x+5, self.sharePostcardShape.frame.origin.y+3, 70, 35)];
        self.sharePostcardIcon.image=UA_ICON_SHARE_POSTCARD;
        [self addSubview:self.sharePostcardIcon];
        
        self.sharePostcardShape.userInteractionEnabled=YES;
        self.sharePostcardLabel.userInteractionEnabled=YES;
        self.sharePostcardIcon.userInteractionEnabled=YES;
        

        
        
    }
    return self;
}

@end
