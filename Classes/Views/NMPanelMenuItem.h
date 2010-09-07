/*
 *  NMPanelMenuItem.h
 *  shapes
 *
 *  Created by Nate Murray on 7/29/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

#import "cocos2d.h"

@interface NMPanelMenuItem : CCMenuItemSprite {
    int world;
    NSString* name_;
    CCSprite* label_;
    CCSprite* glow_;
    CCNode<CCRGBAProtocol> *activeImage_;
    BOOL isActive_;
    BOOL showGlow_;
}
@property (nonatomic) int world;
@property (nonatomic,readwrite,retain) CCSprite* label;
@property (nonatomic,readwrite,retain) NSString* name;
@property (nonatomic,readwrite,retain) CCNode<CCRGBAProtocol> *activeImage;
@property (nonatomic,readwrite,retain) CCSprite *glow;
@property (nonatomic,readwrite) BOOL showGlow;

-(id) initFromNormalSprite:(CCNode<CCRGBAProtocol>*)normalSprite 
            selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite 
              activeSprite:(CCNode<CCRGBAProtocol>*)activeSprite 
            disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite 
					  name:(NSString*)name
                    target:(id)target selector:(SEL)selector;


@end
