#import "CCXSharedResources.h"

%hook AVFlashlight

- (id)init {
	AVFlashlight *orig = %orig;
	[CCXSharedResources sharedInstance].flashlight = orig;
	if ([CCXSharedResources sharedInstance].flashlightSetting) {
		[[CCXSharedResources sharedInstance].flashlightSetting setValue:orig forKey:@"_flashlight"];
	}
	return orig;
}

- (void)dealloc {
	NSLog(@"TRYING TO dealloc");
	@try{
		if ([CCXSharedResources sharedInstance].flashlightSetting) {
			NSLog(@"GOT FLASHLIGHT SETTINGS");
			[self removeObserver:[CCXSharedResources sharedInstance].flashlightSetting forKeyPath:@"available" context:NULL];
        	[self removeObserver:[CCXSharedResources sharedInstance].flashlightSetting forKeyPath:@"overheated" context:NULL];
        	[self removeObserver:[CCXSharedResources sharedInstance].flashlightSetting forKeyPath:@"flashlightLevel" context:NULL];
		}
	}@catch(id anException){
	   	NSLog(@"STUPID EXCEPTION: %@", anException);
	}

	@try{
		if ([CCXSharedResources sharedInstance].flipswitchFlashlightSetting) {
			[self removeObserver:[CCXSharedResources sharedInstance].flipswitchFlashlightSetting forKeyPath:@"available" context:NULL];
		}
	}@catch(id anException){
	   	NSLog(@"STUPID EXCEPTION 1: %@", anException);
	}

	%orig;
}
%end