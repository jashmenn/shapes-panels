//
//  shapesAppDelegate.m
//  shapes
//
//  Created by Nate Murray on 7/24/10.
//  Copyright LittleHiccup 2010. All rights reserved.
//

#import "shapesAppDelegate.h"
#import "cocos2d.h"
#import "HSMenuScene.h"
#import "HSGameScene.h"
#import "GameSoundManager.h"
#import "JSWorld.h"
#import "HSLevelSelectionScene.h"
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

#ifdef LITE_VERSION
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAPI startSession:@"GJSNXELXLP5ER11HN391"];
#endif


// do	{																							
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupCocos2d];
    // [self playIntroVideo];

}

- (void)playIntroVideo {

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"HiccupLogoShort" ofType:@"m4v"]];
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];

    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];

    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
        // Use the new 3.2 style API
        moviePlayer.controlStyle = MPMovieControlStyleNone;
        moviePlayer.shouldAutoplay = YES;
        // This does blows up in cocos2d, so we'll resize manually
        // [moviePlayer setFullscreen:YES animated:YES];
        [moviePlayer.view setTransform:CGAffineTransformMakeRotation((float)M_PI_2)];

//        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize winSize = CGSizeMake(480, 320); // hmm
        moviePlayer.view.frame = CGRectMake(0, 0, winSize.height, winSize.width);	// width and height are swapped after rotation
        [window addSubview:moviePlayer.view];
//        [[[CCDirector sharedDirector] openGLView] addSubview:moviePlayer.view];
    } else {
        // Use the old 2.0 style API
        moviePlayer.movieControlMode = MPMovieControlModeHidden;
        [moviePlayer play];
    }

    [window makeKeyAndVisible];
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *moviePlayer = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];

    // If the moviePlayer.view was added to the openGL view, it needs to be removed
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
        [moviePlayer.view removeFromSuperview];
    }

    [moviePlayer release];
    CCLOG(@"DONE");
//    [[CCDirector sharedDirector] replaceScene: [HSMenuScene scene]];
}



- (void) setupCocos2d {

    //Kick off sound initialisation, this will happen in a separate thread
    [[GameSoundManager sharedManager] setup];

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

     // kick off level loading. todo figure out best place to do this
    [JSWorld setup];
    GameController* gc = [GameController sharedGameController];
    [gc retain];

    if([gc firstLaunch])
      [[CCDirector sharedDirector] runWithScene: [HSIntroScene scene]];
    els
      [[CCDirector sharedDirector] runWithScene: [HSMenuScene scene]];

    // [[CCDirector sharedDirector] runWithScene: [HSOptionsScene scene]];
    // [[CCDirector sharedDirector] runWithScene: [HSLevelSelectionScene2 scene]];
    // [[CCDirector sharedDirector] runWithScene: [HSGameScene scene]];
    // [[CCDirector sharedDirector] runWithScene: [HSBuyNowSceneFlat scene]];
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
	// [[CCTextureCache sharedTextureCache] removeUnusedTextures];
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
    [[GameController sharedGameController] release];
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

#ifdef LITE_VERSION
void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}  
#endif


@end
