//
//  AlphabetView.h
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"
#import <CoreLocation/CoreLocation.h>
#import "AlphabetInfo.h"


@interface AlphabetView : C4CanvasController<CLLocationManagerDelegate>
@property (readwrite, strong) C4Image *currentAlphabetImage;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@property (readwrite) int letterTouched;
-(void )setup:(NSMutableArray*)passedAlphabet ;
-(void)grabCurrentLanguageViaNavigationController;
-(void)redrawAlphabet;
@end
