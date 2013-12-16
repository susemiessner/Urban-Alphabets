//
//  CropPhoto.h
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"

@interface CropPhoto : C4CanvasController
@property (readwrite, strong) C4Image *croppedPhoto;

-(void)displayImage:(C4Image*)image;



@end
