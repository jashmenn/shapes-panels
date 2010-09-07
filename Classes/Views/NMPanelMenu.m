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
#import "NMPanelController.h"
#import "NMPanelMenuItem.h"

@interface NMPanelMenu (Private)
@end

@implementation NMPanelMenu
@synthesize pc;

- (void) onEnter {
    [super onEnter];
    self.pc = [[NMPanelController alloc] initWithNode: self];
    // todo, set contentSize to be the size of the children + padding

    // CCLOG(@"we have %d children", [[self children] count]);
    [pc definePanelsWithSprites: [[self children] getNSArray]];
    // [pc setNodePositionToPanel: 0];
}

/*
// the trick here is to give the PanelMenu a high touch priority than its items
// and if the PanelMenu ignores the touch, only then do you let the items have the touch
// in this way, you might not need any panel items at all
-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] 
        addTargetedDelegate:self 
                   priority:touchPriority_panelMenu 
            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO; // ******************* tmp
    CCMenuItem* sprite = [self itemForTouch: touch];
    if (sprite) { 
        // [sprite selected];
        return [pc ccTouchBegan:touch withEvent:event forSprite:sprite];
    }
    dragged = NO;
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCMenuItem* sprite = [self itemForTouch: touch];
    if (sprite) [pc ccTouchMoved:touch withEvent:event forSprite:sprite];
    dragged = YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCMenuItem* sprite = [self itemForTouch: touch];

    // [sprite selected];

    if(dragged) {
        if (sprite) {
            [pc ccTouchEnded:touch withEvent:event forSprite:sprite];
            // [selectedItem unselected];
            // [selectedItem activate];
                        
        }
    } else {
        [sprite selected];
        [sprite activate];
    }
    dragged = NO;
}
*/


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"ccTouchBegan NMPanelMenu");
    return [super ccTouchBegan:touch withEvent:event];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"ccTouchEnded NMPanelMenu");
    [super ccTouchEnded:touch withEvent:event];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"ccTouchCancelled NMPanelMenu");
    [super ccTouchCancelled:touch withEvent:event];
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

/*
-(void) setToPanel: (int) n {
    [pc setNodePositionToPanel: n];
}
*/


@end
