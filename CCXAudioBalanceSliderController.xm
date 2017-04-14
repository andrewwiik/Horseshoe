#import "CCXAudioBalanceSliderController.h"
#import <substrate.h>
#import <objc/runtime.h>
#include <mach/mach.h>
#include <libkern/OSCacheControl.h>
#include <stdbool.h>
#include <dlfcn.h>
#include <sys/sysctl.h>
#import <notify.h>


%subclass CCXAudioBalanceSliderController : NSObject
- (id)init {
	CCXAudioBalanceSliderController *orig = %orig;
	if (orig) {
		// orig.controller = [[NSClassFromString(@"CCUIBrightnessSectionController") alloc] init];
	}
	return orig;
}

// Slider Delegate Methods

// 0.285

//- 0.81

// .000293


/* Slider || MasterStereBalance
	0.25 || -0.85
	0.75 || 0.85
	0.60 || 0.65
	0.30 || -0.80
	0.40 || -0.65
	0.35 || -0.74
	0.95 || 0.97
	0.55 || 0.52

*/

%new
- (void)sliderValueDidChange:(id)slider {
	if (slider) {
		CGFloat value = (CGFloat)[(UISlider *)slider value];
		value *= 2;
		value -= 1;
		CFPreferencesSetAppValue(CFSTR("MasterStereoBalance"), (__bridge CFPropertyListRef)[NSNumber numberWithFloat:value], CFSTR("com.apple.Accessibility"));
		CFPreferencesSetAppValue(CFSTR("MasterStereoBalance"), (__bridge CFPropertyListRef)[NSNumber numberWithFloat:value], CFSTR("com.apple.coreaudio"));
		CFPreferencesAppSynchronize(CFSTR("com.apple.Accessibility"));
		CFPreferencesAppSynchronize(CFSTR("com.apple.coreaudio"));
	 	notify_post("com.apple.coreaudio.aqmeBalance");
	}
}

%new
- (void)sliderDidBeginTracking:(id)slider {
	return;
}

%new
- (void)sliderDidEndTracking:(id)slider {
	return;
}

%new
- (void)setTracking:(BOOL)tracking {

}

%new
- (CGFloat)currentValue {
	CGFloat value = (CGFloat)[(__bridge NSNumber *)CFPreferencesCopyAppValue(CFSTR("MasterStereoBalance"), CFSTR("com.apple.Accessibility")) floatValue];
	value *= 0.5;
	value += 0.5;
	return  value;
}

%new
- (NSNumber *)testValue {
	return  [NSNumber numberWithFloat:[(__bridge NSNumber *)CFPreferencesCopyAppValue(CFSTR("MasterStereoBalance"), CFSTR("com.apple.Accessibility")) floatValue]];
}

%new
- (BOOL)usesCacheKey {
	return YES;
}

%new
- (UIImage *)maximumValueImage {
	return [UIImage imageNamed:@"HorseshoeAudioBalanceRightSource" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]];
}

%new
- (UIImage *)minimumValueImage {
	return [[UIImage imageNamed:@"HorseshoeAudioBalanceLeftSource" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
- (CGFloat)maximumValue {
	return 1.0f;
}

%new
- (CGFloat)minimumValue {
	return 0.0f;
}

// Appearance Methods

%new
- (void)sliderWillAppear:(BOOL)willAppear {
	
}

%new
- (void)sliderDidDisappear:(BOOL)didDisappear {
	
}

%new
+ (NSString *)sliderIdentifier {
	return @"com.atwiiks.controlcenterx.slider.audio-balance";
}

%new
+ (NSString *)sliderName {
	return @"Audio Balance";
}

%new
+ (UIImage *)sliderImage {
	return [[UIImage imageNamed:@"AudioBalance_Slider" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
%end