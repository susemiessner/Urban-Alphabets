//
//  PostcardMenu.m
//  urbanAlphabetsIII
//
//  Created by Suse on 08/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "PostcardMenu.h"

@implementation PostcardMenu

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
        
        [self listenFor:@"touchesBegan" fromObjects:@[self.myAlphabetsShape, self.myAlphabetsLabel,self.myAlphabetsIcon] andRunMethod:@"goToMyAlphabets"];
        
        //--------------------------------------------------
        //MY Postcards
        //--------------------------------------------------
        self.myPostcardsShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*3+smallMargin), width, height)];
        self.myPostcardsShape.fillColor=UA_WHITE_COLOR;
        self.myPostcardsShape.lineWidth=0;
        [self addShape:self.myPostcardsShape];
        
        self.myPostcardsLabel=[C4Label labelWithText:@"My Postcards" font:UA_NORMAL_FONT];
        self.myPostcardsLabel.origin=CGPointMake(TextmarginFromLeft, self.myPostcardsShape.center.y-self.myPostcardsLabel.height/2);
        [self addLabel:self.myPostcardsLabel];
        
        self.myPostcardsIcon=UA_ICON_MY_POSTCARDS;
        self.myPostcardsIcon.width= 70;
        self.myPostcardsIcon.center=CGPointMake(self.myPostcardsShape.origin.x+self.myPostcardsIcon.width/2+5, self.myPostcardsShape.center.y);
        [self addImage:self.myPostcardsIcon];
        [self listenFor:@"touchesBegan" fromObjects:@[self.myPostcardsShape, self.myPostcardsLabel,self.myPostcardsIcon] andRunMethod:@"goToMyPostcards"];
        //--------------------------------------------------
        //WRITE POSTCARD
        //--------------------------------------------------
        self.writePostcardShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*4+smallMargin*2), width, height)];
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
        [self listenFor:@"touchesBegan" fromObjects:@[self.writePostcardShape, self.writePostcardLabel,self.writePostcardIcon] andRunMethod:@"goToWritePostcard"];
        
        //--------------------------------------------------
        //SAVE POSTCARD
        //--------------------------------------------------
        self.savePostcardShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*5+smallMargin*3), width, height)];
        self.savePostcardShape.fillColor=UA_WHITE_COLOR;
        self.savePostcardShape.lineWidth=0;
        [self addShape:self.savePostcardShape];
        
        self.savePostcardLabel=[C4Label labelWithText:@"Save Postcard" font:UA_NORMAL_FONT];
        self.savePostcardLabel.origin=CGPointMake(TextmarginFromLeft, self.savePostcardShape.center.y-self.savePostcardLabel.height/2);
        [self addLabel:self.savePostcardLabel];
        
        self.savePostcardIcon=UA_ICON_SAVE;
        self.savePostcardIcon.width= 40;
        self.savePostcardIcon.center=CGPointMake(self.savePostcardShape.origin.x+self.writePostcardIcon.width/2+5, self.savePostcardShape.center.y);
        [self addImage:self.savePostcardIcon];
        
        
        //--------------------------------------------------
        //SHARE POSTCARD
        //--------------------------------------------------
        self.sharePostcardShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*6+smallMargin*4), width, height)];
        self.sharePostcardShape.fillColor=UA_WHITE_COLOR;
        self.sharePostcardShape.lineWidth=0;
        [self addShape:self.sharePostcardShape];
        
        self.sharePostcardLabel=[C4Label labelWithText:@"Share Postcard" font:UA_NORMAL_FONT];
        self.sharePostcardLabel.origin=CGPointMake(TextmarginFromLeft, self.sharePostcardShape.center.y-self.sharePostcardLabel.height/2);
        [self addLabel:self.sharePostcardLabel];
        
        self.sharePostcardIcon=UA_ICON_SHARE_POSTCARD;
        self.sharePostcardIcon.width= 70;
        self.sharePostcardIcon.center=CGPointMake(self.sharePostcardShape.origin.x+self.sharePostcardIcon.width/2+5, self.sharePostcardShape.center.y);
        [self addImage:self.sharePostcardIcon];
        [self listenFor:@"touchesBegan" fromObjects:@[self.sharePostcardShape, self.sharePostcardLabel,self.sharePostcardIcon] andRunMethod:@"goToSharePostcard"];
        
        //--------------------------------------------------
        //ALPHABET INFO
        //--------------------------------------------------
        self.postcardInfoShape=[C4Shape rect:CGRectMake(sideMargin, self.height-(sideMargin*2+height*7+smallMargin*5), width, height)];
        self.postcardInfoShape.fillColor=UA_WHITE_COLOR;
        self.postcardInfoShape.lineWidth=0;
        [self addShape:self.postcardInfoShape];
        
        self.postcardInfoLabel=[C4Label labelWithText:@"Postcard info" font:UA_NORMAL_FONT];
        self.postcardInfoLabel.origin=CGPointMake(TextmarginFromLeft, self.postcardInfoShape.center.y-self.postcardInfoLabel.height/2);
        [self addLabel:self.postcardInfoLabel];
        
        self.postcardInfoIcon=UA_ICON_INFO;
        self.postcardInfoIcon.width= 38.676;
        self.postcardInfoIcon.center=CGPointMake(self.postcardInfoShape.origin.x+self.sharePostcardIcon.width/2+5, self.postcardInfoShape.center.y);
        [self addImage:self.postcardInfoIcon];
        [self listenFor:@"touchesBegan" fromObjects:@[self.postcardInfoShape, self.postcardInfoLabel,self.postcardInfoIcon] andRunMethod:@"goToPostcardInfo"];
        

    }
    return self;
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToMyAlphabets{
    C4Log(@"goToMyAlphabets");
    //[self postNotification:@"hidePostcardView"];
}
-(void)goToMyPostcards{
    C4Log(@"goToMyPostcards");
    //[self postNotification:@"hidePostcardView"];
}
-(void)goToWritePostcard{
    C4Log(@"goToWritePostcard");
    [self postNotification:@"hidePostcardView"];
    [self postNotification:@"goToWritePostcard"];
}

-(void)goToSharePostcard{
    C4Log(@"goToSharePostcard");
    //[self postNotification:@"hidePostcardView"];
}
-(void)goToPostcardInfo{
    C4Log(@"goToPostcardInfo");
    //[self postNotification:@"hidePostcardView"];
    //[self postNotification:@"goToPostcardInfo"];
}



@end
