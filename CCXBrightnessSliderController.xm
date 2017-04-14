#import "CCXBrightnessSliderController.h"
#import <substrate.h>

static float (*BKSDisplayBrightnessGetCurrent)() = 0;


%subclass CCXBrightnessSliderController : NSObject
%property (nonatomic, retain) CCUIBrightnessSectionController *controller;
- (id)init {
	CCXBrightnessSliderController *orig = %orig;
	if (orig) {
		orig.controller = [[NSClassFromString(@"CCUIBrightnessSectionController") alloc] init];
		[orig.controller viewDidLoad];
	}
	return orig;
}

// Slider Delegate Methods

%new
- (void)sliderValueDidChange:(id)slider {
	if (self.controller)
		[self.controller _sliderValueDidChange:slider];
}

%new
- (void)sliderDidBeginTracking:(id)slider {
	if (self.controller)
		[self.controller _sliderDidBeginTracking:slider];
}

%new
- (void)sliderDidEndTracking:(id)slider {
	if (self.controller)
		[self.controller _sliderDidEndTracking:slider];
}

%new
- (CGFloat)currentValue {
	return (CGFloat)[[NSNumber numberWithFloat:BKSDisplayBrightnessGetCurrent()] floatValue];
}

%new
- (BOOL)usesCacheKey {
	return NO;
}

%new
- (UIImage *)maximumValueImage {
	//return [self.controller ]
	return [[UIImage imageNamed:@"ControlCenterGlyphMoreBright" inBundle:[NSBundle bundleForClass:NSClassFromString(@"CCUIBrightnessSectionController")]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
- (UIImage *)minimumValueImage {
	return [[UIImage imageNamed:@"ControlCenterGlyphLessBright" inBundle:[NSBundle bundleForClass:NSClassFromString(@"CCUIBrightnessSectionController")]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
- (void)setTracking:(BOOL)tracking {
	if (self.controller) {
		[(CCUIControlCenterSlider *)[self.controller valueForKey:@"_slider"] setTracking:tracking];
	}
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
	return @"com.atwiiks.controlcenterx.slider.brightness";
}

%new
+ (NSString *)sliderName {
	return @"Brightness";
}

%new
+ (UIImage *)sliderImage {
	return [[UIImage imageNamed:@"ControlCenterGlyphMoreBright" inBundle:[NSBundle bundleForClass:NSClassFromString(@"CCUIBrightnessSectionController")]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
%end

%ctor {
	BKSDisplayBrightnessGetCurrent = (float (*)())MSFindSymbol(NULL, "_BKSDisplayBrightnessGetCurrent");
}