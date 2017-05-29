#import "CCUIFlashlightSetting.h"
#import "CCXSharedResources.h"
#import "FlashlightSwitch.h"
#import <FlipSwitch/FSSwitchPanel.h>

%hook CCUIFlashlightSetting
%property (nonatomic, assign) BOOL shouldControlFlashlight;
- (void)activate {

	if ([self valueForKey:@"_flashlight"] && [CCXSharedResources sharedInstance].flashlight) {
		if ([self valueForKey:@"_flashlight"] != [CCXSharedResources sharedInstance].flashlight) {
			[self setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
		}
	}

	if (![self valueForKey:@"_flashlight"]) {
		if ([CCXSharedResources sharedInstance].flashlight) {
			[self setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
		}
	}

	//if (self.shouldControlFlashlight) {
		%orig;
	//}

	if ([self valueForKey:@"_flashlight"]) {
		if (![CCXSharedResources sharedInstance].flashlight) {
			[CCXSharedResources sharedInstance].flashlight = (AVFlashlight *)[self valueForKey:@"_flashlight"];
		}
	}
}


- (void)deactivate {
	return;
	if ([self valueForKey:@"_flashlight"] && [CCXSharedResources sharedInstance].flashlight) {
		if ([self valueForKey:@"_flashlight"] != [CCXSharedResources sharedInstance].flashlight) {
			[self setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
		}
	}

	if (![self valueForKey:@"_flashlight"]) {
		if ([CCXSharedResources sharedInstance].flashlight) {
			[self setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
		}
	}

	//if (self.shouldControlFlashlight) {
		%orig;
	//}

	if ([self valueForKey:@"_flashlight"]) {
		if (![CCXSharedResources sharedInstance].flashlight) {
			[CCXSharedResources sharedInstance].flashlight = (AVFlashlight *)[self valueForKey:@"_flashlight"];
		}
	}
}

- (id)init {
	CCUIFlashlightSetting *orig = %orig;
	orig.shouldControlFlashlight = YES;
	[CCXSharedResources sharedInstance].flashlightSetting = orig;
	return orig;
}

-(void)_setTorchLevel:(float)arg1 {

	// if ([CCXSharedResources sharedInstance].flipswitchFlashlightSetting && [self delegate]) {
	// 	if ([(NSObject *)[self delegate] isKindOfClass:NSClassFromString(@"FCCDarkSideController")]) {
	// 		[[NSClassFromString(@"FSSwitchPanel") sharedPanel] setState:FSSwitchStateIndeterminate forSwitchIdentifier:[[(NSObject *)[self delegate] valueForKey:@"button"] valueForKey:@"switchIdentifier"]];
		
	// 	}
	// 	//[[FSSwitchPanel sharedPanel] setState:FSSwitchStateIndeterminate forSwitchIdentifier:[[[self delegate] valueForKey:@"button"] valueForKey:@"switchIdentifier"]];
	// 	//[(FlashlightSwitch *)[CCXSharedResources sharedInstance].flipswitchFlashlightSetting applyState:arg1 == 0 ? FSSwitchStateOff : FSSwitchStateOn forSwitchIdentifier:nil];
	// }
	self.shouldControlFlashlight = YES;
	if (![self valueForKey:@"_flashlight"]) {
		if ([CCXSharedResources sharedInstance].flashlight) {
			[self setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
		}
	}

	if ([self valueForKey:@"_flashlight"] && [CCXSharedResources sharedInstance].flashlight) {
		if ([self valueForKey:@"_flashlight"] != [CCXSharedResources sharedInstance].flashlight) {
			[self setValue:[CCXSharedResources sharedInstance].flashlight forKey:@"_flashlight"];
		}
	}


	//if (self.shouldControlFlashlight) {
		%orig;
	//}

	if ([self valueForKey:@"_flashlight"]) {
		if (![CCXSharedResources sharedInstance].flashlight) {
			[CCXSharedResources sharedInstance].flashlight = (AVFlashlight *)[self valueForKey:@"_flashlight"];
		}
	}

			//AVFlashlight *_flashlight = [self valueForKey:@"_flashlight"];
			// @try{
	  //  			[_flashlight removeObserver:self forKeyPath:@"available"];
   //          	[_flashlight removeObserver:self forKeyPath:@"overheated"];                                  
   //          	[_flashlight removeObserver:self forKeyPath:@"flashlightLevel"];
			// }@catch(id anException){
	  //  			//do nothing, obviously it wasn't attached because an exception was thrown
			// }
			// [_flashlight addObserver:self forKeyPath:@"available" options:nil context:nil];

}
%end