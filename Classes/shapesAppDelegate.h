//
//  shapesAppDelegate.h
//  shapes
//
//  Created by Nate Murray on 7/24/10.
//  Copyright LittleHiccup 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shapesAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;
- (void) setupCocos2d;
@end

#ifdef LITE_VERSION
void uncaughtExceptionHandler(NSException *exception);
#endif



