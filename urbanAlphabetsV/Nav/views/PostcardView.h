//
//  PostcardView.h
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"

@interface PostcardView : C4CanvasController
@property (readwrite, strong) C4Image *currentPostcardImage;
@property (readwrite)NSString *previousView;
@property (readwrite)NSString *currentLanguage;
@property (readwrite)NSString *postcardText;
-(void)setupWithPostcard: (NSMutableArray*)postcardPassed Rect: (NSMutableArray*)postcardRect withLanguage:(NSString*)language withPostcardText:(NSString*)postcardText;
@end
