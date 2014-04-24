//
//  SaveToDatabase.h
//  urbanAlphabetsIV
//
//  Created by Suse on 18/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "C4WorkSpace.h"

@interface SaveToDatabase : NSObject {
    NSString *path;
    NSString *longitude;
    NSString *latitude;
    NSString *owner;
    NSString *letter;
    NSString *postcard;
    NSString *alphabet;
    NSString *language;
    NSString *postcardText;
    NSNumber *letterNumberInArray;
    CLLocation *currentLocation;
    NSMutableURLRequest *request;
    
    NSData *imageToSend;
    NSData *theImage;
    C4WorkSpace *workspace;
}
//languages
@property (readwrite)NSArray *finnish;
@property (readwrite)NSArray *german;
@property(readwrite)NSArray *danish;
@property(readwrite)NSArray *english;
@property (readwrite)NSArray *spanish;
@property (readwrite)NSArray *russian;
@property (readwrite)NSArray *latvian;


-(void)sendLetterToDatabase: (CLLocation*)currentLocation ImageNo:(NSUInteger)chosenImageNumberInArray Image:(UIImage*)croppedImage Language:(NSString*)theLanguage Username:(NSString*)userName;
-(void)sendAlphabetToDatabase:(NSData*)imageData withLanguage: (NSString*)theLanguage withLocation:(CLLocation*)theLocation withUsername:(NSString*)userName;
-(void)sendPostcardToDatabase:(NSData*)imageData withLanguage: (NSString*)theLanguage withText: (NSString*)thePostcardText withLocation:(CLLocation*)currentLocation withUsername:(NSString*)userName;
@end
