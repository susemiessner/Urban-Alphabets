//
//  C4WorkSpace.m
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4Workspace.h"
#import "TakePhoto.h"

@implementation C4WorkSpace {
    TakePhoto *takePhoto;
    
    C4Button *buttonA;
}

-(void)setup {
    //sets the title for the current nav item
    self.title = @"Start";

    //create the workspaces to drill into
    [self createWorkSpaces];
    
    //create the buttons
    [self createAddButtons];
    
}

-(void)createWorkSpaces {
    
    //create TakePhoto
    takePhoto = [[TakePhoto alloc] initWithNibName:@"TakePhoto" bundle:[NSBundle mainBundle]];
    [takePhoto setup];
    
}

-(void)createAddButtons {
    //create button A
    buttonA = [C4Button buttonWithType:ROUNDEDRECT];
    buttonA.frame = CGRectMake(0,0,128,40);
    [buttonA setTitle:@"TakePhoto" forState:NORMAL];
    
    //position them
    buttonA.center = CGPointMake(self.canvas.center.x, self.canvas.center.y - 100);
    
    //give them methods to run
    [buttonA runMethod:@"goToTakePhoto" target:self forEvent:TOUCHUPINSIDE];
    
    //add them to the canvas
    [self.canvas addObjects:@[buttonA]];
}

//pushes TakePhoto onto the stack
-(void)goToTakePhoto {
    [self.navigationController pushViewController:takePhoto animated:YES];
}



@end
