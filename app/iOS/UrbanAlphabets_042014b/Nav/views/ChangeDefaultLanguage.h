//
//  ChangeDefaultLanguage.h
//  ualphabets
//
//  Created by Suse on 29/06/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeDefaultLanguage : UIViewController
-(void) setupWithLanguage: (NSString*)passedLanguage;
-(void) grabLanguagesViaNavigationController;
-(void)updateLanguage;
-(void)changeLanguage;
@end
