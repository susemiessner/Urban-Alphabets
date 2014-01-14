//
//  MyAlphabets.m
//  UrbanAlphabets
//
//  Created by Suse on 08/01/14.
//  Copyright (c) 2014 moi. All rights reserved.
//

#import "MyAlphabets.h"
#import "C4WorkSpace.h"
#import "AddAlphabet.h"
#import "AlphabetView.h"

@interface MyAlphabets (){
    C4WorkSpace *workspace;
    AddAlphabet *addAlphabet;
    AlphabetView *alphabetView;
    
    NSMutableArray *currentAlphabets;
    
    int selectedAlphabet;
    
    NSMutableArray *backgroundShapes;
    NSMutableArray *labels;
    C4Image *checkedIcon;

    int elementNoChosen;
}
@end

@implementation MyAlphabets
-(void)setup{
    self.title=@"My Alphabets";
    //back button
    CGRect frame = CGRectMake(0, 0, 60,20);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:UA_BACK_BUTTON forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftButton;
}
-(void)grabCurrentLanguageViaNavigationController {
    id obj = [self.navigationController.viewControllers objectAtIndex:0];
    workspace=(C4WorkSpace*)obj;
    currentAlphabets=[[NSMutableArray alloc]init];
    currentAlphabets=[workspace.myAlphabets mutableCopy];
    NSString *test=@"+ add new alphabet";
    [currentAlphabets addObject:test];
    backgroundShapes=[[NSMutableArray alloc]init];
    labels=[[NSMutableArray alloc]init];
    for (int i=0; i<[currentAlphabets count]; i++) {
        //underlying shape
        float height=46.203;
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*height;
        C4Shape *shape=[C4Shape rect:CGRectMake(0, yPos, self.canvas.width, height)];
        shape.lineWidth=2;
        shape.strokeColor=UA_NAV_BAR_COLOR;
        shape.fillColor=UA_NAV_CTRL_COLOR;
        
        if ([currentAlphabets objectAtIndex:i ] == workspace.alphabetName) {
            shape.fillColor=UA_HIGHLIGHT_COLOR;
            selectedAlphabet=i;
        }
        [backgroundShapes addObject:shape];
        [self.canvas addShape:shape];
        
        //text label
        C4Label *label=[C4Label labelWithText:[currentAlphabets objectAtIndex:i] font:UA_NORMAL_FONT];
        label.textColor=UA_TYPE_COLOR;
        float heightLabel=46.203;
        float yPosLabel=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*heightLabel+label.height/2+4;
        label.origin=CGPointMake(49.485, yPosLabel);
        [self.canvas addLabel:label];
        [self listenFor:@"touchesBegan" fromObject:shape andRunMethod:@"alphabetChanged:"];
        [labels addObject:label];
    }
    //√icon only 1x
    checkedIcon=UA_ICON_CHECKED;
    checkedIcon.width= 35;
    float height=46.202999;
    checkedIcon.center=CGPointMake(checkedIcon.width/2+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(selectedAlphabet+1)*height-height/2);
    [self.canvas addImage:checkedIcon];
}

-(void)alphabetChanged:(NSNotification *)notification{
    C4Shape *clickedObject = (C4Shape *)[notification object];
    //figure out which object was clicked
    float yPos=clickedObject.origin.y;
    //C4Log("clicked Object y:%f", yPos);
    yPos=yPos-UA_TOP_WHITE-UA_TOP_BAR_HEIGHT;
    float elementNumber=yPos/clickedObject.height;
    elementNoChosen=lroundf(elementNumber);
    for (int i=0; i<[backgroundShapes count]-1; i++) {
        C4Shape *shape=[backgroundShapes objectAtIndex:i];
        if (i==elementNoChosen) {
            shape.fillColor=UA_HIGHLIGHT_COLOR;
            if (workspace.alphabetName!=[workspace.myAlphabets objectAtIndex:i]) {
                [self loadTabbedAlphabet];
            }
        } else {
            shape.fillColor=UA_NAV_CTRL_COLOR;
        }
    }
    checkedIcon.center=CGPointMake(checkedIcon.width/2+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(elementNumber+1)*clickedObject.height-clickedObject.height/2);
    if (elementNoChosen==[backgroundShapes count]-1) {
        [self addAlphabet];
    }
    
}
-(void)loadTabbedAlphabet{
    //change name of current alphabet
    workspace.alphabetName=[workspace.myAlphabets objectAtIndex:elementNoChosen];
    //loading all letters
    NSString *path= [[workspace documentsDirectory] stringByAppendingString:@"/"];
    path=[path stringByAppendingPathComponent:workspace.alphabetName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        workspace.currentAlphabet=[[NSMutableArray alloc]init];
        for (int i=0; i<42; i++) {
            NSString *filePath=[[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", i]] stringByAppendingString:@".jpg"];
            NSData *imageData = [NSData dataWithContentsOfFile:filePath];
            UIImage *img = [UIImage imageWithData:imageData];
            C4Image *image=[C4Image imageWithUIImage:img];
            [workspace.currentAlphabet addObject:image];
        }
    }
    //go to alphabets view
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    alphabetView=(AlphabetView*)obj;
    [alphabetView redrawAlphabet];
    [self.navigationController popToViewController:alphabetView animated:YES];
}
-(void)addAlphabet{
    addAlphabet=[[AddAlphabet alloc]initWithNibName:@"AddAlphabet" bundle:[NSBundle mainBundle]];
    [addAlphabet setup];
    [self.navigationController pushViewController:addAlphabet animated:NO];
    [addAlphabet grabCurrentLanguageViaNavigationController];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
