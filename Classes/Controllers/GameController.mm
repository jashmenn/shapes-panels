/*
 *  GameController.mm
 *  deadmanschest
 *
 *  Created by Nate Murray on 6/27/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

/*
   game controller should hold a reference to the current world, the current
   world holds a reference to the current level the world and level know how to
   parse the plists.  we need to have the world class load the world
   definitions dictionary then it can create a level with a particular
   dictionary then the game controller asks its world for the current level and
   builds the gamescene based on the level. it gives the gamescene the level

   the panel scene has one panel for all. and otherwise builds a panel for each
   world. it asks the or maybe just the world class method. for the dictionary
   of worlds

   when you are playing the game, you start on the first level of the world. if
   you win, you get a little message, and then its on to the next level of the
   world. if there is no next level in this world. then you go to the first
   level of the next world. 

   one problem is how does one get back to the panel world chooser once they
   have started the game.
 */

#include "GameController.h"
#import "GameSoundManager.h"
#import "HSGameScene.h"
#import "JSWorld.h"

@interface GameController (Private)
@end

@implementation GameController
@synthesize piecesRemaining;
@synthesize currentWorld;
@synthesize currentLevel;
@synthesize currentWorld_i;
@synthesize currentLevel_i;
@synthesize currentVoice;
@synthesize operationQueue;
@synthesize newPlayer;
@synthesize levelReady;
// @synthesize gameScene;

SYNTHESIZE_SINGLETON_FOR_CLASS(GameController);
SimpleAudioEngine *soundEngine;

-(id)init {
    if ((self = [super init])){ 
        self.piecesRemaining = 0;
        soundEngine = [GameSoundManager sharedManager].soundEngine;
        [soundEngine retain];
        [self setWorld: 0 level: 0];
        // [self setWorld: 16 level: 0];
        [self loadVoicePrefs];
        self.operationQueue = [[NSOperationQueue alloc] init]; 
        self.newPlayer = YES;
        self.levelReady = YES;
    }
    return self;
}

- (void)setWorld:(int)i level:(int)j {
    self.currentWorld = [JSWorld world: i];
    self.currentLevel = [currentWorld level: j];
    self.currentWorld_i = i;
    self.currentLevel_i = j;
}

- (void)replaceWorld:(int)i level:(int)j {
    // this isn't called when you press the green button
    CGSize s = [[CCDirector sharedDirector] winSize];
    [self setWorld:i level:j];
    HSGameScene *currentLevelLayer = [self gameScene];

    // HSGameScene* nextLevelLayer = [[HSGameScene alloc] init];
    HSGameScene* nextLevelLayer = [HSGameScene node];
    [[currentLevelLayer parent] addChild: nextLevelLayer]; // add nextLevel to the same scene
    nextLevelLayer.position = ccp(s.width, 0);

    /* race condition here? */
    nextLevelLayer.tag    = kTag_GameScene;
    currentLevelLayer.tag = kTag_OldGameScene;

    float move_t = 1.0f;

    CCLOG(@"replacing world");
    self.levelReady = NO;

    id move_in  = [CCMoveTo actionWithDuration:move_t position:ccp(0, 0)]; 
    id move_out = [CCMoveTo actionWithDuration:move_t position:ccp(-s.width, 0)]; 
    id rm = [CCCallFuncND actionWithTarget:currentLevelLayer selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
    id ready = [CCCallFunc actionWithTarget:self selector:@selector(levelIsReady)];
    id cleanup = [CCCallFunc actionWithTarget:self selector:@selector(cleanupCaches)];

    [currentLevelLayer runAction: [CCSequence actions: move_out, rm, cleanup, nil]];
    [nextLevelLayer runAction: [CCSequence actions: move_in, ready, nil]];
}

- (HSGameScene*) gameScene {
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    // HSGameScene* layer = (HSGameScene*)[[scene children] objectAtIndex:0]; // thin ice, use a tag!
    HSGameScene* layer = (HSGameScene*)[scene getChildByTag:kTag_GameScene];
    return layer;
}

-(void)dealloc {
    [soundEngine release];
	self.currentVoice = nil;
	self.operationQueue = nil;
    [super dealloc];
}

- (void) piecePlaced {
    self.piecesRemaining -= 1;
    if(self.piecesRemaining <= 0) {
        [self noPiecesRemaining];
    }
}

- (void) noPiecesRemaining {
    // [[self gameScene] levelPassed];

    // todo, i don't like putting this here, but it is the best place
    // id delay = [CCDelayTime actionWithDuration: 1.0]; // delay to allow the last sound to play
    id delay = [CCDelayTime actionWithDuration: 1.2]; // delay to allow the last sound to play
    id passed = [CCCallFunc actionWithTarget:[self gameScene] selector:@selector(levelPassed)];
    [[self gameScene] runAction: [CCSequence actions: delay, passed, nil]];
}

- (void) cleanupCaches {
    // [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void) levelIsReady {
    CCLOG(@"level is ready!");
    self.levelReady = YES;
}

- (void) loadVoicePrefs {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"currentVoice"])  {
        CCLOG(@"setting default voice");
        [self changeVoiceTo:@"addie"];
    } else {
        NSString* voiceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVoice"];
        CCLOG(@"loading voice: %@", voiceName);
        self.currentVoice = voiceName;
    }
}

- (void) changeVoiceTo: (NSString*) newVoice {
    self.currentVoice = newVoice;
    [[NSUserDefaults standardUserDefaults] setObject:newVoice forKey:@"currentVoice"];
}

- (BOOL) firstLaunch {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"launchedBefore"])  {
        CCLOG(@"first launch");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"launchedBefore"];
        return YES;
    } else {
        CCLOG(@"launched before");
        // return [[NSUserDefaults standardUserDefaults] boolForKey:@"launchedBefore"];
        return NO;
    }
}

@end
