/*
 *  GameController.h
 *  deadmanschest
 *
 *  Created by Nate Murray on 6/27/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

#import "cocos2d.h"
#import "common.h"
#import "SynthesizeSingleton.h"

@class HSGameScene;
@class JSWorld;
@class JSLevel;

@interface GameController : NSObject {
    int piecesRemaining;
    JSWorld* currentWorld;
    JSLevel* currentLevel;
    int currentWorld_i;
    int currentLevel_i;
    NSString* currentVoice;
    NSOperationQueue* operationQueue;
    BOOL newPlayer;
    BOOL levelReady;
    // HSGameScene* gameScene;
}
@property(nonatomic) int piecesRemaining;
@property(nonatomic, retain) JSWorld* currentWorld;
@property(nonatomic, retain) JSLevel* currentLevel;
@property(nonatomic) int currentWorld_i;
@property(nonatomic) int currentLevel_i;
@property(nonatomic, retain) NSString* currentVoice;
@property(nonatomic, retain) NSOperationQueue* operationQueue;
@property(nonatomic) BOOL newPlayer;
@property(nonatomic) BOOL levelReady;
// @property(nonatomic, retain) HSGameScene* gameScene;

+(GameController *) sharedGameController;
- (void) noPiecesRemaining;
- (void) piecePlaced;
- (void)setWorld:(int)i level:(int)j;
- (void)replaceWorld:(int)i level:(int)j;
- (HSGameScene*) gameScene;
- (void) cleanupCaches;
- (void) loadVoicePrefs;
- (void) changeVoiceTo: (NSString*) newVoice;
- (void) levelIsReady;
- (BOOL) firstLaunch;
@end
