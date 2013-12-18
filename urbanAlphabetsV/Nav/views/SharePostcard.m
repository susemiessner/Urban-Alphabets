//
//  SharePostcard.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "SharePostcard.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SharePostcard (){
    C4Image *postcardImage, *twitterImage, *facebookImage, *mailImage;
    UIImage *imageToSend;
    C4Label *twitterLabel, *facebookLabel, *mailLabel;
    NSString *message;
    
    UITextView *textInput;
    UITapGestureRecognizer * tapGesture;
}

@end

@implementation SharePostcard

-(void)setup:(UIImage*)imageToShare{
    self.title=@"Share Alphabet";
    imageToSend=[imageToShare copy];
    message=@" ";

    
    postcardImage=[C4Image imageWithUIImage:imageToShare];
    postcardImage.width=46;
    postcardImage.center=CGPointMake(20+postcardImage.width/2, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+50);
    [self.canvas addImage:postcardImage];
    
    //add text field
    CGRect textViewFrame = CGRectMake(postcardImage.center.x+postcardImage.width, postcardImage.origin.y, self.canvas.width-40-(postcardImage.center.x+postcardImage.width), postcardImage.height);
    textInput = [[UITextView alloc] initWithFrame:textViewFrame];
    textInput.returnKeyType = UIReturnKeyDone;
    textInput.layer.borderWidth=1.0f;
    textInput.layer.borderColor=[UA_OVERLAY_COLOR CGColor];
    [textInput becomeFirstResponder];
    textInput.delegate = self;
    [self.view addSubview:textInput];
    
    //share images and labels
    int shareIconYPos=140;
    twitterImage=UA_ICON_TWITTER;
    twitterImage.width=40;
    twitterImage.center=CGPointMake(twitterImage.width/2+20, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+shareIconYPos);
    [self.canvas addImage:twitterImage];
    
    int labelToLeft=60;
    int labelUp=10;
    twitterLabel=[C4Label labelWithText:@"Twitter" font:UA_NORMAL_FONT];
    twitterLabel.origin=CGPointMake(twitterImage.center.x+labelToLeft, twitterImage.center.y-labelUp);
    [self.canvas addLabel:twitterLabel];
    
    shareIconYPos+=60;
    facebookImage=UA_Icon_FB;
    facebookImage.width=40;
    facebookImage.center=CGPointMake(facebookImage.width/2+20, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+shareIconYPos);
    [self.canvas addImage:facebookImage];
    
    facebookLabel=[C4Label labelWithText:@"Facebook" font:UA_NORMAL_FONT];
    facebookLabel.origin=CGPointMake(facebookImage.center.x+labelToLeft, facebookImage.center.y-labelUp);
    [self.canvas addLabel:facebookLabel];
    
    shareIconYPos+=60;
    mailImage=UA_ICON_MAIL;
    mailImage.width=46;
    mailImage.center=CGPointMake(twitterImage.width/2+20, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+shareIconYPos);
    [self.canvas addImage:mailImage];
    
    mailLabel=[C4Label labelWithText:@"Mail" font:UA_NORMAL_FONT];
    mailLabel.origin=CGPointMake(mailImage.center.x+labelToLeft, mailImage.center.y-labelUp);
    [self.canvas addLabel:mailLabel];
    
    
    
    //interactions
    [self listenFor:@"touchesBegan" fromObjects:@[facebookImage, facebookLabel] andRunMethod:@"shareToFacebook"];
    [self listenFor:@"touchesBegan" fromObjects:@[twitterImage, twitterLabel] andRunMethod:@"shareToTwitter"];
    [self listenFor:@"touchesBegan" fromObjects:@[mailImage, mailLabel] andRunMethod:@"shareToMail"];
    
    //magic for dismissing the keyboard
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];

    
    
    
}

-(void)shareToFacebook{
    C4Log(@"sharing toFacebook");
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:message];
    [controller addImage:imageToSend];
    [self presentViewController:controller animated:YES completion:Nil];
    
}
-(void)shareToTwitter{
    C4Log(@"sharing to Twitter");
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:message];
    [controller addImage:imageToSend];
    [self presentViewController:controller animated:YES completion:Nil];
    
}
-(void)shareToMail{
    C4Log(@"emailing");
    MFMailComposeViewController *emailShareController = [[MFMailComposeViewController alloc] init];
    emailShareController.mailComposeDelegate = self;
    [emailShareController setSubject:@"Share Urban Alphabets Image"];
    [emailShareController setMessageBody:message isHTML:NO];
    [emailShareController addAttachmentData:UIImageJPEGRepresentation(imageToSend, 1) mimeType:@"image/jpeg" fileName:@"urbanAlphabetsImage.jpeg"];
    if (emailShareController) [self presentViewController:emailShareController animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Cancelled sending");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Message Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Message Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Sending Failed");
            break;
        default:
            NSLog(@"Message not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)hideKeyBoard {
    [textInput resignFirstResponder];
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
    //set message to what the text in the box is
    message=textView.text;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // NSLog(@"textView:shouldChangeTextInRange:replacementText:");
    
    // NSLog(@"textView.text.length -- %lu",(unsigned long)textView.text.length);
    //NSLog(@"text.length          -- %lu",(unsigned long)text.length);
    //NSLog(@"text                 -- '%@'", text);
    NSLog(@"textView.text        -- '%@'", textView.text);
    
    // newCharacter=text;
    //self.entireText=textView.text;
    
    
    /*--
     * This method is called just before text in the textView is displayed
     * This is a good place to disallow certain characters
     * Limit textView to 140 characters
     * Resign keypad if done button pressed comparing the incoming text against the newlineCharacterSet
     * Return YES to update the textView otherwise return NO
     --*/
    
    
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){//140 characters are in the textView
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
