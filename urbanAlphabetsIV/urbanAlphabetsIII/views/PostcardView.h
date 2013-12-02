//
//  PostcardView.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"
#import  "PostcardMenu.h"
#import "SaveToDatabase.h"

@interface PostcardView : C4CanvasController{
    SaveToDatabase *save;
}
@property (readwrite, strong) C4Image *currentPostcardImage;
@property (readwrite)NSString *previousView;
@property (readwrite)NSString *currentLanguage;
@property (readwrite)NSString *postcardText;
-(void)setupWithPostcard: (NSMutableArray*)postcardPassed Rect: (NSMutableArray*)postcardRect withLanguage:(NSString*)language withPostcardText:(NSString*)postcardText;
@end
