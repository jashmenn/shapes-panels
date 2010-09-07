/*
 *  NMPanelMenuItem.m
 *  shapes
 *
 *  Created by Nate Murray on 7/29/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

#include "NMPanelMenuItem.h"
#import "GameSoundManager.h"
#import "GameController.h"

@interface NMPanelMenuItem (Private)
@end

@implementation NMPanelMenuItem
@synthesize world;
@synthesize label=label_;
@synthesize name=name_;
@synthesize activeImage=activeImage_;
@synthesize glow=glow_;
@synthesize showGlow=showGlow_;

-(id) init {
    if ((self = [super init])){ 
    }
    return self;
}

-(id) initFromNormalSprite:(CCNode<CCRGBAProtocol>*)normalSprite 
            selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite 
              activeSprite:(CCNode<CCRGBAProtocol>*)activeSprite 
            disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite 
					  name:(NSString*)name
                    target:(id)target selector:(SEL)selector
{
    if( (self=[super initFromNormalSprite:normalSprite 
            selectedSprite:selectedSprite 
            disabledSprite:disabledSprite 
                    target:target selector:selector]))
    {
        self.activeImage = activeSprite;
		self.name = name;

		CCSpriteFrameCache* fcache = [CCSpriteFrameCache sharedSpriteFrameCache];
		NSString* glowName = @"frames-glow.png";
       if([fcache spriteFrameByName: glowName]) {
       } else {
			// todo, move this to extensions once it works
			CCTexture2D* glowTex = [[CCTexture2D alloc] initWithImage: [UIImage imageNamed:glowName]];
			CCSpriteFrame* spriteFrame = [[CCSpriteFrame alloc] initWithTexture:glowTex 
			   rect:CGRectMake(0,0,glowTex.pixelsWide,glowTex.pixelsHigh) offset: ccp(0,0)];
			[fcache addSpriteFrame:spriteFrame name:glowName];
			[spriteFrame release];
			[glowTex release];
       }
	   self.glow = [CCSprite spriteWithSpriteFrameName:glowName];
       self.showGlow = true;
    }
    return self;
}

-(void) activate
{
    isActive_ = YES;
    SimpleAudioEngine* soundEngine = [GameSoundManager sharedManager].soundEngine;
	if(self.name && ![self.name isEqualToString:@"blank"]) {
		GameController* gc = [GameController sharedGameController];
		NSString* soundName = [NSString stringWithFormat:@"%@-%@.caf", gc.currentVoice, self.name];
		[soundEngine playEffect:soundName pitch:1.0f pan:0.0f gain:1.0f];
	} else {
		[soundEngine playEffect:@"briefcase-click-1.caf" pitch:1.0f pan:0.0f gain:0.7f];
	}
    [super activate];
}

-(void) draw
{
    if(isActive_) {
        [self.activeImage draw];
        if(self.showGlow) [self.glow draw];
    } else {
        [super draw];
    }
}

-(void) dealloc {
    self.label = nil;
    self.name = nil;
    self.activeImage = nil;
	self.glow = nil;
    [super dealloc];
}

@end
