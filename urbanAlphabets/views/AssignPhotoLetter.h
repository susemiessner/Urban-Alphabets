

#import "C4CanvasController.h"

@interface AssignPhotoLetter : C4CanvasController{
    //common variables
    float TopBarFromTop;
    float TopNavBarHeight;
    float BottomNavBarHeight;
    
    UIColor *navBarColor;
    UIColor *buttonColor;
    UIColor *typeColor;
    UIColor *overlayColor;
    UIColor *navigationColor;
    UIColor *highlightColor;
    
    //view variable > which view is active = combining assign photoLetter and alphabets view into one (they are almost same anyways)
    NSString *whichView;
    
    
    //top rect
    C4Shape *defaultRect;
    
    //top toolbar
    C4Shape *topNavBar;
    C4Font *fatFont;
    C4Label *takePhoto;
    C4Font *normalFont;

    //>upper left
    C4Label *backLabel;
    C4Image *backButtonImage;
    C4Shape *navigateBackRect;
    //>upper right
    C4Image *closeButtonImage;
    C4Shape *closeRect;
    
    //bottom Toolbar
    //>for assign photo
    C4Shape *bottomNavBar;
    C4Image *okButtonImage;
    //>for AlphabetView
    C4Image *menuButtonImage;
    C4Image *photoButtonImage;
    
    
    //cropped image> lower left
    C4Image *croppedPhoto;
    
    //settings icon >lower right
    C4Image *settingsItem;
    
    
    //array of default letters
    NSMutableArray *defaultLetters;
    NSMutableArray *alphabetArray;
    
    //shapes to highllight the letter clicked
    NSMutableArray *gridRects;
    
    //makes sure that the "ok" button gets only added ones and not every time the person chooses a new letter
    int *notificationCounter;
    

}
@property (readwrite, strong) C4Window *mainCanvas;
-(void)setupAssignLetterDefaultBottomBarHeight: (float)bottomBarHeightDefault defaultNavBarHeight:(float)TopNavBarHeightDefault defaultTopBarFromTop: (float)TopBarFromTopDefault NavBarColor:(UIColor*)navBarColorDefault NavigationColor:(UIColor*)navigationColorDefault ButtonColor:(UIColor*)buttonColorDefault TypeColor:(UIColor*)typeColorDefault highlightColor:(UIColor*)highlightColorDefault;

@end
