//
//  ResizableView.m
//  StickyHeaderTest
//
//  Created by Diego Martinez on 26/06/14.
//  Copyright (c) 2014 Diego Martinez. All rights reserved.
//

#import "DMResizableView.h"

@implementation DMResizableView

-(id) initWithView:(UIView *) view forEndFrame:(CGRect) frame
{
    self = [super init];
    if (self) {
        self.view = view;
        self.startFrame = view.frame;
        self.endFrame = frame;
        self.translateOnly = YES;
    }
    return self;
}

@end
