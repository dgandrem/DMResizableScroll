//
//  CustomScrollView.h
//  StickyHeaderTest
//
//  Created by Diego Martinez on 24/06/14.
//  Copyright (c) 2014 Diego Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMResizableView;

@interface DMResizableScroll: UIScrollView<UIGestureRecognizerDelegate>

@property CGPoint startPoint;
@property CGPoint endPoint;
@property (readonly,strong,nonatomic) NSMutableArray *resizableViews;


- (id)initWithFrame:(CGRect)frame andEndPoint:(CGPoint) endPoint;
- (void) addResizableView:(DMResizableView *) view;

@end
