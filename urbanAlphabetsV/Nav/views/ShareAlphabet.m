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
    C4Image *alphabetImage, *twitterImage, *facebookImage, *mailImage;
    UIImage *imageToSend;
    
}

@end

@implementation ShareAlphabet

-(void)setup:(UIImage*)imageToShare{
    self.title=@"Share Alphabet";
    imageToSend=[imageToShare copy];
    
    alphabetImage=[C4Image imageWithUIImage:imageToShare];
    alphabetImage.width=46;
    alphabetImage.center=CGPointMake(20+alphabetImage.width/2, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+50);
    [self.canvas addImage:alphabetImage];
    
    twitterImage=UA_ICON_TWITTER;
    twitterImage.width=40;
    twitterImage.center=CGPointMake(twitterImage.width/2+20, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+200);
    [self.canvas addImage:twitterImage];
    
    facebookImage=UA_Icon_FB;
    facebookImage.width=40;
    facebookImage.center=CGPointMake(facebookImage.width/2+20, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+260);
    [self.canvas addImage:facebookImage];
    
    mailImage=UA_ICON_MAIL;
    mailImage.width=46;
    mailImage.center=CGPointMake(twitterImage.width/2+20, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE+320);
    [self.canvas addImage:mailImage];
    //interactions
    [self listenFor:@"touchesBegan" fromObject:facebookImage andRunMethod:@"shareToFacebook"];
    [self listenFor:@"touchesBegan" fromObject:twitterImage andRunMethod:@"shareToTwitter"];
    [self listenFor:@"touchesBegan" fromObject:mailImage andRunMethod:@"shareToMail"];

    

}

-(void)shareToFacebook{
    C4Log(@"sharing toFacebook");
    NSString *message=@"something";
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:message];
    [controller addImage:imageToSend];
    [self presentViewController:controller animated:YES completion:Nil];

}
-(void)shareToTwitter{
    C4Log(@"sharing to Twitter");
    NSString *message=@"something";
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:message];
    [controller addImage:imageToSend];
    [self presentViewController:controller animated:YES completion:Nil];
    
}
-(void)shareToMail{
    NSString *message=@"something";
    MFMailComposeViewController *emailShareController = [[MFMailComposeViewController alloc] init];
    emailShareController.mailComposeDelegate = self;
    [emailShareController setSubject:@"Share Image"];
    [emailShareController setMessageBody:message isHTML:NO];
    [emailShareController addAttachmentData:UIImageJPEGRepresentation(imageToSend, 1) mimeType:@"image/jpeg" fileName:@"urbanAlphabet.jpeg"];
    if (emailShareController) [self presentViewController:emailShareController animated:YES completion:nil];
}
@end
