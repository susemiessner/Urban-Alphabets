//
//  AssignLetter.m
//  UrbanAlphabets
//
//  Created by Suse on 10/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "AssignLetter.h"
#import "BottomNavBar.h"
#import "AlphabetView.h"
#import "C4WorkSpace.h"
@interface AssignLetter (){
    AlphabetView *alphabetView;
    
    int notificationCounter; //to make sure Ok button is only added 1x
    NSMutableArray *greyRectArray;
    C4Image *currentImage; //the image currently highlighted
    C4Image *croppedImage;
    
    NSMutableArray *currentAlphabetPassed;
    NSMutableArray *greyGridArray;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
}
@property (nonatomic) BottomNavBar *bottomNavBar;

@end

@implementation AssignLetter

-(void)setup:(C4Image*)croppedImagePassed  {
    self.title=@"Assign Letter";
    
    croppedImage=[C4Image imageWithImage:croppedImagePassed];
    
    
    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:croppedImage withFrame:CGRectMake(0, 0, 32.788, 40.022) centerIcon:UA_ICON_OK withFrame:CGRectMake(0, 0, 90, 45) rightIcon:UA_ICON_SETTINGS withFrame:CGRectMake(0, 0, 30.017, 30.017)];
    [self.canvas addShape:self.bottomNavBar];
    self.bottomNavBar.centerImage.hidden=YES;
    
    [self loadDefaultAlphabet]; //just for the time testing
    [self initGreyGrid];
    /*C4Log(@"%@",[self.navigationController.viewControllers count]);
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    C4Log(@"obj:%@", obj);
    C4WorkSpace *workspace=(C4WorkSpace*)obj;
    C4Log(@"workspace: %@", workspace);
    currentAlphabetPassed=workspace.currentAlphabet;
    C4Log(@"workspace.currentAlphabet:%@", workspace.currentAlphabet);*/

    [self drawCurrentAlphabet:currentAlphabetPassed];
    
    
    //start location updating
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
}
-(void)loadDefaultAlphabet{
    currentAlphabetPassed=[NSMutableArray arrayWithObjects:
                          //first row
                          [C4Image imageNamed:@"letter_A.png"],
                          [C4Image imageNamed:@"letter_B.png"],
                          [C4Image imageNamed:@"letter_C.png"],
                          [C4Image imageNamed:@"letter_D.png"],
                          [C4Image imageNamed:@"letter_E.png"],
                          [C4Image imageNamed:@"letter_F.png"],
                          //second row
                          [C4Image imageNamed:@"letter_G.png"],
                          [C4Image imageNamed:@"letter_H.png"],
                          [C4Image imageNamed:@"letter_I.png"],
                          [C4Image imageNamed:@"letter_J.png"],
                          [C4Image imageNamed:@"letter_K.png"],
                          [C4Image imageNamed:@"letter_L.png"],
                          
                          [C4Image imageNamed:@"letter_M.png"],
                          [C4Image imageNamed:@"letter_N.png"],
                          [C4Image imageNamed:@"letter_O.png"],
                          [C4Image imageNamed:@"letter_P.png"],
                          [C4Image imageNamed:@"letter_Q.png"],
                          [C4Image imageNamed:@"letter_R.png"],
                          
                          [C4Image imageNamed:@"letter_S.png"],
                          [C4Image imageNamed:@"letter_T.png"],
                          [C4Image imageNamed:@"letter_U.png"],
                          [C4Image imageNamed:@"letter_V.png"],
                          [C4Image imageNamed:@"letter_W.png"],
                          [C4Image imageNamed:@"letter_X.png"],
                          
                          [C4Image imageNamed:@"letter_Y.png"],
                          [C4Image imageNamed:@"letter_Z.png"],
                          [C4Image imageNamed:@"letter_Ä.png"],
                          [C4Image imageNamed:@"letter_Ö.png"],
                          [C4Image imageNamed:@"letter_Å.png"],
                          [C4Image imageNamed:@"letter_.png"],//.
                          
                          [C4Image imageNamed:@"letter_!.png"],
                          [C4Image imageNamed:@"letter_-.png"],//?
                          [C4Image imageNamed:@"letter_0.png"],
                          [C4Image imageNamed:@"letter_1.png"],
                          [C4Image imageNamed:@"letter_2.png"],
                          [C4Image imageNamed:@"letter_3.png"],
                          
                          [C4Image imageNamed:@"letter_4.png"],
                          [C4Image imageNamed:@"letter_5.png"],
                          [C4Image imageNamed:@"letter_6.png"],
                          [C4Image imageNamed:@"letter_7.png"],
                          [C4Image imageNamed:@"letter_8.png"],
                          [C4Image imageNamed:@"letter_9.png"],
                          
                          /* //the ones from the other languages
                           [C4Image imageNamed:@"letter_,.png"], //42
                           [C4Image imageNamed:@"letter_$.png"], //43
                           [C4Image imageNamed:@"letter_+.png"], //44
                           [C4Image imageNamed:@"letter_ae.png"],//45
                           [C4Image imageNamed:@"letter_danisho.png"], //46
                           [C4Image imageNamed:@"letter_Ü.png"], //47*/
                          nil];
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
        [greyGridArray addObject:greyRect];
        [self.canvas addShape:greyRect];
    }
}
-(void)drawCurrentAlphabet: (NSMutableArray*)currentAlphabetPassed{
    notificationCounter=0; //to make sure ok button is only added 1x
    //self.currentAlphabet=[currentAlphabetPassed mutableCopy];
    
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
    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------
    
    save=[[SaveToDatabase alloc]init];
    [save sendLetterToDatabase: currentLocation ImageNo:self.chosenImageNumberInArray Image:croppedImage];
    
    //croppedImage.width=1;//216;
    croppedImage=[self imageWithImage:croppedImage];
    
    //--------------------------------------------------
    //replace current  with new letter
    //--------------------------------------------------
    
    //remove the image currently in that place in the alphabet
    [self.currentAlphabet removeObjectAtIndex:self.chosenImageNumberInArray];
    //add the cropped image in the same position
    [self.currentAlphabet insertObject:croppedImage atIndex:self.chosenImageNumberInArray];
    
    
   // [self postNotification:@"goToAlphabetsView"];
    [locationManager stopUpdatingLocation];
    
    //prepare next view and go there
    alphabetView=[[AlphabetView alloc]initWithNibName:@"AlphabetView" bundle:[NSBundle mainBundle]];
    [alphabetView setup:self.currentAlphabet];
    [self.navigationController pushViewController:alphabetView animated:YES];

    
}
//------------------------------------------------------------------------
//FOR SENDING TO DATABASE
//------------------------------------------------------------------------
-(C4Image*)imageWithImage:(C4Image*)theImage {
    //size to scale to
    CGSize newSize=CGSizeMake(53.53,65.1);
    
    //convert to UIImage
    UIImage *image=theImage.UIImage;
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //convert back to C4Image
    C4Image *convertedImage=[C4Image imageWithUIImage:newImage];
    //return C4Image
    return convertedImage;
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
