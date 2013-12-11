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

}

-(void)setup {
    self.title=@"Take Photo";
    //load the defaults
    [self loadDefaultAlphabet];
    C4Log(@"currentAlphabet in TakePhoto %@", self.currentAlphabet);
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
    //[self listenFor:@"touchesBegan" fromObject:self.bottomNavBar.leftImage andRunMethod:@"goToPhotoLibrary"];
    
    
    [self numberOfTouchesRequired:1 forGesture:@"capture"];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"goToCropPhoto"];
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
-(void)changeCurrentAlphabet:(NSMutableArray*)passedAlphabet{
    self.currentAlphabet=[passedAlphabet mutableCopy];
}



@end
