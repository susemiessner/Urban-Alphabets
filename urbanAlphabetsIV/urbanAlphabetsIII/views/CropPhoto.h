//
//  CropPhoto.h
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface CropPhoto : C4CanvasController
@property (readwrite, strong) C4Image *croppedPhoto;

-(void)setup;
-(void)displayImage:(C4Image*)image;
@end
