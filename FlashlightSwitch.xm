#import "headers.h"
#import "CCUIFlashlightSetting.h"
#import "CCXSharedResources.h"

%hook FlashlightSwitch

- (id)init {
	id orig = %orig;
	[CCXSharedResources sharedInstance].flipswitchFlashlightSetting = orig;
	return orig;
}
- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
	if ([CCXSharedResources sharedInstance].flashlightSetting != nil) {
		// if (((CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting).shouldControlFlashlight) {
		// 	[(CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting _tearDown];
		// }
		((CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting).shouldControlFlashlight = NO;

		//MSHookIvar<AVFlashlight *>((CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting, "_flashlight") = nil;
		//[(CCUIFlashlightSetting *)[[CCXSharedResources sharedInstance] flashlightSetting] deactivate];
		//[(CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting _tearDown];
	}

	%orig;
	// if ([CCXSharedResources sharedInstance].flashlightSetting) {
	// 	((CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting).shouldControlFlashlight = YES;
	// }
}

- (void)beginPrewarmingForSwitchIdentifier:(NSString *)switchIdentifier {
	if ([CCXSharedResources sharedInstance].flashlightSetting) {
		((CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting).shouldControlFlashlight = NO;
		//[(CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting _tearDown];
	}
	%orig;
	// if ([CCXSharedResources sharedInstance].flashlightSetting) {
	// 	((CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting).shouldControlFlashlight = YES;
	// 	//[(CCUIFlashlightSetting *)[CCXSharedResources sharedInstance].flashlightSetting _tearDown];
	// }
}
%end 

%ctor {
	dlopen("/Library/Flipswitch/libFlipswitchSwitches.dylib", RTLD_NOW);
	%init;
}