
#import "C4CanvasController.h"
#import "TakePhoto.h"
#import "CropPhoto.h"
#import "AssignPhotoLetter.h"

@interface C4WorkSpace : C4CanvasController{
    //views
    TakePhoto *takePhoto;
    CropPhoto *cropPhoto;
    AssignPhotoLetter *assignPhoto;
    
    //default variables
    UIColor *navBarColorDefault;
    UIColor *navigationColorDefault;
    UIColor *buttonColorDefault;
    UIColor *typeColorDefault;
    UIColor *overlayColorDefault;
    UIColor *highlightColorDefault;
}
@end
