//
//  C4Defines.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-12.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef C4iOSDevelopment_C4Defines_h
#define C4iOSDevelopment_C4Defines_h

#if !defined(_C4AssertBody)
#define C4Assert(condition, desc, ...) \
do {			\
if (!(condition)) {	\
[[C4AssertionHandler currentHandler] handleFailureInMethod:_cmd \
object:self file:[NSString stringWithUTF8String:__FILE__] \
lineNumber:__LINE__ description:(desc), ##__VA_ARGS__]; \
}			\
} while(0)
#endif

/* NOT SUPPOSED TO USE #DEFINES, BUT HERE WE DON'T WANT PEOPLE TO CHANGE THE VALUE OF THESE VARIABLES */
#ifndef C4_DEFAULT_COLORS
#define C4RED (UIColor *)[UIColor colorWithRed:1.0f green:0.10f blue:0.10f alpha:1.0f]
#define C4BLUE (UIColor *)[UIColor colorWithRed:0.043f green:0.627f blue:0.902f alpha:1.0f]
#define C4GREY (UIColor *)[UIColor colorWithRed:0.196f green:0.216f blue:0.236f alpha:1.0f]
#endif

#ifndef C4_DEFAULT_FONTNAMES
#define SYSTEMFONTNAME [[UIFont systemFontOfSize:12.0f] fontName]
#define BOLDSYSTEMFONTNAME [[UIFont boldSystemFontOfSize:12.0f] fontName]
#define ITALICSYSTEMFONTNAME [[UIFont italicSystemFontOfSize:12.0f] fontName]
#endif

#ifndef C4_EXTERN
#define C4_EXTERN extern
#endif

//C4_EXTERN NSString *const EASEIN, *const EASEINOUT, *const EASEOUT, *const LINEAR, *const DEFAULT;

//---------------------------------------------------------------------
//UA Variables (start)
//---------------------------------------------------------------------
//COLORS
#define UA_NAV_BAR_COLOR    [UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1]
#define UA_NAV_CTRL_COLOR   [UIColor colorWithRed:0 green:0 blue:0 alpha:0]
#define UA_BUTTON_COLOR     [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1]
#define UA_TYPE_COLOR       [UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1]
#define UA_OVERLAY_COLOR    [UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5]
#define UA_HIGHLIGHT_COLOR  [UIColor colorWithRed:0.757 green:0.964 blue:0.617 alpha:0.5]
#define UA_DARKEN_COLOR     [UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.8]
#define UA_GREY_TYPE_COLOR  [UIColor colorWithRed:0.3984375 green:0.3984375 blue:0.3984375 alpha:1.0]
#define UA_WHITE_COLOR      [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]

//BAR HEIGTHS
#define UA_TOP_BAR_HEIGHT       40.0f
#define UA_TOP_WHITE            20.558f
#define UA_BOTTOM_BAR_HEIGHT    49.0f

// TYPE/FONTS
#define UA_FAT_FONT             [C4Font fontWithName:@"HelveticaNeue-Bold" size:17]
#define UA_NORMAL_FONT          [C4Font fontWithName:@"HelveticaNeue" size:17]

//Icons
#define UA_ICON_TAKE_PHOTO      [C4Image imageNamed:@"icon_TakePhoto"]
#define UA_ICON_CLOSE           [C4Image imageNamed:@"icon_Close"]
#define UA_ICON_BACK            [C4Image imageNamed:@"icon_back1"]
#define UA_ICON_OK              [C4Image imageNamed:@"icon_OK"]
#define UA_ICON_SETTINGS        [C4Image imageNamed:@"icon_Settings"]
#define UA_ICON_INFO            [C4Image imageNamed:@"icon_information"]
#define UA_ICON_SHARE_ALPHABET  [C4Image imageNamed:@"icon_ShareAlphabet"]
#define UA_ICON_SHARE_POSTCARD  [C4Image imageNamed:@"icon_SharePostcard"]
#define UA_ICON_SAVE            [C4Image imageNamed:@"icon_Save"]
#define UA_ICON_POSTCARD        [C4Image imageNamed:@"icon_Postcard"]
#define UA_ICON_MY_POSTCARDS    [C4Image imageNamed:@"icon_Postcards"]
#define UA_ICON_MY_ALPHABETS    [C4Image imageNamed:@"icon_Alphabets"]
#define UA_ICON_MENU            [C4Image imageNamed:@"icon_Menu"]
#define UA_ICON_ARROW_FORWARD   [C4Image imageNamed:@"icon_ArrowForward"]
#define UA_ICON_ARROW_BACKWARD  [C4Image imageNamed:@"icon_ArrowBack"]
#define UA_ICON_ALPHABET        [C4Image imageNamed:@"icon_Alphabet"]
#define UA_ICON_CHECKED         [C4Image imageNamed:@"icon_checked"]
#define UA_ICON_PHOTOLIBRARY    [C4Image imageNamed:@"icon_PhotoLibrary"]

#define UA_LETTER_EMPTY         [C4Image imageNamed:@"letter_empty"]


//---------------------------------------------------------------------
//UA Variables (end)
//---------------------------------------------------------------------

C4_EXTERN const CGFloat FOREVER;

C4_EXTERN BOOL VERBOSELOAD;

/* more lexical names for common mathematic variables, e.g. QUARTER_PI instead of M_PI_4 */
C4_EXTERN const CGFloat QUARTER_PI, HALF_PI, PI, TWO_PI, ONE_OVER_PI, TWO_OVER_PI, TWO_OVER_ROOT_PI, E, LOG2E, LOG10E, LN2, LN10, SQRT_TWO, SQRT_ONE_OVER_TWO;

typedef enum C4AnimationOptions : NSUInteger {
    
    ALLOWSINTERACTION = UIViewAnimationOptionAllowUserInteraction,
    BEGINCURRENT = UIViewAnimationOptionBeginFromCurrentState,
    REPEAT = UIViewAnimationOptionRepeat,
    AUTOREVERSE = UIViewAnimationOptionAutoreverse,
//    UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5,
//    UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6,
//    UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7,
//    UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8,
//    
//    UIViewAnimationOptionCurveEaseInOut            = 0 << 16,
//    UIViewAnimationOptionCurveEaseIn               = 1 << 16,
//    UIViewAnimationOptionCurveEaseOut              = 2 << 16,
//    UIViewAnimationOptionCurveLinear               = 3 << 16,
    EASEINOUT            = UIViewAnimationOptionCurveEaseInOut,
    EASEIN               = UIViewAnimationOptionCurveEaseIn,
    EASEOUT              = UIViewAnimationOptionCurveEaseOut,
    LINEAR               = UIViewAnimationOptionCurveLinear,
//    
//    UIViewAnimationOptionTransitionNone            = 0 << 20,
//    UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
//    UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
//    UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
//    UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
//    UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
//    UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
//    UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
    DEFAULT = 0 | UIViewAnimationOptionBeginFromCurrentState,
} C4AnimationOptions;


typedef enum C4ShapeLayerAnimationType : NSUInteger {
    PATH = 0,
    FILLCOLOR,
    LINEDASHPHASE,
    LINEWIDTH,
    MITRELIMIT,
    STROKECOLOR,
    STROKEEND,
    STROKESTART
} C4ShapeLayerAnimationType;

typedef enum C4LineBreakMode : NSUInteger {
    LABELWORDWRAP = 0,
    LABELCHARWRAP,
    LABELCLIP,
    LABELTRUNCATEHEAD,
    LABELTRUNCATETAIL,
    LABELTRUNCATEMIDDLE
} C4LineBreakMode;

C4_EXTERN NSString * const TRUNCATENONE;
C4_EXTERN NSString * const TRUNCATESTART;
C4_EXTERN NSString * const TRUNCATEEND;
C4_EXTERN NSString * const TRUNCATEMIDDLE;

/* Alignment modes. */

C4_EXTERN NSString * const ALIGNNATURAL;
C4_EXTERN NSString * const ALIGNLEFT;
C4_EXTERN NSString * const ALIGNRIGHT;
C4_EXTERN NSString * const ALIGNCENTER;
C4_EXTERN NSString * const ALIGNJUSTIFIED;

typedef enum C4TextAlignment : NSUInteger {
    ALIGNTEXTLEFT = 0,
    ALIGNTEXTCENTER,
    ALIGNTEXTRIGHT
} C4TextAlignment;

typedef enum C4BaselineAdjustment : NSUInteger {
    ALIGNBASELINES = UIBaselineAdjustmentAlignBaselines, 
    ALIGNBASELINECENTERS = UIBaselineAdjustmentAlignCenters, 
    ALIGNBASELINENONE = UIBaselineAdjustmentNone
} C4BaselineAdjustment;

typedef enum C4ControlEvents : NSUInteger {
    TOUCHDOWN           = 1 <<  0,      // on all touch downs
    TOUCHDOWNREPEAT     = 1 <<  1,      // on multiple touchdowns (tap count > 1)
    TOUCHDOWNDRAGINSIDE     = 1 <<  2,
    TOUCHDOWNDRAGOUTSIDE    = 1 <<  3,
    TOUCHDOWNDRAGENTER      = 1 <<  4,
    TOUCHDOWNDRAGEXIT       = 1 <<  5,
    TOUCHUPINSIDE       = 1 <<  6,
    TOUCHUPOUTSIDE      = 1 <<  7,
    TOUCHCANCEL         = 1 <<  8,
    
    VALUECHANGED        = 1 << 12,     // sliders, etc.
    
    EDITINGDIDBEGIN     = 1 << 16,     // UITextField
    EDITINGCHANGED      = 1 << 17,
    EDITINGDIDEND       = 1 << 18,
    EDITINGDIDENDONEXIT = 1 << 19,     // 'return key' ending editing
    
    ALLTOUCHEVENTS      = 0x00000FFF,  // for touch events
    ALLEDITINGEVENTS    = 0x000F0000,  // for UITextField
} C4ControlEvents;


typedef enum C4ButtonType : NSUInteger{
    CUSTOM = 0,
    ROUNDEDRECT,
    DETAILDISCLOSURE,
    INFOLIGHT,
    INFODARK,
    CONTACTADD,
} C4ButtonType;


typedef enum C4ControlState : NSUInteger {
    NORMAL       = UIControlStateNormal,
    HIGHLIGHTED  = 1 << 0,
    DISABLED     = 1 << 1,
    SELECTED     = 1 << 2
} C4ControlState;

typedef enum C4ControlContentHorizontalAlignment : NSUInteger {
    HORIZONTALCENTER = 0,
    HORIZONTALLEFT,
    HORIZONTALRIGHT,
    HORIZONTALFILL
} C4ControlContentHorizontalAlignment;

typedef enum C4ControlContentVerticalAlignment : NSUInteger {
    VERTICALCENTER = 0,
    VERTICALLEFT,
    VERTICALRIGHT,
    VERTICALFILL
} C4ControlContentVerticalAlignment;

/* `cameraPosition` values. */
typedef enum C4CameraPosition : NSUInteger {
    CAMERAUNSPECIFIED = 0,
    CAMERABACK,
    CAMERAFRONT
} C4CameraPosition;

/* 'scrollView' */

typedef enum C4ScrollViewIndicatorStyle : NSUInteger {
    INDICATORDEFAULT = 0,
    INDICATORBLACK,
    INDICATORWHITE
} C4ScrollViewIndicatorStyle;

C4_EXTERN const CGFloat DECELERATENORMAL;
C4_EXTERN const CGFloat DECELERATEFAST;
C4_EXTERN const CGFloat DECELERATEMEDIUM;

/* `fillRule' values. */

C4_EXTERN NSString *const FILLNORMAL
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);
C4_EXTERN NSString *const FILLEVENODD
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);

/* `lineJoin' values. */

C4_EXTERN NSString *const JOINMITER
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);
C4_EXTERN NSString *const JOINROUND
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);
C4_EXTERN NSString *const JOINBEVEL
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);

/* `lineCap' values. */

C4_EXTERN NSString *const CAPBUTT
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);
C4_EXTERN NSString *const CAPROUND
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);
C4_EXTERN NSString *const CAPSQUARE
__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);

/* `videoGravity' values. */

C4_EXTERN NSString *const RESIZEASPECT NS_AVAILABLE(10_7, 4_0);
C4_EXTERN NSString *const RESIZEFILL NS_AVAILABLE(10_7, 4_0);
C4_EXTERN NSString *const RESIZEFRAME NS_AVAILABLE(10_7, 4_0);

/* 'camera quality' values */
C4_EXTERN NSString *const C4CameraQualityPhoto;     //high resolution photo quality
C4_EXTERN NSString *const C4CameraQualityHigh;      //high quality video and audio output
C4_EXTERN NSString *const C4CameraQualityMedium;    //video and audio bitrates suitable for sharing over WiFi
C4_EXTERN NSString *const C4CameraQualityLow;       //video and audio bitrates suitable for sharing over 3G
C4_EXTERN NSString *const C4CameraQuality352x288;   //CIF quality (352x288 pixel) video output
C4_EXTERN NSString *const C4CameraQuality640x480;   //VGA quality (640x480 pixel) video output
C4_EXTERN NSString *const C4CameraQuality1280x720;  //720p quality (1280x720 pixel) video output
C4_EXTERN NSString *const C4CameraQuality1920x1080; //1080p quality (1920x1080 pixel) video output
C4_EXTERN NSString *const C4CameraQualityiFrame960x540;   //iFrame H.264 video at about 30 Mbits/sec with AAC audio
C4_EXTERN NSString *const C4CameraQualityiFrame1280x720;  //iFrame H.264 video at about 40 Mbits/sec with AAC audio

#endif
