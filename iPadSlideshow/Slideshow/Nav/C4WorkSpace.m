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
    //NSLog(@"screen size: %f, %f", [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
    imageTimeLength=5; //in secs

    images=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"image.jpg"],[UIImage imageNamed:@"image2.jpg"],[UIImage imageNamed:@"image3.jpg"],[UIImage imageNamed:@"image4.jpg"],[UIImage imageNamed:@"image5.jpg"],[UIImage imageNamed:@"image6.jpg"],[UIImage imageNamed:@"image7.jpg"],[UIImage imageNamed:@"image8.jpg"],[UIImage imageNamed:@"image9.jpg"],[UIImage imageNamed:@"image10.jpg"],[UIImage imageNamed:@"image11.jpg"],[UIImage imageNamed:@"image12.jpg"],[UIImage imageNamed:@"image13.jpg"],[UIImage imageNamed:@"image14.jpg"],[UIImage imageNamed:@"image15.jpg"],[UIImage imageNamed:@"image16.jpg"],[UIImage imageNamed:@"image17.jpg"],nil ];
    
    
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
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}
-(void) goForward{
    currentImage++;
    if (currentImage>=[images count]) {
        currentImage=0;
    }
    //NSLog(@"currentImage: %i", currentImage);
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
    if (currentImage<0) {
        currentImage=(int)[images count]-1;
    }
    //NSLog(@"currentImage: %i", currentImage);
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
