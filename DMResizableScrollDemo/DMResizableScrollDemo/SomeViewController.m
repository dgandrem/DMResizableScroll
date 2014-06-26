//
//  SomeViewController.m
//  DMResizableScrollDemo
//
//  Created by Diego Martinez on 26/06/14.
//  Copyright (c) 2014 Diego Martinez. All rights reserved.
//

#import "SomeViewController.h"
#import "DMResizableScroll.h"
#import "DMResizableView.h"

@interface SomeViewController ()

@end

@implementation SomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DMResizableScroll *theScroll = [[DMResizableScroll alloc] initWithFrame:_thereWillBeScroll.frame andEndPoint:CGPointMake(0, 100)];
    
    DMResizableView *text = [[DMResizableView alloc] initWithView:_titleLbl forEndFrame:CGRectMake(237, 31, 63, 32)];
    DMResizableView *image = [[DMResizableView alloc] initWithView:_imageIV forEndFrame:CGRectMake(20, 31, 67, 63)];
    
    [theScroll addSubview:_contentView];
    [theScroll setContentSize:_contentView.frame.size];
    
    [theScroll addResizableView:text];
    [theScroll addResizableView:image];
    
    [self.view addSubview:theScroll];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
