//
//  TakePhoto.h
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"
#import "TopNavBar.h"
#import "BottomNavBar.h"

@interface TakePhoto : C4CanvasController{
    C4Camera *cam;
    NSInteger counter;
}
@property (readwrite, strong) C4Image *img;//the image captured
@property (readwrite)NSString *previousView;
-(void)setupWithPreviousView;
-(void)cameraSetup;
@end
