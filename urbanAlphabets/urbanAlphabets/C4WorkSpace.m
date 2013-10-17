//
//  C4WorkSpace.m
//  urbanAlphabets
//
//  Created by SuseMiessner on 10/16/13.
//

#import "C4Workspace.h"
#import "TakePhoto.h"
#import "CropPhoto.h"
#define bottomBarHeight 42
#define NavBarHeight 42
#define TopBarFromTop 20

@implementation C4WorkSpace{
    //views
    TakePhoto *takePhoto;
    CropPhoto *cropPhoto;
    
    //current view
    C4View *currentView;
    
    //variables needed everywhere
    C4Font *fatFont;
    
}

-(void)setup {
    
    fatFont=[C4Font fontWithName:@"HelveticaNeue-Bold" size:17];
    [self createViews];
    //[self createToolBar];
}

-(void) createViews{
    takePhoto=[[TakePhoto alloc] initWithNibName:@"TakePhoto" bundle:[NSBundle mainBundle]];
    cropPhoto=[[CropPhoto alloc] initWithNibName:@"CropPhoto" bundle:[NSBundle mainBundle]];
    
    takePhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    cropPhoto.canvas.frame=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    
    [takePhoto setup];
    [cropPhoto setup];
    C4Log(@"canvas width %f", self.canvas.width);
    C4Log(@"canvas height %f", self.canvas.height);
    
    //[self.canvas addSubview:takePhoto.canvas];
   // currentView = (C4View *)takePhoto.canvas ;
    [self.canvas addSubview:cropPhoto.canvas];
    currentView = (C4View *)cropPhoto.canvas ;
}

-(void)createToolBar{
    CGRect bottomBar = CGRectMake(0, self.canvas.height-bottomBarHeight, self.canvas.width, bottomBarHeight);
    UIToolbar *bottomToolBar = [[UIToolbar alloc] initWithFrame:bottomBar];
    bottomToolBar.barStyle=UIBarStyleDefault;
    
    
    UIBarButtonItem *flexible =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *takePhotoButton=[[UIBarButtonItem alloc] initWithTitle:@"Take Photo" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToTakePhoto)];
    UIBarButtonItem *cropPhotoButton=[[UIBarButtonItem alloc]initWithTitle:@"Crop Photo" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToCropPhoto)];
    
    [bottomToolBar setItems:@[flexible, takePhotoButton, cropPhotoButton, flexible]];
    [self.canvas addSubview:bottomToolBar];
}

-(void)switchToView:(C4View*)view transitionOptions:(UIViewAnimationOptions)options{

    if(![currentView isEqual:view]){
        [UIView transitionFromView:currentView
                            toView: view
                          duration: 0.75f
                           options: options
                        completion: ^(BOOL finished){
                            currentView=view;
                            finished=YES;
                        }];
    }
    [self createToolBar];
}



-(void)switchToTakePhoto{
    UIViewAnimationOptions options =UIViewAnimationOptionTransitionCrossDissolve;
    [self switchToView:(C4View*)takePhoto.canvas transitionOptions:options];
}
-(void)switchToCropPhoto{
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCrossDissolve;
    [self switchToView:(C4View*)cropPhoto.canvas transitionOptions:options];
}
@end
