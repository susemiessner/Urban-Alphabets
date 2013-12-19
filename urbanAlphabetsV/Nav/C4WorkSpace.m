//
//  C4WorkSpace.m
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4Workspace.h"
#import "CropPhoto.h"

@implementation C4WorkSpace {
    CropPhoto *cropPhoto;
    
    C4Camera *cam;
    
    //to set a username when first using the app
    UITextView *userNameField;
    C4Image *okImage;
    C4Label *userNameLabel, *enterUserNameLabel;
   // NSString *userName;
    C4Shape *backgroundRect;

}

-(void)setup {
    self.title=@"Take Photo";

    //load the defaults
    [self loadDefaultAlphabet];
    self.currentLanguage= @"Finnish/Swedish"; 
    //setup the TakePhoto view
    [self cameraSetup];
    
    //setup the bottom bar
    //bottomNavbar WITH 2 ICONS
    CGRect bottomBarFrame = CGRectMake(0, self.canvas.height-UA_BOTTOM_BAR_HEIGHT, self.canvas.width, UA_BOTTOM_BAR_HEIGHT);
    self.bottomNavBar = [[BottomNavBar alloc] initWithFrame:bottomBarFrame leftIcon:UA_ICON_PHOTOLIBRARY withFrame:CGRectMake(0, 0, 45, 22.5) centerIcon:UA_ICON_TAKE_PHOTO withFrame:CGRectMake(0, 0, 90, 45)];
    [self.canvas addShape:self.bottomNavBar];
    //take photo button
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.centerImage andRunMethod:@"captureImage"];
    //photo library button
    [self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToPhotoLibrary"];
    
    
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"goToCropPhoto"];
    
    if (self.userName==nil) {
        //backgroundrect
        backgroundRect=[C4Shape rect:CGRectMake(20, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+30, self.canvas.width-40, 180)];
        backgroundRect.fillColor=UA_NAV_BAR_COLOR;
        backgroundRect.strokeColor=UA_NAV_CTRL_COLOR;
        [self.canvas addShape:backgroundRect];
        
        //enterUserNameLabel
        enterUserNameLabel=[C4Label labelWithText:@"Please choose a user name:" font:UA_FAT_FONT];
        enterUserNameLabel.origin=CGPointMake(backgroundRect.origin.x+10, backgroundRect.origin.y+20);
        [self.canvas addLabel:enterUserNameLabel];
        
        //UserNameLabel:
        userNameLabel=[C4Label labelWithText:@"username:" font:UA_NORMAL_FONT];
        userNameLabel.textColor=UA_TYPE_COLOR;
        userNameLabel.origin=CGPointMake(backgroundRect.origin.x+10, backgroundRect.origin.y+50);
        [self.canvas addLabel:userNameLabel];
        
        //add text field
        CGRect textViewFrame = CGRectMake(backgroundRect.origin.x+userNameLabel.width+20, backgroundRect.origin.y+50, backgroundRect.width-userNameLabel.width-30, 20.0f);
        userNameField = [[UITextView alloc] initWithFrame:textViewFrame];
        userNameField.returnKeyType = UIReturnKeyDone;
        [userNameField becomeFirstResponder];
        userNameField.delegate = self;
        [self.view addSubview:userNameField];
        
        //saveButton =okImage
        okImage=[C4Image imageWithImage:UA_ICON_OK];
        okImage.width=100;
        okImage.origin=CGPointMake(self.canvas.center.x-okImage.width/2, backgroundRect.center.y+10);
        [self listenFor:@"touchesBegan" fromObject:okImage andRunMethod:@"saveUserName"];
        
        [self.canvas addImage:okImage];
        
    }

}
-(void)viewDidLoad{
    self.userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    C4Log(@"userName:%@", self.userName);

}
-(void)saveUserName{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.userName=userNameField.text;
    [defaults setValue:self.userName forKey:@"userName"];
    C4Log(@"userName:%@", self.userName);
    [defaults synchronize];
    C4Log(@"defaults: %@", [defaults objectForKey:@"userName"]);
    //and remove the username stuff
    [backgroundRect removeFromSuperview];
    [enterUserNameLabel removeFromSuperview];
    [userNameLabel removeFromSuperview];
    [userNameField removeFromSuperview];
    [okImage removeFromSuperview];
}
-(void)cameraSetup{
    cam = [C4Camera cameraWithFrame:CGRectMake(0,0, self.canvas.width, self.canvas.height)];
    cam.cameraPosition = CAMERABACK;
    [self.canvas addCamera:cam];
    [cam initCapture];
    
}
-(void)captureImage{
    self.bottomNavBar.centerImage.backgroundColor=UA_HIGHLIGHT_COLOR;
    [cam captureImage];
    C4Log(@"capturing image");
}

-(void)goToCropPhoto {
    self.img = cam.capturedImage;
    C4Log(@"goToCropPhoto");
    cropPhoto = [[CropPhoto alloc] initWithNibName:@"CropPhoto" bundle:[NSBundle mainBundle]];
    [cropPhoto displayImage:self.img];
    [cropPhoto setup];
    
    [self.navigationController pushViewController:cropPhoto animated:YES];
}
-(void)goToPhotoLibrary{
    C4Log(@"goToPhotoLibrary");

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
//load image from photo library
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    C4Log(@"done");

    
    self.img = [C4Image imageWithUIImage:image];
    C4Log(@"goToCropPhoto");
    cropPhoto = [[CropPhoto alloc] initWithNibName:@"CropPhoto" bundle:[NSBundle mainBundle]];
    [cropPhoto displayImage:self.img];
    [cropPhoto setup];
    
    [self.navigationController pushViewController:cropPhoto animated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)loadDefaultAlphabet{
    self.currentAlphabet=[NSMutableArray arrayWithObjects:
                          //first row
                          [C4Image imageNamed:@"letter_A.png"],
                          [C4Image imageNamed:@"letter_B.png"],
                          [C4Image imageNamed:@"letter_C.png"],
                          [C4Image imageNamed:@"letter_D.png"],
                          [C4Image imageNamed:@"letter_E.png"],
                          [C4Image imageNamed:@"letter_F.png"],
                          //second row
                          [C4Image imageNamed:@"letter_G.png"],
                          [C4Image imageNamed:@"letter_H.png"],
                          [C4Image imageNamed:@"letter_I.png"],
                          [C4Image imageNamed:@"letter_J.png"],
                          [C4Image imageNamed:@"letter_K.png"],
                          [C4Image imageNamed:@"letter_L.png"],
                          
                          [C4Image imageNamed:@"letter_M.png"],
                          [C4Image imageNamed:@"letter_N.png"],
                          [C4Image imageNamed:@"letter_O.png"],
                          [C4Image imageNamed:@"letter_P.png"],
                          [C4Image imageNamed:@"letter_Q.png"],
                          [C4Image imageNamed:@"letter_R.png"],
                          
                          [C4Image imageNamed:@"letter_S.png"],
                          [C4Image imageNamed:@"letter_T.png"],
                          [C4Image imageNamed:@"letter_U.png"],
                          [C4Image imageNamed:@"letter_V.png"],
                          [C4Image imageNamed:@"letter_W.png"],
                          [C4Image imageNamed:@"letter_X.png"],
                          
                          [C4Image imageNamed:@"letter_Y.png"],
                          [C4Image imageNamed:@"letter_Z.png"],
                          [C4Image imageNamed:@"letter_Ä.png"],
                          [C4Image imageNamed:@"letter_Ö.png"],
                          [C4Image imageNamed:@"letter_Å.png"],
                          [C4Image imageNamed:@"letter_.png"],//.
                          
                          [C4Image imageNamed:@"letter_!.png"],
                          [C4Image imageNamed:@"letter_-.png"],//?
                          [C4Image imageNamed:@"letter_0.png"],
                          [C4Image imageNamed:@"letter_1.png"],
                          [C4Image imageNamed:@"letter_2.png"],
                          [C4Image imageNamed:@"letter_3.png"],
                          
                          [C4Image imageNamed:@"letter_4.png"],
                          [C4Image imageNamed:@"letter_5.png"],
                          [C4Image imageNamed:@"letter_6.png"],
                          [C4Image imageNamed:@"letter_7.png"],
                          [C4Image imageNamed:@"letter_8.png"],
                          [C4Image imageNamed:@"letter_9.png"],
                          
                          /* //the ones from the other languages
                           [C4Image imageNamed:@"letter_,.png"], //42
                           [C4Image imageNamed:@"letter_$.png"], //43
                           [C4Image imageNamed:@"letter_+.png"], //44
                           [C4Image imageNamed:@"letter_ae.png"],//45
                           [C4Image imageNamed:@"letter_danisho.png"], //46
                           [C4Image imageNamed:@"letter_Ü.png"], //47*/
                          nil];
}




@end
