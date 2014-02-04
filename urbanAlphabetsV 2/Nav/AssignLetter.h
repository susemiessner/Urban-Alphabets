//
//  AssignLetter.h
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"
#import "SaveToDatabase.h"

#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageDestination.h>

@interface AssignLetter : C4CanvasController<CLLocationManagerDelegate, NSURLConnectionDelegate>{
    SaveToDatabase *save;
}
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@property (readwrite) NSString *currentLanguage;
@property (readwrite) NSUInteger chosenImageNumberInArray;


-(void)setup:(UIImage*)croppedImagePassed;
-(void)grabCurrentAlphabetViaNavigationController;
@end
