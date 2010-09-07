/*
 *  NMPanelMenu.m
 *  shapes
 *
 *  Created by Nate Murray on 7/29/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

#include "NMPanelMenu.h"
#import "common.h"
#import "NMPanelMenuItem.h"

@interface NMPanelMenu (Private)
@end

@implementation NMPanelMenu
@synthesize pc;

- (void) onEnter {
    [super onEnter];
}

-(CGRect) rect
{
    return CGRectMake( self.position.x - contentSize_.width*anchorPoint_.x, self.position.y-
            contentSize_.height*anchorPoint_.y,
            contentSize_.width, contentSize_.height);
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    CGPoint local = [self convertToNodeSpace:location];
    CGRect r = [self rect]; 
    r.origin = CGPointZero;
    return CGRectContainsPoint(r, local);
}

-(void) dealloc {
	self.pc = nil;
    [super dealloc];
}

-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    // CCLOG(@".");
    // CCLOG(@"l.x:%f l.y:%f", [self parent].position.x, [self parent].position.y);
    // CCLOG(@"m.x:%f m.y:%f", self.position.x, self.position.y);
    // CCLOG(@"touchLocation.x:%f touchLocation.y:%f", touchLocation.x, touchLocation.y);
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    // CCLOG(@"gl-touchLocation.x:%f gl-touchLocation.y:%f", touchLocation.x, touchLocation.y);

    CCMenuItem* item;
    CCARRAY_FOREACH(children_, item){
        // ignore invisible and disabled items: issue #779, #866
        if ( [item visible] && [item isEnabled] ) {

            CGPoint local = [item convertToNodeSpace:touchLocation];
            local = ccpAdd([self parent].position, local); // to account for something <------ key

            // CCLOG(@"%@ gl-local.x:%f gl-local.y:%f", ((NMPanelMenuItem*)item).name, local.x, local.y);


            CGRect r = [item rect];
            r.origin = CGPointZero;

            float dx = -50;
            float dy = -50;
            //CGRect rplus = CGRectInset(r, dx, dy);

            if( CGRectContainsPoint( r, local ) ) {
            // if( CGRectContainsPoint( rplus, local ) ) {
                return item;
            }
        }
    }
    return nil;
}


@end
