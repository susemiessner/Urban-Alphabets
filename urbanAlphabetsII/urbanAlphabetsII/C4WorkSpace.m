//
//  C4WorkSpace.m
//  urbanAlphabetsII
//
//  Created by Suse on 27/10/13.
//

#import "C4Workspace.h"


@implementation C4WorkSpace

-(void)setup {
    //setup all the default variables
    //>colors
    navBarColorDefault=[UIColor colorWithRed:0.96875 green:0.96875 blue:0.96875 alpha:1];
    navigationColorDefault=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    buttonColorDefault= [UIColor colorWithRed:0.8984275 green:0.8984275 blue:0.8984275 alpha:1];
    typeColorDefault=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:1];
    overlayColorDefault=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.5];
    highlightColorDefault=[UIColor colorWithRed:0.757 green:0.964 blue:0.617 alpha:0.5];
    darkenColorDefault=[UIColor colorWithRed:0.19921875 green:0.19921875 blue:0.19921875 alpha:0.8];
    greyTypeDefault=[UIColor colorWithRed:0.3984375 green:0.3984375 blue:0.3984375 alpha:1.0];
    
    //>nav bar heights
    TopBarFromTopDefault=   20.558;
    TopNavBarHeightDefault= 44.0;
    BottomBarHeightDefault= 49;
    
    //>type/fonts
    fatFontDefault=     [C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    normalFontDefault=  [C4Font fontWithName:@"HelveticaNeue" size:17];
    
    //>icons
    iconTakePhoto=      [C4Image imageNamed:@"icon_TakePhoto.png"];
    iconClose=          [C4Image imageNamed:@"icon_Close.png"];
    iconBack=           [C4Image imageNamed:@"icon_back.png"];
    iconOk=             [C4Image imageNamed:@"icon_OK.png"];
    iconSettings=       [C4Image imageNamed:@"icon_Settings.png"];
    iconAlphabetInfo=   [C4Image imageNamed:@"icon_information.png"];
    iconShareAlphabet=  [C4Image imageNamed:@"icon_ShareAlphabet.png"];
    iconSaveAlphabet=   [C4Image imageNamed:@"icon_Save.png"];
    iconWritePostcard=  [C4Image imageNamed:@"icon_Postcard.png"];
    iconMyPostcards=    [C4Image imageNamed:@"icon_Postcards.png"];
    iconMyAlphabets=    [C4Image imageNamed:@"icon_Alphabets.png"];
    iconMenu=           [C4Image imageNamed:@"icon_Menu.png"];
    iconArrowForward=   [C4Image imageNamed:@"icon_ArrowForward.png"];
    iconArrowBackward=  [C4Image imageNamed:@"icon_ArrowBack.png"];
    iconAlphabet=       [C4Image imageNamed:@"icon_Alphabet.png"];
    iconChecked=        [C4Image imageNamed:@"icon_checked.png"];
    
    currentLanguage=@"Finnish/Swedish";
    
    [self loadDefaultAlphabet];
    [self createViews];

    //the methods to listen for from all other canvasses
    [self listenFor:@"goToTakePhoto" andRunMethod:@"goToTakePhoto"];
    [self listenFor:@"goToCropPhoto" andRunMethod:@"goToCropPhoto"];
    [self listenFor:@"goToAssignPhoto" andRunMethod:@"goToAssignPhoto"];
    [self listenFor:@"goToAlphabetsView" andRunMethod:@"goToAlphabetsView"];
    [self listenFor:@"navigatingBackBetweenAlphabet+AssignLetter" andRunMethod:@"navigatingBackBetweenAlphabetAndAssignLetter"];
    [self listenFor:@"goToLetterView" andRunMethod:@"goToLetterView"];
    [self listenFor:@"goToAlphabetInfo" andRunMethod:@"goToAlphabetInfo"];
    [self listenFor:@"goToChangeLanguage" andRunMethod:@"goToChangeLanguage"];
    
    //listen if current alphabet was changed
    [self listenFor:@"currentAlphabetChanged" andRunMethod:@"currentAlphabetChanged"];
    //when displaying the alphabet, save it as an image used in case user wants to save that alphabet as an image
    [self listenFor:@"saveCurrentAlphabetAsImage" andRunMethod:@"saveCurrentAlphabetAsImage"];
    //when language changed save it in the default settings
    [self listenFor:@"languageChanged" andRunMethod:@"languageChanged"];
}
-(void)createViews{
    //TakePhoto
    takePhoto= [TakePhoto new];
    takePhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    takePhoto.canvas.userInteractionEnabled = YES;
    [takePhoto transferVariables:1 topBarFromTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault fatFont:fatFontDefault normalFont:normalFontDefault iconTakePhoto:iconTakePhoto iconClose:iconClose iconBack:iconBack ];
    [takePhoto setup];
    [takePhoto cameraSetup];
    [self.canvas addSubview:takePhoto.canvas];
    
    //CropPhoto
    cropPhoto=[CropPhoto new];
    cropPhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    cropPhoto.canvas.userInteractionEnabled=YES;
    [cropPhoto transferVariables:1 topBarFroTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault overlayColor:overlayColorDefault fatFont:fatFontDefault normalFont:normalFontDefault iconClose:iconClose iconBack:iconBack iconOk:iconOk];
    [self.canvas addSubview:cropPhoto.canvas];
    cropPhoto.canvas.hidden= YES;
    
    //AssignPhoto
    assignLetter=[AssignLetter new];
    assignLetter.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    assignLetter.canvas.userInteractionEnabled=YES;
    [assignLetter transferVariables:1 topBarFroTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault highlightColor:highlightColorDefault fatFont:fatFontDefault normalFont:normalFontDefault iconClose:iconClose iconBack:iconBack iconOk:iconOk iconSettings:iconSettings];

    [self.canvas addSubview:assignLetter.canvas ];
    assignLetter.canvas.hidden=YES;
    
    //AlphabetView
    alphabetView=[AlphabetView new];
    alphabetView.canvas.frame= CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    alphabetView.canvas.userInteractionEnabled=YES;
    [alphabetView transferVaribles:1 topBarFromTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault darkenColor:darkenColorDefault fatFont:fatFontDefault normalFont:normalFontDefault iconClose:iconClose iconBack:iconBack iconMenu:iconMenu iconTakePhoto:iconTakePhoto iconAlphabetInfo:iconAlphabetInfo iconShareAlphabet:iconShareAlphabet iconWritePostcard:iconWritePostcard iconMyPostcards:iconMyPostcards iconMyAlphabets:iconMyAlphabets iconSaveImage:iconSaveAlphabet currentAlphabet: currentAlphabet];
    [self.canvas addSubview:alphabetView.canvas];
    alphabetView.canvas.hidden=YES;
    
    //LetterView
    letterView=[LetterView new];
    letterView.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    letterView.canvas.userInteractionEnabled=YES;
    [letterView transferVariables:1 topBarFromTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault fatFont:fatFontDefault normalFont:normalFontDefault iconClose:iconClose iconAlphabet:iconAlphabet iconArrowForward:iconArrowForward iconArrowBack:iconArrowBackward currentAlphabet: currentAlphabet];
    [self.canvas addSubview:letterView.canvas];
    letterView.canvas.hidden=YES;
    
    //AlphabetInfo
    alphabetInfo=[AlphabetInfo new];
    alphabetInfo.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    alphabetInfo.canvas.userInteractionEnabled=YES;
    [alphabetInfo transferVariables:1 topBarFromTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault greyType:greyTypeDefault fatFont:fatFontDefault normalFont:normalFontDefault backImage:iconBack closeIcon:iconClose alphabetIcon:iconAlphabet currentLanguage:currentLanguage];
    [self.canvas addSubview:alphabetInfo.canvas];
    alphabetInfo.canvas.hidden=YES;
    
    //ChangeLanguage
    changeLanguage=[ChangeLanguage new];
    changeLanguage.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    changeLanguage.canvas.userInteractionEnabled=YES;
    [changeLanguage transferVariables:1 topBarFromTop:TopBarFromTopDefault topBarHeight:TopNavBarHeightDefault bottomBarHeight:BottomBarHeightDefault navBarColor:navBarColorDefault navigationColor:navigationColorDefault typeColor:typeColorDefault highlightColor:highlightColorDefault fatFont:fatFontDefault normalFont:normalFontDefault backImage:iconBack iconClose:iconClose iconChecked:iconChecked iconOk:iconOk currentLanguage:currentLanguage];
    [self.canvas addSubview:changeLanguage.canvas];
    changeLanguage.canvas.hidden=YES;
}
-(void)loadDefaultAlphabet{
    finnishAlphabet=[NSArray arrayWithObjects:
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
                                    //the ones from the other languages
                                    [C4Image imageNamed:@"letter_,.png"],
                                    [C4Image imageNamed:@"letter_$.png"],
                                    [C4Image imageNamed:@"letter_+.png"],
                                    [C4Image imageNamed:@"letter_ae.png"],
                                    [C4Image imageNamed:@"letter_danisho.png"],
                                     nil];
    //C4Log(@"finnish alphabet length: %i", [finnishAlphabet count]);
    currentAlphabet=[[NSMutableArray alloc]init];
    for (int i=0; i<42; i++) {
        C4Image *currentImage=[finnishAlphabet objectAtIndex:i];
        [currentAlphabet addObject:currentImage];
    }
    C4Log(@"current alphabet length: %i", [currentAlphabet count]);

}
-(void)currentAlphabetChanged{
    C4Log(@"current alphabet changed");
    currentAlphabet=[assignLetter.currentAlphabet mutableCopy];
}
-(void)saveCurrentAlphabetAsImage{
    CGFloat scale = 10.0;
    
    //begin an image context
    CGSize  rect=CGSizeMake(self.canvas.width, self.canvas.height);
    UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
    
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //render the original image into the context
    [alphabetView.canvas renderInContext:c];
    
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end the image context
    UIGraphicsEndImageContext();
    
    //create a new C4Image
    alphabetView.currentAlphabetImage = [C4Image imageWithUIImage:newUIImage];

}
-(void)languageChanged{
    currentLanguage=changeLanguage.chosenLanguage;
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToTakePhoto{
    [takePhoto resetCounter];
    [takePhoto setup];

    C4Log(@"TakePhoto");
    takePhoto.canvas.hidden=NO;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=YES;
    alphabetView.canvas.hidden=YES;
    letterView.canvas.hidden=YES;
    alphabetInfo.canvas.hidden=YES;
    changeLanguage.canvas.hidden=YES;
    
    takePhoto.canvas.userInteractionEnabled=YES;
    cropPhoto.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.userInteractionEnabled=NO;
    alphabetView.canvas.userInteractionEnabled=NO;
    letterView.canvas.userInteractionEnabled=NO;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    changeLanguage.canvas.userInteractionEnabled=NO;

}
-(void)goToCropPhoto{
    C4Log(@"going to CropPhoto");
    [cropPhoto displayImage:takePhoto.img];
    [cropPhoto setup];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=NO;
    assignLetter.canvas.hidden=YES;
    alphabetView.canvas.hidden=YES;
    letterView.canvas.hidden=YES;
    alphabetInfo.canvas.hidden=YES;
    changeLanguage.canvas.hidden=YES;
    
    takePhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.userInteractionEnabled=YES;
    assignLetter.canvas.userInteractionEnabled=NO;
    alphabetView.canvas.userInteractionEnabled=NO;
    letterView.canvas.userInteractionEnabled=NO;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    changeLanguage.canvas.userInteractionEnabled=NO;
}
-(void)goToAssignPhoto{
    C4Log(@"AssignPhoto");
    [assignLetter setup];
    [assignLetter drawCurrentAlphabet:currentAlphabet];
    [assignLetter drawCroppedPhoto:cropPhoto.croppedPhoto];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=NO;
    alphabetView.canvas.hidden=YES;
    letterView.canvas.hidden=YES;
    alphabetInfo.canvas.hidden=YES;
    changeLanguage.canvas.hidden=YES;
    
    takePhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.userInteractionEnabled=YES;
    alphabetView.canvas.userInteractionEnabled=NO;
    letterView.canvas.userInteractionEnabled=NO;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    changeLanguage.canvas.userInteractionEnabled=NO;

}
-(void)goToAlphabetsView{
    C4Log(@"AlphabetsView");
    [alphabetView setup];
    [alphabetView drawCurrentAlphabet:currentAlphabet];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=YES;
    alphabetView.canvas.hidden=NO;
    letterView.canvas.hidden=YES;
    alphabetInfo.canvas.hidden=YES;
    changeLanguage.canvas.hidden=YES;
    
    takePhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.userInteractionEnabled=NO;
    alphabetView.canvas.userInteractionEnabled=YES;
    letterView.canvas.userInteractionEnabled=NO;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    changeLanguage.canvas.userInteractionEnabled=NO;

}
-(void)navigatingBackBetweenAlphabetAndAssignLetter{
    C4Log(@"navigating back between alphabet and assign");
    C4Image *imageToSend=[finnishAlphabet objectAtIndex: assignLetter.chosenImageNumberInArray];
    [currentAlphabet removeObjectAtIndex:assignLetter.chosenImageNumberInArray];
    [currentAlphabet insertObject:imageToSend atIndex:assignLetter.chosenImageNumberInArray];
    [assignLetter setup];
    [assignLetter drawCurrentAlphabet:currentAlphabet];
    [assignLetter drawCroppedPhoto:cropPhoto.croppedPhoto];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=NO;
    alphabetView.canvas.hidden=YES;
    letterView.canvas.hidden=YES;
    alphabetInfo.canvas.hidden=YES;
    changeLanguage.canvas.hidden=YES;
    
    takePhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.userInteractionEnabled=YES;
    alphabetView.canvas.userInteractionEnabled=NO;
    letterView.canvas.userInteractionEnabled=NO;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    changeLanguage.canvas.userInteractionEnabled=NO;

}
-(void)goToLetterView{
    C4Log(@"LetterView");
    [letterView setup];
    [letterView displayLetter:alphabetView.LetterTouched currentAlphabet:currentAlphabet];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=YES;
    alphabetView.canvas.hidden=YES;
    letterView.canvas.hidden=NO;
    alphabetInfo.canvas.hidden=YES;
    changeLanguage.canvas.hidden=YES;
    
    takePhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.userInteractionEnabled=NO;
    alphabetView.canvas.userInteractionEnabled=NO;
    letterView.canvas.userInteractionEnabled=YES;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    changeLanguage.canvas.userInteractionEnabled=NO;
}
-(void)goToAlphabetInfo{
    C4Log(@"AlphabetInfo");
    [alphabetInfo setup];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=YES;
    alphabetView.canvas.hidden=YES;
    letterView.canvas.hidden=YES;
    alphabetInfo.canvas.hidden=NO;
    changeLanguage.canvas.hidden=YES;
    
    takePhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.userInteractionEnabled=NO;
    alphabetView.canvas.userInteractionEnabled=NO;
    letterView.canvas.userInteractionEnabled=NO;
    alphabetInfo.canvas.userInteractionEnabled=YES;
    changeLanguage.canvas.userInteractionEnabled=NO;
}
-(void)goToChangeLanguage{
    C4Log(@"ChangeLanguage");
    [changeLanguage setup];
    takePhoto.canvas.hidden=YES;
    cropPhoto.canvas.hidden=YES;
    assignLetter.canvas.hidden=YES;
    alphabetView.canvas.hidden=YES;
    letterView.canvas.hidden=YES;
    alphabetInfo.canvas.hidden=YES;
    changeLanguage.canvas.hidden=NO;
    
    takePhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.userInteractionEnabled=NO;
    alphabetView.canvas.userInteractionEnabled=NO;
    letterView.canvas.userInteractionEnabled=NO;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    changeLanguage.canvas.userInteractionEnabled=YES;

}

@end
