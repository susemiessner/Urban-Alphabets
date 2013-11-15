//
//  saveToDatabase.h
//  urbanAlphabetsIV
//
//  Created by Suse on 15/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface saveToDatabase : NSObject<NSURLConnectionDelegate>
-(void)saveToDatabaseWithLocation:(CLLocation *)currentLocation ImageNumber:(int)chosenImageNumberInArray Image:(C4Image*)croppedImage;

@end
