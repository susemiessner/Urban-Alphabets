//
//  SaveToDatabase.m
//  urbanAlphabetsIV
//
//  Created by Suse on 18/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "SaveToDatabase.h"

@implementation SaveToDatabase
-(void)sendLetterToDatabase: (CLLocation*)theLocation ImageNo:(NSUInteger)chosenImageNumberInArray Image:(UIImage*)croppedImage Language:(NSString*)theLanguage Username:(NSString*)userName{
    currentLocation=theLocation;
    path=[NSString stringWithFormat:@"letter_%@.png", [NSDate date]];
    longitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    latitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    owner=userName;
    [self findRightLetter:chosenImageNumberInArray Language:theLanguage];
    //letter=[NSString stringWithFormat:@"%lu",(unsigned long)chosenImageNumberInArray];
    postcard=@"no";
    alphabet=@"no";
    language=@"none";
    postcardText=@"none";
    theImage=UIImageJPEGRepresentation(croppedImage,0.0);
    NSData *imageData=UIImagePNGRepresentation(croppedImage);
    [self connect:imageData];
}
-(void)sendAlphabetToDatabase:(NSData*)imageData withLanguage: (NSString*)theLanguage withLocation:(CLLocation*)theLocation  withUsername:(NSString*)userName{
    currentLocation=theLocation;
    path=[NSString stringWithFormat:@"alphabet_%@.png", [NSDate date]];
    longitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    latitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    owner=userName;
    letter=@"no";
    postcard=@"no";
    alphabet=@"yes";
    language=theLanguage;
    postcardText=@"none";
    theImage=[NSData dataWithData:imageData];
    [self connect:imageData];
}

-(void)sendPostcardToDatabase:(NSData*)imageData withLanguage: (NSString*)theLanguage withText: (NSString*)thePostcardText withLocation:(CLLocation*)theLocation withUsername:(NSString*)userName{
    currentLocation=theLocation;
    path=[NSString stringWithFormat:@"postcard_%@.png", [NSDate date]];
    longitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    latitude= [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    owner=userName;
    letter=@"no";
    postcard=@"yes";
    alphabet=@"no";
    language=theLanguage;
    postcardText=thePostcardText;
    theImage=[NSData dataWithData:imageData];
    [self connect:imageData];
}
-(void)connect:(NSData*)imageData{
    NSString *post = [NSString stringWithFormat:@"path=%@&longitude=%@&latitude=%@&owner=%@&letter=%@&postcard=%@&alphabet=%@&image=%@&language=%@&postcardText=%@", path, longitude,latitude,owner,letter,postcard,alphabet, imageData, language, postcardText];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.ualphabets.com/add.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    // now lets make the connection to the web
    (void)[[NSURLConnection alloc]initWithRequest:request delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
-(void)findRightLetter:(NSUInteger)chosenImageNumberInArray Language:(NSString*)theLanguage{
    self.finnish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"Ä", @"Ö", @"Å", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.german=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"Ä", @"Ö", @"Ü", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.danish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"ae", @"danisho", @"Å", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.english=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"+", @"$", @",", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.spanish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"spanishN", @"+", @",", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.russian=[NSArray arrayWithObjects:@"A", @"RusB", @"B", @"RusG", @"RusD", @"E", @"RusJo", @"RusSche", @"RusSe", @"RusI", @"RusIkratkoje", @"K", @"RusL", @"M", @"RusN", @"O", @"RusP", @"P", @"C", @"T", @"Y", @"RusF", @"X", @"RusZ", @"RusTsche", @"RusScha", @"RusTschescha", @"RusMjachkiSnak", @"RusUi", @"RusE", @"RusJu", @"RusJa", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",nil];
    self.latvian=[NSArray arrayWithObjects:@"A",@"LatvA",@"B", @"C", @"LatvC",@"D", @"E", @"LatvE", @"F", @"G", @"LatvG",@"H", @"I", @"LatvI", @"J", @"K", @"LatvK", @"L", @"LatvL", @"M", @"N", @"LatvN", @"O", @"P", @"R", @"S", @"LatvS", @"T", @"U", @"LatvU", @"V", @"Z", @"LatvZ", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
   
    if ([theLanguage isEqualToString:@"Finnish/Swedish"]) {
        letter=[self.finnish objectAtIndex:chosenImageNumberInArray];
    }else if ([theLanguage isEqualToString:@"German"]) {
        letter=[self.german objectAtIndex:chosenImageNumberInArray];
    } else if ([theLanguage isEqualToString:@"Danish/Norwegian"]) {
         letter=[self.danish objectAtIndex:chosenImageNumberInArray];
    }else if ([theLanguage isEqualToString:@"English/Portugese"]) {
        letter=[self.english objectAtIndex:chosenImageNumberInArray];
    }else if ([theLanguage isEqualToString:@"Spanish"]) {
        letter=[self.spanish objectAtIndex:chosenImageNumberInArray];
    } else if ([theLanguage isEqual:@"Russian"]) {
        letter=[self.russian objectAtIndex:chosenImageNumberInArray];
    } else if ([theLanguage isEqual:@"Latvian"]) {
        letter=[self.latvian objectAtIndex:chosenImageNumberInArray];
    }
    
    if ([letter isEqual:@"Ä"]) {
        letter=@"AA";
    } else if ([letter isEqual: @"Å"]){
        letter=@"AAA";
    } else if ([letter isEqual:@"Ö"]){
        letter=@"OO";
    } else if ([letter isEqual:@"Ü"]){
        letter=@"UU";
    }}


@end
