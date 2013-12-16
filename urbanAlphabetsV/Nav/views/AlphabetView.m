//
//  AlphabetView.m
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "AlphabetView.h"
#import "BottomNavBar.h"
#import "AlphabetMenu.h"
#import "SaveToDatabase.h"
#import "C4WorkSpace.h"
#import "LetterView.h"
#import "Write Postcard.h"

@interface AlphabetView (){
    AlphabetInfo *alphabetInfo;
    C4WorkSpace *workspace;
    LetterView *letterView;
    Write_Postcard *writePostcard;
    SaveToDatabase *save;
    
    NSMutableArray *greyRectArray;
    NSString *currentLanguage;
    
    //saving image
    CGContextRef graphicsContext;
    
    
    //location when saving alphabet to server
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (nonatomic) AlphabetMenu *menu;

@end

@implementation AlphabetView

-(void )setup:(NSMutableArray*)passedAlphabet  {
    self.title=@"Alphabet View";

    //self.currentAlphabet=[passedAlphabet mutableCopy];
    
    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 60, 30)  centerIcon:UA_ICON_MENU withFrame:CGRectMake(0, 0, 45, 45)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToTakePhoto"];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"openMenu"];
    [self initGreyGrid];

    
    
}
-(void)grabCurrentLanguageViaNavigationController {
    C4Log(@"%d",[self.navigationController.viewControllers count]);
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    C4Log(@"obj:%@", obj);
    workspace=(C4WorkSpace*)obj;
    C4Log(@"workspace: %@", workspace);
    self.currentAlphabet=[workspace.currentAlphabet mutableCopy];
    currentLanguage=workspace.currentLanguage;
    [self drawCurrentAlphabet];

}
-(void)initGreyGrid{
    float imageWidth=53.53;
    float imageHeight=65.1;
    greyRectArray=[[NSMutableArray alloc]init];
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i)%6;
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
//------------------------------------------------------------------------
//REDRAWING AFTER CHANGING LANGUAGE
//------------------------------------------------------------------------
-(void)redrawAlphabet{
    
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
    
        C4Image *image=[self.currentAlphabet objectAtIndex:i ];
        [image removeFromSuperview];
        [self stopListeningFor:@"touchesBegan" object:image];
    }
    [self grabCurrentLanguageViaNavigationController];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToTakePhoto{
    self.bottomNavBar.leftImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    [self.navigationController popToRootViewControllerAnimated:YES];


}
-(void)goToSaveAlphabet{
    self.menu.saveAlphabetShape.fillColor=UA_HIGHLIGHT_COLOR;
    C4Log(@"goToSaveAlphabet");
    [self closeMenu];
    [self saveAlphabet];
}
-(void)goToWritePostcard{
    self.menu.writePostcardShape.fillColor=UA_HIGHLIGHT_COLOR;
    C4Log(@"goToWritePostcard");
    writePostcard=[[Write_Postcard alloc] initWithNibName:@"Write Postcard" bundle:[NSBundle mainBundle]];
    [writePostcard setupWithLanguage:workspace.currentLanguage Alphabet:workspace.currentAlphabet];
    [self.navigationController pushViewController:writePostcard animated:YES];
    [self closeMenu];
}
-(void)goToAlphabetInfo{
    C4Log(@"goToAlphabetInfo");
    
    //--------------------------------------------------
    //prepare alphabetInfo
    //--------------------------------------------------
    alphabetInfo=[[AlphabetInfo alloc]initWithNibName:@"AlphabetInfo" bundle:[NSBundle mainBundle]];
    [alphabetInfo setup];
    [self.navigationController pushViewController:alphabetInfo animated:YES];
    [alphabetInfo grabCurrentLanguageViaNavigationController ];
    [self closeMenu];

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
-(void)openLetterView{
    C4Log(@"open LetterView");
    letterView=[[LetterView alloc] initWithNibName:@"LetterView" bundle:[NSBundle mainBundle]];
    [letterView setupWithLetterNo: self.letterTouched currentAlphabet:self.currentAlphabet];
    [self.navigationController pushViewController:letterView animated:YES];
}
//------------------------------------------------------------------------
//MENU
//------------------------------------------------------------------------
-(void)openMenu{
    self.bottomNavBar.centerImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    [self saveCurrentAlphabetAsImage];
    CGRect menuFrame = CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    self.menu=[[AlphabetMenu alloc]initWithFrame:menuFrame ];
    [self.canvas addShape:self.menu];
    [self listenFor:@"touchesBegan" fromObjects:@[self.menu.cancelShape, self.menu.cancelLabel] andRunMethod:@"closeMenu"];
    [self listenFor:@"touchesBegan" fromObjects:@[self.menu.saveAlphabetShape, self.menu.saveAlphabetLabel,self.menu.saveAlphabetIcon] andRunMethod:@"goToSaveAlphabet"];
    
    //start location updating
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //alphabet info
    [self listenFor:@"touchesBegan" fromObjects:@[self.menu.alphabetInfoShape, self.menu.alphabetInfoLabel,self.menu.alphabetInfoIcon] andRunMethod:@"goToAlphabetInfo"];
    //alphabet info
    [self listenFor:@"touchesBegan" fromObjects:@[self.menu.writePostcardShape, self.menu.writePostcardLabel,self.menu.writePostcardIcon] andRunMethod:@"goToWritePostcard"];

}
-(void)closeMenu{
    //stop location updating
    [locationManager stopUpdatingLocation];
    
    C4Log(@"closingMenu");
    [self.menu removeFromSuperview];
    
    
}

//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
-(void)saveAlphabet{
    //crop the screenshot
    self.currentAlphabetImage=[self cropImage:self.currentAlphabetImage toArea:CGRectMake(0, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, self.canvas.width, self.canvas.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT))];
    [self exportHighResImage];
}

-(void)saveCurrentAlphabetAsImage{
    CGFloat scale = 10.0;
    
    //begin an image context
    CGSize  rect=CGSizeMake(self.canvas.width, self.canvas.height);
    UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
    
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //render the canvas image into the context
    [self.canvas renderInContext:c];
    
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end the image context
    UIGraphicsEndImageContext();
    
    //create a new C4Image
    self.currentAlphabetImage = [C4Image imageWithUIImage:newUIImage];
    
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
    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------
    save=[[SaveToDatabase alloc]init];
    [save sendAlphabetToDatabase:imageData withLanguage: currentLanguage withLocation:currentLocation];
    
    
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
//LOCATION UPDATING
//------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
}

@end
