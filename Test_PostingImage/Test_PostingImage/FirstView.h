#import "C4CanvasController.h"
#import "SecondView.h"

@interface FirstView : C4CanvasController{
    C4Label *goToSecondView;
    C4Image *postedImage;
    SecondView *secondView;
}
@property (readwrite, strong) C4Window *mainCanvas;

@end

