//
//  AlphabetInfo.h
//  UrbanAlphabets
//
//  Created by Suse on 12/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4CanvasController.h"

@interface AlphabetInfo : C4CanvasController<UITextViewDelegate>
@property (nonatomic) NSString *currentLanguage;

-(void)setup;
-(void)grabCurrentLanguageViaNavigationController;
-(void)changeLanguage;
@end
