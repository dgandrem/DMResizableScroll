//
//  CustomScrollView.m
//  StickyHeaderTest
//
//  Created by Diego Martinez on 24/06/14.
//  Copyright (c) 2014 Diego Martinez. All rights reserved.
//

#import "DMResizableScroll"
#import "DMResizableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DMResizableScroll
{
    UIPanGestureRecognizer *panGR;
    UITapGestureRecognizer *tapGR;
    BOOL animatingTransition;
    BOOL animatingScroll;
}

#pragma mark - Basics

- (id)initWithFrame:(CGRect)frame andEndPoint:(CGPoint) endPoint
{
    self = [super initWithFrame:frame];
    if (self) {
        self.endPoint = endPoint;
        self.startPoint = frame.origin;
        
        panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        panGR.delegate = self;
        panGR.cancelsTouchesInView = NO;
        
        tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tapGR.delegate = self;
        tapGR.cancelsTouchesInView = NO;
        
        animatingScroll = NO;
        animatingTransition = NO;
        
        _resizableViews = [[NSMutableArray alloc] init];
        
        [super addGestureRecognizer:tapGR];
        [super addGestureRecognizer:panGR];
        [super setScrollEnabled:NO];
    }
    return self;
}

- (void) addResizableView:(DMResizableView *) view
{
    [_resizableViews addObject:view];
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - TapGestureRecognizer

-(void) tapped: (UITapGestureRecognizer *) sender
{
    CGRect layer = [[sender.view.layer presentationLayer] frame];
    CGFloat translationY = self.frame.origin.y - layer.origin.y;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    
    self.frame = layer;
    [self updateResizableSubviews:translationY];
    
    [UIView commitAnimations];
    animatingTransition = NO;
}

#pragma mark - PanGestureRecognizer

-(void) panned: (UIPanGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        animatingScroll = animatingTransition = NO;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation =[sender translationInView:sender.view];
        BOOL translate= NO;
        if ([self atTop] && self.contentOffset.y == 0) {
            translate =  (translation.y > 0);
        }
        if ([self atBottom]) {
            translate = (translation.y < 0 );
        }
        if ([self atMiddle]) {
            translate = YES;
        }
        
        translate ? [self performTranslation:sender]:[self scroll:sender];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:sender.view];
        
        if (([self atBottom] && velocity.y < 0 ) || ([self atTop] && velocity.y >0 && self.contentOffset.y == 0) || ([self atMiddle])) {
            
            CGRect newFrame = [self finalPosition:sender];
            CGFloat translationY = self.frame.origin.y - newFrame.origin.y;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            self.frame = newFrame;
            [self updateResizableSubviews:translationY];
            
            [UIView commitAnimations];
            animatingTransition = YES;

        }
        if ( [self atTop] && !animatingTransition ) {
            CGPoint newOffset = [self finalOffset:sender];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            [super setContentOffset:newOffset];
            
            [UIView commitAnimations];
            animatingScroll = YES;
        }

    }
}

#pragma mark - Animate Subviews

-(void) updateResizableSubviews: (CGFloat) translationY
{
    CGRect newFrame;
    CGFloat completionRatio = [self interpolar:_startPoint.y :0 :_endPoint.y :1 :self.frame.origin.y];
    for (DMResizableView *object in _resizableViews) {
        newFrame.origin.y       = [self interpolar:0 :object.startFrame.origin.y    :1 :object.endFrame.origin.y    :completionRatio];
        newFrame.origin.x       = [self interpolar:0 :object.startFrame.origin.x    :1 :object.endFrame.origin.x    :completionRatio];
        newFrame.size.width     = [self interpolar:0 :object.startFrame.size.width  :1 :object.endFrame.size.width  :completionRatio];
        newFrame.size.height    = [self interpolar:0 :object.startFrame.size.height :1 :object.endFrame.size.height :completionRatio];
        object.view.frame = newFrame;
    }
}


#pragma mark - Animation helpers

-(CGPoint) finalOffset: (UIPanGestureRecognizer *) sender
{
    CGPoint finalOffset;
    
    CGPoint velocity    = [sender velocityInView:sender.view];
    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
    CGFloat slideMult = magnitude / 300;
    CGFloat slideFactor = 0.05 * slideMult;
    
    CGPoint originalOffset   = self.contentOffset;
    CGFloat y                =  -(slideFactor * velocity.y) +originalOffset.y;
    
    finalOffset.x     = 0;
    finalOffset.y     = MIN(MAX(0, y),  self.contentSize.height -self.frame.size.height);
    return finalOffset;
}

-(CGRect) finalPosition:(UIPanGestureRecognizer *) sender
{
    CGRect  finalFrame;
    CGPoint velocity    = [sender velocityInView:sender.view];
    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
    CGFloat slideMult = magnitude / 300;
    CGFloat slideFactor = 0.05 * slideMult;
 
    CGRect  originalFrame   = sender.view.frame;
    CGFloat y               = slideFactor * velocity.y +originalFrame.origin.y;

    finalFrame.origin.x     = 0;
    finalFrame.origin.y     = MIN(MAX(_endPoint.y, y), _startPoint.y);
    finalFrame.size.width   = sender.view.frame.size.width;
    finalFrame.size.height  = (originalFrame.origin.y - finalFrame.origin.y) + originalFrame.size.height;
    
    return finalFrame;
}

#pragma mark - Panning Actions

-(void) performTranslation: (UIPanGestureRecognizer *) sender
{
    CGPoint translation = [sender translationInView:sender.view];
    CGRect frame = sender.view.frame;
    
    if (frame.origin.y + translation.y < _endPoint.y)
    {
        translation.y = _endPoint.y - frame.origin.y;
    }
    
    if ((frame.origin.y + translation.y)> _startPoint.y) {
        translation.y = _startPoint.y - frame.origin.y;
    }
    
    frame.origin.y = frame.origin.y + translation.y;
    frame.size.height = frame.size.height - translation.y;
    
    sender.view.frame = frame;
    [self updateResizableSubviews:translation.y];
    
    [sender setTranslation:CGPointMake(0, 0)  inView:sender.view];
}

-(void) scroll: (UIPanGestureRecognizer *) sender
{
    if ([self atBottom]) {
        return;
    }
    CGPoint translation = [sender translationInView:sender.view];
    CGPoint newOffset;
    newOffset.x = 0;
    newOffset.y = -translation.y + self.contentOffset.y;
    
    CGFloat scrollHeight =sender.view.frame.size.height;
    CGFloat contentHeight = [super contentSize].height;
    if (newOffset.y + scrollHeight >contentHeight) {
        newOffset.y = self.contentSize.height - sender.view.frame.size.height;
    }
    if (newOffset.y < 0) {
        newOffset.y = 0;
    }
    
    [super setContentOffset:newOffset];
    [sender setTranslation:CGPointZero inView:sender.view];
}

#pragma mark - Position Markers

-(BOOL) atTop
{
    CGFloat yActual = self.frame.origin.y;
    return yActual == _endPoint.y;
}

-(BOOL) atBottom
{
    CGFloat yActual =self.frame.origin.y;
    return yActual == _startPoint.y;
}

-(BOOL) atMiddle
{
    return (![self atTop]) && (! [self atBottom]);
}
#pragma mark - Auxiliares

-(CGFloat) interpolar:(CGFloat) xa :(CGFloat) ya :(CGFloat) xb :(CGFloat) yb :(CGFloat) x
{
    return (ya + (yb-ya) * ((x-xa) / (xb -xa)));
}


#pragma mark - Overriden

-(void) setContentOffset:(CGPoint)contentOffset{

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
