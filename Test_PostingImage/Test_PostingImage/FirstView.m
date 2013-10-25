#import "FirstView.h"

@implementation FirstView

-(void)setup{
    goToSecondView=[C4Label labelWithText:@"go to second View"];
    goToSecondView.origin=CGPointMake(20, 50);
    [self.canvas addLabel:goToSecondView];
    //goToSecondView.userInteractionEnabled = NO;
    [self listenFor:@"touchesBegan" fromObject:goToSecondView andRunMethod:@"postNoti"];
    
    postedImage=[C4Image imageNamed:@"C4Sky.png"];
    postedImage.center=self.canvas.center;
    [self.canvas addImage:postedImage];
    C4Log(@"sent image: %@", postedImage);
    
}
-(void)postNoti{
    C4Log(@"tapped");
    [self postNotification:@"changeToSecond"];
    secondView=[SecondView new];
    [secondView receiveNumber:postedImage];
}

@end
