//
//  AlphabetView.m
//  urbanAlphabetsII
//
//  Created by Suse on 28/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AlphabetView.h"

@interface AlphabetView ()

@end

@implementation AlphabetView
-(void)transferVaribles:(int)number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault darkenColor:(UIColor*)darkenColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault iconClose:(C4Image*)iconCloseDefault iconBack:(C4Image*)iconBackDefault iconMenu:(C4Image*)iconMenuDefault iconTakePhoto:(C4Image*)iconTakePhotoDefault iconAlphabetInfo:(C4Image*)iconAlphabetInfoDefault iconShareAlphabet:(C4Image*)iconShareAlphabetDefault iconWritePostcard:(C4Image*)iconWritePostcardDefault iconMyPostcards:(C4Image*)iconMyPostcardsDefault iconMyAlphabets:(C4Image*)iconMyAlphabetsDefault iconSaveImage:(C4Image*)iconSaveAlphabetDefault currentAlphabet: (NSMutableArray*)defaultAlphabet{

    //nav bar heights
    topBarFromTop=TopBarFromTopDefault;
    topBarHeight=TopNavBarHeightDefault;
    bottomBarHeight=BottomBarHeightDefault;
    
    //colors
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    typeColor=typeColorDefault;
    darkenColor=darkenColorDefault;
    whiteColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    //fonts
    fatFont=fatFontDefault;
    normalFont=normalFontDefault;
    
    //icons
    iconClose=iconCloseDefault;
    iconBack=iconBackDefault;
    iconMenu=iconMenuDefault;
    iconTakePhoto=iconTakePhotoDefault;
    iconAlphabetInfo=iconAlphabetInfoDefault;
    iconShareAlphabet=iconShareAlphabetDefault;
    iconWritePostcard=iconWritePostcardDefault;
    iconMyPostcards=iconMyPostcardsDefault;
    iconMyAlphabets=iconMyAlphabetsDefault;
    iconSaveAlphabet=iconSaveAlphabetDefault;
    
    currentAlphabet=defaultAlphabet;
}
-(void)setup{
    [self topBarSetup];
    [self bottomBarSetup];
    [self greyGrid];
}
-(void)topBarSetup{
    //--------------------
    //white rect under top bar
    //--------------------
    defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, topBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    
    //--------------------
    //top bar
    //--------------------
    topNavBar=[C4Shape rect:CGRectMake(0, topBarFromTop, self.canvas.width, topBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    //title in center
    titleLabel = [C4Label labelWithText:@"Untitled" font:fatFont];
    titleLabel.center=topNavBar.center;
    [self.canvas addLabel:titleLabel];
    
    //--------------------
    //LEFT
    //--------------------
    //back text
    backLabel=[C4Label labelWithText:@"Back" font: normalFont];
    backLabel.center=CGPointMake(40, topNavBar.center.y);
    [self.canvas addLabel:backLabel];
    
    //back icon
    backButtonImage=iconBack;
    backButtonImage.width= 12.2;
    backButtonImage.center=CGPointMake(10, topNavBar.center.y);
    [self.canvas addImage:backButtonImage];
    
    //invisible rect for navigation
    navigateBackRect=[C4Shape rect: CGRectMake(0, topBarFromTop, 60, topNavBar.height)];
    navigateBackRect.fillColor=navigationColor;
    navigateBackRect.lineWidth=0;
    [self.canvas addShape:navigateBackRect];
    [self listenFor:@"touchesBegan" fromObject:navigateBackRect andRunMethod:@"navigateBack"];
    
    //test navigation towards take photo
    takePhoto=[C4Label labelWithText:@"take Photo" font: normalFont];
    takePhoto.center=CGPointMake(self.canvas.width-(takePhoto.width/2+5), topNavBar.center.y);
    [self.canvas addLabel:takePhoto ];
    [self listenFor:@"touchesBegan" fromObject:takePhoto andRunMethod:@"goToTakePhoto"];

}
-(void)bottomBarSetup{
    //--------------------------------------------------
    //underlying rect
    //--------------------------------------------------
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(bottomBarHeight), self.canvas.width, bottomBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];
    
    //--------------------------------------------------
    //menu button in center
    //--------------------------------------------------
    menuButtonImage=iconMenu;
    menuButtonImage.width=45;
    menuButtonImage.center=bottomNavBar.center;
    [self.canvas addImage:menuButtonImage];
    [self listenFor:@"touchesBegan" fromObject:menuButtonImage andRunMethod:@"openMenu"];
    
    //--------------------------------------------------
    //TakePhotoButton on the left
    //--------------------------------------------------
    takePhotoButton=iconTakePhoto;
    takePhotoButton.width=60;
    takePhotoButton.center=CGPointMake(takePhotoButton.width/2+5, bottomNavBar.center.y);
    [self.canvas addImage:takePhotoButton];
    [self listenFor:@"touchesBegan" fromObject:takePhotoButton andRunMethod:@"goToTakePhoto"];
}
-(void)drawCurrentAlphabet: (NSMutableArray*)passedAlphabet{
    
    currentAlphabet=[passedAlphabet mutableCopy];
    C4Log(@"currentAlphabetLength: %i", [currentAlphabet count]);
    
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (NSUInteger i=0; i<[currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=2+topBarFromTop+topBarHeight+yMultiplier*imageHeight;
        C4Image *image=[currentAlphabet objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        [self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"letterTapped:"];
    }
    /*
    //saving the current alphabet as an image (for saving if needed)
    
    CGFloat scale = 5.0;
    
    //begin an image context
    CGSize  rect=CGSizeMake(self.canvas.width, self.canvas.height);
    UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
    
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    
    //render the original image into the context
    [self.canvas renderInContext:c];
    
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end the image context
    UIGraphicsEndImageContext();
    
    //create a new C4Image
    self.currentAlphabetImage = [C4Image imageWithUIImage:newUIImage];
    C4Log(@"self.currentAlphabetImage:%@", self.currentAlphabetImage);
    self.currentAlphabetImage.width=self.canvas.width/2;
    self.currentAlphabetImage.center=self.canvas.center;
    self.currentAlphabetImage.backgroundColor=navBarColor;
    [self.canvas addImage:self.currentAlphabetImage];
    */
    
}
-(void)letterTapped:(NSNotification *)notification {
    //get the current object
    C4Image *currentImage = (C4Image *)notification.object;
    //
    CGPoint chosenImage=CGPointMake(currentImage.origin.x, currentImage.origin.y);
    //figure out which letter was pressed
    float imageWidth=53.53;
    float imageHeight=65.1;
    float i=chosenImage.x/imageWidth;
    //C4Log(@"i:%i", i);
    float j=chosenImage.y/imageHeight;
    //C4Log(@"j:%i", j);
    
    self.LetterTouched=((j-1)*6)+i;

    
    [self openLetterView];
    
}

-(void)greyGrid{
    float imageWidth=53.53;
    float imageHeight=65.1;
    greyRectArray=[[NSMutableArray alloc]init];
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i
                           )%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=2+topBarFromTop+topBarHeight+yMultiplier*imageHeight;
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=navigationColor;
        greyRect.lineWidth=2;
        greyRect.strokeColor=navBarColor;
        [greyRectArray addObject:greyRect];
        [self.canvas addShape:greyRect];
    }
    //C4Log(@"greyRect Array length:%i",[greyRectArray count]);
}
-(void)removeFromView{
    [defaultRect removeFromSuperview];
    [topNavBar removeFromSuperview];
    [titleLabel removeFromSuperview];
    
    [backLabel removeFromSuperview];
    [backButtonImage removeFromSuperview];
    [navigateBackRect removeFromSuperview];
    
    [bottomNavBar removeFromSuperview];
    [menuButtonImage removeFromSuperview];
    [takePhotoButton removeFromSuperview];
    
    for (int i=0; i<[currentAlphabet count]; i++) {
        C4Image *image=[currentAlphabet objectAtIndex:i];
        [image removeFromSuperview];
        
    }
    for (int i=0; i<[greyRectArray count]; i++) {
        C4Shape *shape=[greyRectArray objectAtIndex:i];
        [shape removeFromSuperview];
    }
    
    //test label
    [takePhoto removeFromSuperview];


}
-(void)setupMenu{
    float sideMargin=8.2;
    float smallMargin=1.0;
    float width=self.canvas.width-2*sideMargin;
    float height=42.45;
    float TextmarginFromLeft=103.11;
    
    //menu background
    menuBackground=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, self.canvas.height)];
    menuBackground.fillColor=darkenColor;
    menuBackground.lineWidth=0;
    [self.canvas addShape:menuBackground];
    
    //--------------------------------------------------
    //CANCEL
    //--------------------------------------------------
    //cancelShape
    cancelShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin+height), width, height)];
    cancelShape.fillColor=whiteColor;
    cancelShape.lineWidth=0;
    [self.canvas addShape:cancelShape];
    [self listenFor:@"touchesBegan" fromObject:cancelShape andRunMethod:@"closeMenu"];
    
    //cancel Label
    cancelLabel=[C4Label labelWithText:@"Cancel" font:fatFont];
    cancelLabel.center=cancelShape.center;
    [self.canvas addLabel:cancelLabel];
    [self listenFor:@"touchesBegan" fromObject:cancelLabel andRunMethod:@"closeMenu"];
    
    //--------------------------------------------------
    //MY ALPHABETS
    //--------------------------------------------------
    //shape
    myAlphabetsShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*2), width, height)];
    myAlphabetsShape.fillColor=whiteColor;
    myAlphabetsShape.lineWidth=0;
    [self.canvas addShape:myAlphabetsShape];
    
    //label
    myAlphabetsLabel=[C4Label labelWithText:@"My Alphabets" font:normalFont];
    myAlphabetsLabel.origin=CGPointMake(TextmarginFromLeft, myAlphabetsShape.center.y-myAlphabetsLabel.height/2);
    [self.canvas addLabel:myAlphabetsLabel];
    
    //image
    myAlphabetsIcon=iconMyAlphabets;
    myAlphabetsIcon.width= 70;
    myAlphabetsIcon.center=CGPointMake(myAlphabetsShape.origin.x+myAlphabetsIcon.width/2+5, myAlphabetsShape.center.y);
    [self.canvas addImage:myAlphabetsIcon];
    
    [self listenFor:@"touchesBegan" fromObjects:@[myAlphabetsShape, myAlphabetsLabel,myAlphabetsIcon] andRunMethod:@"goToMyAlphabets"];
    
    
    //--------------------------------------------------
    //MY Postcards
    //--------------------------------------------------
    myPostcardsShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*3+smallMargin), width, height)];
    myPostcardsShape.fillColor=whiteColor;
    myPostcardsShape.lineWidth=0;
    [self.canvas addShape:myPostcardsShape];
    
    myPostcardsLabel=[C4Label labelWithText:@"My Postcards" font:normalFont];
    myPostcardsLabel.origin=CGPointMake(TextmarginFromLeft, myPostcardsShape.center.y-myPostcardsLabel.height/2);
    [self.canvas addLabel:myPostcardsLabel];
    
    myPostcardsIcon=iconMyPostcards;
    myPostcardsIcon.width= 70;
    myPostcardsIcon.center=CGPointMake(myPostcardsShape.origin.x+myPostcardsIcon.width/2+5, myPostcardsShape.center.y);
    [self.canvas addImage:myPostcardsIcon];
    [self listenFor:@"touchesBegan" fromObjects:@[myPostcardsShape, myPostcardsLabel,myPostcardsIcon] andRunMethod:@"goToMyPostcards"];
    
    //--------------------------------------------------
    //WRITE POSTCARD
    //--------------------------------------------------
    writePostcardShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*4+smallMargin*2), width, height)];
    writePostcardShape.fillColor=whiteColor;
    writePostcardShape.lineWidth=0;
    [self.canvas addShape:writePostcardShape];
    
    writePostcardLabel=[C4Label labelWithText:@"Write Postcard" font:normalFont];
    writePostcardLabel.origin=CGPointMake(TextmarginFromLeft, writePostcardShape.center.y-writePostcardLabel.height/2);
    [self.canvas addLabel:writePostcardLabel];
    
    writePostcardIcon=iconWritePostcard;
    writePostcardIcon.width= 70;
    writePostcardIcon.center=CGPointMake(writePostcardShape.origin.x+writePostcardIcon.width/2+5, writePostcardShape.center.y);
    [self.canvas addImage:writePostcardIcon];
    [self listenFor:@"touchesBegan" fromObjects:@[writePostcardShape, writePostcardLabel,writePostcardIcon] andRunMethod:@"goToWritePostcard"];
    //--------------------------------------------------
    //SAVE ALPHABET
    //--------------------------------------------------
    saveAlphabetShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*5+smallMargin*3), width, height)];
    saveAlphabetShape.fillColor=whiteColor;
    saveAlphabetShape.lineWidth=0;
    [self.canvas addShape:saveAlphabetShape];
    
    saveAlphabetLabel=[C4Label labelWithText:@"Save Alphabet" font:normalFont];
    saveAlphabetLabel.origin=CGPointMake(TextmarginFromLeft, saveAlphabetShape.center.y-saveAlphabetLabel.height/2);
    [self.canvas addLabel:saveAlphabetLabel];
    
    saveAlphabetIcon=iconSaveAlphabet;
    saveAlphabetIcon.width= 40;
    saveAlphabetIcon.center=CGPointMake(saveAlphabetShape.origin.x+writePostcardIcon.width/2+5, saveAlphabetShape.center.y);
    [self.canvas addImage:saveAlphabetIcon];
    
    [self listenFor:@"touchesBegan" fromObjects:@[saveAlphabetShape, saveAlphabetLabel,saveAlphabetIcon] andRunMethod:@"goToSaveAlphabet"];
    //--------------------------------------------------
    //SHARE ALPHABET
    //--------------------------------------------------
    shareAlphabetShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*6+smallMargin*4), width, height)];
    shareAlphabetShape.fillColor=whiteColor;
    shareAlphabetShape.lineWidth=0;
    [self.canvas addShape:shareAlphabetShape];
    
    shareAlphabetLabel=[C4Label labelWithText:@"Share Alphabet" font:normalFont];
    shareAlphabetLabel.origin=CGPointMake(TextmarginFromLeft, shareAlphabetShape.center.y-shareAlphabetLabel.height/2);
    [self.canvas addLabel:shareAlphabetLabel];
    
    shareAlphabetIcon=iconShareAlphabet;
    shareAlphabetIcon.width= 70;
    shareAlphabetIcon.center=CGPointMake(shareAlphabetShape.origin.x+shareAlphabetIcon.width/2+5, shareAlphabetShape.center.y);
    [self.canvas addImage:shareAlphabetIcon];
    [self listenFor:@"touchesBegan" fromObjects:@[shareAlphabetShape, shareAlphabetLabel,shareAlphabetIcon] andRunMethod:@"goToShareAlphabet"];
    //--------------------------------------------------
    //ALPHABET INFO
    //--------------------------------------------------
    alphabetInfoShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*7+smallMargin*5), width, height)];
    alphabetInfoShape.fillColor=whiteColor;
    alphabetInfoShape.lineWidth=0;
    [self.canvas addShape:alphabetInfoShape];
    
    alphabetInfoLabel=[C4Label labelWithText:@"Alphabet info" font:normalFont];
    alphabetInfoLabel.origin=CGPointMake(TextmarginFromLeft, alphabetInfoShape.center.y-alphabetInfoLabel.height/2);
    [self.canvas addLabel:alphabetInfoLabel];
    
    alphabetInfoIcon=iconAlphabetInfo;
    alphabetInfoIcon.width= 38.676;
    alphabetInfoIcon.center=CGPointMake(alphabetInfoShape.origin.x+shareAlphabetIcon.width/2+5, alphabetInfoShape.center.y);
    [self.canvas addImage:alphabetInfoIcon];
    [self listenFor:@"touchesBegan" fromObjects:@[alphabetInfoShape, alphabetInfoLabel,alphabetInfoIcon] andRunMethod:@"goToAlphabetInfo"];

}

-(void)saveAlphabet{
    [self exportHighResImage];
}
//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
-(void)exportHighResImage {
   graphicsContext = [self createHighResImageContext];
   [self.canvas renderInContext:graphicsContext];
    NSString *fileName = [NSString stringWithFormat:@"exportedAlphabet%@.jpg", [NSDate date]];
    //C4Log(@"%@",s );
    
    [self saveImage:fileName];
    [self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(self.canvas.frame.size, YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *savePath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
}
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}
-(void)saveImageToLibrary {
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

-(C4Image *)cropImage:(C4Window *)originalImage toArea:(CGRect)rect{
    //grab the image scale
    CGFloat scale = 1.0;
    
    //begin an image context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //shift BACKWARDS in both directions because this moves the image
    //the area to crop shifts INTO: (0, 0, rect.size.width, rect.size.height)
    CGContextTranslateCTM(c, -rect.origin.x, -rect.origin.y);
    
    //render the original image into the context
    [originalImage renderInContext:c];
    
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end the image context
    UIGraphicsEndImageContext();
    
    //create a new C4Image
    C4Image *newImage = [C4Image imageWithUIImage:newUIImage];
    
    //return the new image
    return newImage;
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)openMenu{
    C4Log(@"openMenu");
    [self setupMenu];
}
-(void)closeMenu{
    C4Log(@"close Menu");
    [menuBackground removeFromSuperview];
    [cancelShape removeFromSuperview];
    [cancelLabel removeFromSuperview];
    [myAlphabetsShape removeFromSuperview];
    [myAlphabetsLabel removeFromSuperview];
    [myAlphabetsIcon removeFromSuperview];
    [myPostcardsShape removeFromSuperview];
    [myPostcardsLabel removeFromSuperview];
    [myPostcardsIcon removeFromSuperview];
    [writePostcardShape removeFromSuperview];
    [writePostcardLabel removeFromSuperview];
    [writePostcardIcon removeFromSuperview];
    [saveAlphabetShape removeFromSuperview];
    [saveAlphabetLabel removeFromSuperview];
    [saveAlphabetIcon removeFromSuperview];
    [shareAlphabetShape removeFromSuperview];
    [shareAlphabetLabel removeFromSuperview];
    [shareAlphabetIcon removeFromSuperview];
    [alphabetInfoShape removeFromSuperview];
    [alphabetInfoLabel removeFromSuperview];
    [alphabetInfoIcon removeFromSuperview];
}

-(void) navigateBack{
    C4Log(@"navigating back");
    [self removeFromView];
    [self closeMenu];
    [self postNotification:@"navigatingBackBetweenAlphabet+AssignLetter"];
}
-(void) goToTakePhoto{
    C4Log(@"goToTakePhoto");
    [self removeFromView];
    [self closeMenu];
    [self postNotification:@"goToTakePhoto"];
}
-(void)openLetterView{
    C4Log(@"open LetterView");
    [self removeFromView];
    [self closeMenu];
    [self postNotification:@"goToLetterView"];
}
-(void)goToMyAlphabets{
    C4Log(@"goToMyAlphabets");
    [self removeFromView];
    [self closeMenu];

}
-(void)goToMyPostcards{
    C4Log(@"goToMyPostcards");
    [self removeFromView];
    [self closeMenu];

}
-(void)goToWritePostcard{
    C4Log(@"goToWritePostcard");
    [self removeFromView];
    [self closeMenu];

}
-(void)goToSaveAlphabet{
    C4Log(@"goToSaveAlphabet");
    [self saveAlphabet];
}
-(void)goToShareAlphabet{
    C4Log(@"goToShareAlphabet");
    [self removeFromView];
    [self closeMenu];

}
-(void)goToAlphabetInfo{
    C4Log(@"goToAlphabetInfo");
    [self removeFromView];
    [self closeMenu];
    [self postNotification:@"goToAlphabetInfo"];
}
@end
