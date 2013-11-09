//
//  WritePostcard.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface WritePostcard : C4CanvasController<UITextViewDelegate>
@property (readwrite, strong) NSMutableArray *postcardArray, *greyRectArray, *currentAlphabet;
@property (readwrite)     NSString *entireText;

-(void)setupWithLanguage: (NSString*)passedLanguage Alphabet:(NSMutableArray*)passedAlphabet ;
@end
