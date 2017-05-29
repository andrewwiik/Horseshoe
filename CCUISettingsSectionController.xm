#import "headers.h"
#import "CCXSettingsFlipControlCenterViewController.h"
#import "CCXSettingsPolusViewController.h"

%hook CCUISettingsSectionController
%new
+ (NSString *)sectionIdentifier {
	return @"com.apple.controlcenter.settings";
}

%new
+ (NSString *)sectionName {
	return @"Toggles";
}

%new
+ (UIViewController *)configuredSettingsController {
	if (NSClassFromString(@"FCCButtonsScrollView") || NSClassFromString(@"PLAppsController")) {
		if (NSClassFromString(@"PLAppsController")) {
			CCXSettingsPolusViewController *viewController = [[NSClassFromString(@"CCXSettingsPolusViewController") alloc] init];
			viewController.viewMode = PLViewModeTopShelf;

			viewController.enabledSectionName = @"Toggles (Enabled)";
			viewController.disabledSectionName = @"Toggles (Disabled)";

			return viewController;
		} else {
			CCXSettingsFlipControlCenterViewController *viewController = [[NSClassFromString(@"CCXSettingsFlipControlCenterViewController") alloc] init];
			viewController.templateBundle = [[NSBundle alloc] initWithPath:@"/Library/Application Support/FlipControlCenter/TopShelf8.bundle"];
			viewController.settingsFile = @"/var/mobile/Library/Preferences/com.rpetrich.flipcontrolcenter.plist";
			viewController.preferencesApplicationID = @"com.rpetrich.flipcontrolcenter";
			viewController.notificationName = @"com.rpetrich.flipcontrolcenter.settingschanged";
			viewController.enabledKey = @"EnabledIdentifiers";
			viewController.disabledKey = @"DisabledIdentifiers";
			viewController.enabledSectionName = @"Toggles (Enabled)";
			viewController.disabledSectionName = @"Toggles (Disabled)";

			NSMutableArray *defaultEnabledIdentifiers = [NSMutableArray new];
			[defaultEnabledIdentifiers addObject:@"com.a3tweaks.switch.airplane-mode"];
			[defaultEnabledIdentifiers addObject:@"com.a3tweaks.switch.wifi"];
			[defaultEnabledIdentifiers addObject:@"com.a3tweaks.switch.bluetooth"];
			[defaultEnabledIdentifiers addObject:@"com.a3tweaks.switch.do-not-disturb"];
			[defaultEnabledIdentifiers addObject:@"com.a3tweaks.switch.rotation-lock"];

			NSMutableArray *defaultDisabledIdentifiers = [NSMutableArray new];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.rotation"];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.flashlight"];
			[defaultDisabledIdentifiers addObject:@"com.rpetrich.flipcontrolcenter.clock"];
			[defaultDisabledIdentifiers addObject:@"com.rpetrich.flipcontrolcenter.calculator"];
			[defaultDisabledIdentifiers addObject:@"com.rpetrich.flipcontrolcenter.camera"];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.settings"];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.respring"];

			viewController.defaultEnabledIdentifiers = defaultEnabledIdentifiers;
			viewController.defaultDisabledIdentifiers = defaultDisabledIdentifiers;

			return viewController;
		}
	} else return nil;
}

%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Settings_Section" inBundle:[NSBundle bundleWithPath:@"/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
+ (Class)controllerClass {
	return NSClassFromString(@"CCUISettingsSectionController");
}
%new
+ (Class)settingsControllerClass {
	if (NSClassFromString(@"FCCButtonsScrollView") || NSClassFromString(@"PLAppsController")) {
		if (NSClassFromString(@"PLAppsController"))
			return NSClassFromString(@"CCXSettingsPolusViewController");
		else
			return NSClassFromString(@"CCXSettingsFlipControlCenterViewController");
	} else return nil;
}
%end