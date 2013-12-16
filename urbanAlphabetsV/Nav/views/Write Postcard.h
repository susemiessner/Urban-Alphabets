//
//  Write Postcard.h
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"

@interface Write_Postcard : C4CanvasController<UITextViewDelegate>
@property (readwrite, strong) NSMutableArray *postcardArray, *greyRectArray, *currentAlphabet;
@property (readwrite)     NSString *entireText;
@property (readwrite) NSString *postcardText;

-(void)setupWithLanguage: (NSString*)passedLanguage Alphabet:(NSMutableArray*)passedAlphabet;
-(void)clearPostcard;
@end
