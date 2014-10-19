//
//  Settings.h
//  ualphabets
//
//  Created by Suse on 27/06/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController<UITextViewDelegate>
@property (nonatomic) NSString *defaultLanguage;
@property (nonatomic) NSString *userName;

-(void)setup;
-(void)grabCurrentUsernameViaNavigationController;
-(void)updateDefaultLanguage;
@end
