//
//  TouchDelegatingView.m
//  Jacob's Shapes
//
//  Created by Nate Murray on 8/23/10.
//  Copyright 2010 LittleHiccup. All rights reserved.
//

#import "TouchDelegatingView.h"

@implementation TouchDelegatingView
@synthesize scrollView;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.scrollView;
    }
    return nil;
}

-(void) dealloc {
    self.scrollView = nil;
	[super dealloc];
}

@end
