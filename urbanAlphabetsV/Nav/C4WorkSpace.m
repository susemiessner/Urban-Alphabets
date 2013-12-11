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



@end
