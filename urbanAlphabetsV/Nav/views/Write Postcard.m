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
    //to start empty again
    /*[self.postcardArray removeAllObjects];
    [self.greyRectArray removeAllObjects];*/
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
-(void)setupWithLanguage: (NSString*)passedLanguage Alphabet:(NSMutableArray*)passedAlphabet{
    self.title=@"Write Postcard";
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
    NSLog(@"setupTextFieldDone");
    
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
    C4Log(@"updating character number");
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
    
    C4Log(@"postCardArrayLength:%i", [self.postcardArray count]);
    
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
    }else if ([newCharacter isEqual: @"ä"]||[newCharacter isEqual: @"Ä"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 26]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"ö"]||[newCharacter isEqual: @"Ö"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 27]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"å"]||[newCharacter isEqual: @"Å"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 28]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"."]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 29]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"!"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 30]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"?"]){
        C4Image *image=[C4Image imageWithImage:[self.currentAlphabet objectAtIndex: 31]];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"0"]){
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
    }else if([newCharacter isEqual: @""] && [self.postcardArray count]>1){//remove last letter if delete button is pressed
        C4Image *image=[self.postcardArray objectAtIndex:[self.postcardArray count]-1];
        [image removeFromSuperview];
        [self.postcardArray removeLastObject];
        C4Shape *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }else if([newCharacter isEqual: @""] && [self.postcardArray count]==1){//remove last letter if delete button is pressed
        C4Image *image=[self.postcardArray objectAtIndex:0];
        [image removeFromSuperview];
        [self.postcardArray removeAllObjects];
        C4Shape *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }
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
    //textView.textColor = UA_OVERLAY_COLOR;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView is no longer active
     --*/
    NSLog(@"textViewDidEndEditing:");
//prepare next view and go there
    postcardView=[[PostcardView alloc]initWithNibName:@"PostcardView" bundle:[NSBundle mainBundle]];
    [postcardView setupWithPostcard:self.postcardArray Rect:self.greyRectArray withLanguage:self.currentLanguage withPostcardText:self.entireText];
    [self.navigationController pushViewController:postcardView animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // NSLog(@"textView:shouldChangeTextInRange:replacementText:");
    
    // NSLog(@"textView.text.length -- %lu",(unsigned long)textView.text.length);
    //NSLog(@"text.length          -- %lu",(unsigned long)text.length);
    //NSLog(@"text                 -- '%@'", text);
    NSLog(@"textView.text        -- '%@'", textView.text);
    
    newCharacter=text;
    self.entireText=textView.text;
    
    
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

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange:");
    //This method is called when the user makes a change to the text in the textview
}

@end
