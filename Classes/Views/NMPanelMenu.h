/*
 *  NMPanelMenu.h
 *  shapes
 *
 *  Created by Nate Murray on 7/29/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

#import "cocos2d.h"

@class NMPanelController;
@interface NMPanelMenu : CCMenu {
    NMPanelController* pc;
    BOOL dragged;
}
@property(nonatomic, retain) NMPanelController* pc;

-(CCMenuItem *) itemForTouch: (UITouch *) touch;
- (void) onEnter;
// -(void) setToPanel: (int) n;

@end
