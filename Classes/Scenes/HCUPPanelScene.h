/*
 *  HSLevelSelectionScene.h
 *  shapes
 *
 *  Created by Nate Murray on 7/24/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CocosOverlayScrollView.h"

@class TouchDelegatingView;
@class NMPanelMenu;

@interface HCUPPanelScene : CCLayer
{
    int nextWorld_;
    BOOL transitioning_;
    CocosOverlayScrollView* scrollView;
    TouchDelegatingView* touchDelegatingView;
    UIPageControl* pageControl;
}

// returns a Scene that contains the HSLevelSelectionScene as the only child
+(id) scene;
- (void) levelPicked: (id) sender ;

@end
