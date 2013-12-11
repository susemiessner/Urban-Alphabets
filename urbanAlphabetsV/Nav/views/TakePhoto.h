//
//  TakePhoto.h
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"

@interface TakePhoto : C4CanvasController
@property (readwrite, strong) C4Image *img;//the image captured
-(void)setup;
-(void)cameraSetup;
@end
