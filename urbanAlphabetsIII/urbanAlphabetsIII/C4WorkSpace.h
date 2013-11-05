//
//  C4WorkSpace.h
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//

#import "C4CanvasController.h"
#import "TakePhoto.h"
#import "CropPhoto.h"
#import "AssignLetter.h"


@interface C4WorkSpace : C4CanvasController{
    //views
    TakePhoto *takePhoto;
    CropPhoto *cropPhoto;
    AssignLetter *assignLetter;
    
    //full canvasRect
    CGRect fullCanvas;
}
@property (readwrite) NSMutableArray *currentAlphabet;
@property (readwrite) NSArray *defaultAlphabet;
@property (readwrite) NSString *currentLanguage;
@property (readwrite) NSString *oldLanguage;

@end
