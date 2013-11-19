//
//  AssignLetter.m
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "AssignLetter.h"
@interface AssignLetter (){
    int notificationCounter; //to make sure Ok button is only added 1x
    NSMutableArray *greyRectArray;
    C4Image *currentImage; //the image currently highlighted
    C4Image *croppedImage;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;

    C4Label *longitudeLabel, *latitudeLabel;
    

}
@property (nonatomic) TopNavBar *topNavBar;
@property (nonatomic) BottomNavBar *bottomNavBar;
@end

@implementation AssignLetter

-(void)setup:(C4Image*)croppedImagePassed withAlphabet:(NSMutableArray*)currentAlphabetPassed withGreyGrid: (NSMutableArray*)greyGridArray{
    croppedImage=[C4Image imageWithImage:croppedImagePassed];

    //top nav bar
    CGRect topBarFrame = CGRectMake(0, UA_TOP_WHITE, self.canvas.width, UA_TOP_BAR_HEIGHT);
    self.topNavBar = [[TopNavBar alloc] initWithFrame:topBarFrame text:@"Assign photo letter" lastView:@"CropPhoto"];
    [self.canvas addShape:self.topNavBar];

    
    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:croppedImage withFrame:CGRectMake(0, 0, 32.788, 40.022) centerIcon:[C4Image imageNamed:@"icon_OK"] withFrame:CGRectMake(0, 0, 90, 45) rightIcon:[C4Image imageNamed:@"icon_Settings"] withFrame:CGRectMake(0, 0, 30.017, 30.017)];
    [self.canvas addShape:self.bottomNavBar];
    self.bottomNavBar.centerImage.hidden=YES;
    
    [self drawGreyGrid:greyGridArray];
    [self drawCurrentAlphabet:currentAlphabetPassed];
    
    //start location updating
    locationManager = [[CLLocationManager alloc] init];

    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
}
-(void)drawCurrentAlphabet: (NSMutableArray*)currentAlphabetPassed{
    notificationCounter=0; //to make sure ok button is only added 1x
    self.currentAlphabet=[currentAlphabetPassed mutableCopy];
    
    self.currentAlphabet=currentAlphabetPassed;
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
        [self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"highlightLetter:"];
    }
}
-(void)drawGreyGrid: (NSMutableArray*)greyGridArray{

    //greyRectArray=[[NSMutableArray alloc]init];
    for (NSUInteger i=0; i<42; i++) {
        C4Shape *greyRect=[greyGridArray objectAtIndex:i];
        [self.canvas addShape:greyRect];
    }
}
-(void)highlightLetter:(NSNotification *)notification {
    
    for (int i=0; i<[self.currentAlphabet count]; i++) {
        currentImage= self.currentAlphabet[i];
        currentImage.backgroundColor=UA_NAV_CTRL_COLOR;
    }
    
    currentImage = (C4Image *)notification.object;
    C4Log(@"currentImage x:%f",currentImage.origin.x);
    currentImage.backgroundColor= UA_HIGHLIGHT_COLOR;
    
    
    //making sure that the "OK" button is only added ones not every time the person clicks on a new letter
    if (notificationCounter==0) {
        //add Ok button
        self.bottomNavBar.centerImage.hidden=NO;
        [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"goToAlphabetsViewAddingImageToAlphabet"];
    }
    notificationCounter++;

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
        [self stopListeningFor:@"touchesBegan" object:shape];

        [shape removeFromSuperview];
    }
    [self stopListeningFor:@"touchesBegan" object:self.bottomNavBar.centerImage];

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
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) goToAlphabetsViewAddingImageToAlphabet{

    self.bottomNavBar.centerImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    //--------------------------------------------------
    //which image was chosen
    //--------------------------------------------------
    C4Log(@"going to Alphabetsview");
    float imageWidth=53.53;
    float imageHeight=65.1;
    float i=currentImage.origin.x/imageWidth;
    float j=currentImage.origin.y/imageHeight;
    
    self.chosenImageNumberInArray=((j-1)*6)+i+1;
    
    //remove the image currently in that place in the alphabet
    [self.currentAlphabet removeObjectAtIndex:self.chosenImageNumberInArray];
    //add the cropped image in the same position
    [self.currentAlphabet insertObject:croppedImage atIndex:self.chosenImageNumberInArray];
    
    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------

    //save=[[SaveToDatabase alloc]init];
    [save sendLetterToDatabase: currentLocation ImageNo:self.chosenImageNumberInArray Image:croppedImage];
   
    
    
    [self postNotification:@"currentAlphabetChanged"];
    
    [self removeFromView];
    [self postNotification:@"goToAlphabetsView"];
    [locationManager stopUpdatingLocation];

}

@end
