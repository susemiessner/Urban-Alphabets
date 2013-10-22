#import "C4WorkSpace.h"

@implementation C4WorkSpace{
    C4Image * photoTaken;
    C4Label * sliderLabel;
    C4Stepper *stepper;
}

-(void)setup{
    
    photoTaken=[C4Image imageNamed:@"C4Sky.png"];
    //photoTaken.width=self.canvas.width;
    photoTaken.origin=CGPointMake(0, 0);
    [self.canvas addImage:photoTaken];
    [photoTaken addGesture:PAN name:@"pan" action:@"move:"];
    
    sliderLabel=[C4Label labelWithText:@"1.0"];
    
    //stepper
    stepper = [C4Stepper stepper];
    stepper.center = self.canvas.center;
    [stepper runMethod:@"stepperValueChanged:" target:self forEvent:VALUECHANGED];
    [self.canvas addSubview:stepper];
    stepper.maximumValue = 10.0f;
    stepper.minimumValue = 0.0f;
    stepper.value=1.0f;
    stepper.stepValue=0.25f;
    
    //positioning
    sliderLabel.center=CGPointMake(self.canvas.width/2,self.canvas.height-50);
    
    //set up action

    
    [self.canvas addObjects:@[sliderLabel]];

    
}

-(void)stepperValueChanged:(UIStepper*)theStepper{
    //update the label to reflect current scale factor
    sliderLabel.text=[NSString stringWithFormat:@"%4.2f", theStepper.value];
    [sliderLabel sizeToFit];
    
    //theStepper.value=3.0f;
    C4Log(@"value changed");
    C4Log(@"current sender.value %f", theStepper.value);
    photoTaken.height=self.canvas.height*theStepper.value;
    photoTaken.center=self.canvas.center;
}

@end