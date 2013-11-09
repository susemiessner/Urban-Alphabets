//
//  AlphabetInfo.h
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "C4CanvasController.h"

@interface AlphabetInfo : C4CanvasController
@property (readwrite)NSString *previousView;

-(void)setupWithLanguage:(NSString*)theLanguage;
@end
