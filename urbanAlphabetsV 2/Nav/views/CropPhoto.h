//
//  CropPhoto.h
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"

@interface CropPhoto : C4CanvasController
@property (readwrite, strong) UIImage *croppedPhoto;
@property (readwrite, strong) UIImageView *croppedPhotoView;
-(void)displayImage:(UIImage*)image;



@end
