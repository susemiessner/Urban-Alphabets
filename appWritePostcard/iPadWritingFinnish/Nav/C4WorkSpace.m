//
//  C4WorkSpace.m
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4Workspace.h"
#import <AVFoundation/AVFoundation.h>

#import "SaveToDatabase.h"
#import "Letter.h"

@implementation C4WorkSpace {
    SaveToDatabase *save;

    //saving image
    CGContextRef graphicsContext;
    UIImage *currentImageToExport;
    
    //images loaded from documents directory
    UIImageView *loadedImage;
    
    UIImagePickerController *picker;
    float yPosIntro;
    
    float imageWidth;
    float imageHeight;
    float alphabetFromLeft;
    
    //background
    UIImage *background;
    
    //2 buttons
    UIImage *buttonRefresh;
    UIImage *buttonSend;
    

    NSMutableData *_downloadedData;
    
    NSData *receivedData;
    BOOL receivedResponse;
    
    //typing
    UITextView *textViewTest;
    //-----------------------
    //FOR KEYBOARD INPUT
    //-----------------------
    NSString *newCharacter;
    UIScrollView *scrollViewSuse;

    
}

-(void)setup {
    //load the defaults
    self.userName=@"MediaLabHelsinki 20 Year Exhibition";
    self.currentLanguage=@"Finnish/Swedish";
    
    background=[UIImage imageNamed:@"iPadWriting.png"];
    buttonRefresh=[UIImage imageNamed:@"icon_ClearPostcard.png"];
    buttonSend=[UIImage imageNamed:@"icon_SendToScreen.png"];
    
    //to see when app becomes active/inactive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //[self loadCurrentQuestion];
    //send request to server
    self.finalAlphabetArray=[[NSMutableArray alloc]init];
    [self loadAlphabetFromServer];
    
    
}
-(void)loadCurrentQuestion{
    
    NSString *urlString=@"http://www.ualphabets.com/requests/Riga/connected/question_iPad.php";
    
    NSURL *url = [NSURL URLWithString:urlString];
    //NSLog(@"URL: %@",urlString);
    NSData *receivedQuestion = [NSData dataWithContentsOfURL:url];
    NSString* newStr = [[NSString alloc] initWithData:receivedQuestion encoding:NSUTF8StringEncoding];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"[{\"question\":\""
                                               withString:@""];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"\"}]"                                          withString:@""];
    //newStr=[newStr substringToIndex:newStr.length-3];
    //newStr=[newStr substringWithRange:NSMakeRange(14, [newStr length]-3)];
    //NSLog(@"data: %@",newStr );
    self.title=newStr;
}

-(void)viewDidAppear:(BOOL)animated{
    self.title=@"Waiting for current question...";
    
    [self alphabetSetup];
}
-(void)loadAlphabetFromServer{
    self.receivedLettersArray=[[NSMutableArray alloc]init];
    self.theNewAlphabetArray=[[NSMutableArray alloc]init];
    
    NSLog(@"sending Request");
    receivedResponse=false;
    self.theNewAlphabetArray=[[NSMutableArray alloc]init];

    //build up the request that is to be sent to the server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL    URLWithString:@"http://www.ualphabets.com/requests/Helsinki/alphabet.php"]];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"getValues" forHTTPHeaderField:@"METHOD"]; //selects what task the server will perform
    
    //initialize an NSURLConnection  with the request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }

}
-(void)writePostcard{
    self.maxPostcardLength=42;
    
    //initiate postcard arrays
    self.postcardArray=[[NSMutableArray alloc]init];
    self.greyRectArray=[[NSMutableArray alloc]init];
    self.postcardViewArray=[[NSMutableArray alloc]init];
    
    
    //add text field
    CGRect textViewFrame = CGRectMake(20.0f, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+10, [[UIScreen mainScreen] bounds].size.width-40, 124.0f);
    textViewTest = [[UITextView alloc] initWithFrame:textViewFrame];
    textViewTest.returnKeyType = UIReturnKeyDone;
    [textViewTest becomeFirstResponder];
    textViewTest.delegate = self;
    textViewTest.hidden=true;
    textViewTest.userInteractionEnabled=NO;
    textViewTest.scrollEnabled=NO;
    [self.view addSubview:textViewTest];
    
    
    //make view scrollable
    scrollViewSuse=[[UIScrollView alloc]initWithFrame:CGRectMake(126, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE, [[UIScreen mainScreen] bounds].size.width-126*2, [[UIScreen mainScreen] bounds].size.height-216-30)];
    scrollViewSuse.scrollsToTop = NO;
    scrollViewSuse.bounces=NO;
    scrollViewSuse.pagingEnabled = NO;
    scrollViewSuse.delegate=self;
    [self.view addSubview: scrollViewSuse];
    scrollViewSuse.contentSize=CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-111);
   
    
}
-(void)clearPostcard{
    for (int i=0; i<[self.postcardViewArray count]; i++) {
        UIImageView *image=[self.postcardViewArray objectAtIndex:i];
        [image removeFromSuperview];
    }
    [self.postcardArray removeAllObjects];
    [self.postcardViewArray removeAllObjects];
    [self.greyRectArray removeAllObjects];
}


//------------------------------------------------------------------------
//download connection
//------------------------------------------------------------------------
#pragma mark - Data connection delegate -
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{ // executed when the connection receives data
    
    receivedData = data;
    /* NOTE: if you are working with large data , it may be better to set recievedData as NSMutableData
     and use  [receivedData append:Data] here, in this event you should also set recievedData to nil
     when you are done working with it or any new data received could end up just appending to the
     last message received*/
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{ //executed when the connection fails
    
    NSLog(@"Connection failed with error: %@",error.localizedDescription);
}
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    /*This message is sent when there is an authentication challenge ,our server does not have this requirement so we do not need to handle that here*/
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"Request Complete,recieved %d bytes of data",receivedData.length);
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:&error];
    //NSLog(@"received data: %@", jsonArray);
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new location object and set its props to JsonElement properties
        Letter *newLetter = [[Letter alloc] init];
        newLetter.identifier = [jsonElement[@"ID"] intValue];
        newLetter.letterName= jsonElement[@"letter"];
        
        [self.receivedLettersArray addObject:newLetter];
    }
    
    //[self.delegate requestReturnedData:receivedData];//send the data to the delegate
    //for all letters we need to have
    for (int i=0; i<[self.finnish count]; i++) {
        //add the latest letter to the new alphabet
        for (int j=0; j<[self.receivedLettersArray count]; j++) {
            Letter *letter=self.receivedLettersArray[j];
            if ([self.finnish[i] isEqualToString: letter.letterName]) {
                [self.theNewAlphabetArray addObject: letter];
                //NSLog(@"added : %@", letter.letterName);
                break;

            }
        }
    }
    //NSLog(@"length latvian: %i, length new alphabet: %i", [self.finnish count], [self.theNewAlphabetArray count]);
    for (int i=0; i<[self.finnish count]; i++) {
        for (int j=0; j<[self.theNewAlphabetArray count]; j++) {
            Letter *newLetter=self.theNewAlphabetArray[j];
            //NSLog(@"i:%i, j: %i latvian letter: %@   new alphabetletter: %@,   finalAlphabetArrayLength: %i",i,j, self.finnish[i], newLetter.letterName, [self.finalAlphabetArray count]);
            if ([self.finnish[i] isEqualToString: newLetter.letterName]) {
                //first time add all
                if ([self.finalAlphabetArray count] <42) {
                    //load the image
                    [newLetter loadImage];
                    //add the new letter
                    [self.finalAlphabetArray addObject:newLetter];
                    //NSLog(@"added new : %@", newLetter.letterName);
                    //Letter *letter=self.theNewAlphabetArray[[self.theNewAlphabetArray count]-1];
                    break;
                } else{
                    //then look which is newer + replace that one
                    Letter *oldLetter=self.finalAlphabetArray[i];
                   // NSLog(@"letter: %@ oldID: %i: new id: %i", newLetter.letterName,oldLetter.identifier, newLetter.identifier);
                    if (newLetter.identifier!=oldLetter.identifier) {
                        [newLetter loadImage];
                        [self.finalAlphabetArray removeObjectAtIndex:i];
                        [self.finalAlphabetArray insertObject:newLetter atIndex:i];
                       // NSLog(@"replaced : %@", newLetter.letterName);
                    }
                    

                    break;
                }
                //if it's not in the array add the letter from the Latvian array
            }else if (j==[self.theNewAlphabetArray count]-1 && [self.finalAlphabetArray count]<42){
                Letter *letterToAdd=[[Letter alloc]init];
               /* newLetter.identifier = 0;
                newLetter.letterName= self.finnish[i];
                //[newLetter loadImageFromDirectory];
                [self.finalAlphabetArray addObject:newLetter];
                NSLog(@"added missing : %@", newLetter.letterName);*/
                
                 letterToAdd.identifier = 0;
                 letterToAdd.letterName= self.finnish[i];
                 letterToAdd.image=[[UIImageView alloc]initWithImage: self.currentAlphabetUIImage[i]];
                 [self.finalAlphabetArray addObject:letterToAdd];
                 //NSLog(@"added missing : %@", letterToAdd.letterName);
            }
        }
    }
    //NSLog(@"final Alphabet array length %i", [self.finalAlphabetArray count]);
    receivedResponse=true;
    
    for (int i=0; i<[self.finalAlphabetArray count]; i++) {
        Letter *object=[self.finalAlphabetArray objectAtIndex:i ];
        UIImageView *image=[[UIImageView alloc]initWithImage:object.image.image];
        self.currentAlphabet[i]=image;
        //image.frame=CGRectMake(0, 0, 200, 200);
        //[self.view addSubview:image];
    }
    
    
    [self alphabetSetup];
    //[self drawCurrentAlphabet];
    //[self initGreyGrid];
    [self writePostcard];
    [self loadCurrentQuestion];
    
}


-(void)alphabetSetup{
    //remove everything displayed first
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    //white background
    UIImageView *backgroundView=[[UIImageView alloc]initWithImage:background];
    backgroundView.userInteractionEnabled=NO;
    [self.view addSubview:backgroundView];
    
    //buttons
    self.buttonRefreshView=[[UIImageView alloc]initWithImage:buttonRefresh];
    self.buttonRefreshView.frame=CGRectMake(0, 670, 120, 67);
    self.buttonRefreshView.userInteractionEnabled=YES;
    [self.view addSubview:self.buttonRefreshView];
    
    //make touchable
    UITapGestureRecognizer *refreshButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadAlphabetFromServer)];
    refreshButtonRecognizer.numberOfTapsRequired = 1;
    [self.buttonRefreshView addGestureRecognizer:refreshButtonRecognizer];
    
    
    self.buttonSendView=[[UIImageView alloc]initWithImage:buttonSend];
    self.buttonSendView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width-120, 670, 120, 67);
    self.buttonSendView.userInteractionEnabled=YES;
    [self.view addSubview:self.buttonSendView];
    
    //make touchable
    UITapGestureRecognizer *sendButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savePostcard)];
    sendButtonRecognizer.numberOfTapsRequired = 1;
    [self.buttonSendView addGestureRecognizer:sendButtonRecognizer];

    
    
    
    imageWidth=UA_IPAD_LETTER_IMG_WIDTH_5;
    imageHeight=UA_IPAD_LETTER_IMG_HEIGHT_5;
    alphabetFromLeft=UA_IPAD_LETTER_SIDE_MARGIN_ALPHABETS;
}
-(void)drawCurrentAlphabet{
    if (receivedResponse) {
        //self.currentAlphabet=[[NSMutableArray alloc]init];
        
    }
    for (NSUInteger i=0; i<[self.currentAlphabet count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth+alphabetFromLeft;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        
        UIImageView *image=[self.currentAlphabet objectAtIndex:i ];
        image.frame=CGRectMake(xPos, yPos, imageWidth, imageHeight);
        [self.view addSubview:image];
    }
}
-(void)initGreyGrid{
    self.greyRectArray=[[NSMutableArray alloc]init];
    
    for (NSUInteger i=0; i<42; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth+alphabetFromLeft;
        float yPos=1+UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        UIView *greyRect=[[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
        [greyRect setBackgroundColor:UA_NAV_CTRL_COLOR];
        
        greyRect.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        greyRect.layer.borderWidth=1.0f;
        greyRect.userInteractionEnabled=YES;
        [self.greyRectArray addObject:greyRect];
        [self.view addSubview:greyRect];
        
    }
}

//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
//------------------------------------------------------------------------
-(void)savePostcard{
    NSLog(@"saving");
    [self saveCurrentAlphabetAsImage];
    [self exportHighResImage];
    [self clearPostcard];
    [self loadAlphabetFromServer];
}
-(void)saveCurrentAlphabetAsImage{
    double screenScale = [[UIScreen mainScreen] scale];
    CGImageRef imageRef = CGImageCreateWithImageInRect([[self createScreenshot] CGImage], CGRectMake((alphabetFromLeft)*screenScale, (UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+2) * screenScale, ([[UIScreen mainScreen] bounds].size.width-alphabetFromLeft*2) * screenScale, ([[UIScreen mainScreen] bounds].size.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT+200))*screenScale));
    
    self.currentAlphabetImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}
- (UIImage *)createScreenshot{
    //    UIGraphicsBeginImageContext(pageSize);
    CGSize pageSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    UIGraphicsBeginImageContextWithOptions(pageSize, YES, 0.0f);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT)), YES, 5.0f);
    NSString *fileName = [NSString stringWithFormat:@"exportedPostcard%@.jpg", [NSDate date]];
    [self saveImage:fileName];
    [self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT)), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = self.currentAlphabetImage;
    self.currentAlphabetImageAsUIImage=[image copy];
    NSData *imageData = UIImagePNGRepresentation(image);

    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------
    save=[[SaveToDatabase alloc]init];
    [save sendPostcardToDatabase:imageData withLanguage: self.currentLanguage withText: self.postcardText  withUsername:self.userName];
    //--------------------------------------------------
    //save to documents directory
    //--------------------------------------------------
    NSString *dataPath = [[self documentsDirectory] stringByAppendingPathComponent:@"/alphabets"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *savePath = [dataPath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
}
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}
-(void)saveImageToLibrary {
    UIImage *image = self.currentAlphabetImageAsUIImage;
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    NSString *albumName=@"Urban Alphabets";
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    __block ALAssetsGroup* groupToAddTo;
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                        groupToAddTo = group;
                                    }
                                }
                              failureBlock:^(NSError* error) {
                              }];
    CGImageRef img = [image CGImage];
    [library writeImageToSavedPhotosAlbum:img
                                      metadata:nil
                               completionBlock:^(NSURL* assetURL, NSError* error) {
                                   if (error.code == 0) {
                                       
                                       // try to get the asset
                                       [library assetForURL:assetURL
                                                     resultBlock:^(ALAsset *asset) {
                                                         // assign the photo to the album
                                                         [groupToAddTo addAsset:asset];
                                                     }
                                                    failureBlock:^(NSError* error) {
                                                    }];
                                   }
                                   else {
                                   }
                               }];

}

-(void)saveUsernameToUserDefaults{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:self.userName forKey:@"userName"];
    [defaults synchronize];
}
//--------------------------------------------------
//load default alphabet
//--------------------------------------------------
-(void)loadDefaultAlphabet{
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"] ||[self.currentLanguage isEqualToString:@"German"]||[self.currentLanguage isEqualToString:@"Danish/Norwegian"]||[self.currentLanguage isEqualToString:@"English/Portugese"]||[self.currentLanguage isEqualToString:@"Spanish"]) {
        self.currentAlphabetUIImage=[NSMutableArray arrayWithObjects:
                                     //first row
                                     [UIImage imageNamed:@"letter_A.png"],
                                     [UIImage imageNamed:@"letter_B.png"],
                                     [UIImage imageNamed:@"letter_C.png"],
                                     [UIImage imageNamed:@"letter_D.png"],
                                     [UIImage imageNamed:@"letter_E.png"],
                                     [UIImage imageNamed:@"letter_F.png"],
                                     //second row
                                     [UIImage imageNamed:@"letter_G.png"],
                                     [UIImage imageNamed:@"letter_H.png"],
                                     [UIImage imageNamed:@"letter_I.png"],
                                     [UIImage imageNamed:@"letter_J.png"],
                                     [UIImage imageNamed:@"letter_K.png"],
                                     [UIImage imageNamed:@"letter_L.png"],
                                     
                                     [UIImage imageNamed:@"letter_M.png"],
                                     [UIImage imageNamed:@"letter_N.png"],
                                     [UIImage imageNamed:@"letter_O.png"],
                                     [UIImage imageNamed:@"letter_P.png"],
                                     [UIImage imageNamed:@"letter_Q.png"],
                                     [UIImage imageNamed:@"letter_R.png"],
                                     
                                     [UIImage imageNamed:@"letter_S.png"],
                                     [UIImage imageNamed:@"letter_T.png"],
                                     [UIImage imageNamed:@"letter_U.png"],
                                     [UIImage imageNamed:@"letter_V.png"],
                                     [UIImage imageNamed:@"letter_W.png"],
                                     [UIImage imageNamed:@"letter_X.png"],
                                     
                                     [UIImage imageNamed:@"letter_Y.png"],
                                     [UIImage imageNamed:@"letter_Z.png"],
                                     //here the special characters will be inserted
                                     [UIImage imageNamed:@"letter_.png"],//.
                                     
                                     [UIImage imageNamed:@"letter_!.png"],
                                     [UIImage imageNamed:@"letter_-.png"],//?
                                     [UIImage imageNamed:@"letter_0.png"],
                                     [UIImage imageNamed:@"letter_1.png"],
                                     [UIImage imageNamed:@"letter_2.png"],
                                     [UIImage imageNamed:@"letter_3.png"],
                                     
                                     [UIImage imageNamed:@"letter_4.png"],
                                     [UIImage imageNamed:@"letter_5.png"],
                                     [UIImage imageNamed:@"letter_6.png"],
                                     [UIImage imageNamed:@"letter_7.png"],
                                     [UIImage imageNamed:@"letter_8.png"],
                                     [UIImage imageNamed:@"letter_9.png"],
                                     nil];
        if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ä.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ö.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Å.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"German"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ä.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ö.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Ü.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"Danish/Norwegian"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_ae.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_danisho.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_Å.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"English/Portugese"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_+.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_dollar.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_,.png"] atIndex:28];
        }
        if ([self.currentLanguage isEqualToString:@"Spanish"]) {
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_spanishN.png"] atIndex:26];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_+.png"] atIndex:27];
            [self.currentAlphabetUIImage insertObject:[UIImage imageNamed:@"letter_,.png"] atIndex:28];
        }
    } else if ([self.currentLanguage isEqualToString:@"Latvian"]){
        self.currentAlphabetUIImage=[NSMutableArray arrayWithObjects:
                                     //first row
                                     [UIImage imageNamed:@"letter_A.png"],
                                     [UIImage imageNamed:@"letter_LatvA.png"],
                                     [UIImage imageNamed:@"letter_B.png"],
                                     [UIImage imageNamed:@"letter_C.png"],
                                     [UIImage imageNamed:@"letter_LatvC.png"],
                                     [UIImage imageNamed:@"letter_D.png"],
                                     //second row
                                     [UIImage imageNamed:@"letter_E.png"],
                                     [UIImage imageNamed:@"letter_LatvE.png"],
                                     [UIImage imageNamed:@"letter_F.png"],
                                     [UIImage imageNamed:@"letter_G.png"],
                                     [UIImage imageNamed:@"letter_LatvG.png"],
                                     [UIImage imageNamed:@"letter_H.png"],
                                     
                                     [UIImage imageNamed:@"letter_I.png"],
                                     [UIImage imageNamed:@"letter_LatvI.png"],
                                     [UIImage imageNamed:@"letter_J.png"],
                                     [UIImage imageNamed:@"letter_K.png"],
                                     [UIImage imageNamed:@"letter_LatvK.png"],
                                     [UIImage imageNamed:@"letter_L.png"],
                                     
                                     [UIImage imageNamed:@"letter_LatvL.png"],
                                     [UIImage imageNamed:@"letter_M.png"],
                                     [UIImage imageNamed:@"letter_N.png"],
                                     [UIImage imageNamed:@"letter_LatvN.png"],
                                     [UIImage imageNamed:@"letter_O.png"],
                                     [UIImage imageNamed:@"letter_P.png"],
                                     
                                     [UIImage imageNamed:@"letter_R.png"],
                                     [UIImage imageNamed:@"letter_S.png"],
                                     [UIImage imageNamed:@"letter_LatvSs.png"],
                                     [UIImage imageNamed:@"letter_T.png"],
                                     [UIImage imageNamed:@"letter_U.png"],
                                     [UIImage imageNamed:@"letter_LatvU.png"],
                                     
                                     [UIImage imageNamed:@"letter_V.png"],
                                     [UIImage imageNamed:@"letter_Z.png"],
                                     [UIImage imageNamed:@"letter_LatvZ.png"],
                                     [UIImage imageNamed:@"letter_1.png"],
                                     [UIImage imageNamed:@"letter_2.png"],
                                     [UIImage imageNamed:@"letter_3.png"],
                                     
                                     [UIImage imageNamed:@"letter_4.png"],
                                     [UIImage imageNamed:@"letter_5.png"],
                                     [UIImage imageNamed:@"letter_6.png"],
                                     [UIImage imageNamed:@"letter_7.png"],
                                     [UIImage imageNamed:@"letter_8.png"],
                                     [UIImage imageNamed:@"letter_9.png"],
                                     nil];
    } else{
        self.currentAlphabetUIImage=[NSMutableArray arrayWithObjects:
                                     //first row
                                     [UIImage imageNamed:@"letter_A.png"],
                                     [UIImage imageNamed:@"letter_RusB.png"],
                                     [UIImage imageNamed:@"letter_B.png"],
                                     [UIImage imageNamed:@"letter_RusG.png"],
                                     [UIImage imageNamed:@"letter_RusD.png"],
                                     [UIImage imageNamed:@"letter_E.png"],
                                     //second row
                                     [UIImage imageNamed:@"letter_RusJo.png"],
                                     [UIImage imageNamed:@"letter_RusSche.png"],
                                     [UIImage imageNamed:@"letter_RusSe.png"],
                                     [UIImage imageNamed:@"letter_RusI.png"],
                                     [UIImage imageNamed:@"letter_RusIkratkoje.png"],
                                     [UIImage imageNamed:@"letter_K.png"],
                                     
                                     [UIImage imageNamed:@"letter_RusL.png"],
                                     [UIImage imageNamed:@"letter_M.png"],
                                     [UIImage imageNamed:@"letter_RusN.png"],
                                     [UIImage imageNamed:@"letter_O.png"],
                                     [UIImage imageNamed:@"letter_RusP.png"],
                                     [UIImage imageNamed:@"letter_P.png"],
                                     
                                     [UIImage imageNamed:@"letter_C.png"],
                                     [UIImage imageNamed:@"letter_T.png"],
                                     [UIImage imageNamed:@"letter_Y.png"],
                                     [UIImage imageNamed:@"letter_RusF.png"],
                                     [UIImage imageNamed:@"letter_X.png"],
                                     [UIImage imageNamed:@"letter_RusZ.png"],
                                     
                                     [UIImage imageNamed:@"letter_RusTsche.png"],
                                     [UIImage imageNamed:@"letter_RusScha.png"],
                                     [UIImage imageNamed:@"letter_RusTschescha.png"],
                                     [UIImage imageNamed:@"letter_RusMjachkiSnak.png"],
                                     [UIImage imageNamed:@"letter_RusUi.png"],
                                     [UIImage imageNamed:@"letter_RusE.png"],
                                     
                                     [UIImage imageNamed:@"letter_RusJu.png"],
                                     [UIImage imageNamed:@"letter_RusJa.png"],
                                     [UIImage imageNamed:@"letter_0.png"],
                                     [UIImage imageNamed:@"letter_1.png"],
                                     [UIImage imageNamed:@"letter_2.png"],
                                     [UIImage imageNamed:@"letter_3.png"],
                                     
                                     [UIImage imageNamed:@"letter_4.png"],
                                     [UIImage imageNamed:@"letter_5.png"],
                                     [UIImage imageNamed:@"letter_6.png"],
                                     [UIImage imageNamed:@"letter_7.png"],
                                     [UIImage imageNamed:@"letter_8.png"],
                                     [UIImage imageNamed:@"letter_9.png"],
                                     nil];
    }
    self.currentAlphabet=[[NSMutableArray alloc]init];
    for (int i=0; i<[self.currentAlphabetUIImage count]; i++) {
        [self.currentAlphabet addObject:[[UIImageView alloc]initWithImage:[self.currentAlphabetUIImage objectAtIndex:i]]];
    }
    
    
    self.finnish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"AA", @"OO", @"AAA", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.german=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"AA", @"OO", @"UU", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.danish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"ae", @"danisho", @"Å", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.english=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"+", @"$", @",", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.spanish=[NSArray arrayWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"spanishN", @"+", @",", @".", @"!", @"?", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.russian=[NSArray arrayWithObjects:@"A", @"RusB", @"B", @"RusG", @"RusD", @"E", @"RusJo", @"RusSche", @"RusSe", @"RusI", @"RusIkratkoje", @"K", @"RusL", @"M", @"RusN", @"O", @"RusP", @"P", @"C", @"T", @"Y", @"RusF", @"X", @"RusZ", @"RusTsche", @"RusScha", @"RusTschescha", @"RusMjachkiSnak", @"RusUi", @"RusE", @"RusJu", @"RusJa", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",nil];
    self.latvian=[NSArray arrayWithObjects:@"A",@"LatvA",@"B", @"C", @"LatvC",@"D", @"E", @"LatvE", @"F", @"G", @"LatvG",@"H", @"I", @"LatvI", @"J", @"K", @"LatvK", @"L", @"LatvL", @"M", @"N", @"LatvN", @"O", @"P", @"R", @"S", @"LatvSs", @"T", @"U", @"LatvU", @"V", @"Z", @"LatvZ", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
}
//--------------------------------------------------
//save alphabet when app becomes inactive
//--------------------------------------------------
-(void)appWillResignActive:(NSNotification*)note{
    //save all images under alphabetName
    [self writeAlphabetsUserDefaults];
}
-(void)writeAlphabetsUserDefaults{
    NSUserDefaults *alphabetName=[NSUserDefaults standardUserDefaults];
    [alphabetName setValue:self.alphabetName forKey:@"alphabetName"];
    [alphabetName setValue:self.currentLanguage forKey:@"language"];
    [alphabetName setValue:self.myAlphabets forKey:@"myAlphabets"];
    [alphabetName setValue:self.myAlphabetsLanguages forKey:@"myAlphabetsLanguages"];
    [alphabetName setValue:self.defaultLanguage forKeyPath:@"defaultLanguage"];
    [alphabetName synchronize];
}
-(void)appWillBecomeActive:(NSNotification*)note{
    [self loadCorrectAlphabet];
}
-(void)loadCorrectAlphabet{
    //load default alphabet (in case needed)
    for (int i =0; i<[self.myAlphabets count]; i++) {
        if ([self.alphabetName isEqualToString:[self.myAlphabets objectAtIndex:i]]) {
            self.currentLanguage=[self.myAlphabetsLanguages objectAtIndex:i];
        }
    }
    [self loadDefaultAlphabet];
    //loading all letters
    NSString *path= [[self documentsDirectory] stringByAppendingString:@"/"];
    path=[path stringByAppendingPathComponent:self.alphabetName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSMutableArray *defaultAlphabet=[self.currentAlphabet mutableCopy];
        self.currentAlphabet=[[NSMutableArray alloc]init];
        for (int i=0; i<42; i++) {
            NSString *letterToAdd=@" ";
            if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]) {
                letterToAdd=[self.finnish objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"German"]){
                letterToAdd=[self.german objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"English/Portugese"]){
                letterToAdd=[self.english objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"Danish/Norwegian"]){
                letterToAdd=[self.danish objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"Spanish"]){
                letterToAdd=[self.spanish objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"Russian"]){
                letterToAdd=[self.russian objectAtIndex:i];
            }else if([self.currentLanguage isEqualToString:@"Latvian"]){
                letterToAdd=[self.latvian objectAtIndex:i];
            }
            
            NSString *filePath=[[path stringByAppendingPathComponent:letterToAdd] stringByAppendingString:@".jpg"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                NSData *imageData = [NSData dataWithContentsOfFile:filePath];
                UIImage *img = [UIImage imageWithData:imageData];
                UIImageView *imgView=[[UIImageView alloc]initWithImage:img];
                loadedImage=imgView;
            }else{
                loadedImage=[defaultAlphabet objectAtIndex:i];
            }
            [self.currentAlphabet addObject:loadedImage];
        }
    }
    
}

//------------------------------------------------------------------------
#pragma mark DISPLAY POSTCARD
//------------------------------------------------------------------------
-(void)displayPostcard{
    if([self.postcardArray count]<self.maxPostcardLength){
        [self addLetterToPostcard];
    }
    //delete letter
    if([newCharacter isEqual: @""] && [self.postcardArray count]>1){//remove last letter if delete button is pressed
        UIImageView *image=[self.postcardViewArray objectAtIndex:[self.postcardViewArray count]-1];
        [image removeFromSuperview];
        [self.postcardArray removeLastObject];
        [self.postcardViewArray removeLastObject];
        UIView *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }else if([newCharacter isEqual: @""] && [self.postcardArray count]==1){//remove last letter if delete button is pressed and only 1 character exists
        UIImageView *image=[self.postcardViewArray objectAtIndex:0];
        [image removeFromSuperview];
        [self.postcardArray removeAllObjects];
        [self.postcardViewArray removeAllObjects];
        UIView *greyRectRemove=[self.greyRectArray objectAtIndex:[self.greyRectArray count]-1 ];
        [greyRectRemove removeFromSuperview];
        [self.greyRectArray removeObjectAtIndex:[self.greyRectArray count]-1];
    }
    
    
    if (![newCharacter  isEqual:@""]) { //if something was added
        //draw only the last letter
        NSInteger lastLetter=[self.postcardArray count]-1;
        float xMultiplier=(lastLetter)%6;
        float yMultiplier= (lastLetter)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=yMultiplier*imageHeight;
        if (lastLetter>=0) {
            UIImageView *image=[self.postcardArray objectAtIndex:lastLetter];
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
            imageView.image=image.image;
            [scrollViewSuse addSubview:imageView];
            [self.postcardViewArray addObject:imageView];
            
            UIView *greyRect=[[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, imageWidth, imageHeight)];
            [greyRect setBackgroundColor:UA_NAV_CTRL_COLOR];
            greyRect.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
            greyRect.layer.borderWidth=1.0f;
            [self.greyRectArray addObject:greyRect];
            [scrollViewSuse addSubview:greyRect];
        }
    }
}
-(void)addLetterToPostcard{
    NSLog(@"new character: %@", newCharacter);
    //letters
    if ([self.currentLanguage isEqualToString:@"Finnish/Swedish"]||[self.currentLanguage isEqualToString:@"English/Portugese"]||[self.currentLanguage isEqualToString:@"Danish/Norwegian"]||[self.currentLanguage isEqualToString:@"German"]||[self.currentLanguage isEqualToString:@"Spanish"]) {
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            UIImageView *image=[self.currentAlphabet objectAtIndex: 0];
            [self.postcardArray addObject: image];
        } else if ([newCharacter isEqual: @"b"]||[newCharacter isEqual: @"B"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 1];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"c"]||[newCharacter isEqual: @"C"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 2];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"d"]||[newCharacter isEqual: @"D"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 3];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"e"]||[newCharacter isEqual: @"E"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 4];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"f"]||[newCharacter isEqual: @"F"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 5];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"g"]||[newCharacter isEqual: @"G"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 6];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"h"]||[newCharacter isEqual: @"H"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 7];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"i"]||[newCharacter isEqual: @"I"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 8];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"j"]||[newCharacter isEqual: @"J"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 9];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"k"]||[newCharacter isEqual: @"K"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 10];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"l"]||[newCharacter isEqual: @"L"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 11];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"m"]||[newCharacter isEqual: @"M"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 12];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"n"]||[newCharacter isEqual: @"N"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 13];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"o"]||[newCharacter isEqual: @"O"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 14];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"p"]||[newCharacter isEqual: @"P"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 15];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"q"]||[newCharacter isEqual: @"Q"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 16];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"r"]||[newCharacter isEqual: @"R"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 17];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"s"]||[newCharacter isEqual: @"S"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 18];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"t"]||[newCharacter isEqual: @"T"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 19];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"u"]||[newCharacter isEqual: @"U"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 20];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"v"]||[newCharacter isEqual: @"V"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 21];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"w"]||[newCharacter isEqual: @"W"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 22];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"x"]||[newCharacter isEqual: @"X"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 23];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"y"]||[newCharacter isEqual: @"Y"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 24];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"z"]||[newCharacter isEqual: @"Z"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 25];
            [self.postcardArray addObject: image];
            //pos 26
        }else if (([newCharacter isEqual: @"ä"]||[newCharacter isEqual: @"Ä"])&&([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"German"])){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"æ"]||[newCharacter isEqual: @"Æ"])&&[self.currentLanguage isEqual: @"Danish/Norwegian"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"+"]&&[self.currentLanguage isEqual: @"English/Portugese"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ñ"]||[newCharacter isEqual: @"Ñ"])&&[self.currentLanguage isEqual: @"Spanish"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }
        
        //pos 27
        else if (([newCharacter isEqual: @"ö"]||[newCharacter isEqual: @"Ö"]) && ([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"German"])){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"+"]&&[self.currentLanguage isEqual: @"Spanish"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"$"] && [self.currentLanguage isEqual: @"English/Portugese"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ø"]||[newCharacter isEqual: @"Ø"]) && [self.currentLanguage isEqual: @"Danish/Norwegian"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }
        
        //pos 28
        else if (([newCharacter isEqual: @"å"]||[newCharacter isEqual: @"Å"])&& ([self.currentLanguage isEqual: @"Finnish/Swedish"]||[self.currentLanguage isEqual: @"Danish/Norwegian"])){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }else if (([newCharacter isEqual: @"ü"]||[newCharacter isEqual: @"Ü"])&& [self.currentLanguage isEqual: @"German"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @","]&& ([self.currentLanguage isEqual: @"English/Portugese"]||[self.currentLanguage isEqual: @"Spanish"])){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }
        //pos 29
        else if ([newCharacter isEqual: @"."]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 29];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"!"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 30];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"?"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 31];
            [self.postcardArray addObject: image];
        }
    }
    if ([self.currentLanguage isEqualToString:@"Russian"]){
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            UIImageView *image=[self.currentAlphabet objectAtIndex: 0];
            [self.postcardArray addObject: image];
        } else if ([newCharacter isEqual: @"б"]||[newCharacter isEqual: @"Б"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 1];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"в"]||[newCharacter isEqual: @"В"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 2];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"г"]||[newCharacter isEqual: @"Г"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 3];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"д"]||[newCharacter isEqual: @"Д"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 4];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"е"]||[newCharacter isEqual: @"Е"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 5];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ё"]||[newCharacter isEqual: @"Ё"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 6];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ж"]||[newCharacter isEqual: @"Ж"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 7];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"з"]||[newCharacter isEqual: @"З"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 8];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"и"]||[newCharacter isEqual: @"И"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 9];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"й"]||[newCharacter isEqual: @"Й"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 10];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"к"]||[newCharacter isEqual: @"К"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 11];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"л"]||[newCharacter isEqual: @"Л"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 12];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"м"]||[newCharacter isEqual: @"М"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 13];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"н"]||[newCharacter isEqual: @"Н"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 14];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"о"]||[newCharacter isEqual: @"O"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 15];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"п"]||[newCharacter isEqual: @"П"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 16];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"р"]||[newCharacter isEqual: @"P"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 17];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"с"]||[newCharacter isEqual: @"C"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 18];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"т"]||[newCharacter isEqual: @"T"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 19];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"у"]||[newCharacter isEqual: @"Y"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 20];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ф"]||[newCharacter isEqual: @"Ф"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 21];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"х"]||[newCharacter isEqual: @"X"]){
            UIImage *image=[self.currentAlphabet objectAtIndex: 22];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ц"]||[newCharacter isEqual: @"Ц"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 23];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ч"]||[newCharacter isEqual: @"Ч"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 24];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ш"]||[newCharacter isEqual: @"Ш"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 25];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"щ"]||[newCharacter isEqual: @"Щ"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ь"]||[newCharacter isEqual: @"Ь"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ы"]||[newCharacter isEqual: @"Ы"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"э"]||[newCharacter isEqual: @"Э"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 29];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ю"]||[newCharacter isEqual: @"Ю"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 30];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"я"]||[newCharacter isEqual: @"Я"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 31];
            [self.postcardArray addObject: image];
        }
    }
    if ([self.currentLanguage isEqualToString:@"Latvian"]) {
        if ([newCharacter isEqual: @"a"]||[newCharacter isEqual: @"A"]) {
            UIImageView *image=[self.currentAlphabet objectAtIndex: 0];
            [self.postcardArray addObject: image];
        } else if ([newCharacter isEqual: @"ā"]||[newCharacter isEqual: @"Ā"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 1];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"b"]||[newCharacter isEqual: @"B"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 2];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"c"]||[newCharacter isEqual: @"C"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 3];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"č"]||[newCharacter isEqual: @"Č"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 4];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"d"]||[newCharacter isEqual: @"D"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 5];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"e"]||[newCharacter isEqual: @"E"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 6];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ē"]||[newCharacter isEqual: @"Ē"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 7];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"f"]||[newCharacter isEqual: @"F"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 8];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"g"]||[newCharacter isEqual: @"G"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 9];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ģ"]||[newCharacter isEqual: @"Ģ"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 10];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"h"]||[newCharacter isEqual: @"H"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 11];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"i"]||[newCharacter isEqual: @"I"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 12];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ī"]||[newCharacter isEqual: @"Ī"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 13];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"j"]||[newCharacter isEqual: @"j"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 14];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"k"]||[newCharacter isEqual: @"k"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 15];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ķ"]||[newCharacter isEqual: @"Ķ"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 16];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"l"]||[newCharacter isEqual: @"L"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 17];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ļ"]||[newCharacter isEqual: @"Ļ"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 18];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"m"]||[newCharacter isEqual: @"M"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 19];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"n"]||[newCharacter isEqual: @"N"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 20];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ņ"]||[newCharacter isEqual: @"Ņ"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 21];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"o"]||[newCharacter isEqual: @"O"]||[newCharacter isEqual: @"0"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 22];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"p"]||[newCharacter isEqual: @"P"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 23];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"r"]||[newCharacter isEqual: @"R"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 24];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"s"]||[newCharacter isEqual: @"S"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 25];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"š"]||[newCharacter isEqual: @"Š"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 26];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"t"]||[newCharacter isEqual: @"T"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 27];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"u"]||[newCharacter isEqual: @"U"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 28];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ū"]||[newCharacter isEqual: @"Ū"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 29];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"v"]||[newCharacter isEqual: @"V"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 30];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"z"]||[newCharacter isEqual: @"Z"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 31];
            [self.postcardArray addObject: image];
        }else if ([newCharacter isEqual: @"ž"]||[newCharacter isEqual: @"Ž"]){
            UIImageView *image=[self.currentAlphabet objectAtIndex: 32];
            [self.postcardArray addObject: image];
        }
    }
    
    //numbers
    if ([newCharacter isEqual: @"0"] &&(![self.currentLanguage isEqualToString: @"Latvian"])){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 32];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"1"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 33];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"2"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 34];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"3"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 35];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"4"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 36];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"5"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 37];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"6"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 38];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"7"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 39];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"8"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 40];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @"9"]){
        UIImageView *image=[self.currentAlphabet objectAtIndex: 41];
        [self.postcardArray addObject: image];
    }else if ([newCharacter isEqual: @" "]){ //space is displaying an empty letter
        UIImageView *image=[[UIImageView alloc]initWithImage:UA_LETTER_EMPTY];
        [self.postcardArray addObject: image];
    }
}
//------------------------------------------------------------------------
//STUFF TO HANDLE THE KEYBOARD INPUT
//------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{}
- (void)textViewDidEndEditing:(UITextView *)textView{
    //[self savePostcard];
    /*//prepare next view and go there
    postcardView=[[PostcardView alloc]initWithNibName:@"PostcardView" bundle:[NSBundle mainBundle]];
    [postcardView setupWithPostcard:self.postcardArray Rect:self.greyRectArray withLanguage:self.currentLanguage withPostcardText:self.entireText];
    [self.navigationController pushViewController:postcardView animated:NO];*/
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    newCharacter=text;
    self.postcardText=textView.text;
    [self displayPostcard];
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > self.maxPostcardLength){//42 characters are in the textView
        if (location != NSNotFound){ //Did not find any newline characters
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){ //Did not find any newline characters
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{}
@end
