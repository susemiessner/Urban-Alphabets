//
//  PostcardView.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"
#import  "PostcardMenu.h"

@interface PostcardView : C4CanvasController
@property (readwrite, strong) C4Image *currentPostcardImage;
@property (readwrite)NSString *previousView;

-(void)setupWithPostcard: (NSMutableArray*)postcardPassed Rect: (NSMutableArray*)postcardRect;
@end
