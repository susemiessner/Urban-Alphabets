//
//  AlphabetView.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"
#import "AlphabetMenu.h"

@interface AlphabetView : C4CanvasController
@property (readwrite) int letterTouched;
@property (readwrite, strong) C4Image *currentAlphabetImage;
-(void )setup:(NSMutableArray*)passedAlphabet;

@end
