#import "ICGTransitionAnimation/ICGNavigationController.h"
#import "CCXSettingsNavigationBar.h"
#import <AVFoundation/AVFlashlight.h>
#import "headers.h"

@interface CCXSharedResources : NSObject {
	ICGNavigationController *_settingsNavigationController;
	CCXSettingsNavigationBar *_settingsNavigationBar;
	AVFlashlight *_flashlight;
}
@property (nonatomic, retain) ICGNavigationController *settingsNavigationController;
@property (nonatomic, retain) CCXSettingsNavigationBar *settingsNavigationBar;
@property (nonatomic, retain) NSObject *flashlightSetting;
@property (nonatomic, retain) NSObject *flipswitchFlashlightSetting;
+ (instancetype)sharedInstance;
- (AVFlashlight *)flashlight;
- (void)setFlashlight:(AVFlashlight *)flashlight;
+ (id)controlCenterSystemAgent;
@end