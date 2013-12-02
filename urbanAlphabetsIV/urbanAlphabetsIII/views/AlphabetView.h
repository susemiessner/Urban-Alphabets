//
//  AlphabetView.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"
#import "AlphabetMenu.h"
#import "SaveToDatabase.h"

@interface AlphabetView : C4CanvasController{
    SaveToDatabase *save;
}
@property (readwrite) int letterTouched;
@property (readwrite, strong) C4Image *currentAlphabetImage;
-(void )setup:(NSMutableArray*)passedAlphabet withGrid:(NSMutableArray*)greyGridArray withLanguage: (NSString*) language;

@end
