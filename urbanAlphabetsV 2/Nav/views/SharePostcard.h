//
//  SharePostcard.h
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SharePostcard : UIViewController<MFMailComposeViewControllerDelegate, UITextViewDelegate>
-(void)setup:(UIImage*)imageToShare;


@end
