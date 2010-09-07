/*
 *  HSLevelSelectionScene2.m
 *  shapes
 *
 *  Created by Nate Murray on 7/24/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

#include "HCUPPanelScene.h"
#import "NMPanelMenu.h"
#import "NMPanelMenuItem.h"
#import "PreviewScrollContainerView.h"
#import "GoBackScene.h"

// http://getsetgames.com/2009/08/21/cocos2d-and-uiscrollview/
// http://blog.proculo.de/archives/180-Paging-enabled-UIScrollView-With-Previews.html

@implementation HCUPPanelScene

+(id) scene
{
    CCScene *scene = [CCScene node];
    HCUPPanelScene *layer = [HCUPPanelScene node];
    [scene addChild: layer];
    return scene;
}

-(id) init
{
    if( (self=[super init] )) {
        transitioning_ = NO;
        // In the real world, you'd probably want to add all your panels to a
        // zwoptex sprite sheet. You could pre-load the frame cache with
        // something like this:
        // CCSpriteFrameCache* fcache = [CCSpriteFrameCache sharedSpriteFrameCache];
        // [fcache addSpriteFramesWithFile: @"panels-sheet-1.plist"];
    }
    return self;
}

- (void) onEnter 
{
    CGSize s = [[CCDirector sharedDirector] winSize];

    { // background
        CCSprite* bg = [CCSprite spriteWithFile:@"paper-background.png"];
        bg.position = ccp(s.width/2, s.height/2);
        [self addChild: bg];
    }

    // In your game this array would be created by a function that returns a
    // list of worlds. In Jacob's Shapes we have a GameController that knows
    // about each level.
    NSArray* panelNames = [NSArray arrayWithObjects: 
        @"amazon" @"arctic" @"brkfst" @"camp" @"city" nil;
    int numPanels = [panelNames count];

    // create an empty layer for us to work with
    CCLayer* panels = [CCLayer node];

    // The easiest way to add to a CCMenu dynamically is to start with one panel 
    // and then add more later. (Anyone have advice on a better way to do this?)
    NSString *firstPanelName = [NSString stringWithFormat: @"%@-panel.png", [panelNames objectAtIndex:0]];
    CCSprite* pane1 = [CCSprite spriteWithFile:firstPanelName];
    NMPanelMenuItem* menuItem1 = [NMPanelMenuItem itemFromNormalSprite:pane1 
                                                        selectedSprite:pane1 
                                                          activeSprite:pane1
                                                        disabledSprite:pane1
                                                                target:self 
                                                              selector:@selector(levelPicked:)];
    menuItem1.world = 0;
    menuItem1.name = [panelNames objectAtIndex:0];
    NMPanelMenu* menu = [NMPanelMenu menuWithItems: menuItem1, nil];

    // Now add the rest of the panels
    for(int i=1; i < numPanels; i++) {
        NSString* currentName = [panelNames objectAtIndex:i];
        CCSprite* pane2 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat: @"%@-panel.png", currentName]];
        NMPanelMenuItem* menuItem2 = [[NMPanelMenuItem alloc] initFromNormalSprite:pane2 
                                                                    selectedSprite:pane2
                                                                      activeSprite:pane2
                                                                    disabledSprite:pane2
                                                                              name:currentName
                                                                            target:self selector:@selector(levelPicked:)];
        menuItem2.world = i;
        menuItem2.name = currentName;
        [menu addChild: menuItem2];
        [menuItem2 release];
    }

    [menu alignItemsHorizontallyWithPadding:30.0];
    [panels addChild:menu];

    int numberOfPages = [JSWorld numWorlds];

    float onePanelWide = 363;
    //float padding = 15;
    float totalWidth = numberOfPages * onePanelWide; // panel width + padding * 2

    [self addChild:panels];

    // 
    GameController* gc = [GameController sharedGameController];
    CCLOG(@"setting to panel: %d", gc.currentWorld_i+1);
    CCLOG(@"menu.x:%f menu.y:%f", menu.position.x, menu.position.y);
    // newMenuX =  
    // menu.position = ccp(newMenuX, menu.position.y);
    // [menu setToPanel: gc.currentWorld_i+1]; // ew
    CCLOG(@"menu.x:%f menu.y:%f", menu.position.x, menu.position.y);
    // float unknown = 70;
    float unknown = 15;
    // menu.position = ccp(totalWidth/2 + onePanelWide/2 - onePanelWide + unknown,  s.height/2);
    // menu.position = ccpAdd(menu.position, ccp(totalWidth/2 - onePanelWide + unknown, 0));
    int woff = gc.currentWorld_i;
    // menu.position = ccpAdd(menu.position, ccp(totalWidth/2 - onePanelWide - (woff * onePanelWide) + unknown, 0));
    // menu.position = ccpAdd(menu.position, ccp(totalWidth/2 - onePanelWide + unknown, 0)); // use this
    menu.position = ccpAdd(menu.position, ccp(totalWidth/2 + unknown, 0));
    // you need to scroll the scoll view container


    // Init Scrollview

    // scrollView = [[CocosOverlayScrollView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    // scrollView = [[CocosOverlayScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

    scrollViewContainer = [[PreviewScrollContainerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

    scrollView = [[CocosOverlayScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, onePanelWide)
                                                      numPages: numberOfPages + 1
                                                         width: onePanelWide
                                                         layer: panels];

    scrollViewContainer.scrollView = scrollView;

    // pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 50, 480)];
    // pageControl.numberOfPages = numberOfPages;
    // pageControl.currentPage = 0;
    // pageControl.delegate = scrollView;

    [scrollView setContentOffset: CGPointMake(0, (woff + 1) * onePanelWide) animated: NO];

    // Add Scrollview to cocos2d
    [[[CCDirector sharedDirector] openGLView] addSubview:scrollViewContainer];
    [[[CCDirector sharedDirector] openGLView] addSubview:scrollView];
    // [[[CCDirector sharedDirector] openGLView] addSubview:pageControl];

    // set to current level
    // [scrollView setContentOffset: CGPointMake(woff * onePanelWide, s.height/2) animated: YES];

    [scrollView release];
    [scrollViewContainer release];

    [super onEnter]; // ?
}

- (void) menuButtonPressed: (id) sender 
{
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:0.5 scene:[HSMenuScene scene]]];
}

- (void) levelPicked: (id) sender 
{
    // tmp
    // [scrollView removeFromSuperview];
    // [scrollViewContainer removeFromSuperview];

    CCLOG(@"world %@ %d picked", ((NMPanelMenuItem*)sender).name, ((NMPanelMenuItem*)sender).world);
    nextWorld_ = ((NMPanelMenuItem*)sender).world;
    // if(false) {
    //     GameController* gc = [GameController sharedGameController];
    //     [gc setWorld:((NMPanelMenuItem*)sender).world level:0];
    //     [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:0.5 scene:[HSGameScene scene]]];
    // }    
}

- (void) visit {
    if(nextWorld_ > -1 && !transitioning_) {
        transitioning_ = YES;
        [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:0.5 scene:[GoBackScene scene]]];
    }
    [super visit];
}

- (void) onExit 
{
    [scrollView removeFromSuperview];
    [scrollViewContainer removeFromSuperview];
    [super onExit];
}

- (void) dealloc
{
    [super dealloc];
}
@end
