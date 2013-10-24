//
//  C4WorkSpace.h
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//

#import "C4CanvasController.h"
#import "TakePhoto.h"
#import "CropPhoto.h"
#import "AssignPhotoLetter.h"

@interface C4WorkSpace : C4CanvasController{
    //initial view
    TakePhoto *takePhoto;
    CropPhoto *cropPhoto;
    AssignPhotoLetter *assignPhoto;

}
@end
