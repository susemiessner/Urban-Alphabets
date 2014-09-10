//
//  Letter.h
//  iPadWriting
//
//  Created by Suse on 31/08/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Letter : NSObject
@property (nonatomic) int identifier;
@property (nonatomic) NSString  *letterName;
@property (nonatomic) UIImageView *image;
-(void)loadImage;
-(void)loadImageFromDirectory;
@end
