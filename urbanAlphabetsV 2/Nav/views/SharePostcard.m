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
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
    
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
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:message];
    [controller addImage:imageToSend];
    [self presentViewController:controller animated:NO completion:Nil];
}
-(void)shareToTwitter{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:message];
    [controller addImage:imageToSend];
    [self presentViewController:controller animated:NO completion:Nil];
}
-(void)shareToMail{
    MFMailComposeViewController *emailShareController = [[MFMailComposeViewController alloc] init];
    emailShareController.mailComposeDelegate = self;
    [emailShareController setSubject:@"Share Urban Alphabets Image"];
    [emailShareController setMessageBody:message isHTML:NO];
    [emailShareController addAttachmentData:UIImageJPEGRepresentation(imageToSend, 1) mimeType:@"image/jpeg" fileName:@"urbanAlphabetsImage.jpeg"];
    if (emailShareController) [self presentViewController:emailShareController animated:NO completion:nil];
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
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)hideKeyBoard {
    [textInput resignFirstResponder];
}
//--------------------------------------------------
//NAVIGATION
//--------------------------------------------------
-(void)goBack{
    [self.navigationController popViewControllerAnimated:NO];
}
//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{}
- (void)textViewDidEndEditing:(UITextView *)textView{
    message=textView.text;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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

- (void)textViewDidChange:(UITextView *)textView{}


@end
