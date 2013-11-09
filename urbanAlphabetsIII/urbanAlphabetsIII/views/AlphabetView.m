//
//  AlphabetView.m
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AlphabetView.h"


@interface AlphabetView (){
    NSMutableArray *greyRectArray;

    C4Shape *background;
    
    //saving image
    CGContextRef graphicsContext;
}
@property (nonatomic) TopNavBar *topNavBar;
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (nonatomic) AlphabetMenu *menu;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@end

@implementation AlphabetView
-(void )setup:(NSMutableArray*)passedAlphabet {
    self.currentAlphabet=[passedAlphabet mutableCopy];

    background=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, self.canvas.height)];
    background.fillColor=UA_WHITE_COLOR;
    background.lineWidth=0;
    [self.canvas addShape:background];

    //top nav bar
    CGRect topBarFrame = CGRectMake(0, UA_TOP_WHITE, self.canvas.width, UA_TOP_BAR_HEIGHT);
    self.topNavBar = [[TopNavBar alloc] initWithFrame:topBarFrame text:@"Untitled" lastView:@"AssignLetter"];
    [self.canvas addShape:self.topNavBar];

    
    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 60, 30)  centerIcon:UA_ICON_MENU withFrame:CGRectMake(0, 0, 45, 45)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToTakePhoto"];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"openMenu"];

    [self drawGreyGrid];
    [self drawCurrentAlphabet];

}
-(void)drawGreyGrid{
    float imageWidth=53.53;
    float imageHeight=65.1;
    greyRectArray=[[NSMutableArray alloc]init];
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i
                           )%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=UA_NAV_CTRL_COLOR;
        greyRect.lineWidth=2;
        greyRect.strokeColor=UA_NAV_BAR_COLOR;
        [greyRectArray addObject:greyRect];
        [self.canvas addShape:greyRect];
    }
}
-(void)drawCurrentAlphabet{
    
    //C4Log(@"currentAlphabetLength: %i", [self.currentAlphabet count]);
    C4Log(@"drawing the alphabet");
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        C4Image *image=[self.currentAlphabet objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        [self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"tappedLetter:"];
    }
}
-(void)tappedLetter:(NSNotification *)notification {
    //get the current object
    C4Image *currentImage = (C4Image *)notification.object;
    //
    CGPoint chosenImage=CGPointMake(currentImage.origin.x, currentImage.origin.y);
    //figure out which letter was pressed
    float imageWidth=53.53;
    float imageHeight=65.1;
    float i=chosenImage.x/imageWidth;
    float j=chosenImage.y/imageHeight;
    
    self.letterTouched=((j-1)*6)+i+1;
    //C4Log(@"letterTouched: %i", self.letterTouched);
    [self openLetterView];
    
}
-(void)removeFromView{
    [self.topNavBar removeFromSuperview];
    [self.bottomNavBar removeFromSuperview];
    for (int i=0; i<[self.currentAlphabet count]; i++) {
        C4Image *image=[self.currentAlphabet objectAtIndex:i];
        [image removeFromSuperview];
        [self stopListeningFor:@"touchesBegan" object:image];
    }
    for (int i=0; i<[greyRectArray count]; i++) {
        C4Shape *shape=[greyRectArray objectAtIndex:i];
        [shape removeFromSuperview];
    }
    [self.menu removeFromSuperview];
    [self stopListeningFor:@"touchesBegan" objects:@[self.bottomNavBar.centerImage, self.bottomNavBar.leftImage]];
}

//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
-(void)saveAlphabet{
    //crop the screenshot
    self.currentAlphabetImage=[self cropImage:self.currentAlphabetImage toArea:CGRectMake(0, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, self.canvas.width, self.canvas.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT))];
    [self exportHighResImage];
}
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    [self.currentAlphabetImage renderInContext:graphicsContext];
    NSString *fileName = [NSString stringWithFormat:@"exportedAlphabet%@.jpg", [NSDate date]];
    //C4Log(@"%@",s );
    
    [self saveImage:fileName];
    [self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.canvas.width, self.canvas.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT)), YES, 5.0f);
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
-(C4Image *)cropImage:(C4Image *)originalImage toArea:(CGRect)rect{
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
-(void)goToTakePhoto{
    [self removeFromView];
    self.bottomNavBar.leftImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    [self postNotification:@"goToTakePhoto"];
}
-(void)openLetterView{
    C4Log(@"open LetterView");
    [self removeFromView];
    [self postNotification:@"goToLetterView"];
}
-(void)openMenu{
    CGRect menuFrame = CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    self.menu=[[AlphabetMenu alloc]initWithFrame:menuFrame text:@"Untitled" lastView:@"AssignLetter"];
    [self.canvas addShape:self.menu];
    [self listenFor:@"touchesBegan" fromObjects:@[self.menu.cancelShape, self.menu.cancelLabel] andRunMethod:@"closeMenu"];
    [self listenFor:@"touchesBegan" fromObjects:@[self.menu.saveAlphabetShape, self.menu.saveAlphabetLabel,self.menu.saveAlphabetIcon] andRunMethod:@"goToSaveAlphabet"];
    [self listenFor:@"hideAlphabetView" andRunMethod:@"removeFromView"];
}
-(void)closeMenu{
    C4Log(@"closingMenu");
    [self.menu removeFromSuperview];
}
-(void)goToSaveAlphabet{
    C4Log(@"goToSaveAlphabet");
    [self.menu removeFromSuperview];
    [self postNotification:@"saveCurrentAlphabetAsImage"];
    [self saveAlphabet];
}
@end
