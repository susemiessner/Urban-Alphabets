//
//  C4WorkSpace.m
//  Nav
//
//  Created by moi on 12/5/2013.
//

#import "C4Workspace.h"
#import <AVFoundation/AVFoundation.h>


@implementation C4WorkSpace {
    NSMutableArray *images;
    int currentImage;
    UIImageView *imageView;
    int imageTimeLength;
    NSTimer *timer;

    int secondsLeft;
}

-(void)setup {
    
}
-(void)viewDidAppear:(BOOL)animated{
    imageTimeLength=3; //in secs

    images=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"image1.jpg"],[UIImage imageNamed:@"image2.jpg"],[UIImage imageNamed:@"image3.jpg"],nil ];
    
    
    currentImage=0;
    imageView=[[UIImageView alloc]initWithFrame:
                            CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
    imageView.image=[images objectAtIndex:currentImage];
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];

    UISwipeGestureRecognizer *swipeLeftRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goForward)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [imageView addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goBackward)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [imageView addGestureRecognizer:swipeRightRecognizer];
    
    secondsLeft = imageTimeLength;
    [self countdownTimer];


}
- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        secondsLeft -- ;
    }
    else{
        [self goForward];
    }
}
-(void)countdownTimer{
    
    //secondsLeft = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}
-(void) goForward{
    currentImage++;
    if (currentImage>=[images count]) {
        currentImage=0;
    }
    //imageView.image=[images objectAtIndex:currentImage];
    [UIView transitionWithView:imageView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        imageView.image = [images objectAtIndex:currentImage];
                    } completion:NULL];
    secondsLeft = imageTimeLength;
}
-(void) goBackward{
    currentImage--;
    if (currentImage<=0) {
        currentImage=(int)[images count]-1;
    }
    [UIView transitionWithView:imageView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        imageView.image = [images objectAtIndex:currentImage];
                    } completion:NULL];
    secondsLeft = imageTimeLength;

}

-(void)appWillResignActive:(NSNotification*)note{
    }

-(void)appWillBecomeActive:(NSNotification*)note{}
   
@end
