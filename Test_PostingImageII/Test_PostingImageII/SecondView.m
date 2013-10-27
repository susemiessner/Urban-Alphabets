#import "SecondView.h"
@implementation SecondView
-(void)setup{
    goToFirstView=[C4Label labelWithText:@"go to First View"];
    goToFirstView.origin=CGPointMake(20, 50);
    [self.canvas addLabel:goToFirstView];
    //goToFirstView.userInteractionEnabled = NO;
    [self listenFor:@"touchesBegan" fromObject:goToFirstView andRunMethod:@"postNoti"];
    
}
-(void)postNoti{
    C4Log(@"tapped");
    [self postNotification:@"changeToFirst"];
    //[self.secondView receiveNumber:self.postedImage];
}
-(void)receiveNumber:(C4Image*)number{
    C4Image *newNumber = [number copy];
    //C4Log(@"number:%@", newNumber);
    newNumber.width=number.width/2;
    newNumber.center=self.canvas.center;
    [self.canvas addImage:newNumber];
    
    receivedImage=newNumber;
    C4Log(@"received number: %@", receivedImage);
}
@end
