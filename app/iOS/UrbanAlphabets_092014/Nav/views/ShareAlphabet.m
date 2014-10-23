//
//  ShareAlphabet.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "ShareAlphabet.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ShareAlphabet (){
    UIImageView *alphabetImage, *twitterImage, *facebookImage, *mailImage;
    UIImage *imageToSend;
    UILabel *twitterLabel, *facebookLabel, *mailLabel;
    NSString *message;
    
    UITextView *textInput;
    UITapGestureRecognizer * tapGesture;
}

@end

@implementation ShareAlphabet

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
    
    alphabetImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+20, 100, 120) ];
    alphabetImage.image=imageToShare;
    [self.view addSubview:alphabetImage];
    
    //add text field
    CGRect textViewFrame = CGRectMake(alphabetImage.center.x+alphabetImage.frame.size.width, alphabetImage.frame.origin.y, [[UIScreen mainScreen] bounds].size.width-40-(alphabetImage.center.x+alphabetImage.frame.size.width), alphabetImage.frame.size.height);
    textInput = [[UITextView alloc] initWithFrame:textViewFrame];
    textInput.returnKeyType = UIReturnKeyDone;
    textInput.layer.borderWidth=1.0f;
    textInput.layer.borderColor=[UA_OVERLAY_COLOR CGColor];
    [textInput becomeFirstResponder];
    textInput.delegate = self;
    [self.view addSubview:textInput];
    
    //share images and labels
    int shareIconYPos=alphabetImage.frame.size.height+alphabetImage.frame.origin.y+20;
    NSLog(@"imageHeight: %i", shareIconYPos);
    twitterImage=[[UIImageView alloc]initWithFrame:CGRectMake(20,  shareIconYPos, 40, 40)];
    twitterImage.image=UA_ICON_TWITTER;
    twitterImage.userInteractionEnabled=YES;
    [self.view addSubview:twitterImage];
    NSLog(@"%f", twitterImage.frame.origin.y);
    
    int labelToLeft=60;
    int labelUp=10;
    twitterLabel=[[UILabel alloc]initWithFrame:CGRectMake(twitterImage.center.x+labelToLeft, twitterImage.center.y-labelUp, 100, 20) ];
    [twitterLabel setText:@"Twitter"];
    [twitterLabel setFont:UA_NORMAL_FONT];
    twitterLabel.userInteractionEnabled=YES;
    [self.view addSubview:twitterLabel];
    
    shareIconYPos+=60;
    facebookImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, shareIconYPos, 40, 40)];
    facebookImage.image=UA_Icon_FB;
    facebookImage.userInteractionEnabled=YES;
    [self.view addSubview:facebookImage];
    
    facebookLabel=[[UILabel alloc]initWithFrame:CGRectMake(facebookImage.center.x+labelToLeft, facebookImage.center.y-labelUp, 100, 20)];
    [facebookLabel setText:@"Facebook"];
    [facebookLabel setFont:UA_NORMAL_FONT];
    facebookLabel.userInteractionEnabled=YES;
    [self.view addSubview:facebookLabel];
    
    shareIconYPos+=60;
    mailImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, shareIconYPos, 40, 40)];
    mailImage.image=UA_ICON_MAIL;
    mailImage.userInteractionEnabled=YES;
    [self.view addSubview:mailImage];
    
    mailLabel=[[UILabel alloc]initWithFrame:CGRectMake(mailImage.center.x+labelToLeft, mailImage.center.y-labelUp, 100, 20)];
    [mailLabel setText:@"Mail"];
    [mailLabel setFont:UA_NORMAL_FONT];
    mailLabel.userInteractionEnabled=YES;
    [self.view addSubview:mailLabel];
    
    //interactions
    UITapGestureRecognizer *facebookImageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareToFacebook)];
    facebookImageTapRecognizer.numberOfTapsRequired = 1;
    [facebookImage addGestureRecognizer:facebookImageTapRecognizer];
    UITapGestureRecognizer *facebookLabelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareToFacebook)];
    facebookLabelTapRecognizer.numberOfTapsRequired = 1;
    [facebookLabel addGestureRecognizer:facebookLabelTapRecognizer];
    
    UITapGestureRecognizer *twitterImageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareToTwitter)];
    twitterImageTapRecognizer.numberOfTapsRequired = 1;
    [twitterImage addGestureRecognizer:twitterImageTapRecognizer];
    UITapGestureRecognizer *twitterLabelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareToTwitter)];
    twitterLabelTapRecognizer.numberOfTapsRequired = 1;
    [twitterLabel addGestureRecognizer:twitterLabelTapRecognizer];
    
    UITapGestureRecognizer *mailImageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareToMail)];
    mailImageTapRecognizer.numberOfTapsRequired = 1;
    [mailImage addGestureRecognizer:mailImageTapRecognizer];
    UITapGestureRecognizer *mailLabelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareToMail)];
    mailLabelTapRecognizer.numberOfTapsRequired = 1;
    [mailLabel addGestureRecognizer:mailLabelTapRecognizer];
    
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
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{}
- (void)textViewDidEndEditing:(UITextView *)textView{
    //set message to what the text in the box is
    message=textView.text;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
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
