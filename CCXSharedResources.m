#import "CCXSharedResources.h"

@implementation CCXSharedResources
+ (instancetype)sharedInstance
{
	static CCXSharedResources *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
	return _sharedInstance;
}

- (ICGNavigationController *)settingsNavigationController {
	return _settingsNavigationController;
}

- (void)setSettingsNavigationController:(ICGNavigationController *)navigationController {
	_settingsNavigationController = navigationController;
}

- (CCXSettingsNavigationBar *)settingsNavigationBar {
	return _settingsNavigationBar;
}

- (void)setSettingsNavigationBar:(CCXSettingsNavigationBar *)navigationBar {
	_settingsNavigationBar = navigationBar;
}

- (AVFlashlight *)flashlight {
	return _flashlight;
}

- (void)setFlashlight:(AVFlashlight *)flashlight {
	_flashlight = flashlight;
}

+ (id)controlCenterSystemAgent {
	if ([NSClassFromString(@"SBControlCenterController") sharedInstanceIfExists]) {
		SBControlCenterController *controller = [NSClassFromString(@"SBControlCenterController") sharedInstanceIfExists];
		return [controller valueForKey:@"_systemAgent"];
	}
	return nil;
}

@end