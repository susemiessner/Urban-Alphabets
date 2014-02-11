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
    [self connect:imageData];
}
-(void)connect:(NSData*)imageData{
    NSString *post = [NSString stringWithFormat:@"path=%@&longitude=%@&latitude=%@&owner=%@&letter=%@&postcard=%@&alphabet=%@&image=%@&language=%@&postcardText=%@", path, longitude,latitude,owner,letter,postcard,alphabet, imageData, language, postcardText];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://mlab.taik.fi/UrbanAlphabets/add.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSLog(@"request: %@", request);
    // now lets make the connection to the web
    (void)[[NSURLConnection alloc]initWithRequest:request delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@", response);
}
-(void)findRightLetter:(NSUInteger)chosenImageNumberInArray Language:(NSString*)theLanguage{
    if ([theLanguage isEqual:@"Finnish/Swedish"]||[theLanguage isEqualToString:@"German"] ||[theLanguage isEqualToString:@"English"] ||[theLanguage isEqualToString:@"Danish/Norwegian"] || [theLanguage isEqualToString:@"Spanish"]) {
        if ([theLanguage isEqualToString:@"Finnish/Swedish"]) {
            switch (chosenImageNumberInArray) {
                case 26:
                    letter=@"AA"; //Ä
                    break;
                case 27:
                    letter=@"OO"; //Ö
                    break;
                case 28:
                    letter=@"AAA"; //Å
                    break;
            }
        }
        if ([theLanguage isEqualToString:@"German"]) {
            switch (chosenImageNumberInArray) {
                case 26:
                    letter=@"AA"; //Ä
                    break;
                case 27:
                    letter=@"OO"; //Ö
                    break;
                case 28:
                    letter=@"UU"; //Ü
                    break;
            }
        }
        if ([theLanguage isEqualToString:@"Danish/Norwegian"]) {
            switch (chosenImageNumberInArray) {
                case 26:
                    letter=@"AE"; //AE
                    break;
                case 27:
                    letter=@"OO"; //Ö
                    break;
                case 28:
                    letter=@"UU"; //Ü
                    break;
            }
        }
        if ([theLanguage isEqualToString:@"English"]) {
            switch (chosenImageNumberInArray) {
                case 26:
                    letter=@"+"; //+
                    break;
                case 27:
                    letter=@"$"; //$
                    break;
                case 28:
                    letter=@","; //,
                    break;
            }
        }
        if ([theLanguage isEqualToString:@"Spanish"]) {
            switch (chosenImageNumberInArray) {
                case 26:
                    letter=@"NN"; //spanishN
                    break;
                case 27:
                    letter=@"+"; //+
                    break;
                case 28:
                    letter=@","; //,
                    break;
            }
        }
        switch (chosenImageNumberInArray) {
            case 0:
                letter=@"A";
                break;
            case 1:
                letter=@"B";
                break;
            case 2:
                letter=@"C";
                break;
            case 3:
                letter=@"D";
                break;
            case 4:
                letter=@"E";
                break;
            case 5:
                letter=@"F";
                break;
            case 6:
                letter=@"G";
                break;
            case 7:
                letter=@"H";
                break;
            case 8:
                letter=@"I";
                break;
            case 9:
                letter=@"J";
                break;
            case 10:
                letter=@"K";
                break;
            case 11:
                letter=@"L";
                break;
            case 12:
                letter=@"M";
                break;
            case 13:
                letter=@"N";
                break;
            case 14:
                letter=@"O";
                break;
            case 15:
                letter=@"P";
                break;
            case 16:
                letter=@"Q";
                break;
            case 17:
                letter=@"R";
                break;
            case 18:
                letter=@"S";
                break;
            case 19:
                letter=@"T";
                break;
            case 20:
                letter=@"U";
                break;
            case 21:
                letter=@"V";
                break;
            case 22:
                letter=@"W";
                break;
            case 23:
                letter=@"X";
                break;
            case 24:
                letter=@"Y";
                break;
            case 25:
                letter=@"Z";
                break;
            case 29:
                letter=@".";
                break;
            case 30:
                letter=@"!";
                break;
            case 31:
                letter=@"?";
                break;
            case 32:
                letter=@"0";
                break;
            case 33:
                letter=@"1";
                break;
            case 34:
                letter=@"2";
                break;
            case 35:
                letter=@"3";
                break;
            case 36:
                letter=@"4";
                break;
            case 37:
                letter=@"5";
                break;
            case 38:
                letter=@"6";
                break;
            case 39:
                letter=@"7";
                break;
            case 40:
                letter=@"8";
                break;
            case 41:
                letter=@"9";
                break;
            default:
                if (letter==nil) {
                    letter=[NSString stringWithFormat:@"%lu",(unsigned long)chosenImageNumberInArray];
                }
        }
        
    }if ([theLanguage isEqual:@"Russian"]) {
        switch (chosenImageNumberInArray) {
            case 0:
                letter=@"A";
                break;
            case 1:
                letter=@"RusB";
                break;
            case 2:
                letter=@"B";
                break;
            case 3:
                letter=@"RusG";
                break;
            case 4:
                letter=@"RusD";
                break;
            case 5:
                letter=@"E";
                break;
            case 6:
                letter=@"RusJo";
                break;
            case 7:
                letter=@"RusSche";
                break;
            case 8:
                letter=@"RusSe";
                break;
            case 9:
                letter=@"RusI";
                break;
            case 10:
                letter=@"RusIkratkoje";
                break;
            case 11:
                letter=@"K";
                break;
            case 12:
                letter=@"RusL";
                break;
            case 13:
                letter=@"M";
                break;
            case 14:
                letter=@"RusN";
                break;
            case 15:
                letter=@"O";
                break;
            case 16:
                letter=@"RusP";
                break;
            case 17:
                letter=@"P";
                break;
            case 18:
                letter=@"C";
                break;
            case 19:
                letter=@"T";
                break;
            case 20:
                letter=@"Y";
                break;
            case 21:
                letter=@"RusF";
                break;
            case 22:
                letter=@"X";
                break;
            case 23:
                letter=@"RusZ";
                break;
            case 24:
                letter=@"RusTsche";
                break;
            case 25:
                letter=@"RusScha";
                break;
            case 26:
                letter=@"RusTschescha"; //spanishN
                break;
            case 27:
                letter=@"RusMjachkiSnak"; //+
                break;
            case 28:
                letter=@"RusUi"; //,
                break;
            case 29:
                letter=@"RusE";
                break;
            case 30:
                letter=@"RusJu";
                break;
            case 31:
                letter=@"RusJa";
                break;
            case 32:
                letter=@"0";
                break;
            case 33:
                letter=@"1";
                break;
            case 34:
                letter=@"2";
                break;
            case 35:
                letter=@"3";
                break;
            case 36:
                letter=@"4";
                break;
            case 37:
                letter=@"5";
                break;
            case 38:
                letter=@"6";
                break;
            case 39:
                letter=@"7";
                break;
            case 40:
                letter=@"8";
                break;
            case 41:
                letter=@"9";
                break;
            default:
                letter=[NSString stringWithFormat:@"%lu",(unsigned long)chosenImageNumberInArray];
                break;
        }

    }
}


@end
