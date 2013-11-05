//
//  C4WorkSpace.m
//  urbanAlphabetsIII
//
//  Created by Suse on 05/11/13.
//

#import "C4Workspace.h"

@implementation C4WorkSpace

-(void)setup {
    [self loadDefaultAlphabet]; //loads default alphabet (all languages in 1 array) + sets up current alphabet as finnish
    fullCanvas=CGRectMake(0, 0, self.canvas.width, self.canvas.height);
    
    //change default styles as needd
    [self setupDefaultStyles];
    
    //create all the views
    [self createViews];
    
    //all the notificationListeners
    [self listenNotifications];
}
-(void)listenNotifications{
    [self listenFor:@"goToCropPhoto" andRunMethod:@"goToCropPhoto"];
    [self listenFor:@"goToTakePhoto" andRunMethod:@"goToTakePhoto"];
    [self listenFor:@"goToAssignPhoto" andRunMethod:@"goToAssignPhoto"];
}
//--------------------------------------------------
//CREATE VIEWS
//--------------------------------------------------
-(void)createViews{
    [self setupTakePhoto];
    [self setupCropPhoto];
    [self setupAssignLetter];
}
-(void)setupTakePhoto{
    takePhoto=[TakePhoto new];
    takePhoto.canvas.frame=fullCanvas;
    takePhoto.canvas.userInteractionEnabled=YES;
    [takePhoto setup];
    [takePhoto cameraSetup];
    [self.canvas addSubview:takePhoto.canvas];
}
-(void)setupCropPhoto{
    cropPhoto=[CropPhoto new];
    cropPhoto.canvas.frame=fullCanvas;
    cropPhoto.canvas.userInteractionEnabled=NO;
    cropPhoto.canvas.hidden=YES;
    //[cropPhoto setup];
    [self.canvas addSubview:cropPhoto.canvas];
    
}
-(void)setupAssignLetter{
    assignLetter=[AssignLetter new];
    assignLetter.canvas.frame=fullCanvas;
    assignLetter.canvas.userInteractionEnabled=NO;
    assignLetter.canvas.hidden=YES;
    [self.canvas addSubview:assignLetter.canvas];
}
//--------------------------------------------------
//NAVIGATION FUNCTIONS
//--------------------------------------------------
-(void)goToTakePhoto{
    [takePhoto setup];
    
    takePhoto.canvas.hidden=NO;
    takePhoto.canvas.userInteractionEnabled=YES;
    
    cropPhoto.canvas.hidden=YES;
    cropPhoto.canvas.userInteractionEnabled=NO;

}
-(void)goToCropPhoto{
    [cropPhoto displayImage:takePhoto.img];
    [cropPhoto setup];
    
    takePhoto.canvas.hidden=YES;
    takePhoto.canvas.userInteractionEnabled=NO;
    
    cropPhoto.canvas.hidden=NO;
    cropPhoto.canvas.userInteractionEnabled=YES;

}
-(void)goToAssignPhoto{
    C4Log(@"assignPhoto");
    [assignLetter setup:cropPhoto.croppedPhoto withAlphabet:self.currentAlphabet];
    takePhoto.canvas.hidden=YES;
    takePhoto.canvas.userInteractionEnabled=NO;

    cropPhoto.canvas.hidden=YES;
    cropPhoto.canvas.userInteractionEnabled=NO;
    
    assignLetter.canvas.hidden=NO;
    assignLetter.canvas.userInteractionEnabled=YES;

}

//--------------------------------------------------
//SETUP VERY BASIC STUFF (STYLES, ALPHABET)
//--------------------------------------------------
-(void)setupDefaultStyles{
    //label
    [C4Label defaultStyle].textColor = UA_GREY_TYPE_COLOR;
    //shape
    [C4Shape defaultStyle].lineWidth=0;
    [C4Shape defaultStyle].fillColor=UA_NAV_BAR_COLOR;
}
-(void)loadDefaultAlphabet{
    self.defaultAlphabet=[NSArray arrayWithObjects:
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
                          
                          //the ones from the other languages
                          [C4Image imageNamed:@"letter_,.png"], //42
                          [C4Image imageNamed:@"letter_$.png"], //43
                          [C4Image imageNamed:@"letter_+.png"], //44
                          [C4Image imageNamed:@"letter_ae.png"],//45
                          [C4Image imageNamed:@"letter_danisho.png"], //46
                          [C4Image imageNamed:@"letter_Ü.png"], //47
                          nil];
    
    self.currentAlphabet=[[NSMutableArray alloc]init];
    for (int i=0; i<42; i++) {
        C4Image *currentImage=[self.defaultAlphabet objectAtIndex:i];
        [self.currentAlphabet addObject:currentImage];
    }
}
@end
