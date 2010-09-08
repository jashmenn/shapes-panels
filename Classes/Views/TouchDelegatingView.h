//
//  TouchDelegatingView.h
//  shapes
//
//  Created by Nate Murray on 8/23/10.
//  Copyright 2010 LittleHiccup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocosOverLayScrollView.h"

@interface TouchDelegatingView : UIView {
    // UIPageControl* pageControl;
    CocosOverlayScrollView* scrollView;
}
@property(nonatomic, retain) CocosOverlayScrollView* scrollView;

@end
