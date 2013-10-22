#import "C4WorkSpace.h"

@implementation C4WorkSpace{
    C4Image * photoTaken;
    C4Slider * zoomSlider;
    C4Label *
}

-(void)setup{
    
    photoTaken=[C4Image imageNamed:@"C4Sky.png"];
    photoTaken.width=self.canvas.width;
    photoTaken.origin=CGPointMake(0, 0);
    [self.canvas addImage:photoTaken];
    //[photoTaken addGesture:PAN name:@"pan" action:@"move:"];
    
    sliderLabel=[C4Label labelWithText:@"1.0"];
    sliderLabel.textColor=navBarColor;
    zoomSlider=[C4Slider slider:CGRectMake(0, 0, self.canvas.width-20, 20)];
    
    //positioning
    sliderLabel.center=CGPointMake(self.canvas.width/2,self.canvas.height-NavBarHeight-50);
    zoomSlider.center=CGPointMake(sliderLabel.center.x,sliderLabel.center.y+10);
    
    //set up action
    [zoomSlider runMethod:@"sliderWasUpdated:"
                   target:self
                 forEvent:VALUECHANGED];
    [self.canvas addObjects:@[sliderLabel, zoomSlider]];

    
}

-(void)sliderWasUpdated:(C4Slider*)theSlider{
    photoTaken.height=self.canvas.height*theSlider.value;
    photoTaken.center=self.canvas.center;
}

@end