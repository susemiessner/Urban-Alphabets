//
//  PostcardView.h
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"
#import <CoreLocation/CoreLocation.h>

@interface PostcardView : UIViewController<CLLocationManagerDelegate>
@property (readwrite, strong) UIImage *currentPostcardImage;
@property (readwrite, strong) UIImage *currentPostcardImageAsUIImage;
@property (readwrite)NSString *previousView;
@property (readwrite)NSString *currentLanguage;
@property (readwrite)NSString *postcardText;
-(void)setupWithPostcard: (NSMutableArray*)postcardPassed Rect: (NSMutableArray*)postcardRect withLanguage:(NSString*)language withPostcardText:(NSString*)postcardText;
@end
