//
//  CocosOverlayScrollView.m
//  shapes
//
//  Created by Nate Murray on 8/23/10.
//  Copyright 2010 LittleHiccup. All rights reserved.
//

#import "CocosOverlayScrollView.h"

@implementation CocosOverlayScrollView
@synthesize targetLayer;

// Configure your favorite UIScrollView options here
-(id) initWithFrame: (CGRect) frameRect numPages: (int) numPages width: (float) width layer: (CCNode*) layer {
    if ((self = [super initWithFrame: frameRect])){ 
        self.contentSize = CGSizeMake(320, width * numPages);
        self.bounces = YES;
        self.delaysContentTouches = NO;
        self.delegate = self;
        self.pagingEnabled = YES;
        self.scrollsToTop = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self setUserInteractionEnabled:TRUE];
        [self setScrollEnabled:TRUE];
        self.targetLayer = layer;
        // self.canCancelContentTouches  = YES;
    }
    return self;
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging)
    {
        UITouch* touch = [[touches allObjects] objectAtIndex:0];
        // CGPoint location = [touch locationInView: [touch view]];
        // CCLOG(@"touch at l.x:%f l.y:%f", location.x, location.y);

        [self.nextResponder touchesBegan: touches withEvent:event];
        [[[CCDirector sharedDirector] openGLView] touchesBegan:touches withEvent:event];
    }

    [super touchesBegan: touches withEvent: event];
}

-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging)
    {
        [self.nextResponder touchesEnded: touches withEvent:event];
        [[[CCDirector sharedDirector] openGLView] touchesEnded:touches withEvent:event];
    }

    [super touchesEnded: touches withEvent: event];
}

-(void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event
{
    // if (!self.dragging)
    // {
        // CCLOG(@"CocosOverlayScrollView touchesEnded not dragging");
        [self.nextResponder touchesCancelled: touches withEvent:event];
        [[[CCDirector sharedDirector] openGLView] touchesCancelled:touches withEvent:event];
    // }
    [super touchesCancelled: touches withEvent: event];
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  // TODO - Custom code for handling deceleration of the scroll view
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint dragPt = [scrollView contentOffset];
    dragPt = [[CCDirector sharedDirector] convertToGL:dragPt];

    dragPt.y = dragPt.y * -1;
    dragPt.x = dragPt.x * -1;

    CGPoint newLayerPosition = CGPointMake(dragPt.x, dragPt.y);

    [targetLayer setPosition:newLayerPosition];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // CGPoint dragPt = [scrollView contentOffset];
    // etc.
}

-(void) dealloc {
    self.targetLayer = nil;
    [super dealloc];
}
@end