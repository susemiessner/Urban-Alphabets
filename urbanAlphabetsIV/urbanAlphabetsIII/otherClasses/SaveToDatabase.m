//
//  SaveToDatabase.m
//  urbanAlphabetsIV
//
//  Created by Suse on 18/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "SaveToDatabase.h"

@implementation SaveToDatabase
-(void)sendLetterToDatabase: (CLLocation*)theLocation ImageNo:(NSUInteger)chosenImageNumberInArray Image:(C4Image*)croppedImage{
    currentLocation=theLocation;
    C4Log(@"sendingLetter");
    path=[NSString stringWithFormat:@"letter_%@.png", [NSDate date]];
    longitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    latitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    owner=@"user";
    letter=[NSString stringWithFormat:@"%lu",(unsigned long)chosenImageNumberInArray];
    postcard=@"no";
    alphabet=@"no";
    NSData *imageData=UIImagePNGRepresentation(croppedImage.UIImage);

    [self connect:imageData];
 
}
-(void)sendAlphabetToDatabase:(NSData*)imageData{
    C4Log(@"sendingAlphabet");

    path=[NSString stringWithFormat:@"alphabet_%@.png", [NSDate date]];
    longitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    latitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    owner=@"user";
    letter=@"no";
    postcard=@"no";
    alphabet=@"yes";
    [self connect:imageData];

}
-(void)sendPostcardToDatabase:(NSData*)imageData{
    C4Log(@"sendingPostcard");

    path=[NSString stringWithFormat:@"postcard_%@.png", [NSDate date]];
    longitude= @"0";
    latitude= @"0";
    owner=@"user";
    letter=@"no";
    postcard=@"yes";
    alphabet=@"no";
    [self connect:imageData];

}
-(void)connect:(NSData*)imageData{
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
