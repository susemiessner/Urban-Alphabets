//
#import "C4CanvasController.h"
#import "FirstView.h"

@interface SecondView : C4CanvasController{
    C4Label *goToFirstView;
    C4Image *receivedImage;
}
@property (readwrite, strong) C4Window *mainCanvas;
-(void)receiveNumber:(C4Image*)number;
@end