#import "CCXSharedResources.h"

%hook AVFlashlight


// + (AVFlashlight *)alloc {
// 	if ([CCXSharedResources sharedInstance].flashlight) {
// 		if ([CCXSharedResources sharedInstance].flashlightSetting) {
// 			[[CCXSharedResources sharedInstance].flashlightSetting setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
// 		}
// 		return (AVFlashlight *)[CCXSharedResources sharedInstance].flashlight;
// 	} else {
// 		[CCXSharedResources sharedInstance].flashlight = %orig;
// 		if ([CCXSharedResources sharedInstance].flashlightSetting) {
// 			[[CCXSharedResources sharedInstance].flashlightSetting setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
// 		}
// 		return (AVFlashlight *)[CCXSharedResources sharedInstance].flashlight;
// 	}
// }
- (AVFlashlight *)init {
	//if ()
	//if ([CCXSharedResources sharedInstance].flashlight) return nil;
	// if ([CCXSharedResources sharedInstance].flashlight) {
	// 	if ([CCXSharedResources sharedInstance].flashlightSetting) {
	// 		[[CCXSharedResources sharedInstance].flashlightSetting setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
	// 	}
	// 	return (AVFlashlight *)[CCXSharedResources sharedInstance].flashlight;
	// }

	AVFlashlight *orig = %orig;
	if ([CCXSharedResources sharedInstance].flashlight) {
		//if (self = (AVFlashlight *const __unsafe_unretained)[CCXSharedResources sharedInstance].flashlight) return self;
		[orig setFlashlightLevel:[CCXSharedResources sharedInstance].flashlight.flashlightLevel withError:nil];
	}
	[CCXSharedResources sharedInstance].flashlight = orig;
	if ([CCXSharedResources sharedInstance].flashlightSetting) {
		[[CCXSharedResources sharedInstance].flashlightSetting setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
	}
	return orig;
}

-(BOOL)setFlashlightLevel:(float)arg1 withError:(id*)arg2 {
	if ([CCXSharedResources sharedInstance].flashlight) {
		if (self != [CCXSharedResources sharedInstance].flashlight) {
			return [[CCXSharedResources sharedInstance].flashlight setFlashlightLevel:arg1 withError:arg2];
		}
	}

	return %orig;
	
}

- (void)dealloc {

	//if (self == [CCXSharedResources sharedInstance].flashlight) return;
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