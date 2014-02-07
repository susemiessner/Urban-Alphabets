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
    UIView *keyboardBarBackground;
    UILabel *countingLabel;
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
    self.postcardViewArray=[[NSMutableArray alloc]init];
    self.currentLanguage=[passedLanguage copy];
    self.currentAlphabet=[passedAlphabet copy];
    //add text field
    CGRect textViewFrame = CGRectMake(20.0f, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+10, self.view.frame.size.width-40, 124.0f);
    textViewTest = [[UITextView alloc] initWithFrame:textViewFrame];
    textViewTest.returnKeyType = UIReturnKeyDone;
    [textViewTest becomeFirstResponder];
    textViewTest.delegate = self;
    textViewTest.hidden=true;
    [self.view addSubview:textViewTest];
    
    textViewTest.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self setupKeyboardBar];
}
//------------------------------------------------------------------------
//bar with character count + done button on top of the keyboard
//------------------------------------------------------------------------
-(void)setupKeyboardBar{
    int barHeight=30;
    keyboardBarBackground=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-barHeight, self.view.frame.size.width, barHeight)];
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
    bool addLetterResult = true;
    if([self.postcardArray count] < self.maxPostcardLength){
        addLetterResult = [self addLetterToPostcard];
    } else {
        addLetterResult = false;
    }
    float imageWidth=53.53;
    float imageHeight=65.1;

    if([newCharacter isEqual: @""] && [self.postcardArray count]>1)
    {
        //remove last letter if delete button is pressed
        UIImageView *imageView=[self.postcardViewArray objectAtIndex:[self.postcardViewArray count]-1];
        [imageView removeFromSuperview];
        [self.postcardArray removeLastObject];
        [self.postcardViewArray removeLastObject];
        UIView *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }
    else if([newCharacter isEqual: @""] && [self.postcardArray count]==1)
    {
        //remove last letter if delete button is pressed and only 1 character exists
        UIImageView *imageView=[self.postcardViewArray objectAtIndex:0];
        [imageView removeFromSuperview];
        [self.postcardArray removeAllObjects];
        [self.postcardViewArray removeAllObjects];
        UIView *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }
    else
    {
        if ((![newCharacter  isEqual:@""]) && (addLetterResult)) { //if something was added
            //draw only the last letter
            NSInteger lastLetter=[self.postcardArray count]-1;
            float xMultiplier=(lastLetter)%6;
            float yMultiplier= (lastLetter)/6;
            float xPos=xMultiplier*imageWidth;
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
}
-(BOOL)addLetterToPostcard{
    UIImageView *imageView = nil;
    
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]||[self.currentLanguage isEqualToString:@"English"]||[self.currentLanguage isEqualToString:@"Danish/Norwegian"]||[self.currentLanguage isEqualToString:@"German"]||[self.currentLanguage isEqualToString:@"Spanish"]) {
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            imageView=[self.currentAlphabet objectAtIndex: 0];
            [self.postcardArray addObject: imageView];
        } else if ([newCharacter isEqual: @"b"]||[newCharacter isEqual: @"B"]){
            imageView=[self.currentAlphabet objectAtIndex: 1];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"c"]||[newCharacter isEqual: @"C"]){
            imageView=[self.currentAlphabet objectAtIndex: 2];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"d"]||[newCharacter isEqual: @"D"]){
            imageView=[self.currentAlphabet objectAtIndex: 3];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"e"]||[newCharacter isEqual: @"E"]){
            imageView=[self.currentAlphabet objectAtIndex: 4];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"f"]||[newCharacter isEqual: @"F"]){
            imageView=[self.currentAlphabet objectAtIndex: 5];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"g"]||[newCharacter isEqual: @"G"]){
            imageView=[self.currentAlphabet objectAtIndex: 6];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"h"]||[newCharacter isEqual: @"H"]){
            imageView=[self.currentAlphabet objectAtIndex: 7];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"i"]||[newCharacter isEqual: @"I"]){
            imageView=[self.currentAlphabet objectAtIndex: 8];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"j"]||[newCharacter isEqual: @"J"]){
            imageView=[self.currentAlphabet objectAtIndex: 9];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"k"]||[newCharacter isEqual: @"K"]){
            imageView=[self.currentAlphabet objectAtIndex: 10];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"l"]||[newCharacter isEqual: @"L"]){
            imageView=[self.currentAlphabet objectAtIndex: 11];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"m"]||[newCharacter isEqual: @"M"]){
            imageView=[self.currentAlphabet objectAtIndex: 12];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"n"]||[newCharacter isEqual: @"N"]){
            imageView=[self.currentAlphabet objectAtIndex: 13];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"o"]||[newCharacter isEqual: @"O"]){
            imageView=[self.currentAlphabet objectAtIndex: 14];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"p"]||[newCharacter isEqual: @"P"]){
            imageView=[self.currentAlphabet objectAtIndex: 15];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"q"]||[newCharacter isEqual: @"Q"]){
            imageView=[self.currentAlphabet objectAtIndex: 16];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"r"]||[newCharacter isEqual: @"R"]){
            imageView=[self.currentAlphabet objectAtIndex: 17];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"s"]||[newCharacter isEqual: @"S"]){
            imageView=[self.currentAlphabet objectAtIndex: 18];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"t"]||[newCharacter isEqual: @"T"]){
            imageView=[self.currentAlphabet objectAtIndex: 19];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"u"]||[newCharacter isEqual: @"U"]){
            imageView=[self.currentAlphabet objectAtIndex: 20];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"v"]||[newCharacter isEqual: @"V"]){
            imageView=[self.currentAlphabet objectAtIndex: 21];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"w"]||[newCharacter isEqual: @"W"]){
            imageView=[self.currentAlphabet objectAtIndex: 22];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"x"]||[newCharacter isEqual: @"X"]){
            imageView=[self.currentAlphabet objectAtIndex: 23];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"y"]||[newCharacter isEqual: @"Y"]){
            imageView=[self.currentAlphabet objectAtIndex: 24];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"z"]||[newCharacter isEqual: @"Z"]){
            imageView=[self.currentAlphabet objectAtIndex: 25];
            [self.postcardArray addObject: imageView];
            //pos 26
        }else if (([newCharacter isEqual: @"ä"]||[newCharacter isEqual: @"Ä"])&&([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"German"])){
            imageView=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: imageView];
        }else if (([newCharacter isEqual: @"æ"]||[newCharacter isEqual: @"Æ"])&&[self.currentLanguage isEqual: @"Danish/Norwegian"]){
            imageView=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"+"]&&[self.currentLanguage isEqual: @"English"]){
            imageView=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: imageView];
        }else if (([newCharacter isEqual: @"ñ"]||[newCharacter isEqual: @"Ñ"])&&[self.currentLanguage isEqual: @"Spanish"]){
            imageView=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: imageView];
        }
        
        //pos 27
        else if (([newCharacter isEqual: @"ö"]||[newCharacter isEqual: @"Ö"]) && ([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"German"])){
            imageView=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"+"]&&[self.currentLanguage isEqual: @"Spanish"]){
            imageView=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"$"] && [self.currentLanguage isEqual: @"English"]){
            imageView=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: imageView];
        }else if (([newCharacter isEqual: @"ø"]||[newCharacter isEqual: @"Ø"]) && [self.currentLanguage isEqual: @"Danish/Norwegian"]){
            imageView=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: imageView];
        }
        
        //pos 28
        else if (([newCharacter isEqual: @"å"]||[newCharacter isEqual: @"Å"])&& ([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"Danish/Norwegian"])){
            imageView=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: imageView];
        }else if (([newCharacter isEqual: @"ü"]||[newCharacter isEqual: @"Ü"])&& [self.currentLanguage isEqual: @"German"]){
            imageView=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @","]&& ([self.currentLanguage isEqual: @"English"]||[self.currentLanguage isEqual: @"Spanish"])){
            imageView=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: imageView];
        }
        //pos 29
        else if ([newCharacter isEqual: @"."]){
            imageView=[self.currentAlphabet objectAtIndex: 29];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"!"]){
            imageView=[self.currentAlphabet objectAtIndex: 30];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"?"]){
            imageView=[self.currentAlphabet objectAtIndex: 31];
            [self.postcardArray addObject: imageView];
        }
    }
    else if ([self.currentLanguage isEqualToString:@"Russian"]){
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            imageView=[self.currentAlphabet objectAtIndex: 0];
            [self.postcardArray addObject: imageView];
        } else if ([newCharacter isEqual: @"б"]||[newCharacter isEqual: @"Б"]){
            imageView=[self.currentAlphabet objectAtIndex: 1];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"в"]||[newCharacter isEqual: @"В"]){
            imageView=[self.currentAlphabet objectAtIndex: 2];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"г"]||[newCharacter isEqual: @"Г"]){
            imageView=[self.currentAlphabet objectAtIndex: 3];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"д"]||[newCharacter isEqual: @"Д"]){
            imageView=[self.currentAlphabet objectAtIndex: 4];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"е"]||[newCharacter isEqual: @"Е"]){
            imageView=[self.currentAlphabet objectAtIndex: 5];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ё"]||[newCharacter isEqual: @"Ё"]){
            imageView=[self.currentAlphabet objectAtIndex: 6];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ж"]||[newCharacter isEqual: @"Ж"]){
            imageView=[self.currentAlphabet objectAtIndex: 7];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"з"]||[newCharacter isEqual: @"З"]){
            imageView=[self.currentAlphabet objectAtIndex: 8];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"и"]||[newCharacter isEqual: @"И"]){
            imageView=[self.currentAlphabet objectAtIndex: 9];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"й"]||[newCharacter isEqual: @"Й"]){
            imageView=[self.currentAlphabet objectAtIndex: 10];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"к"]||[newCharacter isEqual: @"К"]){
            imageView=[self.currentAlphabet objectAtIndex: 11];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"л"]||[newCharacter isEqual: @"Л"]){
            imageView=[self.currentAlphabet objectAtIndex: 12];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"м"]||[newCharacter isEqual: @"М"]){
            imageView=[self.currentAlphabet objectAtIndex: 13];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"н"]||[newCharacter isEqual: @"Н"]){
            imageView=[self.currentAlphabet objectAtIndex: 14];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"о"]||[newCharacter isEqual: @"O"]){
            imageView=[self.currentAlphabet objectAtIndex: 15];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"п"]||[newCharacter isEqual: @"П"]){
            imageView=[self.currentAlphabet objectAtIndex: 16];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"р"]||[newCharacter isEqual: @"P"]){
            imageView=[self.currentAlphabet objectAtIndex: 17];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"с"]||[newCharacter isEqual: @"C"]){
            imageView=[self.currentAlphabet objectAtIndex: 18];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"т"]||[newCharacter isEqual: @"T"]){
            imageView=[self.currentAlphabet objectAtIndex: 19];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"у"]||[newCharacter isEqual: @"Y"]){
            imageView=[self.currentAlphabet objectAtIndex: 20];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ф"]||[newCharacter isEqual: @"Ф"]){
            imageView=[self.currentAlphabet objectAtIndex: 21];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"х"]||[newCharacter isEqual: @"X"]){
            imageView=[self.currentAlphabet objectAtIndex: 22];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ц"]||[newCharacter isEqual: @"Ц"]){
            imageView=[self.currentAlphabet objectAtIndex: 23];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ч"]||[newCharacter isEqual: @"Ч"]){
            imageView=[self.currentAlphabet objectAtIndex: 24];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ш"]||[newCharacter isEqual: @"Ш"]){
            imageView=[self.currentAlphabet objectAtIndex: 25];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"щ"]||[newCharacter isEqual: @"Щ"]){
            imageView=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ь"]||[newCharacter isEqual: @"Ь"]){
            imageView=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ы"]||[newCharacter isEqual: @"Ы"]){
            imageView=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"э"]||[newCharacter isEqual: @"Э"]){
            imageView=[self.currentAlphabet objectAtIndex: 29];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"ю"]||[newCharacter isEqual: @"Ю"]){
            imageView=[self.currentAlphabet objectAtIndex: 30];
            [self.postcardArray addObject: imageView];
        }else if ([newCharacter isEqual: @"я"]||[newCharacter isEqual: @"Я"]){
            imageView=[self.currentAlphabet objectAtIndex: 31];
            [self.postcardArray addObject: imageView];
        }
    }
    if ([newCharacter isEqual: @"0"]){
        imageView=[self.currentAlphabet objectAtIndex: 32];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"1"]){
        imageView=[self.currentAlphabet objectAtIndex: 33];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"2"]){
        imageView=[self.currentAlphabet objectAtIndex: 34];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"3"]){
        imageView=[self.currentAlphabet objectAtIndex: 35];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"4"]){
        imageView=[self.currentAlphabet objectAtIndex: 36];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"5"]){
        imageView=[self.currentAlphabet objectAtIndex: 37];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"6"]){
        imageView=[self.currentAlphabet objectAtIndex: 38];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"7"]){
        imageView=[self.currentAlphabet objectAtIndex: 39];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"8"]){
        imageView=[self.currentAlphabet objectAtIndex: 40];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @"9"]){
        imageView=[self.currentAlphabet objectAtIndex: 41];
        [self.postcardArray addObject: imageView];
    }else if ([newCharacter isEqual: @" "]){ //space is displaying an empty letter
        imageView=[[UIImageView alloc] initWithImage:UA_LETTER_EMPTY];
        [self.postcardArray addObject: imageView];
    }
    
    if (!imageView)
        return false;
    
    return true;
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
