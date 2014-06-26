//
//  SomeViewController.h
//  DMResizableScrollDemo
//
//  Created by Diego Martinez on 26/06/14.
//  Copyright (c) 2014 Diego Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UIView *thereWillBeScroll;


@end
