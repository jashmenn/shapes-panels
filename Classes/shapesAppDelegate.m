//
//  shapesAppDelegate.m
//  shapes
//
//  Created by Nate Murray on 7/24/10.
//  Copyright LittleHiccup 2010. All rights reserved.
//

#import "shapesAppDelegate.h"
#import "cocos2d.h"
#import "HCUPPanelScene.h"

@implementation shapesAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{

    // CC_DIRECTOR_INIT()
    //
    // 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
    // 2. EAGLView multiple touches: disabled
    // 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
    // 4. Parents EAGLView to the newly created window
    // 5. Creates Display Link Director
    // 5a. If it fails, it will use an NSTimer director
    // 6. It will try to run at 60 FPS
    // 7. Display FPS: NO
    // 8. Device orientation: Portrait
    // 9. Connects the director to the EAGLView
    //
    // CC_DIRECTOR_INIT();

    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupCocos2d];
}


- (void) setupCocos2d {
    if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
          [CCDirector setDirectorType:kCCDirectorTypeNSTimer];
    CCDirector *__director = [CCDirector sharedDirector];
    [__director setDeviceOrientation:kCCDeviceOrientationPortrait];
    [__director setDisplayFPS:NO];
    [__director setAnimationInterval:1.0/60];
    EAGLView *__glView = [EAGLView viewWithFrame:[window bounds]
                                     pixelFormat:kEAGLColorFormatRGB565
                                     depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */
                              preserveBackbuffer:NO];
    [__director setOpenGLView:__glView];
    [window addSubview:__glView];
    [window makeKeyAndVisible];
 
    // not sure why, the page turn says to turn that on
    // [[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];

    // Obtain the shared director in order to...
    CCDirector *director = [CCDirector sharedDirector];

    // Sets landscape mode
    [director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];

    // Turn on display FPS
    //[director setDisplayFPS:YES];

    // Turn on multiple touches
    EAGLView *view = [director openGLView];
    [view setMultipleTouchEnabled:YES];

    // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
    // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
    // You can change anytime.
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	

    [[CCDirector sharedDirector] runWithScene: [HCUPPanelScene scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"memory warning");
	[[CCDirector sharedDirector] purgeCachedData];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
