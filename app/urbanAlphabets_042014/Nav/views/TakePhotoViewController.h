//
//  TakePhotoViewController.h
//  UAlphabets
//
//  Created by Suse on 05/04/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhotoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
// camera views and layers
@property (nonatomic, strong) UIView *previewLayerHostView;
@property (nonatomic, strong) AVCaptureSession *avSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *avSnapper;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *avPreviewLayer;
@property (nonatomic, strong) CALayer *stillLayer;

@property (nonatomic, assign) bool isPhotoBeingTaken;
@property (nonatomic, assign) bool isCameraAlreadySetup;
@property (readwrite, strong) UIImage *img;//the image captured

-(void)setup;
-(void)take;
-(void)snapshot;
-(void)cameraPrepareToRetake;
-(void)imageSelected;
@end
