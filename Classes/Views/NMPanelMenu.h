/*
 *  NMPanelMenu.h
 *  shapes
 *
 *  Created by Nate Murray on 7/29/10.
 *  Copyright 2010 YetiApps. All rights reserved.
 *
 */

#import "cocos2d.h"
@interface NMPanelMenu : CCMenu {
}
-(CCMenuItem *) itemForTouch: (UITouch *) touch;
@end
