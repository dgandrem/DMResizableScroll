//
//  ResizableView.h
//  StickyHeaderTest
//
//  Created by Diego Martinez on 26/06/14.
//  Copyright (c) 2014 Diego Martinez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMResizableView : NSObject

@property (weak, nonatomic) UIView *view;
@property CGRect startFrame;
@property CGRect endFrame;

@property BOOL translateOnly;

-(id) initWithView:(UIView *) view forEndFrame:(CGRect) frame;

@end
