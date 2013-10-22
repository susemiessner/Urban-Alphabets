//
//  TakePhoto.m
//  cameraTest
//
//  Created by SuseMiessner on 10/18/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "TakePhoto.h"

@interface TakePhoto ()

@end

@implementation TakePhoto

-(void)setup{
    
    cam = [C4Camera cameraWithFrame:CGRectMake(0,0, self.canvas.width, self.canvas.height)];
    cam.cameraPosition = CAMERABACK;
    [self.canvas addCamera:cam];
    [cam initCapture];
    //tapping to take image
    [self addGesture:TAP name:@"capture" action:@"captureImage"];
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"putCapturedImageOnCanvas"];
}

-(void) captureImage{
    [cam captureImage];
    C4Log(@"capturing image");
}

-(void)putCapturedImageOnCanvas{
    
    C4Image *img = cam.capturedImage;
    img.width=240;
    //    img.center=CGPointMake(self.canvas.width*2/3, self.canvas.center.y);
    img.center = CGPointMake([C4Math randomInt:self.mainCanvas.width], [C4Math randomInt:self.mainCanvas.height]);
    [self.mainCanvas addImage:img];
    [self.mainCanvas bringSubviewToFront:self.canvas];
    C4Log(@"image captured");
}


@end
