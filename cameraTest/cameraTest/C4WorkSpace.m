//
//  C4WorkSpace.m
//  cameraTest
//
//  Created by SuseMiessner on 10/18/13.
//

#import "C4Workspace.h"
#import "TakePhoto.h"

@implementation C4WorkSpace {
    TakePhoto *tp;
}

-(void)setup {
    tp = [TakePhoto new];
    tp.canvas.frame = CGRectMake(30,
                                 30,
                                 self.canvas.width - 60,
                                 self.canvas.height - 60);
    tp.canvas.shadowOffset = CGSizeMake(10,10);
    tp.canvas.shadowOpacity = 1.0f;
    tp.canvas.userInteractionEnabled = YES;
    [tp setup];
    tp.mainCanvas = self.canvas;
    [self.canvas addSubview:tp.canvas];
}
@end
