//
//  Write Postcard.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "Write Postcard.h"
#import "PostcardView.h"
#import "AlphabetView.h"

@interface Write_Postcard (){
    PostcardView *postcardView;
    AlphabetView *alphabetView;
    UITextView *textViewTest;
    //-----------------------
    //BAR ON TOP OF KEYBOARD
    //-----------------------
    C4Shape *keyboardBarBackground;
    C4Label *countingLabel;
    //-----------------------
    //FOR KEYBOARD INPUT
    //-----------------------
    NSString *newCharacter;
    
}
@property (readwrite) NSString *currentLanguage;
@property (readwrite) int maxPostcardLength;
@end

@implementation Write_Postcard
-(void)viewWillAppear:(BOOL)animated{
    [textViewTest becomeFirstResponder];
    //draw the current postcard text
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (int i=0; i<[self.postcardArray count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        
        C4Image *image=[self.postcardArray objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=UA_NAV_CTRL_COLOR;
        greyRect.lineWidth=2;
        greyRect.strokeColor=UA_NAV_BAR_COLOR;
        [self.greyRectArray addObject:greyRect];
        [self.canvas addShape:greyRect];

    }
}
-(void)clearPostcard{
    [self.postcardArray removeAllObjects];
    [self.greyRectArray removeAllObjects];
}
-(void)setupWithLanguage: (NSString*)passedLanguage Alphabet:(NSMutableArray*)passedAlphabet{
    self.title=@"Write Postcard";
    self.navigationItem.hidesBackButton = YES;
    
    //close button
    CGRect frame = CGRectMake(0, 0, 22.5, 22.5);
    UIButton *closeButton = [[UIButton alloc] initWithFrame:frame];
    [closeButton setBackgroundImage:UA_ICON_CLOSE_UI forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeView)
          forControlEvents:UIControlEventTouchUpInside];
    [closeButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem=rightButton;
    self.maxPostcardLength=24;
    //initiate postcard arrays
    self.postcardArray=[[NSMutableArray alloc]init];
    self.greyRectArray=[[NSMutableArray alloc]init];
    self.currentLanguage=[passedLanguage copy];
    self.currentAlphabet=[passedAlphabet copy];
    //add text field
    CGRect textViewFrame = CGRectMake(20.0f, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+10, self.canvas.width-40, 124.0f);
    textViewTest = [[UITextView alloc] initWithFrame:textViewFrame];
    textViewTest.returnKeyType = UIReturnKeyDone;
    [textViewTest becomeFirstResponder];
    textViewTest.delegate = self;
    textViewTest.hidden=true;
    [self.view addSubview:textViewTest];
    
    //[self setupKeyboardBar];
}
//------------------------------------------------------------------------
//bar with character count + done button on top of the keyboard
//------------------------------------------------------------------------
-(void)setupKeyboardBar{
    int barHeight=30;
    keyboardBarBackground=[C4Shape rect:CGRectMake(0, self.canvas.height-216-barHeight, self.canvas.width, barHeight)];
    keyboardBarBackground.fillColor=UA_NAV_BAR_COLOR;
    keyboardBarBackground.lineWidth=0;
    [self.canvas addShape:keyboardBarBackground];
    
    
    NSString *text=[NSString stringWithFormat:@"0/%i", self.maxPostcardLength];
    countingLabel=[C4Label labelWithText:text font:UA_NORMAL_FONT];
    countingLabel.center=CGPointMake(countingLabel.width/2+10, keyboardBarBackground.center.y);
    //countingLabel.textColor=typeColor;
    [self.canvas addLabel:countingLabel];
}
-(void)updateCharacterNumber{
    countingLabel.text=[NSString stringWithFormat:@"%lu/%i", (unsigned long)[self.postcardArray count], self.maxPostcardLength];
    [countingLabel sizeToFit];
}

//------------------------------------------------------------------------
//DISPLAY POSTCARD
//------------------------------------------------------------------------
-(void)displayPostcard{
    if([self.postcardArray count]<self.maxPostcardLength){
        [self addLetterToPostcard];
    }
    float imageWidth=53.53;
    float imageHeight=65.1;
    
    if (![newCharacter  isEqual:@""]) { //if something was added
        //draw only the last letter
        NSInteger lastLetter=[self.postcardArray count]-1;
        float xMultiplier=(lastLetter)%6;
        float yMultiplier= (lastLetter)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        
        C4Image *image=[self.postcardArray objectAtIndex:lastLetter ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
        
        C4Shape *greyRect=[C4Shape rect:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        greyRect.fillColor=UA_NAV_CTRL_COLOR;
        greyRect.lineWidth=2;
        greyRect.strokeColor=UA_NAV_BAR_COLOR;
        [self.greyRectArray addObject:greyRect];
        [self.canvas addShape:greyRect];
    }
}
-(void)addLetterToPostcard{
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]||[self.currentLanguage isEqualToString:@"English"]||[self.currentLanguage isEqualToString:@"Danish/Norwegian"]||[self.currentLanguage isEqualToString:@"German"]||[self.currentLanguage isEqualToString:@"Spanish"]) {
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 0]];
            [self.postcardArray addObject: image];
        } else if ([newCharacter isEqual: @"b"]||[newCharacter isEqual: @"B"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 1]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"c"]||[newCharacter isEqual: @"C"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 2]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"d"]||[newCharacter isEqual: @"D"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 3]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"e"]||[newCharacter isEqual: @"E"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 4]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"f"]||[newCharacter isEqual: @"F"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 5]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"g"]||[newCharacter isEqual: @"G"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 6]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"h"]||[newCharacter isEqual: @"H"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 7]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"i"]||[newCharacter isEqual: @"I"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 8]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"j"]||[newCharacter isEqual: @"J"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 9]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"k"]||[newCharacter isEqual: @"K"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 10]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"l"]||[newCharacter isEqual: @"L"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 11]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"m"]||[newCharacter isEqual: @"M"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 12]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"n"]||[newCharacter isEqual: @"N"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 13]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"o"]||[newCharacter isEqual: @"O"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 14]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"p"]||[newCharacter isEqual: @"P"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 15]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"q"]||[newCharacter isEqual: @"Q"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 16]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"r"]||[newCharacter isEqual: @"R"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 17]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"s"]||[newCharacter isEqual: @"S"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 18]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"t"]||[newCharacter isEqual: @"T"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 19]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"u"]||[newCharacter isEqual: @"U"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 20]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"v"]||[newCharacter isEqual: @"V"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 21]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"w"]||[newCharacter isEqual: @"W"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 22]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"x"]||[newCharacter isEqual: @"X"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 23]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"y"]||[newCharacter isEqual: @"Y"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 24]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"z"]||[newCharacter isEqual: @"Z"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 25]];
            [self.postcardArray addObject: image];
            //pos 26
        }else if (([newCharacter isEqual: @"ä"]||[newCharacter isEqual: @"Ä"])&&([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"German"])){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 26]];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"æ"]||[newCharacter isEqual: @"Æ"])&&[self.currentLanguage isEqual: @"Danish/Norwegian"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 26]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"+"]&&[self.currentLanguage isEqual: @"English"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 26]];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ñ"]||[newCharacter isEqual: @"Ñ"])&&[self.currentLanguage isEqual: @"Spanish"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 26]];
            [self.postcardArray addObject: image];
        }
        
        //pos 27
        else if (([newCharacter isEqual: @"ö"]||[newCharacter isEqual: @"Ö"]) && ([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"German"])){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 27]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"+"]&&[self.currentLanguage isEqual: @"Spanish"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 27]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"$"] && [self.currentLanguage isEqual: @"English"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 27]];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ø"]||[newCharacter isEqual: @"Ø"]) && [self.currentLanguage isEqual: @"Danish/Norwegian"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 27]];
            [self.postcardArray addObject: image];
        }
        
        //pos 28
        else if (([newCharacter isEqual: @"å"]||[newCharacter isEqual: @"Å"])&& ([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"Danish/Norwegian"])){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 28]];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ü"]||[newCharacter isEqual: @"Ü"])&& [self.currentLanguage isEqual: @"German"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 28]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @","]&& ([self.currentLanguage isEqual: @"English"]||[self.currentLanguage isEqual: @"Spanish"])){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 28]];
            [self.postcardArray addObject: image];
        }
        //pos 29
        else if ([newCharacter isEqual: @"."]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 29]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"!"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 30]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"?"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 31]];
            [self.postcardArray addObject: image];
        }
    }
    if ([self.currentLanguage isEqualToString:@"Russian"]){
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 0]];
            [self.postcardArray addObject: image];
        } else if ([newCharacter isEqual: @"б"]||[newCharacter isEqual: @"Б"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 1]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"в"]||[newCharacter isEqual: @"В"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 2]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"г"]||[newCharacter isEqual: @"Г"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 3]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"д"]||[newCharacter isEqual: @"Д"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 4]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"е"]||[newCharacter isEqual: @"Е"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 5]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ё"]||[newCharacter isEqual: @"Ё"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 6]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ж"]||[newCharacter isEqual: @"Ж"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 7]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"з"]||[newCharacter isEqual: @"З"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 8]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"и"]||[newCharacter isEqual: @"И"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 9]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"й"]||[newCharacter isEqual: @"Й"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 10]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"к"]||[newCharacter isEqual: @"К"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 11]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"л"]||[newCharacter isEqual: @"Л"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 12]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"м"]||[newCharacter isEqual: @"М"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 13]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"н"]||[newCharacter isEqual: @"Н"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 14]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"о"]||[newCharacter isEqual: @"O"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 15]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"п"]||[newCharacter isEqual: @"П"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 16]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"р"]||[newCharacter isEqual: @"P"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 17]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"с"]||[newCharacter isEqual: @"C"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 18]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"т"]||[newCharacter isEqual: @"T"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 19]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"у"]||[newCharacter isEqual: @"Y"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 20]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ф"]||[newCharacter isEqual: @"Ф"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 21]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"х"]||[newCharacter isEqual: @"X"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 22]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ц"]||[newCharacter isEqual: @"Ц"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 23]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ч"]||[newCharacter isEqual: @"Ч"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 24]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ш"]||[newCharacter isEqual: @"Ш"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 25]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"щ"]||[newCharacter isEqual: @"Щ"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 26]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ь"]||[newCharacter isEqual: @"Ь"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 27]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ы"]||[newCharacter isEqual: @"Ы"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 28]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"э"]||[newCharacter isEqual: @"Э"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 29]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ю"]||[newCharacter isEqual: @"Ю"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 30]];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"я"]||[newCharacter isEqual: @"Я"]){
            C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 31]];
            [self.postcardArray addObject: image];
        }
    }
    if ([newCharacter isEqual: @"0"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 32]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"1"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 33]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"2"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 34]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"3"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 35]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"4"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 36]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"5"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 37]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"6"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 38]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"7"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 39]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"8"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 40]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"9"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 41]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @" "]){ //space is displaying an empty letter
        C4Image *image=[C4Image imageWithImage:UA_LETTER_EMPTY];
        [self.postcardArray addObject: image];
    } else if([newCharacter isEqual: @""] && [self.postcardArray count]>1){//remove last letter if delete button is pressed
        C4Image *image=[self.postcardArray objectAtIndex:[self.postcardArray count]-1];
        [image removeFromSuperview];
        [self.postcardArray removeLastObject];
        C4Shape *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }else if([newCharacter isEqual: @""] && [self.postcardArray count]==1){//remove last letter if delete button is pressed and only 1 character exists
        C4Image *image=[self.postcardArray objectAtIndex:0];
        [image removeFromSuperview];
        [self.postcardArray removeAllObjects];
        C4Shape *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }
}
//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    id obj = [self.navigationController.viewControllers objectAtIndex:3];
    alphabetView=(AlphabetView*)obj;
    [self.navigationController popToViewController:alphabetView animated:NO];
}
-(void)closeView{
    [self.navigationController popViewControllerAnimated:NO];
}
//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------

#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{}
- (void)textViewDidEndEditing:(UITextView *)textView{
    //prepare next view and go there
    postcardView=[[PostcardView alloc]initWithNibName:@"PostcardView" bundle:[NSBundle mainBundle]];
    [postcardView setupWithPostcard:self.postcardArray Rect:self.greyRectArray withLanguage:self.currentLanguage withPostcardText:self.entireText];
    [self.navigationController pushViewController:postcardView animated:NO];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    newCharacter=text;
    self.entireText=textView.text;
    [self displayPostcard];
    [self updateCharacterNumber];
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > self.maxPostcardLength){//140 characters are in the textView
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
- (void)textViewDidChange:(UITextView *)textView{}

@end
