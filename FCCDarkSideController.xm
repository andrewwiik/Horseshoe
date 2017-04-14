static NSMutableDictionary *_identifiersToModules;


#import "headers.h"
#import "CCXSharedResources.h"

@interface FCCDarkSideController : NSObject <CCUIButtonModuleDelegate>
@property (nonatomic, assign) BOOL hasLoadedModule;
-(void)buttonModule:(id)arg1 willExecuteSecondaryActionWithCompletionHandler:(/*^block*/id)arg2;
-(void)buttonModuleStateDidChange:(id)arg1;
-(void)buttonModulePropertiesDidChange:(id)arg1;
-(id)controlCenterSystemAgent;
@end
%hook FCCDarkSideController
%property (nonatomic, assign) BOOL hasLoadedModule;

- (id)initWithButton:(UIView *)button templateBundle:(id)bundle radius:(CGFloat)radius {

	id orig = %orig;
	for (UIGestureRecognizer *gesture in [button gestureRecognizers]) {
		if ([gesture isKindOfClass:NSClassFromString(@"SBUIForceTouchGestureRecognizer")]) {
			if ([gesture valueForKey:@"_targets"]) {
				if ([(NSArray *)[gesture valueForKey:@"_targets"] count] < 2) {
					[gesture addTarget:self action:@selector(_handleGestureRecognizer:)];
				}
			}
		}
	}
	return orig;
}


- (void)_handleGestureRecognizer:(id)gestureRecognizer {
	NSLog(@"HANDLING GESTURE: %@", gestureRecognizer);
	if (!_identifiersToModules) {
		_identifiersToModules = [NSMutableDictionary new];
		_identifiersToModules[@"com.apple.mobiletimer"] = [[NSClassFromString(@"CCUITimerShortcut") alloc] init];
		_identifiersToModules[@"com.rpetrich.flipcontrolcenter.clock"] = [[NSClassFromString(@"CCUITimerShortcut") alloc] init];
		_identifiersToModules[@"com.apple.calculator"] = [[NSClassFromString(@"CCUICalculatorShortcut") alloc] init];
		_identifiersToModules[@"com.apple.camera"] = [[NSClassFromString(@"CCUICameraShortcut") alloc] init];
		if ([CCXSharedResources sharedInstance].flashlightSetting) {
			_identifiersToModules[@"com.a3tweaks.switch.flashlight"] = [CCXSharedResources sharedInstance].flashlightSetting;
		} else {
			_identifiersToModules[@"com.a3tweaks.switch.flashlight"] = [[NSClassFromString(@"CCUIFlashlightSetting") alloc] init];
		}
	}

	if (![self valueForKey:@"nativeSwitchModule"] && !self.hasLoadedModule) {
		self.hasLoadedModule = YES;
		if ([_identifiersToModules objectForKey:[[self valueForKey:@"button"] valueForKey:@"switchIdentifier"]]) {
			CCUIButtonModule *module = [_identifiersToModules objectForKey:[[self valueForKey:@"button"] valueForKey:@"switchIdentifier"]];
			module.delegate = self;
			[self setValue:module forKey:@"nativeSwitchModule"];
		}
	}

	%orig;
}

%new
-(void)buttonModule:(id)arg1 willExecuteSecondaryActionWithCompletionHandler:(/*^block*/id)arg2 {
	NSLog(@"MODULE WILL EXECUTE SECONDARY ACTION: %@", arg1);
	if ([NSClassFromString(@"SBUIIconForceTouchController") _isPeekingOrShowing]) {
		[NSClassFromString(@"SBUIIconForceTouchController") _dismissAnimated:YES withCompletionHandler:arg2];
	}
}

- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 primaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	if ([[[self valueForKey:@"button"] valueForKey:@"switchIdentifier"] isEqualToString:@"com.apple.mobiletimer"] || [[[self valueForKey:@"button"] valueForKey:@"switchIdentifier"] isEqualToString:@"com.rpetrich.flipcontrolcenter.clock"]) {

		if (!_identifiersToModules) {
			_identifiersToModules = [NSMutableDictionary new];
			_identifiersToModules[@"com.apple.mobiletimer"] = [[NSClassFromString(@"CCUITimerShortcut") alloc] init];
			_identifiersToModules[@"com.rpetrich.flipcontrolcenter.clock"] = [[NSClassFromString(@"CCUITimerShortcut") alloc] init];
			_identifiersToModules[@"com.apple.calculator"] = [[NSClassFromString(@"CCUICalculatorShortcut") alloc] init];
			_identifiersToModules[@"com.apple.camera"] = [[NSClassFromString(@"CCUICameraShortcut") alloc] init];
			if ([CCXSharedResources sharedInstance].flashlightSetting) {
				_identifiersToModules[@"com.a3tweaks.switch.flashlight"] = [CCXSharedResources sharedInstance].flashlightSetting;
			} else {
				_identifiersToModules[@"com.a3tweaks.switch.flashlight"] = [[NSClassFromString(@"CCUIFlashlightSetting") alloc] init];
			}
		}

		if (![self valueForKey:@"nativeSwitchModule"] && !self.hasLoadedModule) {
			self.hasLoadedModule = YES;
			if ([_identifiersToModules objectForKey:[[self valueForKey:@"button"] valueForKey:@"switchIdentifier"]]) {
				CCUIButtonModule *module = [_identifiersToModules objectForKey:[[self valueForKey:@"button"] valueForKey:@"switchIdentifier"]];
				module.delegate = self;
				[self setValue:module forKey:@"nativeSwitchModule"];
			}
		}


		if ([self valueForKey:@"nativeSwitchModule"]) {
			return [[NSClassFromString(@"SBUIActionPlatterViewController") alloc] initWithActions:[(CCUIButtonModule *)[self valueForKey:@"nativeSwitchModule"] buttonActions] gestureRecognizer:arg2];
		}
	}
	return %orig;
}

%new
-(void)buttonModuleStateDidChange:(id)arg1 {

}

%new
-(void)buttonModulePropertiesDidChange:(id)arg1 {

}

%new
-(id)controlCenterSystemAgent {
	return [CCXSharedResources controlCenterSystemAgent];
}
%end