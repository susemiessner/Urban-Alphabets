//
//  LetterView.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface LetterView : C4CanvasController

-(void)setupWithLetterNo: (int)chosenNumber currentAlphabet:(NSMutableArray*)passedAlphabet;
@end
