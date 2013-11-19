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
#import "AlphabetView.h"
#import "LetterView.h"
#import "AlphabetInfo.h"
#import "ChangeLanguage.h"
#import "WritePostcard.h"
#import "PostcardView.h"

#import "SaveToDatabase.h"


@interface C4WorkSpace : C4CanvasController{
    //views
    TakePhoto       *takePhoto;
    CropPhoto       *cropPhoto;
    AssignLetter    *assignLetter;
    AlphabetView    *alphabetView;
    LetterView      *letterView;
    AlphabetInfo    *alphabetInfo;
    ChangeLanguage  *changeLanguage;
    WritePostcard   *writePostcard;
    PostcardView    *postcardView;
    
    //full canvasRect
    CGRect fullCanvas;
    NSMutableArray *greyRectArray;
}
@property (readwrite) NSMutableArray *currentAlphabet;
@property (readwrite) NSArray *defaultAlphabet;
@property (readwrite) NSString *currentLanguage;
@property (readwrite) NSString *oldLanguage;
@property (readwrite) NSString *previousView;

@end
