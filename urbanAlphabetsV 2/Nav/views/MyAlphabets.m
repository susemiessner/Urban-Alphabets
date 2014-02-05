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
    UIImageView *checkedIcon;

    int elementNoChosen;
    //images loaded from documents directory
    UIImage *loadedImage;
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
    float height=46.203;
    for (int i=0; i<[currentAlphabets count]; i++) {
        //underlying shape
        float yPos=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*height;
        UIView *shape = [[UIView alloc]initWithFrame:CGRectMake(0, yPos, self.view.frame.size.width, height)];
        [shape setBackgroundColor:UA_NAV_CTRL_COLOR];
        shape.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        shape.layer.borderWidth=1.0f;

        
        if ([currentAlphabets objectAtIndex:i ] == workspace.alphabetName) {
            [shape setBackgroundColor:UA_HIGHLIGHT_COLOR];
            selectedAlphabet=i;
        }
        [backgroundShapes addObject:shape];
        [self.view addSubview:shape];
        
        //text label
        float heightLabel=46.203;
        float yPosLabel=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*heightLabel+4;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(49.485, yPosLabel, 100, 20) ];
        [label setText:[currentAlphabets objectAtIndex:i]];
        [label setFont:UA_NORMAL_FONT];
        [label setTextColor:UA_TYPE_COLOR];
        [self.view addSubview:label];
        //[self listenFor:@"touchesBegan" fromObject:shape andRunMethod:@"alphabetChanged:"];
        [labels addObject:label];
    }
    //√icon only 1x
        //√icon only 1x
    checkedIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(selectedAlphabet)*height+2, 46, 46)];
    checkedIcon.image=UA_ICON_CHECKED;
    [self.view addSubview:checkedIcon];

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
    [checkedIcon setFrame: CGRectMake(+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(elementNumber)*clickedObject.frame.size.height+2, 46,46)];
    if (elementNoChosen==[backgroundShapes count]-1) {
        [self addAlphabet];
    }
    
}
-(void)loadTabbedAlphabet{
    //change name of current alphabet
    workspace.alphabetName=[workspace.myAlphabets objectAtIndex:elementNoChosen];
    //loading all letters
    [workspace loadCorrectAlphabet];
    //go to alphabets view
    id obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    alphabetView=(AlphabetView*)obj;
    [alphabetView redrawAlphabet];
    [self.navigationController popToViewController:alphabetView animated:NO];
}
-(void)addAlphabet{
    addAlphabet=[[AddAlphabet alloc]initWithNibName:@"AddAlphabet" bundle:[NSBundle mainBundle]];
    [addAlphabet setup];
    [self.navigationController pushViewController:addAlphabet animated:NO];
    [addAlphabet grabCurrentLanguageViaNavigationController];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:NO];
}
@end
