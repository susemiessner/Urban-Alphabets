//
//  AlphabetView.h
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AlphabetInfo.h"


@interface AlphabetView : UIViewController<CLLocationManagerDelegate>
@property (readwrite, strong) UIImage *currentAlphabetImage;
@property (readwrite, strong) UIImage *currentAlphabetImageAsUIImage;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@property (readwrite) int letterTouched;
-(void )setup:(NSMutableArray*)passedAlphabet ;
-(void)grabCurrentLanguageViaNavigationController;
-(void)redrawAlphabet;
-(void)goToMyAlphabets;
@end
