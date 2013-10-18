//
//  TakePhoto.h
//  cameraTest
//
//  Created by SuseMiessner on 10/18/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "C4CanvasController.h"

@interface TakePhoto : C4CanvasController{
    //camera
    C4Camera *cam;
}
@property (readwrite, strong) C4Window *mainCanvas;

@end
