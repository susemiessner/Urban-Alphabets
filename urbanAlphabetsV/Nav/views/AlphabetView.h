//
//  AlphabetView.h
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"

@interface AlphabetView : C4CanvasController
@property (readwrite, strong) C4Image *currentAlphabetImage;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;

-(void )setup:(NSMutableArray*)passedAlphabet ;
@end
