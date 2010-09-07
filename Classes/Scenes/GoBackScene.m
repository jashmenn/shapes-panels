/*
 *  GoBackScene.m
 *  shapes-panels
 *
 *  Created by Nate Murray on 9/7/10.
 *  Copyright 2010 LittleHiccup. All rights reserved.
 *
 */

#include "GoBackScene.h"


@implementation GoBackScene

+(id) scene
{
    CCScene *scene = [CCScene node];
    GoBackScene *layer = [GoBackScene node];
    [scene addChild: layer];
    return scene;
}

-(id) init
{
    if( (self=[super init] )) {
        CCLabel* label = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
        CGSize size = [[CCDirector sharedDirector] winSize];
        label.position =  ccp( size.width /2 , size.height/2 );
        [self addChild: label];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}
@end
