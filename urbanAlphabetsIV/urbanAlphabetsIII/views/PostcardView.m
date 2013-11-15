//
//  PostcardView.m
//  urbanAlphabetsIII
//
//  Created by Suse on 06/11/13.
//  Copyright (c) 2013 Suse. All rights reserved.
//

#import "PostcardView.h"

@interface PostcardView (){
    //saving image
    CGContextRef graphicsContext;
    
    C4Shape *background;

}
@property (nonatomic) TopNavBar *topNavBar;
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite) NSMutableArray  *postcardArray, *greyRectArray;
@property (nonatomic) PostcardMenu *menu;
@end

@implementation PostcardView

-(void)setupWithPostcard: (NSMutableArray*)postcardPassed Rect: (NSMutableArray*)postcardRect {

    self.postcardArray=[[NSMutableArray alloc]init];
    self.postcardArray=[postcardPassed mutableCopy];
    self.greyRectArray=[[NSMutableArray alloc]init];
    self.greyRectArray=[postcardRect mutableCopy];
    C4Log(@"passed grey rect array:%i", [postcardRect count]);
    C4Log(@"self grey rect array: %i", [self.greyRectArray count]);
    
    //white background
    background=[C4Shape rect:CGRectMake(0, 0, self.canvas.width, self.canvas.height)];
    background.fillColor=UA_WHITE_COLOR;
    background.lineWidth=0;
    [self.canvas addShape:background];
    
    //top nav bar
    CGRect topBarFrame = CGRectMake(0, UA_TOP_WHITE, self.canvas.width, UA_TOP_BAR_HEIGHT);
    self.topNavBar = [[TopNavBar alloc] initWithFrame:topBarFrame text:@"Postcard" lastView:@"WritePostcard"];
    [self.canvas addShape:self.topNavBar];

    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:[C4Image imageNamed:@"icon_TakePhoto"] withFrame:CGRectMake(0, 0, 60, 30)  centerIcon:[C4Image imageNamed:@"icon_Menu"] withFrame:CGRectMake(0, 0, 45, 45)];
    [self.canvas addShape:self.bottomNavBar];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToTakePhoto"];
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"openMenu"];
    
    //display the postcard
    
    float imageWidth=53.53;
    float imageHeight=65.1;
    for (int i=0; i<[self.postcardArray count]; i++) {
        float xMultiplier=(i)%6;
        float yMultiplier= (i)/6;
        float xPos=xMultiplier*imageWidth;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+yMultiplier*imageHeight;
        
        C4Image *image=[self.postcardArray objectAtIndex:i ];
        image.origin=CGPointMake(xPos, yPos);
        image.width=imageWidth;
        [self.canvas addImage:image];
    }
    for (int i=0; i<[self.greyRectArray count]; i++) {
        C4Shape *greyRect=[self.greyRectArray objectAtIndex:i];
        greyRect.fillColor=UA_NAV_CTRL_COLOR;
        greyRect.lineWidth=2;
        greyRect.strokeColor=UA_NAV_BAR_COLOR;
        [self.canvas addShape:greyRect];

    }
}

-(void)removeFromView{
    [background removeFromSuperview];
    [self.topNavBar removeFromSuperview];
    [self.bottomNavBar removeFromSuperview];
    for (int i=0; i<[self.postcardArray count]; i++) {
        C4Image *image=[self.postcardArray objectAtIndex:i];
        [image removeFromSuperview];
    }
    for (int i=0; i<[self.greyRectArray count]; i++) {
        C4Shape *shape=[self.greyRectArray objectAtIndex:i];
        [shape removeFromSuperview];
    }
    [self.menu removeFromSuperview];
}

//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void)goToTakePhoto{
    //[self removeFromView];
    self.bottomNavBar.leftImage.backgroundColor=UA_HIGHLIGHT_COLOR;

    [self postNotification:@"goToTakePhoto"];
}
-(void)openMenu{
    C4Log(@"openMenu");
    CGRect menuFrame = CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    self.menu=[[PostcardMenu alloc]initWithFrame:menuFrame];
    [self.canvas addShape:self.menu];
    [self listenFor:@"touchesBegan" fromObjects:@[self.menu.cancelShape, self.menu.cancelLabel] andRunMethod:@"closeMenu"];
    [self listenFor:@"touchesBegan" fromObjects:@[self.menu.savePostcardShape, self.menu.savePostcardLabel,self.menu.savePostcardIcon] andRunMethod:@"goToSavePostcard"];
    [self listenFor:@"hidePostcardView" andRunMethod:@"removeFromView"];
}
-(void)closeMenu{
    C4Log(@"closingMenu");
    [self.menu removeFromSuperview];
}

-(void)goToSavePostcard{
    C4Log(@"goToSavePostcard");
    [self.menu removeFromSuperview];
    [self postNotification:@"saveCurrentPostcardAsImage"];
    [self savePostcard];
}
//------------------------------------------------------------------------
//SAVING IMAGE FUNCTIONS
//------------------------------------------------------------------------
-(void)savePostcard{
    //crop the screenshot
    self.currentPostcardImage=[self cropImage:self.currentPostcardImage toArea:CGRectMake(0, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT, self.canvas.width, self.canvas.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT))];
    [self exportHighResImage];
}
-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    [self.currentPostcardImage renderInContext:graphicsContext];
    NSString *fileName = [NSString stringWithFormat:@"exportedPostcard%@.jpg", [NSDate date]];
    //C4Log(@"%@",s );
    
    [self saveImage:fileName];
    [self saveImageToLibrary];
}
-(CGContextRef)createHighResImageContext { //setting up image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.canvas.width, self.canvas.height-(UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+UA_BOTTOM_BAR_HEIGHT)), YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}
-(void)saveImage:(NSString *)fileName {
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //--------------------------------------------------
    //upload image to database
    //--------------------------------------------------
    NSString *path=[NSString stringWithFormat:@"postcard_%@.png", [NSDate date]];
    NSString *longitude= @"0";
    NSString *latitude= @"0";
    NSString *owner=@"user";
    NSString *letter=@"no";
    NSString *postcard=@"yes";
    NSString *alphabet=@"no";
    
    //NSData *imageData=UIImagePNGRepresentation(croppedImage.UIImage);
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

    
    NSString *savePath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
}
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}
-(void)saveImageToLibrary {
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}
-(C4Image *)cropImage:(C4Image *)originalImage toArea:(CGRect)rect{
    //grab the image scale
    CGFloat scale = 1.0;
    
    //begin an image context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    
    //create a new context ref
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //shift BACKWARDS in both directions because this moves the image
    //the area to crop shifts INTO: (0, 0, rect.size.width, rect.size.height)
    CGContextTranslateCTM(c, -rect.origin.x, -rect.origin.y);
    
    //render the original image into the context
    [originalImage renderInContext:c];
    
    //grab a UIImage from the context
    UIImage *newUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end the image context
    UIGraphicsEndImageContext();
    
    //create a new C4Image
    C4Image *newImage = [C4Image imageWithUIImage:newUIImage];
    
    //return the new image
    return newImage;
}

@end
