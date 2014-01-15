//
//  AddAlphabet.h
//  UrbanAlphabets
//
//  Created by Suse on 09/01/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import "C4CanvasController.h"

@interface AddAlphabet : C4CanvasController <UITextViewDelegate>
-(void)setup;
-(void)grabCurrentLanguageViaNavigationController;
@end
