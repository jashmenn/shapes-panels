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
        nextWorld_ = -1;

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
    NSArray* panelNames = [NSArray arrayWithObjects: @"amazon", @"arctic",
        @"brkfst", @"camp", @"city", nil];
    int numberOfPages = [panelNames count];

    // create an empty layer for us to work with
    CCLayer* panels = [CCLayer node];

    // The easiest way to add to a CCMenu dynamically is to start with one panel 
    // and then add more later. (Anyone have advice on a better way to do this?)
    NSString *firstPanelName = [NSString stringWithFormat: @"%@-panel.png", [panelNames objectAtIndex:0]];
    CCSprite* pane1 = [CCSprite spriteWithFile:firstPanelName];
    NMPanelMenuItem* menuItem1 = [[NMPanelMenuItem alloc] initFromNormalSprite:pane1 
                                                        selectedSprite:pane1 
                                                          activeSprite:pane1
                                                        disabledSprite:pane1
                                                                  name:[panelNames objectAtIndex:0]
                                                                target:self 
                                                              selector:@selector(levelPicked:)];
    menuItem1.world = 0;
    menuItem1.name = [panelNames objectAtIndex:0];
    NMPanelMenu* menu = [NMPanelMenu menuWithItems: menuItem1, nil];
    [pane1 release];

    // Now add the rest of the panels
    for(int i=1; i < numberOfPages; i++) {
        NSString* currentName = [panelNames objectAtIndex:i];
        CCSprite* pane2 = [CCSprite spriteWithFile:[NSString stringWithFormat: @"%@-panel.png", currentName]];
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

    // #define this somewhere. It is dependend on the size of your images.
    float onePanelWide = 363;
    float padding = 15;
    float totalWidth = numberOfPages * onePanelWide; // (wait, do we need padding in here?)

    // When the user returns to the panel scene, you may want the panel to be
    // positioned on the level they left.  In Jacob's Shapes we use the
    // GameController gc method currentWorld_i to indicate what level we are
    // currently on. For the demo, we're just setting to 0
    int currentWorldOffset = 0;    // current world number. 
    // int currentWorldOffset = 1; // Try changing to 1 and see what happens

    [menu alignItemsHorizontallyWithPadding: padding*2];

    // add our panels layer
    [panels addChild:menu];
    [self addChild:panels];

    // set the position of the menu to the center of the very first panel
    menu.position = ccpAdd(menu.position, ccp(totalWidth/2 - onePanelWide/2, 0));

    // Now we do two things: 
    //
    //   1. Add our CocosOverlayScrollView which is only one panel wide (less
    //      than the whole screen). If we had this layer only then we wouldn't
    //      be notified of touches on the edge of the screen.
    //   2. We add the PreviewScrollContainerView which is full screen. The
    //      PreviewScrollContainerView will delegate any touches it receives to
    //      our paging scroll view
    //      
    // Note that we're only concerned with a horizontal iPhone. If your game is
    // vertical, change accordingly
    scrollViewContainer = [[PreviewScrollContainerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    scrollView = [[CocosOverlayScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, onePanelWide)
                                                      numPages: numberOfPages
                                                         width: onePanelWide
                                                         layer: panels];
    scrollViewContainer.scrollView = scrollView;

    // this is just to pre-set the scroll view to a particular panel
    [scrollView setContentOffset: CGPointMake(0, currentWorldOffset * onePanelWide) animated: NO];

    // Add views to cocos2d
    // We called it a PreviewScrollContainerView, but it actually isn't containing anything at all.
    // In reality it is just taking up any space under our ScrollView and delegating the touches. 
    [[[CCDirector sharedDirector] openGLView] addSubview:scrollViewContainer];
    [[[CCDirector sharedDirector] openGLView] addSubview:scrollView];

    [scrollView release];
    [scrollViewContainer release];

    [super onEnter];
}

- (void) levelPicked: (id) sender 
{
    CCLOG(@"world %@ %d picked", ((NMPanelMenuItem*)sender).name, ((NMPanelMenuItem*)sender).world);
    nextWorld_ = ((NMPanelMenuItem*)sender).world;
    // why do we do this? See #visit
}

// We want our panel "active" image to draw before we change scenes. This
// allows us to draw the active image and then change scenes. It feels a bit
// hacky, but the result is a snappier experience for the user.
- (void) visit {
    [super visit];
    if(nextWorld_ > -1 && !transitioning_) {
        transitioning_ = YES;
        [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:0.5 scene:[HCUPPanelScene scene]]];
    }
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
