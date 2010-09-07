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

@class PreviewScrollContainerView;
@class NMPanelMenu;

// HSLevelSelectionScene Layer
@interface HSLevelSelectionScene2 : CCLayer
{
    int nextWorld_;
    BOOL transitioning_;
    CocosOverlayScrollView* scrollView;
    PreviewScrollContainerView* scrollViewContainer;
    UIPageControl* pageControl;
    NSString* currentLockPanelName_;
}
@property(nonatomic,retain) NSString* currentLockPanelName;

// returns a Scene that contains the HSLevelSelectionScene as the only child
+(id) scene;
- (void) menuButtonPressed: (id) sender;
- (void) addLockPanelToMenu:(NMPanelMenu*)menu;
- (void) lockPanelPicked: (id) sender;

@end
