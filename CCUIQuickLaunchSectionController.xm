#import "headers.h"
#import "CCXSettingsFlipControlCenterViewController.h"
#import "CCXSettingsPolusViewController.h"

%hook CCUIQuickLaunchSectionController
%new
+ (NSString *)sectionIdentifier {
	return @"com.apple.controlcenter.quick-launch";
}

%new
+ (NSString *)sectionName {
	return @"Shortcuts";
}

%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Shortcuts_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
+ (UIViewController *)configuredSettingsController {
	if (NSClassFromString(@"FCCButtonsScrollView") || NSClassFromString(@"PLAppsController")) {
		if (NSClassFromString(@"PLAppsController")) {
			CCXSettingsPolusViewController *viewController = [[NSClassFromString(@"CCXSettingsPolusViewController") alloc] init];
			viewController.viewMode = PLViewModeBottomShelf;

			viewController.enabledSectionName = @"Shortcuts (Enabled)";
			viewController.disabledSectionName = @"Shortcuts (Disabled)";

			return viewController;
		} else {
			CCXSettingsFlipControlCenterViewController *viewController = [[NSClassFromString(@"CCXSettingsFlipControlCenterViewController") alloc] init];
			viewController.templateBundle = [[NSBundle alloc] initWithPath:@"/Library/Application Support/FlipControlCenter/TopShelf8.bundle"];
			viewController.settingsFile = @"/var/mobile/Library/Preferences/com.rpetrich.flipcontrolcenter.plist";
			viewController.preferencesApplicationID = @"com.rpetrich.flipcontrolcenter";
			viewController.notificationName = @"com.rpetrich.flipcontrolcenter.settingschanged";
			viewController.enabledKey = @"EnabledIdentifiersBottom";
			viewController.disabledKey = @"DisabledIdentifiersBottom";
			viewController.enabledSectionName = @"Shortcuts (Enabled)";
			viewController.disabledSectionName = @"Shortcuts (Disabled)";

			NSMutableArray *defaultEnabledIdentifiers = [NSMutableArray new];
			[defaultEnabledIdentifiers addObject:@"com.a3tweaks.switch.flashlight"];
			[defaultEnabledIdentifiers addObject:@"com.rpetrich.flipcontrolcenter.clock"];
			[defaultEnabledIdentifiers addObject:@"com.rpetrich.flipcontrolcenter.calculator"];
			[defaultEnabledIdentifiers addObject:@"com.rpetrich.flipcontrolcenter.camera"];
			[defaultEnabledIdentifiers addObject:@"com.a3tweaks.switch.settings"];
			[defaultEnabledIdentifiers addObject:@"com.a3tweaks.switch.respring"];

			NSMutableArray *defaultDisabledIdentifiers = [NSMutableArray new];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.airplane-mode"];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.wifi"];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.bluetooth"];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.do-not-disturb"];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.rotation-lock"];
			[defaultDisabledIdentifiers addObject:@"com.a3tweaks.switch.rotation"];


			viewController.defaultEnabledIdentifiers = defaultEnabledIdentifiers;
			viewController.defaultDisabledIdentifiers = defaultDisabledIdentifiers;
			return viewController;
		}
	} else return nil;
}

%new
+ (Class)controllerClass {
	return NSClassFromString(@"CCUIQuickLaunchSectionController");
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