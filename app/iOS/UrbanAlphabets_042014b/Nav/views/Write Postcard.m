//
//  Write Postcard.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "Write Postcard.h"
#import "PostcardView.h"

@interface Write_Postcard (){
    PostcardView *postcardView;
    C4View *alphabetView;
    UITextView *textViewTest;
    //-----------------------
    //BAR ON TOP OF KEYBOARD
    //-----------------------
    UIView *keyboardBarBackground;
    UILabel *countingLabel;
    //-----------------------
    //FOR KEYBOARD INPUT
    //-----------------------
    NSString *newCharacter;
    
    
    float imageWidth;
    float imageHeight;
    float alphabetFromLeft;
    
}
@property (readwrite) NSString *currentLanguage;
@property (readwrite) int maxPostcardLength;
@end

@implementation Write_Postcard
-(void)viewWillAppear:(BOOL)animated{
    imageWidth=UA_LETTER_IMG_WIDTH_5;
    imageHeight=UA_LETTER_IMG_HEIGHT_5;
    alphabetFromLeft=0;
    if ( UA_IPHONE_5_HEIGHT != [[UIScreen mainScreen] bounds].size.height) {
        //if ( UA_IPHONE_5_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
        imageHeight=UA_LETTER_IMG_HEIGHT_4;
        imageWidth=UA_LETTER_IMG_WIDTH_4;
        alphabetFromLeft=UA_LETTER_SIDE_MARGIN_ALPHABETS;
    }
    
    [textViewTest becomeFirstResponder];
    //draw the current postcard text
    for (int i=0; i<[self.postcardArray count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth+alphabetFromLeft;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        
        UIImageView *image=[self.postcardArray objectAtIndex:i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        imageView.image=image.image;
        [self.view addSubview:imageView];
        [self.postcardViewArray addObject:imageView];
        
        UIView *greyRect=[[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        [greyRect setBackgroundColor:UA_NAV_CTRL_COLOR];
        greyRect.layer.borderWidth=1.0f;
        greyRect.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        [self.greyRectArray addObject:greyRect];
        [self.view addSubview:greyRect];
    }
}
-(void)clearPostcard{
    for (int i=0; i<[self.postcardViewArray count]; i++) {
        UIImageView *image=[self.postcardViewArray objectAtIndex:i];
        [image removeFromSuperview];
    }
    [self.postcardArray removeAllObjects];
    [self.postcardViewArray removeAllObjects];
    [self.greyRectArray removeAllObjects];
}
-(void)setupWithLanguage: (NSString*)passedLanguage Alphabet:(NSMutableArray*)passedAlphabet{
    self.title=@"Write Postcard";
    self.navigationItem.hidesBackButton = YES;
    
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //close button
    frame = CGRectMake(0, 0, 22.5, 22.5);
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
    self.postcardViewArray=[[NSMutableArray alloc]init];
    self.currentLanguage=[passedLanguage copy];
    self.currentAlphabet=[passedAlphabet copy];
    
    //add text field
    CGRect textViewFrame = CGRectMake(20.0f, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+10, [[UIScreen mainScreen] bounds].size.width-40, 124.0f);
    textViewTest = [[UITextView alloc] initWithFrame:textViewFrame];
    textViewTest.returnKeyType = UIReturnKeyDone;
    [textViewTest becomeFirstResponder];
    textViewTest.delegate = self;
    textViewTest.hidden=true;
    [self.view addSubview:textViewTest];
    
    [self setupKeyboardBar];
}

//------------------------------------------------------------------------
//bar with character count + done button on top of the keyboard
//------------------------------------------------------------------------
-(void)setupKeyboardBar{
    int barHeight=30;
    keyboardBarBackground=[[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-216-barHeight, [[UIScreen mainScreen] bounds].size.width, barHeight)];
    [keyboardBarBackground setBackgroundColor:UA_NAV_BAR_COLOR];
    [self.view addSubview: keyboardBarBackground];
    
    
    NSString *text=[NSString stringWithFormat:@"0/%i", self.maxPostcardLength];
    countingLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, keyboardBarBackground.frame.origin.y+5, 50, 15) ];
    [countingLabel setText:text];
    [countingLabel setFont:UA_NORMAL_FONT];
    [countingLabel setTextColor:UA_TYPE_COLOR];
    [self.view addSubview:countingLabel];
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
    
    if (![newCharacter  isEqual:@""]) { //if something was added
        //draw only the last letter
        NSInteger lastLetter=[self.postcardArray count]-1;
        float xMultiplier=(lastLetter)%6;
        float yMultiplier= (lastLetter)/6;
        float xPos=xMultiplier*imageWidth+alphabetFromLeft;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        
        UIImageView *image=[self.postcardArray objectAtIndex:lastLetter];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        imageView.image=image.image;
        [self.view addSubview:imageView];
        [self.postcardViewArray addObject:imageView];
        
        UIView *greyRect=[[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        [greyRect setBackgroundColor:UA_NAV_CTRL_COLOR];
        greyRect.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        greyRect.layer.borderWidth=1.0f;
        [self.greyRectArray addObject:greyRect];
        [self.view addSubview:greyRect];
    }
}
-(void)addLetterToPostcard{
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]||[self.currentLanguage isEqualToString:@"English/Portugese"]||[self.currentLanguage isEqualToString:@"Danish/Norwegian"]||[self.currentLanguage isEqualToString:@"German"]||[self.currentLanguage isEqualToString:@"Spanish"]) {
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            UIImageView *image=[self.currentAlphabet objectAtIndex: 0];
            [self.postcardArray addObject: image];
        } else if ([newCharacter isEqual: @"b"]||[newCharacter isEqual: @"B"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 1];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"c"]||[newCharacter isEqual: @"C"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 2];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"d"]||[newCharacter isEqual: @"D"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 3];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"e"]||[newCharacter isEqual: @"E"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 4];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"f"]||[newCharacter isEqual: @"F"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 5];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"g"]||[newCharacter isEqual: @"G"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 6];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"h"]||[newCharacter isEqual: @"H"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 7];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"i"]||[newCharacter isEqual: @"I"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 8];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"j"]||[newCharacter isEqual: @"J"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 9];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"k"]||[newCharacter isEqual: @"K"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 10];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"l"]||[newCharacter isEqual: @"L"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 11];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"m"]||[newCharacter isEqual: @"M"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 12];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"n"]||[newCharacter isEqual: @"N"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 13];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"o"]||[newCharacter isEqual: @"O"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 14];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"p"]||[newCharacter isEqual: @"P"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 15];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"q"]||[newCharacter isEqual: @"Q"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 16];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"r"]||[newCharacter isEqual: @"R"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 17];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"s"]||[newCharacter isEqual: @"S"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 18];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"t"]||[newCharacter isEqual: @"T"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 19];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"u"]||[newCharacter isEqual: @"U"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 20];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"v"]||[newCharacter isEqual: @"V"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 21];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"w"]||[newCharacter isEqual: @"W"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 22];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"x"]||[newCharacter isEqual: @"X"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 23];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"y"]||[newCharacter isEqual: @"Y"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 24];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"z"]||[newCharacter isEqual: @"Z"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 25];
            [self.postcardArray addObject: image];
            //pos 26
        }else if (([newCharacter isEqual: @"ä"]||[newCharacter isEqual: @"Ä"])&&([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"German"])){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"æ"]||[newCharacter isEqual: @"Æ"])&&[self.currentLanguage isEqual: @"Danish/Norwegian"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"+"]&&[self.currentLanguage isEqual: @"English/Portugese"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ñ"]||[newCharacter isEqual: @"Ñ"])&&[self.currentLanguage isEqual: @"Spanish"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }
        
        //pos 27
        else if (([newCharacter isEqual: @"ö"]||[newCharacter isEqual: @"Ö"]) && ([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"German"])){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"+"]&&[self.currentLanguage isEqual: @"Spanish"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"$"] && [self.currentLanguage isEqual: @"English/Portugese"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ø"]||[newCharacter isEqual: @"Ø"]) && [self.currentLanguage isEqual: @"Danish/Norwegian"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }
        
        //pos 28
        else if (([newCharacter isEqual: @"å"]||[newCharacter isEqual: @"Å"])&& ([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"Danish/Norwegian"])){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ü"]||[newCharacter isEqual: @"Ü"])&& [self.currentLanguage isEqual: @"German"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @","]&& ([self.currentLanguage isEqual: @"English/Portugese"]||[self.currentLanguage isEqual: @"Spanish"])){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }
        //pos 29
        else if ([newCharacter isEqual: @"."]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 29];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"!"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 30];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"?"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 31];
            [self.postcardArray addObject: image];
        }
    }
    if ([self.currentLanguage isEqualToString:@"Russian"]){
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            UIImageView *image=[self.currentAlphabet objectAtIndex: 0];
            [self.postcardArray addObject: image];
        } else if ([newCharacter isEqual: @"б"]||[newCharacter isEqual: @"Б"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 1];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"в"]||[newCharacter isEqual: @"В"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 2];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"г"]||[newCharacter isEqual: @"Г"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 3];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"д"]||[newCharacter isEqual: @"Д"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 4];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"е"]||[newCharacter isEqual: @"Е"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 5];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ё"]||[newCharacter isEqual: @"Ё"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 6];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ж"]||[newCharacter isEqual: @"Ж"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 7];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"з"]||[newCharacter isEqual: @"З"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 8];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"и"]||[newCharacter isEqual: @"И"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 9];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"й"]||[newCharacter isEqual: @"Й"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 10];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"к"]||[newCharacter isEqual: @"К"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 11];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"л"]||[newCharacter isEqual: @"Л"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 12];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"м"]||[newCharacter isEqual: @"М"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 13];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"н"]||[newCharacter isEqual: @"Н"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 14];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"о"]||[newCharacter isEqual: @"O"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 15];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"п"]||[newCharacter isEqual: @"П"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 16];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"р"]||[newCharacter isEqual: @"P"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 17];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"с"]||[newCharacter isEqual: @"C"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 18];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"т"]||[newCharacter isEqual: @"T"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 19];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"у"]||[newCharacter isEqual: @"Y"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 20];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ф"]||[newCharacter isEqual: @"Ф"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 21];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"х"]||[newCharacter isEqual: @"X"]){
            UIImage *image=[self.currentAlphabet objectAtIndex: 22];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ц"]||[newCharacter isEqual: @"Ц"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 23];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ч"]||[newCharacter isEqual: @"Ч"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 24];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ш"]||[newCharacter isEqual: @"Ш"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 25];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"щ"]||[newCharacter isEqual: @"Щ"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ь"]||[newCharacter isEqual: @"Ь"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ы"]||[newCharacter isEqual: @"Ы"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"э"]||[newCharacter isEqual: @"Э"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 29];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ю"]||[newCharacter isEqual: @"Ю"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 30];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"я"]||[newCharacter isEqual: @"Я"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 31];
            [self.postcardArray addObject: image];
        }
    }
    if ([newCharacter isEqual: @"0"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 32];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"1"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 33];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"2"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 34];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"3"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 35];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"4"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 36];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"5"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 37];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"6"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 38];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"7"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 39];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"8"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 40];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"9"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 41];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @" "]){ //space is displaying an empty letter
        UIImageView *image=[[UIImageView alloc]initWithImage:UA_LETTER_EMPTY];
        [self.postcardArray addObject: image];
    } else if([newCharacter isEqual: @""] && [self.postcardArray count]>1){//remove last letter if delete button is pressed
        UIImageView *image=[self.postcardViewArray objectAtIndex:[self.postcardViewArray count]-1];
        [image removeFromSuperview];
        [self.postcardArray removeLastObject];
        [self.postcardViewArray removeLastObject];
        UIView *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }else if([newCharacter isEqual: @""] && [self.postcardArray count]==1){//remove last letter if delete button is pressed and only 1 character exists
        UIImageView *image=[self.postcardViewArray objectAtIndex:0];
        [image removeFromSuperview];
        [self.postcardArray removeAllObjects];
        [self.postcardViewArray removeAllObjects];
        UIView *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }
    
}
//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)closeView{
    [self.navigationController popToRootViewControllerAnimated:NO];
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
