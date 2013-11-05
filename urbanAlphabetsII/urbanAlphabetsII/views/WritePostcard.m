//
//  WritePostcard.m
//  urbanAlphabetsII
//
//  Created by Suse on 31/10/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "WritePostcard.h"

@implementation WritePostcard

-(void)transferVariables:(int) number topBarFromTop:(float)TopBarFromTopDefault topBarHeight:(float)TopNavBarHeightDefault bottomBarHeight:(float)BottomBarHeightDefault navBarColor:(UIColor*)navBarColorDefault navigationColor:(UIColor*)navigationColorDefault typeColor:(UIColor*)typeColorDefault  darkenColor:(UIColor*)darkenColorDefault fatFont:(C4Font*)fatFontDefault normalFont:(C4Font*)normalFontDefault backImage:(C4Image*)iconBackDefault iconClose:(C4Image*)iconCloseDefault emptyLetter:(C4Image*)emptyLetterDefault iconMenu:(C4Image*)iconMenuDefault takePhoto:(C4Image*)iconTakePhotoDefault iconAlphabetInfo:(C4Image*)iconAlphabetInfoDefault iconShareAlphabet:(C4Image*)iconSharePostcardDefault iconWritePostcard:(C4Image*)iconWritePostcardDefault iconMyPostcards:(C4Image*)iconMyPostcardsDefault iconMyAlphabets:(C4Image*)iconMyAlphabetsDefault iconSaveImage:(C4Image*)iconSaveAlphabetDefault{
    
    //nav bar heights
    topBarFromTop=TopBarFromTopDefault;
    topBarHeight=TopNavBarHeightDefault;
    bottomBarHeight=BottomBarHeightDefault;
    
    //colors
    navBarColor=navBarColorDefault;
    navigationColor=navigationColorDefault;
    typeColor=typeColorDefault;
    buttonColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    darkenColor=darkenColorDefault;
    whiteColor=buttonColor;
    
    //fonts
    fatFont=fatFontDefault;
    normalFont=normalFontDefault;
    
    //icons
    iconClose=iconCloseDefault;
    iconBack=iconBackDefault;
    iconMenu =iconMenuDefault;
    iconTakePhoto=iconTakePhotoDefault;
    iconAlphabetInfo=iconAlphabetInfoDefault;
    iconSharePostcard=iconSharePostcardDefault;
    iconWritePostcard=iconWritePostcardDefault;
    iconMyPostcards=iconMyPostcardsDefault;
    iconMyAlphabets=iconMyAlphabetsDefault;
    iconSaveAlphabet=iconSaveAlphabetDefault;
    
    //setup postcard as empty
    postcardArray=[[NSMutableArray alloc]init];
    greyRectArray=[[NSMutableArray alloc]init];


    emptyLetter=[C4Image imageWithImage:emptyLetterDefault];
    maxPostcardLength=24;
}
-(void)setup:(NSMutableArray*)passedAlphabet currentLanguage:(NSString*)passedLanguage{
    //setup postcard as empty
    postcardArray=[[NSMutableArray alloc]init];
    greyRectArray=[[NSMutableArray alloc]init];

    //remove image that might remain there from before
    if ([postcardArray count]!=0) {
        [postcardArray removeAllObjects];
    }

    currentAlphabet=[passedAlphabet copy];
    currentLanguage=[passedLanguage copy];
    
    background=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, self.canvas.height)];
    background.fillColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    background.lineWidth=0;
    [self.canvas addShape:background];

    
    [self topBarSetup];
    [self setupTextField];
    [self setupKeyboardBar];

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
    titleLabel = [C4Label labelWithText:@"Write Postcard" font:fatFont];
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
    //--------------------------------------------------
    //RIGHT
    //--------------------------------------------------
    //close icon
    closeButtonImage=iconClose;
    closeButtonImage.width= 25;
    closeButtonImage.center=CGPointMake(self.canvas.width-18, topNavBar.center.y);
    [self.canvas addImage:closeButtonImage];
    
    //invisible rect to interact with
    closeRect=[C4Shape rect:CGRectMake(self.canvas.width-35, topBarFromTop, 35, topNavBar.height)];
    closeRect.fillColor=navigationColor;
    closeRect.lineWidth=0;
    [self.canvas addShape:closeRect];
    [self listenFor:@"touchesBegan" fromObject:closeRect andRunMethod:@"navigateBack"];
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
-(void)removeBottomBar{
    [bottomNavBar removeFromSuperview];
    [menuButtonImage removeFromSuperview];
    [takePhotoButton removeFromSuperview];
    
    [self stopListeningFor:@"touchesBegan" objects:@[menuButtonImage, takePhotoButton]];
}
-(void)setupTextField{
    CGRect textViewFrame = CGRectMake(20.0f, topBarFromTop+topBarHeight+10, self.canvas.width-40, 124.0f);
    textViewTest = [[UITextView alloc] initWithFrame:textViewFrame];
    textViewTest.returnKeyType = UIReturnKeyDone;
    [textViewTest becomeFirstResponder];
    textViewTest.delegate = self;
    textViewTest.hidden=true;

    [self.view addSubview:textViewTest];
    NSLog(@"setupTextFieldDone");
}
//------------------------------------------------------------------------
//DISPLAY POSTCARD
//------------------------------------------------------------------------
-(void)displayPostcard{
    if([postcardArray count]<maxPostcardLength){
        [self addLetterToPostcard];}
    
    C4Log(@"postCardArrayLength:%i", [postcardArray count]);
    
    float imageWidth=53.53;
    float imageHeight=65.1;
    
    if (![newCharacter  isEqual:@""]) { //if something was added
        //draw only the last letter
        NSInteger lastLetter=[postcardArray count]-1;
        float xMultiplier=(lastLetter)%6;
        float yMultiplier= (lastLetter)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
        C4Image *image=[postcardArray objectAtIndex:lastLetter ];
        
        //trying to split the string into words
        NSMutableString *theString=[[NSMutableString alloc]init];
        [theString setString:entireText];
        [theString appendString:newCharacter];
        C4Log(@"theString:%@", theString);
        NSArray *words=[theString componentsSeparatedByString:@" "];
        //how many words
        C4Log(@"number of words found: %i", [words count]);
        //how many characters in the whole string
        NSInteger numberOfCharacters=[theString length];
        C4Log(@"number of characters :  %i", numberOfCharacters);
        
        //number of rows
        float numberOfRows=numberOfCharacters/6+1;
        C4Log(@"number of rows       :  %f", numberOfRows);

        /*if ([words count]>1) { //only if at least 2 words
            NSInteger lengthTillNow=0;
            for (int i=1; i<[words count]; i++) {
                NSInteger length1=[[words objectAtIndex:i-1]length];
                NSInteger length2=[[words objectAtIndex:i]length];
                C4Log(@"length of word1 %i = %i",i, length1);
                C4Log(@"length of word2 %i = %i",i, length2);
                if (length1+length2>=6) {
                    C4Log(@"!!!!!!linebreak %i !!!!!!", i);
                    int rotator=0;
                    //for (int j=[postcardArray count]-length2; j<[postcardArray count]; j++) {
                    for (int j=lengthTillNow+length1+i; j<[postcardArray count]; j++) {
                        C4Image *imageRemove=[postcardArray objectAtIndex:j];
                        [imageRemove removeFromSuperview];
                        xMultiplier=(rotator)%6;
                        yMultiplier= (rotator)/6+i;
                        xPos=xMultiplier*imageWidth;
                        yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
                        rotator++;
                        C4Image *imageToAdd=[postcardArray objectAtIndex:j];
                        imageToAdd.origin=CGPointMake(xPos, yPos);
                        imageToAdd.width=imageWidth;
                        [self.canvas addImage:imageToAdd];
                        lengthTillNow+=length1;
                    }
                }
            }
            
        }*/
        //________________________________________________________________________
        //this still does not work properly but I give up for now.... (BEGIN)
        //________________________________________________________________________
        //for 2 words + rows
        if ([words count]>1) { //only if at least 2 words
            int i=1;
            NSInteger length1=[[words objectAtIndex:i-1]length];
            NSInteger length2=[[words objectAtIndex:i]length];
            C4Log(@"length of word1 %i = %i",i, length1);
            C4Log(@"length of word2 %i = %i",i, length2);
            //2 words on first row
            if (length1+length2>=6) {
                C4Log(@"!!!!!!2 words in first row >linebreak to second!!!!!!");
                int rotator=0;
                for (int j=length1+i; j<[postcardArray count]; j++) {
                    //remove
                    C4Image *imageRemove=[postcardArray objectAtIndex:j];
                    [imageRemove removeFromSuperview];
                    
                    C4Shape *greyRectRemove=[greyRectArray objectAtIndex:j ];
                    [greyRectRemove removeFromSuperview];
                    
                    //add
                    xMultiplier=(rotator)%6;
                    yMultiplier= (rotator)/6+i;
                    xPos=xMultiplier*imageWidth;
                    yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
                    rotator++;
                    C4Image *imageToAdd=[postcardArray objectAtIndex:j];
                    imageToAdd.origin=CGPointMake(xPos, yPos);
                    imageToAdd.width=imageWidth;
                    
                    [self.canvas addImage:imageToAdd];
                    C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
                    greyRect.fillColor=navigationColor;
                    greyRect.lineWidth=2;
                    greyRect.strokeColor=navBarColor;
                    [greyRectArray addObject:greyRect];
                    [self.canvas addShape:greyRect];
                }
                //for 2nd and 3rd word, linebreak to 3rd rows
                if ([words count]>2) { //only if at least 3 words
                    int i=2;
                    NSInteger length1=[[words objectAtIndex:i-1]length];
                    NSInteger length2=[[words objectAtIndex:i]length];
                    C4Log(@"length of word1 %i = %i",i, length1);
                    C4Log(@"length of word2 %i = %i",i, length2);
                    if (length1+length2>=6) {
                        C4Log(@"!!!!!!3 words >linebreak to 3rd row!!!!!!");
                        int rotator=0;
                        NSInteger lengthFirstWord=[[words objectAtIndex:0]length];
                        //for (int j=[postcardArray count]-length2; j<[postcardArray count]; j++) {
                        for (int j=lengthFirstWord+length1+i; j<[postcardArray count]; j++) {
                            C4Image *imageRemove=[postcardArray objectAtIndex:j];
                            [imageRemove removeFromSuperview];
                            C4Shape *greyRectRemove=[greyRectArray objectAtIndex:j ];
                            [greyRectRemove removeFromSuperview];
                            
                            xMultiplier=(rotator)%6;
                            yMultiplier= (rotator)/6+2;
                            xPos=xMultiplier*imageWidth;
                            yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
                            rotator++;
                            C4Image *imageToAdd=[postcardArray objectAtIndex:j];
                            imageToAdd.origin=CGPointMake(xPos, yPos);
                            imageToAdd.width=imageWidth;
                            [self.canvas addImage:imageToAdd];
                        }
                        //for 3nd and 4rd word, linebreak to 4rd rows
                        if ([words count]>3) { //only if at least 3 words
                            int i=3;
                            NSInteger length1=[[words objectAtIndex:i-1]length];
                            NSInteger length2=[[words objectAtIndex:i]length];
                            C4Log(@"length of word1 %i = %i",i, length1);
                            C4Log(@"length of word2 %i = %i",i, length2);
                            if (length1+length2>=6) {
                                C4Log(@"!!!!!!4 words > linebreak to 4th row!!!!!!");
                                int rotator=0;
                                NSInteger lengthFirstWord=[[words objectAtIndex:0]length]+[[words objectAtIndex:1]length];
                                //for (int j=[postcardArray count]-length2; j<[postcardArray count]; j++) {
                                for (int j=lengthFirstWord+length1+i; j<[postcardArray count]; j++) {
                                    C4Image *imageRemove=[postcardArray objectAtIndex:j];
                                    [imageRemove removeFromSuperview];
                                    C4Shape *greyRectRemove=[greyRectArray objectAtIndex:j ];
                                    [greyRectRemove removeFromSuperview];
                                    
                                    xMultiplier=(rotator)%6;
                                    yMultiplier= (rotator)/6+i;
                                    xPos=xMultiplier*imageWidth;
                                    yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
                                    rotator++;
                                    C4Image *imageToAdd=[postcardArray objectAtIndex:j];
                                    imageToAdd.origin=CGPointMake(xPos, yPos);
                                    imageToAdd.width=imageWidth;
                                    [self.canvas addImage:imageToAdd];
                                }
                            }
                        }
                    }
                }
            }
            else //meaning that 3rd word will also begin in this line
            {
                if ([words count]>2 && [[words objectAtIndex:0]length]+[[words objectAtIndex:1]length]<6) {//only if a third word exists we need a linebreak
                    int i=2;
                    NSInteger length1=[[words objectAtIndex:i-1]length]+[[words objectAtIndex:i-2]length]+1; //first and second word length together + 1 space
                    NSInteger length2=[[words objectAtIndex:i]length];
                    C4Log(@"length of word1 %i = %i",i, length1);
                    C4Log(@"length of word2 %i = %i",i, length2);
                    if (length1+length2>=6) {
                        C4Log(@"!!!!!!3 words in first row > linebreak to 2nd!!!!!!");
                        int rotator=0;
                        for (int j=length1+1; j<[postcardArray count]; j++) {
                            C4Image *imageRemove=[postcardArray objectAtIndex:j];
                            [imageRemove removeFromSuperview];
                            C4Shape *greyRectRemove=[greyRectArray objectAtIndex:j ];
                            [greyRectRemove removeFromSuperview];
                            
                            xMultiplier=(rotator)%6;
                            yMultiplier= (rotator)/6+i-1;
                            xPos=xMultiplier*imageWidth;
                            yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
                            rotator++;
                            C4Image *imageToAdd=[postcardArray objectAtIndex:j];
                            imageToAdd.origin=CGPointMake(xPos, yPos);
                            imageToAdd.width=imageWidth;
                            [self.canvas addImage:imageToAdd];
                        }
                    }
                }
                //first row has 3 words, 2nd row has 2 words
                if ([words count]>3 && [[words objectAtIndex:0]length]+[[words objectAtIndex:1]length]<6) {
                    int i=3;
                    NSInteger length3=[[words objectAtIndex:i-1]length]+1; //3rd word length+1 space
                    NSInteger length2=[[words objectAtIndex:i]length];
                    C4Log(@"length of word1 %i = %i",i, length3);
                    C4Log(@"length of word2 %i = %i",i, length2);
                    if (length3+length2>6) {
                        C4Log(@"!!!!!!3 words in first row, 2 words in second row > linebreak to 3rd!!!!!!");
                        int rotator=0;
                        for (int j=[postcardArray count]-length2; j<[postcardArray count]; j++) {
                            C4Image *imageRemove=[postcardArray objectAtIndex:j];
                            [imageRemove removeFromSuperview];
                            C4Shape *greyRectRemove=[greyRectArray objectAtIndex:j ];
                            [greyRectRemove removeFromSuperview];
                            
                            xMultiplier=(rotator)%6;
                            yMultiplier= (rotator)/6+i-1;
                            xPos=xMultiplier*imageWidth;
                            yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
                            rotator++;
                            C4Image *imageToAdd=[postcardArray objectAtIndex:j];
                            imageToAdd.origin=CGPointMake(xPos, yPos);
                            imageToAdd.width=imageWidth;
                            [self.canvas addImage:imageToAdd];
                        }
                    }
                }
            }
            //if 2 words on first line + 3 words on second line
            if ([words count]>4 && [[words objectAtIndex:2]length]+[[words objectAtIndex:3]length]<6) {//only if a 5th word exists we need a linebreak
                //C4Log(@"5 words");
                int i=4;
                NSInteger length3=[[words objectAtIndex:i-1]length]+[[words objectAtIndex:i-2]length]+1; //third and fourth word length together + 1 space
                NSInteger length2=[[words objectAtIndex:i]length];
                C4Log(@"length of word1 %i = %i",i, length3);
                C4Log(@"length of word2 %i = %i",i, length2);
                if (length3+length2>=6) {
                    C4Log(@"!!!!!!2 words in first row, 3 words in second row > linebreak to 3rd!!!!!!");
                    int rotator=0;
                    for (int j=[postcardArray count]-length2; j<[postcardArray count]; j++) {
                        C4Image *imageRemove=[postcardArray objectAtIndex:j];
                        [imageRemove removeFromSuperview];
                        C4Shape *greyRectRemove=[greyRectArray objectAtIndex:j ];
                        [greyRectRemove removeFromSuperview];
                        
                        xMultiplier=(rotator)%6;
                        yMultiplier= (rotator)/6+i-2;
                        xPos=xMultiplier*imageWidth;
                        yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
                        rotator++;
                        C4Image *imageToAdd=[postcardArray objectAtIndex:j];
                        imageToAdd.origin=CGPointMake(xPos, yPos);
                        imageToAdd.width=imageWidth;
                        [self.canvas addImage:imageToAdd];
                    }
                }
                
            }
            //if 1 word on first line + 3 words on second line
            if ([words count]>3 && [[words objectAtIndex:0]length]>=5 &&[[words objectAtIndex:1]length]+[[words objectAtIndex:2]length]<6) {//4 words, first words has at least 5 characters, 2nd+3rd shorter than 6
                C4Log(@"4 words");
                int i=3;
                NSInteger length3=[[words objectAtIndex:i-1]length]+[[words objectAtIndex:i-2]length]+1; //2nd and 3rd word length together + 1 space
                NSInteger length2=[[words objectAtIndex:i]length];
                C4Log(@"length of word1 %i = %i",i, length3);
                C4Log(@"length of word2 %i = %i",i, length2);
                if (length3+length2>=6) {
                    C4Log(@"!!!!!!1 word in first row, 3 words in 2nd row > linebreak to 3rd!!!!!!");
                    int rotator=0;
                    for (int j=[postcardArray count]-length2; j<[postcardArray count]; j++) {
                        C4Image *imageRemove=[postcardArray objectAtIndex:j];
                        [imageRemove removeFromSuperview];
                        C4Shape *greyRectRemove=[greyRectArray objectAtIndex:j ];
                        [greyRectRemove removeFromSuperview];
                        
                        xMultiplier=(rotator)%6;
                        yMultiplier= (rotator)/6+i-1;
                        xPos=xMultiplier*imageWidth;
                        yPos=topBarFromTop+topBarHeight+yMultiplier*imageHeight;
                        rotator++;
                        C4Image *imageToAdd=[postcardArray objectAtIndex:j];
                        imageToAdd.origin=CGPointMake(xPos, yPos);
                        imageToAdd.width=imageWidth;
                        [self.canvas addImage:imageToAdd];
                    }
                }
            }
        }
        //________________________________________________________________________
        //this still does not work properly but I give up for now.... (END)
        //________________________________________________________________________
        

        //ends here
        
        
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=navigationColor;
        greyRect.lineWidth=2;
        greyRect.strokeColor=navBarColor;
        [greyRectArray addObject:greyRect];
        [self.canvas addShape:greyRect];
    }
    
    

}
-(void)addLetterToPostcard{
    if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 0]];
        [postcardArray addObject: image];
    } else if ([newCharacter isEqual: @"b"]||[newCharacter isEqual: @"B"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 1]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"c"]||[newCharacter isEqual: @"C"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 2]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"d"]||[newCharacter isEqual: @"D"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 3]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"e"]||[newCharacter isEqual: @"E"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 4]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"f"]||[newCharacter isEqual: @"F"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 5]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"g"]||[newCharacter isEqual: @"G"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 6]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"h"]||[newCharacter isEqual: @"H"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 7]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"i"]||[newCharacter isEqual: @"I"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 8]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"j"]||[newCharacter isEqual: @"J"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 9]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"k"]||[newCharacter isEqual: @"K"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 10]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"l"]||[newCharacter isEqual: @"L"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 11]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"m"]||[newCharacter isEqual: @"M"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 12]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"n"]||[newCharacter isEqual: @"N"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 13]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"o"]||[newCharacter isEqual: @"O"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 14]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"p"]||[newCharacter isEqual: @"P"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 15]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"q"]||[newCharacter isEqual: @"Q"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 16]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"r"]||[newCharacter isEqual: @"R"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 17]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"s"]||[newCharacter isEqual: @"S"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 18]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"t"]||[newCharacter isEqual: @"T"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 19]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"u"]||[newCharacter isEqual: @"U"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 20]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"v"]||[newCharacter isEqual: @"V"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 21]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"w"]||[newCharacter isEqual: @"W"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 22]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"x"]||[newCharacter isEqual: @"X"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 23]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"y"]||[newCharacter isEqual: @"Y"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 24]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"z"]||[newCharacter isEqual: @"Z"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 25]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"ä"]||[newCharacter isEqual: @"Ä"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 26]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"ö"]||[newCharacter isEqual: @"Ö"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 27]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"å"]||[newCharacter isEqual: @"Å"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 28]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"."]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 29]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"!"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 30]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"?"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 31]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"0"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 32]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"1"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 33]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"2"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 34]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"3"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 35]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"4"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 36]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"5"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 37]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"6"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 38]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"7"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 39]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"8"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 40]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"9"]){
        C4Image *image=[C4Image imageWithImage:[currentAlphabet objectAtIndex: 41]];
        [postcardArray addObject: image];
    }else if ([newCharacter isEqual: @" "]){ //space is displaying an empty letter
        C4Image *image=[C4Image imageWithImage:emptyLetter];
        [postcardArray addObject: image];
    }else if([newCharacter isEqual: @""] && [postcardArray count]>1){//remove last letter if delete button is pressed
        C4Image *image=[postcardArray objectAtIndex:[postcardArray count]-1];
        [image removeFromSuperview];
        [postcardArray removeLastObject];
        C4Shape *greyRectRemove=[greyRectArray objectAtIndex:[greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [greyRectArray removeObjectAtIndex:[greyRectArray count]-1];
    }else if([newCharacter isEqual: @""] && [postcardArray count]==1){//remove last letter if delete button is pressed
        C4Image *image=[postcardArray objectAtIndex:0];
        [image removeFromSuperview];
        [postcardArray removeAllObjects];
        C4Shape *greyRectRemove=[greyRectArray objectAtIndex:[greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [greyRectArray removeObjectAtIndex:[greyRectArray count]-1];
    }
}
//------------------------------------------------------------------------
//bar with character count + done button on top of the keyboard
//------------------------------------------------------------------------
-(void)setupKeyboardBar{
    int barHeight=40;
    keyboardBarBackground=[C4Shape rect:CGRectMake(0, self.canvas.height-216-barHeight, self.canvas.width, barHeight)];
    keyboardBarBackground.fillColor=navBarColor;
    keyboardBarBackground.lineWidth=0;
    [self.canvas addShape:keyboardBarBackground];
    
    DoneButton=[C4Shape rect:CGRectMake(self.canvas.width-10-60, keyboardBarBackground.origin.y+5, 60, keyboardBarBackground.height-2*5)];
    DoneButton.fillColor=buttonColor;
    DoneButton.lineWidth=0;
    [self.canvas addShape:DoneButton];
    
    doneLabel=[C4Label labelWithText:@"Done" font:normalFont];
    doneLabel.textColor=typeColor;
    doneLabel.center=DoneButton.center;
    [self.canvas addLabel: doneLabel];
    [self listenFor:@"touchesBegan" fromObjects:@[DoneButton,doneLabel] andRunMethod:@"dismissKeyboard"];
    
    NSString *text=[NSString stringWithFormat:@"0/%i", maxPostcardLength];
    countingLabel=[C4Label labelWithText:text font:normalFont];
    countingLabel.center=CGPointMake(countingLabel.width/2+10, keyboardBarBackground.center.y);
    countingLabel.textColor=typeColor;
    [self.canvas addLabel:countingLabel];
    

}
-(void)updateCharacterNumber{
    countingLabel.text=[NSString stringWithFormat:@"%i/%i", [postcardArray count], maxPostcardLength];
    [countingLabel sizeToFit];
}
-(void)removeKeyboardBar{
    [keyboardBarBackground removeFromSuperview];
    [DoneButton removeFromSuperview];
    [doneLabel removeFromSuperview];
    [countingLabel removeFromSuperview];
    
    openKeyboardShape=[C4Shape rect:CGRectMake(0, topBarFromTop+topBarHeight, self.canvas.width, self.canvas.height-(topBarFromTop+topBarHeight+bottomBarHeight))];
    openKeyboardShape.fillColor=navigationColor;
    openKeyboardShape.lineWidth=0;
    [self listenFor:@"touchesBegan" fromObject:openKeyboardShape andRunMethod:@"openKeyboard"];
    [self.canvas addShape:openKeyboardShape];
}
//------------------------------------------------------------------------
//POSTCARD MENU
//------------------------------------------------------------------------
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
    //SAVE Postcard
    //--------------------------------------------------
    savePostcardShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*5+smallMargin*3), width, height)];
    savePostcardShape.fillColor=whiteColor;
    savePostcardShape.lineWidth=0;
    [self.canvas addShape:savePostcardShape];
    
    savePostcardLabel=[C4Label labelWithText:@"Save Postcard" font:normalFont];
    savePostcardLabel.origin=CGPointMake(TextmarginFromLeft, savePostcardShape.center.y-savePostcardLabel.height/2);
    [self.canvas addLabel:savePostcardLabel];
    
    savePostcardIcon=iconSaveAlphabet;
    savePostcardIcon.width= 40;
    savePostcardIcon.center=CGPointMake(savePostcardShape.origin.x+writePostcardIcon.width/2+5, savePostcardShape.center.y);
    [self.canvas addImage:savePostcardIcon];
    
    [self listenFor:@"touchesBegan" fromObjects:@[savePostcardShape, savePostcardLabel,savePostcardIcon] andRunMethod:@"goToSavePostcard"];
    //--------------------------------------------------
    //SHARE POSTCARD
    //--------------------------------------------------
    sharePostcardShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*6+smallMargin*4), width, height)];
    sharePostcardShape.fillColor=whiteColor;
    sharePostcardShape.lineWidth=0;
    [self.canvas addShape:sharePostcardShape];
    
    sharePostcardLabel=[C4Label labelWithText:@"Share Postcard" font:normalFont];
    sharePostcardLabel.origin=CGPointMake(TextmarginFromLeft, sharePostcardShape.center.y-sharePostcardLabel.height/2);
    [self.canvas addLabel:sharePostcardLabel];
    
    sharePostcardIcon=iconSharePostcard;
    sharePostcardIcon.width= 70;
    sharePostcardIcon.center=CGPointMake(sharePostcardShape.origin.x+sharePostcardIcon.width/2+5, sharePostcardShape.center.y);
    [self.canvas addImage:sharePostcardIcon];
    [self listenFor:@"touchesBegan" fromObjects:@[sharePostcardShape, sharePostcardLabel,sharePostcardIcon] andRunMethod:@"goToSharePostcard"];
    //--------------------------------------------------
    //POSTCARD INFO
    //--------------------------------------------------
    postcardInfoShape=[C4Shape rect:CGRectMake(sideMargin, self.canvas.height-(sideMargin*2+height*7+smallMargin*5), width, height)];
    postcardInfoShape.fillColor=whiteColor;
    postcardInfoShape.lineWidth=0;
    [self.canvas addShape:postcardInfoShape];
    
    postcardInfoLabel=[C4Label labelWithText:@"Postcard info" font:normalFont];
    postcardInfoLabel.origin=CGPointMake(TextmarginFromLeft, postcardInfoShape.center.y-postcardInfoLabel.height/2);
    [self.canvas addLabel:postcardInfoLabel];
    
    postcardInfoIcon=iconAlphabetInfo;
    postcardInfoIcon.width= 38.676;
    postcardInfoIcon.center=CGPointMake(postcardInfoShape.origin.x+sharePostcardIcon.width/2+5, postcardInfoShape.center.y);
    [self.canvas addImage:postcardInfoIcon];
    [self listenFor:@"touchesBegan" fromObjects:@[postcardInfoShape, postcardInfoLabel,postcardInfoIcon] andRunMethod:@"goToPostcardInfo"];
    
}


//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
-(void)savePostcard{
    C4Log(@"saving Postcard");
    //crop the screenshot
    self.currentPostcardImage=[self cropImage:self.currentPostcardImage toArea:CGRectMake(0, topBarFromTop+topBarHeight, self.canvas.width, self.canvas.height-(topBarFromTop+topBarHeight+bottomBarHeight))];
    [self exportHighResImage];
}
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    [self.currentPostcardImage renderInContext:graphicsContext];
    NSString *fileName = [NSString stringWithFormat:@"exportedPostcard%@.jpg", [NSDate date]];
    //C4Log(@"%@",s );
    
    [self saveImage:fileName];
    [self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.canvas.width, self.canvas.height-(topBarFromTop+topBarHeight+bottomBarHeight)), YES, 5.0f);
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
-(void)removeFromView{
    [background removeFromSuperview];
    C4Log(@"postcardArrayLength:%i", [postcardArray count]);
    if ([postcardArray count]<1) {
        C4Image *image=[C4Image imageWithImage:emptyLetter];
        [postcardArray addObject: image];
    } else{
        for (int i=0; i<[postcardArray count]; i++) {
            C4Image *image=[postcardArray objectAtIndex:i];
            [image removeFromSuperview];
        }
    }
    C4Log(@"postcardArrayLength:%i", [postcardArray count]);
    
    [defaultRect removeFromSuperview];
    [topNavBar removeFromSuperview];
    [titleLabel removeFromSuperview];
    
    [backLabel removeFromSuperview];
    [backButtonImage removeFromSuperview];
    [navigateBackRect removeFromSuperview];
    
    [closeButtonImage removeFromSuperview];
    [closeRect removeFromSuperview];
    
    [self stopListeningFor:@"touchesBegan" objects:@[navigateBackRect, closeRect]];

}
-(void)navigateBack{
    C4Log(@"navigateBack");
    [self removeFromView];
    [self postNotification:@"goToAlphabetsView"];

}
-(void)dismissKeyboard{
    C4Log(@"dismiss keyboard");

    [textViewTest resignFirstResponder];
    if ([postcardArray count]>0) {
        C4Image *image =[postcardArray objectAtIndex:[postcardArray count]-1];
        [image removeFromSuperview];
    }
    [self removeKeyboardBar];
    [self bottomBarSetup];
}
-(void)openKeyboard{
    C4Log(@"open Keyboard");
    [textViewTest becomeFirstResponder];
    [self setupKeyboardBar];
    [openKeyboardShape removeFromSuperview];
    [self stopListeningFor:@"touchesBegan" object:openKeyboardShape];

}
-(void) goToTakePhoto{
    C4Log(@"goToTakePhoto");
    [self removeFromView];
    [self closeMenu];
    [self postNotification:@"goToTakePhoto"];
}
-(void)openMenu{
    C4Log(@"openMenu");
    [self setupMenu];
}
-(void)goToMyAlphabets{
    C4Log(@"goToMyAlphabets");
    //[self removeFromView];
    [self closeMenu];
    
}
-(void)goToMyPostcards{
    C4Log(@"goToMyPostcards");
    //[self removeFromView];
    [self closeMenu];
    
}
-(void)goToWritePostcard{
    C4Log(@"goToWritePostcard");
   
}
-(void)goToSavePostcard{
    C4Log(@"goToSavePostcard");
    [self closeMenu];
    [self postNotification:@"saveCurrentPostcardAsImage"];
    [self savePostcard];
}
-(void)goToSharePostcard{
    C4Log(@"goToSharePostcard");
    //[self removeFromView];
    [self closeMenu];
}
-(void)goToPostcardInfo{
    C4Log(@"goToPostcardInfo");
    //[self removeFromView];
    [self closeMenu];
    //[self postNotification:@"goToPostcardInfo"];
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
    [savePostcardShape removeFromSuperview];
    [savePostcardLabel removeFromSuperview];
    [savePostcardIcon removeFromSuperview];
    [sharePostcardShape removeFromSuperview];
    [sharePostcardLabel removeFromSuperview];
    [sharePostcardIcon removeFromSuperview];
    [postcardInfoShape removeFromSuperview];
    [postcardInfoLabel removeFromSuperview];
    [postcardInfoIcon removeFromSuperview];
}
//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------

#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView becomes active, or is the First Responder
     --*/
    
    NSLog(@"textViewDidBeginEditing:");
    textView.textColor = navigationColor;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView is no longer active
     --*/
    [self displayPostcard];
    NSLog(@"textViewDidEndEditing:");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"textView:shouldChangeTextInRange:replacementText:");
    
    NSLog(@"textView.text.length -- %lu",(unsigned long)textView.text.length);
    NSLog(@"text.length          -- %lu",(unsigned long)text.length);
    NSLog(@"text                 -- '%@'", text);
    NSLog(@"textView.text        -- '%@'", textView.text);
    
    newCharacter=text;
    entireText=textView.text;
    
    
    /*--
     * This method is called just before text in the textView is displayed
     * This is a good place to disallow certain characters
     * Limit textView to 140 characters
     * Resign keypad if done button pressed comparing the incoming text against the newlineCharacterSet
     * Return YES to update the textView otherwise return NO
     --*/
    [self displayPostcard];
    [self updateCharacterNumber];
    
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > maxPostcardLength){//140 characters are in the textView
        if (location != NSNotFound){ //Did not find any newline characters
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){ //Did not find any newline characters
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange:");
    //This method is called when the user makes a change to the text in the textview
}
@end
