//
//  TakePhoto.h
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//  Copyright (c) 2013 SuseMiessner. All rights reserved.
//

#import "C4CanvasController.h"
#import "C4WorkSpace.h"
#import "CropPhoto.h"

@interface TakePhoto : C4CanvasController{

    
    //common variables
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    
        
    //main canvas variable to access it's function
   // C4WorkSpace *mainWorkspace;
    CropPhoto *cropPhoto;
    C4Image *photoButtonImage;
    
}
@property (readwrite, strong) C4Window *mainCanvas;

@end
