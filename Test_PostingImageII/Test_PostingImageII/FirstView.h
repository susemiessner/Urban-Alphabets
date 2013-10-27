#import "C4CanvasController.h"
#import "SecondView.h"

@interface FirstView : C4CanvasController{
    C4Label *goToSecondView;
}
@property (readwrite, strong) C4Window *mainCanvas;
@property (readwrite, strong) C4Image *postedImage;
@property (readwrite, strong) SecondView *secondView;
@end
