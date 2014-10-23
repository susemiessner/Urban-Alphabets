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

@interface MyAlphabets (){
    C4WorkSpace *workspace;
    AddAlphabet *addAlphabet;
    
    NSMutableArray *currentAlphabets;
    
    int selectedAlphabet;
    
    NSMutableArray *backgroundShapes;
    NSMutableArray *labels;
    UIImageView *checkedIcon;
    
    int elementNoChosen;
    //images loaded from documents directory
    UIImage *loadedImage;
    float firstShapeY;
    float alphabetFrameSize;
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
    alphabetFrameSize=height;
    firstShapeY=UA_TOP_BAR_HEIGHT+UA_TOP_WHITE;
    for (int i=0; i<[currentAlphabets count]; i++) {
        
        //underlying shape
        float yPos=firstShapeY+i*height;
        UIView *shape = [[UIView alloc]initWithFrame:CGRectMake(0, yPos, [[UIScreen mainScreen] bounds].size.width, height)];
        [shape setBackgroundColor:UA_NAV_CTRL_COLOR];
        shape.layer.borderColor=[UA_NAV_BAR_COLOR CGColor];
        shape.layer.borderWidth=1.0f;
        if ([[currentAlphabets objectAtIndex:i ] isEqualToString: workspace.alphabetName]) {
            [shape setBackgroundColor:UA_HIGHLIGHT_COLOR];
            selectedAlphabet=i;
        }
        shape.userInteractionEnabled=YES;
        [backgroundShapes addObject:shape];
        [self.view addSubview:shape];
        
        //text label
        float heightLabel=46.203;
        float yPosLabel=UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+i*heightLabel+heightLabel/2-7;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(75, yPosLabel, 200, 20) ];
        [label setText:[currentAlphabets objectAtIndex:i]];
        [label setFont:UA_NORMAL_FONT];
        [label setTextColor:UA_TYPE_COLOR];
        [self.view addSubview:label];
        label.userInteractionEnabled=YES;
        [labels addObject:label];
        
        UITapGestureRecognizer *shapeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphabetChanged:)];
        shapeRecognizer.numberOfTapsRequired = 1;
        [shape addGestureRecognizer:shapeRecognizer];
        
        UITapGestureRecognizer *labelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphabetChanged:)];
        labelRecognizer.numberOfTapsRequired = 1;
        [label addGestureRecognizer:labelRecognizer];
    }
    //√icon only 1x
    checkedIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(selectedAlphabet)*height+2, 46, 46)];
    checkedIcon.image=UA_ICON_CHECKED;
    [self.view addSubview:checkedIcon];
    
}

-(void)alphabetChanged:(UIGestureRecognizer *)notification{
    UIView *clickedObject = notification.view;
    //figure out which object was clicked
    float yPos=clickedObject.frame.origin.y;
    float firstYPos=firstShapeY;
    yPos=yPos-firstYPos;
    float elementNumber=yPos/alphabetFrameSize;
    elementNoChosen=(int)lroundf(elementNumber);
    
    for (int i=0; i<[backgroundShapes count]; i++) {
        UIView *shape=[backgroundShapes objectAtIndex:i];
        if (i==elementNoChosen) {
            [shape setBackgroundColor:UA_HIGHLIGHT_COLOR];
        } else {
            [shape setBackgroundColor:UA_NAV_CTRL_COLOR];
        }
    }
    [checkedIcon setFrame: CGRectMake(+5, UA_TOP_WHITE+UA_TOP_BAR_HEIGHT+(elementNumber)*clickedObject.frame.size.height+2, 46,46)];
    if (elementNoChosen==([backgroundShapes count]-1)) {
        [self addAlphabet];
    } else if(elementNoChosen<=([backgroundShapes count]-2)){
        [self loadTabbedAlphabet];
    }
}

-(void)loadTabbedAlphabet{
    //change name of current alphabet
    workspace.alphabetName=[workspace.myAlphabets objectAtIndex:elementNoChosen];
    //loading all letters
    [workspace loadCorrectAlphabet];
    //go to alphabets view
    
    [self.navigationController popToRootViewControllerAnimated: NO];
}
-(void)addAlphabet{
    addAlphabet=[[AddAlphabet alloc]initWithNibName:@"AddAlphabet" bundle:[NSBundle mainBundle]];
    [addAlphabet setup];
    [self.navigationController pushViewController:addAlphabet animated:NO];
    [addAlphabet grabCurrentLanguageViaNavigationController];
}
-(void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
