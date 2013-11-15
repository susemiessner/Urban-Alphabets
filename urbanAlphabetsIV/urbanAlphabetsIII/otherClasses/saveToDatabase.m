//
//  saveToDatabase.m
//  urbanAlphabetsIV
//
//  Created by Suse on 15/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "saveToDatabase.h"

@implementation saveToDatabase

-(void)saveToDatabaseWithLocation:(CLLocation *)currentLocation ImageNumber:(int)chosenImageNumberInArray Image:(C4Image*)image
{
    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------
    NSString *path=[NSString stringWithFormat:@"letter_%@.png", [NSDate date]];
    NSString *longitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSString *latitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *owner=@"user";
    NSString *letter=[NSString stringWithFormat:@"%lu",(unsigned long)chosenImageNumberInArray];
    NSString *postcard=@"no";
    NSString *alphabet=@"no";
    
    NSData *imageData=UIImagePNGRepresentation(image.UIImage);
    NSString *post = [NSString stringWithFormat:@"path=%@&longitude=%@&latitude=%@&owner=%@&letter=%@&postcard=%@&alphabet=%@&image=%@", path, longitude,latitude,owner,letter,postcard,alphabet, imageData];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://mlab.taik.fi/UrbanAlphabets/add.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // now lets make the connection to the web
    [[NSURLConnection alloc]initWithRequest:request delegate:self];

}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    C4Log(@"received response:%@", response);
}
@end
