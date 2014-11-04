//
//  LetterView.m
//  UrbanAlphabets
//
//  Created by Suse on 16/12/13.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "LetterView.h"
#import "BottomNavBar.h"
#import "TakePhotoViewController.h"

@interface LetterView (){
    TakePhotoViewController *takePhoto;
    C4WorkSpace *workspace;
    int currentLetter;
    UIImageView *currentImage; //the image currently displayed
    UIImageView *currentImageView;
    
    float letterWidth;
    float letterHeight;
    float letterFromLeft;
}
@property (nonatomic) BottomNavBar *bottomNavBar;
@property (readwrite, strong)  NSMutableArray *currentAlphabet;
@end

@implementation LetterView
-(void)setupWithLetterNo: (int)chosenNumber currentAlphabet:(NSMutableArray*)passedAlphabet{
    self.title=@"Letter View";
    self.navigationItem.hidesBackButton = YES;
    //bottomNavbar WITH 3 ICONS
    CGRect bottomBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-UA_BOTTOM_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 70, 35) centerIcon:UA_ICON_ALPHABET withFrame:CGRectMake(0, 0, 70, 35) rightIcon:UA_ICON_DELETE withFrame:CGRectMake(0, 0, 40, 40)];
    [self.view addSubview:self.bottomNavBar];
    
    UITapGestureRecognizer *takePhotoButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToTakePhoto)];
    takePhotoButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.leftImageView addGestureRecognizer:takePhotoButtonRecognizer];
    UITapGestureRecognizer *deleteButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteLetter)];
    deleteButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.rightImageView addGestureRecognizer:deleteButtonRecognizer];
    UITapGestureRecognizer *abcButtonRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAlphabetsView)];
    abcButtonRecognizer.numberOfTapsRequired = 1;
    [self.bottomNavBar.centerImageView addGestureRecognizer:abcButtonRecognizer];
    
    //check which phone
    letterWidth=[[UIScreen mainScreen] bounds].size.width;
    letterHeight=letterWidth/0.82;
    letterFromLeft=0;
    if ( UA_IPHONE_4_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
      //if ( UA_IPHONE_5_HEIGHT == [[UIScreen mainScreen] bounds].size.height) {
        letterHeight=[[UIScreen mainScreen] bounds].size.height-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT-self.bottomNavBar.frame.size.height;
        letterWidth=letterWidth*0.82;
        letterFromLeft=([[UIScreen mainScreen] bounds].size.width-letterWidth)/2;
    }else if(UA_IPAD_RETINA_HEIGHT==[[UIScreen mainScreen]bounds].size.height){
        letterHeight=[[UIScreen mainScreen] bounds].size.height-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT-self.bottomNavBar.frame.size.height;
        letterWidth=letterWidth*0.82;
        letterFromLeft=([[UIScreen mainScreen] bounds].size.width-letterWidth)/2;
    }
    
    //THE LETTER
    self.currentAlphabet=[passedAlphabet mutableCopy];
    currentLetter=chosenNumber;
    currentImage=[[UIImageView alloc]init];
    currentImage=[self.currentAlphabet objectAtIndex:currentLetter];
    currentImageView=[[UIImageView alloc] initWithFrame:CGRectMake(letterFromLeft, UA_TOP_BAR_HEIGHT+UA_TOP_WHITE, letterWidth, letterHeight)];
    currentImageView.image=currentImage.image;
    currentImageView.userInteractionEnabled=YES;
    [self.view addSubview:currentImageView];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goForward)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [currentImageView addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goBackward)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [currentImageView addGestureRecognizer:swipeRightRecognizer];
    
}
-(void)displayLetter:(int)chosenNumber{
    currentLetter=chosenNumber;
    currentImage=[self.currentAlphabet objectAtIndex:currentLetter];
    currentImageView.image=[currentImage.image copy];
}
//------------------------------------------------------------------------
//NAVIGATION FUNCTIONS
//------------------------------------------------------------------------
-(void) goToAlphabetsView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) goForward{
    [currentImage removeFromSuperview];
    currentLetter++;
    if (currentLetter>=[self.currentAlphabet count]) {
        currentLetter=0;
    }
    [self displayLetter:(int)currentLetter];
}
-(void) goBackward{
    [currentImage removeFromSuperview];
    currentLetter--;
    if (currentLetter<=0) {
        currentLetter=(int)[self.currentAlphabet count]-1;
    }
    [self displayLetter:(int)currentLetter];
}
-(void)goToTakePhoto{
    takePhoto=[[TakePhotoViewController alloc]initWithNibName:@"TakePhotoViewController" bundle:[NSBundle mainBundle]];
    [takePhoto setup];
    takePhoto.preselectedLetterNum=currentLetter;
    [self.navigationController pushViewController:takePhoto animated:YES];
}
-(void)deleteLetter{
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    //-----------------------------------
    //delete right letter
    [workspace.currentAlphabet removeObjectAtIndex:currentLetter];
    
    //-----------------------------------
    //add default letter back
    //>> find right letter in different languages
    NSString *letterToAdd=@" ";
    if ([workspace.currentLanguage isEqualToString:@"Finnish/Swedish"]) {
        letterToAdd=[workspace.finnish objectAtIndex:currentLetter];
    }else if([workspace.currentLanguage isEqualToString:@"German"]){
        letterToAdd=[workspace.german objectAtIndex:currentLetter];
    }else if([workspace.currentLanguage isEqualToString:@"English/Portugese"]){
        letterToAdd=[workspace.english objectAtIndex:currentLetter];
    }else if([workspace.currentLanguage isEqualToString:@"Danish/Norwegian"]){
        letterToAdd=[workspace.danish objectAtIndex:currentLetter];
    }else if([workspace.currentLanguage isEqualToString:@"Spanish"]){
        letterToAdd=[workspace.spanish objectAtIndex:currentLetter];
    }else if([workspace.currentLanguage isEqualToString:@"Russian"]){
        letterToAdd=[workspace.russian objectAtIndex:currentLetter];
    } else if([workspace.currentLanguage isEqualToString:@"Latvian"]){
        letterToAdd=[workspace.latvian objectAtIndex:currentLetter];
    }
    //>>replace for special characters
    if ([letterToAdd isEqualToString:@"?"]) {
        letterToAdd=@"-";
    }else if([letterToAdd isEqualToString:@"."]){
        letterToAdd=@"";
    }
    //>>construct filepath
    NSString *filepath=@"letter_";
    filepath=[filepath stringByAppendingString:letterToAdd];
    filepath=[filepath stringByAppendingString:@".png"];
    //>>load file
    UIImage *img = [UIImage imageNamed:filepath];
    UIImageView *loadedImage=[[UIImageView alloc]initWithImage:img];
    //add default letter
    [workspace.currentAlphabet insertObject:loadedImage atIndex:currentLetter];
    
    //-----------------------------------
    //delete letter from documents directory so it doesn't reload when reopening the app
    NSString *path= workspace.alphabetName;
    NSString *filePath=[[path stringByAppendingPathComponent:letterToAdd] stringByAppendingString:@".jpg"];
    [self removeImage:filePath];
    
    //go to alphabet view
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)removeImage:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    [fileManager removeItemAtPath:filePath error:&error];
}
@end
