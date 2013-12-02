//
//  C4WorkSpace.m
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//

#import "C4Workspace.h"

@implementation C4WorkSpace

-(void)setup {
    [self loadDefaultAlphabet]; //loads default alphabet (all languages in 1 array) + sets up current alphabet as finnish
    fullCanvas=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    self.previousView=@"TakePhoto";
    
    //change default styles as needd
    [self setupDefaultStyles];
    
    //create all the views
    [self createViews];
    
    //all the notificationListeners
    [self listenNotifications];
    
    //initialize the grey grid used for assignPhoto and AlphabetView
    [self initGreyGrid];
}
-(void)listenNotifications{
    //changing views
    [self listenFor:@"goToCropPhoto" andRunMethod:@"goToCropPhoto"];
    [self listenFor:@"goToTakePhoto" andRunMethod:@"goToTakePhoto"];
    [self listenFor:@"goToAssignPhoto" andRunMethod:@"goToAssignPhoto"];
    [self listenFor:@"goToAlphabetsView" andRunMethod:@"goToAlphabetsView"];
    [self listenFor:@"goToLetterView" andRunMethod:@"goToLetterView"];
    [self listenFor:@"goToAlphabetInfo" andRunMethod:@"goToAlphabetInfo"];
    [self listenFor:@"goToChangeLanguage" andRunMethod:@"goToChangeLanguage"];
    [self listenFor:@"goToWritePostcard" andRunMethod:@"goToWritePostcard"];
    [self listenFor:@"goToPostcardView" andRunMethod:@"goToPostcardView"];

    
    //listen if current alphabet was changed
    [self listenFor:@"currentAlphabetChanged" andRunMethod:@"currentAlphabetChanged"];
    //navigating back from alphabet view to assign letter > the image input needs to be deleted
    [self listenFor:@"goToAssignLetter" andRunMethod:@"goToAssignLetter"];
    //when language changed save it in the default settings
    [self listenFor:@"languageChanged" andRunMethod:@"languageChanged"];
    
    //when displaying the alphabet, save it as an image used in case user wants to save that alphabet as an image
    [self listenFor:@"saveCurrentAlphabetAsImage" andRunMethod:@"saveCurrentAlphabetAsImage"];
    [self listenFor:@"saveCurrentPostcardAsImage" andRunMethod:@"saveCurrentPostcardAsImage"];
    
    //listen for postcard ended editing
    [self listenFor:@"editingPostcardDone" andRunMethod:@"editingPostcardDone"];
}


//--------------------------------------------------
//CREATE VIEWS
//--------------------------------------------------
-(void)createViews{
    [self setupTakePhoto];
    [self setupCropPhoto];
    [self setupAssignLetter];
    [self setupAlphabetView];
    [self setupLetterView];
    [self setupAlphabetInfo];
    [self setupChangeLanguage];
    [self setupWritePostcard];
    [self setupPostcardView];
    

}
-(void)setupTakePhoto{
    takePhoto=[TakePhoto new];
    takePhoto.canvas.frame=fullCanvas;
    takePhoto.canvas.userInteractionEnabled=YES;
    [takePhoto setupWithPreviousView];
    [takePhoto cameraSetup];
    [self.canvas addSubview:takePhoto.canvas];
}
-(void)setupCropPhoto{
    cropPhoto=[CropPhoto new];
    cropPhoto.canvas.frame=fullCanvas;
    cropPhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.hidden=YES;
    [self.canvas addSubview:cropPhoto.canvas];
    
}
-(void)setupAssignLetter{
    assignLetter=[AssignLetter new];
    assignLetter.canvas.frame=fullCanvas;
    assignLetter.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.hidden=YES;
    [self.canvas addSubview:assignLetter.canvas];
}
-(void)setupAlphabetView{
    alphabetView=[AlphabetView new];
    alphabetView.canvas.frame=fullCanvas;
    alphabetView.canvas.userInteractionEnabled=NO;
    alphabetView.canvas.hidden=YES;
    [self.canvas addSubview:alphabetView.canvas];
}
-(void)setupLetterView{
    letterView=[LetterView new];
    letterView.canvas.frame=fullCanvas;
    letterView.canvas.hidden=YES;
    letterView.canvas.userInteractionEnabled=NO;
    [self.canvas addSubview:letterView.canvas];
}
-(void)setupAlphabetInfo{
    alphabetInfo=[AlphabetInfo new];
    alphabetInfo.canvas.frame=fullCanvas;
    alphabetInfo.canvas.hidden=YES;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    [self.canvas addSubview:alphabetInfo.canvas];
}
-(void)setupChangeLanguage{
    changeLanguage=[ChangeLanguage new];
    changeLanguage.canvas.frame=fullCanvas;
    changeLanguage.canvas.hidden=YES;
    changeLanguage.canvas.userInteractionEnabled=NO;
    [self.canvas addSubview:changeLanguage.canvas];
}
-(void)setupWritePostcard{
    writePostcard=[WritePostcard new];
    writePostcard.canvas.frame=fullCanvas;
    writePostcard.canvas.hidden=YES;
    writePostcard.canvas.userInteractionEnabled=NO;
    [self.canvas addSubview:writePostcard.canvas];
}
-(void)setupPostcardView{
    postcardView=[PostcardView new];
    postcardView.canvas.frame=fullCanvas;
    postcardView.canvas.hidden=YES;
    postcardView.canvas.userInteractionEnabled=NO;
    [self.canvas addSubview:postcardView.canvas];
}
//--------------------------------------------------
//NAVIGATION FUNCTIONS
//--------------------------------------------------
-(void)hideAll{
    takePhoto.canvas.hidden=YES;
    takePhoto.canvas.userInteractionEnabled=NO;
    
    cropPhoto.canvas.hidden=YES;
    cropPhoto.canvas.userInteractionEnabled=NO;
    
    assignLetter.canvas.hidden=YES;
    assignLetter.canvas.userInteractionEnabled=NO;
    
    alphabetView.canvas.hidden=YES;
    alphabetView.canvas.userInteractionEnabled=NO;
    
    letterView.canvas.hidden=YES;
    letterView.canvas.userInteractionEnabled=NO;
    
    alphabetInfo.canvas.hidden=YES;
    alphabetInfo.canvas.userInteractionEnabled=NO;
    
    changeLanguage.canvas.hidden=YES;
    changeLanguage.canvas.userInteractionEnabled=NO;
    
    writePostcard.canvas.hidden=YES;
    writePostcard.canvas.userInteractionEnabled=NO;
    
    postcardView.canvas.hidden=YES;
    postcardView.canvas.userInteractionEnabled=NO;
}
-(void)goToTakePhoto{
    [self hideAll];
    [takePhoto setupWithPreviousView];
    
    takePhoto.canvas.hidden=NO;
    takePhoto.canvas.userInteractionEnabled=YES;

}
-(void)goToCropPhoto{
    [self hideAll];

    [cropPhoto displayImage:takePhoto.img];
    [cropPhoto setup];
    
    cropPhoto.canvas.hidden=NO;
    cropPhoto.canvas.userInteractionEnabled=YES;

}
-(void)goToAssignPhoto{
    [self hideAll];
    C4Log(@"assignPhoto");
    [assignLetter setup:cropPhoto.croppedPhoto withAlphabet:self.currentAlphabet withGreyGrid: greyRectArray];
    
    assignLetter.canvas.hidden=NO;
    assignLetter.canvas.userInteractionEnabled=YES;
}
-(void)goToAssignLetter{
    [self hideAll];
    C4Log(@"assignPhotoDeletingOne Image");
    //replacing the image that was just put in
    C4Image *imageToSend=[self.currentAlphabet objectAtIndex: assignLetter.chosenImageNumberInArray];
    [self.currentAlphabet removeObjectAtIndex:assignLetter.chosenImageNumberInArray];
    [self.currentAlphabet insertObject:imageToSend atIndex:assignLetter.chosenImageNumberInArray];
    
    [assignLetter setup:cropPhoto.croppedPhoto withAlphabet:self.currentAlphabet withGreyGrid:greyRectArray];
    
    assignLetter.canvas.hidden=NO;
    assignLetter.canvas.userInteractionEnabled=YES;
}
-(void)goToAlphabetsView{
    [self hideAll];
    C4Log(@"alphabetView");
    
    [alphabetView setup:self.currentAlphabet withGrid:greyRectArray withLanguage:self.currentLanguage];
    alphabetView.canvas.hidden=NO;
    alphabetView.canvas.userInteractionEnabled=YES;
    
}
-(void)goToLetterView{
    [self hideAll];
    C4Log(@"LetterView");
    //C4Log(@"letterTouched:%i", alphabetView.letterTouched);
    [letterView setupWithLetterNo: alphabetView.letterTouched currentAlphabet:self.currentAlphabet];
    letterView.canvas.hidden=NO;
    letterView.canvas.userInteractionEnabled=YES;
}
-(void)goToAlphabetInfo{
    [self hideAll];
    C4Log(@"alphabetInfo");
    [alphabetInfo setupWithLanguage:self.currentLanguage];
    alphabetInfo.canvas.hidden=NO;
    alphabetInfo.canvas.userInteractionEnabled=YES;
}
-(void)goToChangeLanguage{
    [self hideAll];
    C4Log(@"changeLanguage");
    [changeLanguage setupWithLanguage:self.currentLanguage];
    changeLanguage.canvas.hidden=NO;
    changeLanguage.canvas.userInteractionEnabled=YES;

}
-(void)goToWritePostcard{
    [self hideAll];
    C4Log(@"writePostcard");
    [writePostcard setupWithLanguage: self.currentLanguage Alphabet:self.currentAlphabet];
    writePostcard.canvas.hidden=NO;
    writePostcard.canvas.userInteractionEnabled=YES;
}
-(void)goToPostcardView{
    [self hideAll];
    C4Log(@"PostcardView");
    [postcardView setupWithPostcard: writePostcard.postcardArray Rect: writePostcard.greyRectArray withLanguage:self.currentLanguage withPostcardText:writePostcard.postcardText];
    
    postcardView.canvas.hidden=NO;
    postcardView.canvas.userInteractionEnabled=YES;
}
//--------------------------------------------------
//OTHER STUFF
//--------------------------------------------------
-(void)currentAlphabetChanged{
    C4Log(@"current alphabet changed");
    self.currentAlphabet=[assignLetter.currentAlphabet mutableCopy];
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
-(void)saveCurrentPostcardAsImage{
    CGFloat scale = 10.0;
    
    //begin an image context
    CGSize  rect=CGSizeMake(self.canvas.width, self.canvas.height);
    UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
    
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //render the original image into the context
    [postcardView.canvas renderInContext:c];
    
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end the image context
    UIGraphicsEndImageContext();
    
    //create a new C4Image
    postcardView.currentPostcardImage = [C4Image imageWithUIImage:newUIImage];
    
}
-(void)initGreyGrid{
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
        //[self.canvas addShape:greyRect];
    }
}
-(void)editingPostcardDone{
   // self.postcardText=writePostcard.postcardText;
}
//--------------------------------------------------
//SETUP VERY BASIC STUFF (STYLES, ALPHABET, changing langauges)
//--------------------------------------------------
-(void)setupDefaultStyles{
    //label
    [C4Label defaultStyle].textColor = UA_GREY_TYPE_COLOR;
    //shape
    [C4Shape defaultStyle].lineWidth=0;
    [C4Shape defaultStyle].fillColor=UA_NAV_BAR_COLOR;
}
-(void)loadDefaultAlphabet{
    self.currentAlphabet=[NSMutableArray arrayWithObjects:
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
    
    //self.currentAlphabet=[[NSMutableArray alloc]init];
    //for (int i=0; i<42; i++) {
    //    C4Image *currentImage=[self.defaultAlphabet objectAtIndex:i];
    //    [self.currentAlphabet addObject:currentImage];
    //}
    self.currentLanguage=@"Finnish/Swedish";
    self.oldLanguage=self.currentLanguage;
    //C4Log(@"currentAlphabetLength:%@", [self.currentAlphabet count]);
}
-(void)languageChanged{
    C4Log(@"languageChanged");

    //get the new language
    self.currentLanguage=changeLanguage.chosenLanguage;
    C4Log(@"currentLanguage: %@", self.currentLanguage);
    C4Log(@"    oldLanguage: %@", self.oldLanguage);

    //Finnish>german
    if ([self.currentLanguage isEqual:@"German"] && [self.oldLanguage isEqual:@"Finnish/Swedish"]) {
        C4Log(@"change Finnish to German");
        //change Å to Ü
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //Finnish>Danish
    if ([self.currentLanguage isEqual:@"Danish/Norwegian"] && [self.oldLanguage isEqual:@"Finnish/Swedish"]) {
        C4Log(@"change Finnish to Danish");
        //change Ä to AE
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö to danishO
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
    }
    //Finnish>English
    if ([self.currentLanguage isEqual:@"English"] && [self.oldLanguage isEqual:@"Finnish/Swedish"]) {
        C4Log(@"change Finnish to English");
        //change Ä to +
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_+.png"] atIndex:26];
        //change Ö to $
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_$.png"] atIndex:27];
        //change Å to ,
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_,.png"] atIndex:28];
    }
    //German>Finnish
    if ([self.currentLanguage isEqual:@"Finnish/Swedish"] && [self.oldLanguage isEqual:@"German"]) {
        C4Log(@"change German to Finnish");
        //change Ü to Å
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //Danish/Finnish
    if ([self.currentLanguage isEqual:@"Finnish/Swedish"] && [self.oldLanguage isEqual:@"Danish/Norwegian"]) {
        C4Log(@"change Danish to Finnish");
        //change Ä to AE
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö to danishO
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
    }
    //English>Finnish
    if ([self.currentLanguage isEqual:@"Finnish/Swedish"] && [self.oldLanguage isEqual:@"English"]) {
        C4Log(@"change English to Finnish");
        //change Ä to +
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö to $
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
        //change Å to ,
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //German>English
    if ([self.currentLanguage isEqual:@"English"] && [self.oldLanguage isEqual:@"German"]) {
        C4Log(@"change Finnish to English");
        //change Ä to +
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_+.png"] atIndex:26];
        //change Ö to $
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_$.png"] atIndex:27];
        //change Å to ,
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_,.png"] atIndex:28];
    }
    //Danish>English
    if ([self.currentLanguage isEqual:@"English"] && [self.oldLanguage isEqual:@"Danish/Norwegian"]) {
        C4Log(@"change Finnish to English");
        //change Ä to +
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_+.png"] atIndex:26];
        //change Ö to $
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_$.png"] atIndex:27];
        //change Å to ,
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_,.png"] atIndex:28];
    }
    //English>German
    if ([self.currentLanguage isEqual:@"German"] && [self.oldLanguage isEqual:@"English"]) {
        C4Log(@"change English to German");
        //change Ä
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
        //change Å to ,
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //English>Danish
    if ([self.currentLanguage isEqual:@"Danish/Norwegian"] && [self.oldLanguage isEqual:@"English"]) {
        C4Log(@"change English to Danish");
        //change Ä
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
        //change Å to ,
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //German>Danish
    if ([self.currentLanguage isEqual:@"Danish/Norwegian"] && [self.oldLanguage isEqual:@"German"]) {
        C4Log(@"change English to Danish");
        //change Ä
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_ae.png"] atIndex:26];
        //change Ö
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_danisho.png"] atIndex:27];
        //change Å to ,
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Å.png"] atIndex:28];
    }
    //Danish>German
    if ([self.currentLanguage isEqual:@"German"] && [self.oldLanguage isEqual:@"Danish/Norwegian"]) {
        C4Log(@"change Danish to German");
        //change Ä
        [self.currentAlphabet removeObjectAtIndex:26];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ä.png"] atIndex:26];
        //change Ö
        [self.currentAlphabet removeObjectAtIndex:27];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ö.png"] atIndex:27];
        //change Å to ,
        [self.currentAlphabet removeObjectAtIndex:28];
        [self.currentAlphabet insertObject:[C4Image imageNamed:@"letter_Ü.png"] atIndex:28];
    }
    //lastly for the next change set old to new alphabet
    self.oldLanguage=self.currentLanguage;
    
}

@end
