#import "C4Workspace.h"
#import "FirstView.h"
#import "SecondView.h"

@implementation C4WorkSpace {
}
-(void)setup {
    firstView=[FirstView new];
    firstView.canvas.frame = self.canvas.frame;
    [firstView setup];
    firstView.canvas.userInteractionEnabled = YES;
    [self.canvas addSubview:firstView.canvas];
    
    secondView=[SecondView new];
    secondView.canvas.frame = self.canvas.frame;
    [secondView setup];
    secondView.canvas.userInteractionEnabled = YES;
    [self.canvas addSubview:secondView.canvas];
    
    secondView.canvas.hidden = YES;
   
    firstView.secondView = secondView;
    
    [self listenFor:@"changeToSecond" andRunMethod:@"changeToSecondView"];
    [self listenFor:@"changeToFirst" andRunMethod:@"changeToFirstView"];
}
-(void)changeToSecondView{

    C4Log(@"tapped arrived");
    firstView.canvas.hidden = YES;
    secondView.canvas.hidden = NO;
}
-(void)changeToFirstView{
    C4Log(@"tapped arrived");
    firstView.canvas.hidden = NO;
    secondView.canvas.hidden = YES;
}

@end