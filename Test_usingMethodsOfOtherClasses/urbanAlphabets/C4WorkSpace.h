//
//  C4WorkSpace.h
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//

#import "C4CanvasController.h"
#import "TakePhoto.h"
#import "CropPhoto.h"

@interface C4WorkSpace : C4CanvasController{
    //views
    TakePhoto *takePhoto;
    CropPhoto *cropPhoto;
    
    //current view
    C4View *currentView;

}
@end
