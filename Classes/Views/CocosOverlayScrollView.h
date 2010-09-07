//
//  CocosOverlayScrollView.h
//  shapes
//
//  Created by Nate Murray on 8/23/10.
//  Copyright 2010 LittleHiccup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CocosOverlayScrollView : UIScrollView
{
    CCNode* targetLayer;
}
@property(nonatomic, retain) CCNode* targetLayer;
-(id) initWithFrame: (CGRect) frameRect numPages: (int) numPages width: (float) width layer: (CCNode*) layer;
@end
