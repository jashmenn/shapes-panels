/*
 *  HSLevelSelectionScene2.m
 *  shapes
 *
 *  Created by Nate Murray on 7/24/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

#include "HCUPPanelScene.h"
#import "HSGameScene.h"
#import "NMPanelMenu.h"
#import "NMPanelMenuItem.h"
#import "GameController.h"
#import "JSWorld.h"
#import "PreviewScrollContainerView.h"
#import "HSMenuScene.h"
#import "JSNetworkManager.h"

#ifdef LITE_VERSION
#import "FlurryAPI.h"
#endif

// http://getsetgames.com/2009/08/21/cocos2d-and-uiscrollview/
// http://blog.proculo.de/archives/180-Paging-enabled-UIScrollView-With-Previews.html

@implementation HSLevelSelectionScene2
@synthesize currentLockPanelName=currentLockPanelName_;

+(id) scene
{
    CCScene *scene = [CCScene node];
    HSLevelSelectionScene2 *layer = [HSLevelSelectionScene2 node];
    [scene addChild: layer];
    return scene;
}

-(id) init
{
    if( (self=[super init] )) {
        nextWorld_ = -1;
        transitioning_ = NO;

        CCSpriteFrameCache* fcache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [fcache addSpriteFramesWithFile: @"panels-sheet-1.plist"];
        [fcache addSpriteFramesWithFile: @"panels-sheet-2.plist"];
        self.currentLockPanelName = @"n/a";

#ifdef LITE_VERSION
        [FlurryAPI logEvent:@"LevelSelectionScene"];
#endif

    }
    return self;
}

- (void) onEnter 
{
    // CCLOG(@"======= HSLevelSelection onEnter");
    CGSize s = [[CCDirector sharedDirector] winSize];

    CCSprite* bg = [CCSprite spriteWithFile:@"paper-background-2.png"];
    bg.position = ccp(s.width/2, s.height/2);
    [self addChild: bg];

    CCLayer* panels = [CCLayer node];
    CCLOG(@"p.x:%f p.y:%f", panels.position.x, panels.position.y);
    // panels.position = ccp(s.width/2, s.height/2);

    // create "all" panel
    CCSprite* pane1 = [CCSprite spriteWithFile:@"main-menu-panel.png"];
    CCSprite* pane2 = [CCSprite spriteWithFile:@"main-menu-panel-on.png"];
    // pane1.opacity = 0;
    NMPanelMenuItem* menuItem1 = [NMPanelMenuItem itemFromNormalSprite:pane1 selectedSprite:pane2 target:self selector:@selector(menuButtonPressed:)];
    menuItem1.world = 0;
    menuItem1.name = @"blank";

    NMPanelMenu* menu = [NMPanelMenu menuWithItems: menuItem1, nil];
    //CCSpriteFrameCache* fcache = [CCSpriteFrameCache sharedSpriteFrameCache];

    for(int i=0; i < [JSWorld numWorlds]; i++) {
        JSWorld* world = [JSWorld world: i];
        // CCSprite* pane2 = [CCSprite spriteWithFile:[NSString stringWithFormat: @"%@-panel.png", world.name]];
        CCSprite* pane2 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat: @"%@-panel.png", world.name]];
        // CCSprite* pane2_on = [CCSprite spriteWithFile:[NSString stringWithFormat: @"%@-panel-on.png", world.name]];

        NMPanelMenuItem* menuItem2 = [[NMPanelMenuItem alloc] initFromNormalSprite:pane2 
                                                                    selectedSprite:pane2
                                                                      activeSprite:pane2
                                                                    disabledSprite:pane2
                                                                              name:world.name
                                                                            target:self selector:@selector(levelPicked:)];
        menuItem2.world = i;
        menuItem2.name = world.name;
        [menu addChild: menuItem2];
        [menuItem2 release];
    }

#ifdef LITE_VERSION
    
    // [self addLockPanelToMenu: menu];
    NSUInteger randomIndex = arc4random() % 100;
    NSString* paneName = randomIndex <= 50 ? @"locked-panel-camp" : @"locked-panel-dino";
    CCSprite* pane    = [CCSprite spriteWithFile:[NSString stringWithFormat: @"%@.png",    paneName]];
    CCSprite* pane_on = [CCSprite spriteWithFile:[NSString stringWithFormat: @"%@-on.png", paneName]];

    NMPanelMenuItem* lockedItem = [[NMPanelMenuItem alloc] initFromNormalSprite:pane 
                                                               selectedSprite:pane
                                                                 activeSprite:pane_on
                                                               disabledSprite:pane
                                                                         name:@"blank"
                                                                       target:self selector:@selector(lockPanelPicked:)];
    lockedItem.showGlow = false;

    [menu addChild: lockedItem];
    // menuItem.position = ccp(menuItem.position.x, menuItem.position.y - 100);
    [lockedItem release];

#endif

    // where you're at: get the locked panel to align vertically
    // get it to work
    // then add the last level buy now screen

    [menu alignItemsHorizontallyWithPadding:30.0];
    [panels addChild:menu];

#ifdef LITE_VERSION
    lockedItem.position = ccp(lockedItem.position.x, lockedItem.position.y - 7);
#endif


    // menu.anchorPoint = ccp(0,0);
    // CCLOG(@"menu.x:%f menu.y:%f", menu.position.x, menu.position.y);
    // menu.position = ccp(0, s.height/2);
    // CCLOG(@"menu.x:%f menu.y:%f", menu.position.x, menu.position.y);

    int numberOfPages = [JSWorld numWorlds];

#ifdef LITE_VERSION
    numberOfPages += 1;
#endif

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

- (void) addLockPanelToMenu:(NMPanelMenu*)menu
{
    NSString* paneName = @"locked-panel-camp";
    CCSprite* pane    = [CCSprite spriteWithFile:[NSString stringWithFormat: @"%@.png",    paneName]];
    CCSprite* pane_on = [CCSprite spriteWithFile:[NSString stringWithFormat: @"%@-on.png", paneName]];
    self.currentLockPanelName = paneName;

    NMPanelMenuItem* menuItem = [[NMPanelMenuItem alloc] initFromNormalSprite:pane 
                                                               selectedSprite:pane
                                                                 activeSprite:pane_on
                                                               disabledSprite:pane
                                                                         name:@"blank"
                                                                       target:self selector:@selector(lockPanelPicked:)];

    [menu addChild: menuItem];
    // menuItem.position = ccp(menuItem.position.x, menuItem.position.y - 100);
    [menuItem release];
}

- (void) lockPanelPicked: (id) sender {
    CCLOG(@"buying!");

#ifdef LITE_VERSION
    NSArray *keys = [NSArray arrayWithObjects:@"image", nil];
    NSArray *objects = [NSArray arrayWithObjects:self.currentLockPanelName, nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [FlurryAPI logEvent:@"LockPanelBuyNowPressed" withParameters:dictionary];
#endif

    [[JSNetworkManager manager] openFullVersionURL];
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
        GameController* gc = [GameController sharedGameController];
        [gc setWorld:nextWorld_ level:0]; //maybe this cuold be an object to be slightly faster
        [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:0.5 scene:[HSGameScene scene]]];
    }
    [super visit];
}

- (void) onExit 
{
    CCLOG(@"=== removing view");
    [scrollView removeFromSuperview];
    [scrollViewContainer removeFromSuperview];
    [super onExit];
}

- (void) dealloc
{
    self.currentLockPanelName = nil;
    CCLOG(@"=== deallocing HSLevelSelectionScene2");
    // [scrollView removeFromSuperview];
    // [scrollViewContainer removeFromSuperview];

    // [pageControl removeFromSuperview];
    [super dealloc];
}
@end
