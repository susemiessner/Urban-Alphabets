
#import "AssignPhotoLetter.h"

@implementation AssignPhotoLetter

-(void)setupAssignLetterDefaultBottomBarHeight: (float)BottomBarHeightDefault defaultNavBarHeight:(float)TopNavBarHeightDefault defaultTopBarFromTop: (float)TopBarFromTopDefault NavBarColor:(UIColor*)navBarColorDefault NavigationColor:(UIColor*)navigationColorDefault ButtonColor:(UIColor*)buttonColorDefault TypeColor:(UIColor*)typeColorDefault highlightColor:(UIColor*)highlightColorDefault{
    
    //getting all the default variables needed (declared in C4Workspace setup and #define
    TopBarFromTop=TopBarFromTopDefault;
    TopNavBarHeight=TopNavBarHeightDefault;
    BottomNavBarHeight=BottomBarHeightDefault;
    
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    buttonColor= buttonColorDefault;
    typeColor=typeColorDefault;
    highlightColor=highlightColorDefault;
    
    
    croppedPhoto=[C4Image imageNamed:@"image.jpg"];

    [self topBarSetup];
    [self bottomBarSetup];
    
    [self greyGrid];
    [self drawDefaultLetters];
    notificationCounter=0;
    whichView=@"assignLetter";
    
}

-(void)topBarSetup{
    
    //white rect under top bar that stays
    defaultRect=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, TopBarFromTop)];
    defaultRect.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.canvas addShape:defaultRect];
    defaultRect.lineWidth=0;
    
    
    //navigation bar
    topNavBar=[C4Shape rect:CGRectMake(0, TopBarFromTop, self.canvas.width, TopNavBarHeight)];
    topNavBar.fillColor=navBarColor;
    topNavBar.lineWidth=0;
    [self.canvas addShape:topNavBar];
    
    //text
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    takePhoto = [C4Label labelWithText:@"Assign photo letter" font:fatFont];
    takePhoto.center=topNavBar.center;
    [self.canvas addLabel:takePhoto];
    
    //upper left
    normalFont =[C4Font fontWithName:@"HelveticaNeue" size:17];
    backLabel=[C4Label labelWithText:@"Back" font: normalFont];
    backLabel.center=CGPointMake(40, topNavBar.center.y);
    [self.canvas addLabel:backLabel];
    
    backButtonImage=[C4Image imageNamed:@"icon_back.png"];
    backButtonImage.width= 12.2;
    backButtonImage.center=CGPointMake(10, topNavBar.center.y);
    [self.canvas addImage:backButtonImage];
    
    navigateBackRect=[C4Shape rect: CGRectMake(0, TopBarFromTop, 60, topNavBar.height)];
    navigateBackRect.fillColor=navigationColor;
    navigateBackRect.lineWidth=0;
    [self.canvas addShape:navigateBackRect];
    [self listenFor:@"touchesBegan" fromObject:navigateBackRect andRunMethod:@"navigateBack"];
    //upper right
    closeButtonImage=[C4Image imageNamed:@"icon_Close.png"];
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    [self.canvas addImage:closeButtonImage];
    
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, TopBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    [self.canvas addShape:closeRect];
    [self listenFor:@"touchesBegan" fromObject:closeRect andRunMethod:@"goToAlphabetsView"];

}
-(void) bottomBarSetup{
    //the bar itself
    bottomNavBar=[C4Shape rect:CGRectMake(0, self.canvas.height-(BottomNavBarHeight), self.canvas.width, BottomNavBarHeight)];
    bottomNavBar.fillColor= navBarColor;
    bottomNavBar.lineWidth=0;
    [self.canvas addShape:bottomNavBar];
    
    //lower left: the cropped image as a miniature
    croppedPhoto.width=32.788;
    croppedPhoto.center=CGPointMake(croppedPhoto.width/2+5, bottomNavBar.center.y);
    [self.canvas addImage:croppedPhoto];
    C4Log(@"croppedPhotoWidth %f", croppedPhoto.width);
    
    //lower right: settings icon
    settingsItem=[C4Image imageNamed:@"icon_Settings.png"];
    settingsItem.width=30.017;
    settingsItem.center=CGPointMake(self.canvas.width-settingsItem.width/2-5,bottomNavBar.center.y);
    [self listenFor:@"touchesBegan" fromObject:settingsItem andRunMethod:@"goToSettings"];
    [self.canvas addImage:settingsItem];
}
-(void)drawDefaultLetters{
    
    /*NSArray *finnishAlphabet=[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E",@"F", @"G", @"H", @"I", @"J",@"K", @"L", @"M", @"N", @"O",@"P", @"Q", @"R", @"S", @"T",@"U", @"V", @"W", @"X", @"Y",@"Z", @"Ä", @"Ö", @"Å", @".",@"!", @"?", @"0", @"1", @"2",@"3", @"4", @"5", @"6", @"6", @"8", @"9",nil];
    }*/
    NSArray *finnishLetters=[NSArray arrayWithObjects:
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
                    nil];
    defaultLetters=[finnishLetters mutableCopy];
    alphabetArray=[[NSMutableArray alloc]init];
    C4Log(@"arrayLength:%i", [defaultLetters count]);
    int imageWidth=53.53;
    int imageHeight=65.1;
    for (NSUInteger i=0; i<[defaultLetters count]; i++) {
        int xMultiplier=(i)%6;
        int yMultiplier= (i)/6;
        int xPos=xMultiplier*imageWidth;
        int yPos=2+TopBarFromTop+TopNavBarHeight+yMultiplier*imageHeight;
        C4Image *image=[defaultLetters objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [alphabetArray addObject:image];
        [self.canvas addImage:image];
        [self listenFor:@"touchesBegan" fromObject:image andRunMethod:@"highlightLetter:"];
    }
    C4Log(@"alphabetArrayLength: %i", [alphabetArray count]);
}
-(void)greyGrid{
    int imageWidth=53.53;
    int imageHeight=65.1;

    for (NSUInteger i=0; i<42; i++) {
        int xMultiplier=(i)%6;
        int yMultiplier= (i)/6;
        int xPos=xMultiplier*imageWidth;
        int yPos=2+TopBarFromTop+TopNavBarHeight+yMultiplier*imageHeight;
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=navigationColor;
        greyRect.lineWidth=2;
        greyRect.strokeColor=navBarColor;
        [self.canvas addShape:greyRect];
    }
}
-(void)highlightLetter:(NSNotification *)notification {
    if ([whichView isEqual:@"assignLetter"]) {
        for (int i=0; i<[defaultLetters count]; i++) {
            C4Image *currentImage= defaultLetters[i];
            currentImage.backgroundColor=navigationColor;
        }
        
        C4Image *currentImage = (C4Image *)notification.object;
        currentImage.backgroundColor= highlightColor;
        
        //making sure that the "OK" button is only added ones not every time the person clicks on a new letter
        if (notificationCounter==0) {
            //add Ok button
            okButtonImage=[C4Image imageNamed:@"icon_OK.png"];
            okButtonImage.height=45;
            okButtonImage.width=90;
            okButtonImage.center=bottomNavBar.center;
            [self.canvas addImage:okButtonImage];
            [self listenFor:@"touchesBegan" fromObject:okButtonImage andRunMethod:@"goToAlphabetsView"];
        }
        notificationCounter++;
    }
}
-(void)setupAlphabetsView{
    
    //change top bar
    //>update text
    takePhoto.text=@"Untitled";
    [takePhoto sizeToFit];
    takePhoto.center=topNavBar.center;
    //>remove close button on upper right
    [closeButtonImage removeFromSuperview];
    [closeRect removeFromSuperview];
    
    //change bottombar
    //>remove current buttons
    [croppedPhoto removeFromSuperview];
    [settingsItem removeFromSuperview];
    [okButtonImage removeFromSuperview];
    //>add new buttons as needed
    //>>menu
    menuButtonImage=[C4Image imageNamed:@"icon_Menu.png"];
    menuButtonImage.width= 45;
    menuButtonImage.center=bottomNavBar.center;
    [self.canvas addImage:menuButtonImage];
    //>>takePhotoIcon
    photoButtonImage=[C4Image imageNamed:@"icon_TakePhoto.png"];
    photoButtonImage.width=60;
    photoButtonImage.center=CGPointMake(photoButtonImage.width/2+5, bottomNavBar.center.y);
    [self.canvas addImage:photoButtonImage];
    
    //add chosen letter to alphabet
    NSInteger chosenImageNumber=4;
    //go through all images and find the one selected
    for (int i=0; i<[defaultLetters count]; i++) {
        C4Image *currentImage= defaultLetters[i];
        
        if (currentImage.backgroundColor==navigationColor) {
            chosenImageNumber=i;
            C4Log(@"chosenImageNumber %i", chosenImageNumber);
        }
    }
    
    

    //replace selected number in the array with chropped image
    
    C4Image *image=[alphabetArray objectAtIndex:chosenImageNumber];
    [image removeFromSuperview];
    [alphabetArray replaceObjectAtIndex:chosenImageNumber withObject:croppedPhoto];
    
    int imageWidth=53.53;
    int imageHeight=65.1;
    int xMultiplier=(chosenImageNumber)%6;
    int yMultiplier= (chosenImageNumber)/6;
    int xPos=xMultiplier*imageWidth;
    int yPos=2+TopBarFromTop+TopNavBarHeight+yMultiplier*imageHeight;
    image=[alphabetArray objectAtIndex:chosenImageNumber];
    image.origin=CGPointMake(xPos, yPos);
    image.width=imageWidth;
    image.height=imageHeight;
    [self.canvas addImage:image];
    
}

-(void)goToAlphabetsView{
    C4Log(@"goToAlphabetsView");
    //[self postNotification:@"goToAlphabetsView"];
    whichView=@"AlphabetView";
    [self setupAlphabetsView];
    
}
-(void) navigateBack{
    C4Log(@"navigating back");
    if ([whichView isEqual:@"assignLetter"]) {
        [self postNotification:@"goToCropPhoto"];
    }
    
    
}
-(void)goToSettings{
    C4Log(@"go to settings");
}

@end
