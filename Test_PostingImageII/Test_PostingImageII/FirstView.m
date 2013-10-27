#import "FirstView.h"

@implementation FirstView

-(void)setup{
    goToSecondView=[C4Label labelWithText:@"go to second View"];
    goToSecondView.origin=CGPointMake(20, 50);
    [self.canvas addLabel:goToSecondView];
    //goToSecondView.userInteractionEnabled = NO;
    [self listenFor:@"touchesBegan" fromObject:goToSecondView andRunMethod:@"postNoti"];
    
    self.postedImage=[C4Image imageNamed:@"C4Sky.png"];
    self.postedImage.center=self.canvas.center;
    [self.canvas addImage:self.postedImage];
    C4Log(@"sent image: %@", self.postedImage);
}
-(void)postNoti{
    C4Log(@"tapped");
    [self postNotification:@"changeToSecond"];
    [self.secondView receiveNumber:self.postedImage];
}

@end
