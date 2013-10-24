

#import "C4CanvasController.h"


@interface CropPhoto : C4CanvasController{
    //common variables
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    UIColor *overlayColor;
    UIColor *navigationColor;
    //top rect
    C4Shape *defaultRect;
    
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *cropPhoto;
    C4Font *normalFont;
    //>upper left
    C4Label *backLabel;
    C4Image *backButtonImage;
    C4Shape *navigateBackRect;
    //>upper right
    C4Image *closeButtonImage;
    C4Shape *closeRect;
    
    //bottom Toolbar
    C4Shape *bottomNavBar;
    C4Image *okButtonImage;
    
    //photo
    C4Image *photoTaken;
    C4Image *croppedPhoto;
    
    //overlay rectangles
    C4Shape *upperRect;
    C4Shape *lowerRect;
    C4Shape *leftRect;
    C4Shape *rightRect;
    
    //stepper to zoom
    C4Stepper *zoomStepper;
  
    
    //for saving that image
    CGSize *areaToSave;
    CGContextRef graphicsContext;
        
    //saving which one is the last view
    NSString *lastView;
}
@property (readwrite, strong) C4Window *mainCanvas;
-(void) setup;
-(void) sendPhoto:(C4Image*)image;
@end
