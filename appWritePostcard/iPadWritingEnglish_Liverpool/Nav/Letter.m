//
//  Letter.m
//  iPadWriting
//
//  Created by Suse on 31/08/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import "Letter.h"

@implementation Letter
-(void)loadImage{
    NSString *identifierString=[NSString stringWithFormat:@"%i", (int)self.identifier];
    NSString *folderName=[identifierString substringToIndex:2];
    NSString *urlString=[NSString stringWithFormat:@"http://www.ualphabets.com/images/244x200/%@/%i.png", folderName, (int)self.identifier];

    NSURL *url = [NSURL URLWithString:urlString];
    //NSLog(@"URL: %@",urlString);
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(110,10,100,80)];
    [self.image setImage:[UIImage imageWithData:data]];
    
    NS

}
-(void)loadImageFromDirectory{
    NSString *letter=self.letterName;
    if ([letter isEqualToString:@"AA"]) {
        letter=@"Ä";
    } else if ([letter isEqualToString:@"OO"]) {
        letter=@"Ö";
    }else if ([letter isEqualToString:@"UU"]) {
        letter=@"Ü";
    }else if ([letter isEqualToString:@"AAA"]) {
        letter=@"Å";
    }
    NSString *imageName=[NSString stringWithFormat:@"letter_%@.png", letter];
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(110,10,100,80)];
    [self.image setImage:[UIImage imageNamed:imageName]];

}
@end
