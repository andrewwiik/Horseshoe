#import "headers.h"

%hook CCUIBrightnessSectionController
%new
+ (NSString *)sectionIdentifier {
	return @"com.apple.controlcenter.brightness";
}

%new
+ (NSString *)sectionName {
	return @"Brightness Slider";
}

%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"ControlCenterGlyphMoreBright" inBundle:[NSBundle bundleForClass:NSClassFromString(@"CCUIBrightnessSectionController")]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
+ (Class)settingsControllerClass {
	return nil;
}
%end