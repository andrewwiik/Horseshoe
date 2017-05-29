#import "CCXVolumeSliderController.h"

%subclass CCXVolumeSliderController : NSObject
%property (nonatomic, retain) MPUMediaControlsVolumeView *controller;
%property (nonatomic, retain) MPUVolumeHUDController *hudController;
- (id)init {
	CCXVolumeSliderController *orig = %orig;
	if (orig) {
		orig.controller = [(MPUMediaControlsVolumeView *)[NSClassFromString(@"MPUMediaControlsVolumeView") alloc] initWithStyle:4];
		orig.hudController =  [[NSClassFromString(@"MPUVolumeHUDController") alloc] init];
		[orig.controller layoutSubviews];
		//[orig.controller viewWillAppear:YES];
	}
	return orig;
}

// Slider Delegate Methods

%new
- (void)sliderValueDidChange:(id)slider {
	if (self.controller) {
		[(CCUIControlCenterSlider *)[self.controller valueForKey:@"_slider"] _setValue:[(CCUIControlCenterSlider *)slider value] andSendAction:NO];
		[self.controller _volumeSliderValueChanged:slider];

	}
}

%new
- (void)sliderDidBeginTracking:(id)slider {
	if (self.controller)
		[self.controller _volumeSliderBeganChanging:slider];
}

%new
- (void)sliderDidEndTracking:(id)slider {
	if (self.controller)
		[self.controller _volumeSliderStoppedChanging:slider];
}

%new
- (CGFloat)currentValue {
	if (self.controller) {
		if (self.controller.volumeController) {
			[self.controller.volumeController updateVolumeValue];
			return (CGFloat)[[NSNumber numberWithFloat:[self.controller.volumeController volumeValue]] floatValue];
		}
	}
	return 0;
}

%new
- (UIImage *)maximumValueImage {
	// if (self.controller) {
	// 	if ([self.controller valueForKey:@"_slider"]) {
	// 		return [[(CCUIControlCenterSlider *)[self.controller valueForKey:@"_slider"] maximumValueImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	// 	}
	// }
	return [[[UIImage imageNamed:@"volume-maximum-value-image" inBundle:[NSBundle bundleForClass:NSClassFromString(@"MPUMediaControlsVolumeView")]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] _flatImageWithColor:[UIColor whiteColor]];
}

%new
- (UIImage *)minimumValueImage {
	return [[UIImage imageNamed:@"volume-minimum-value-image-center" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MediaPlayerUI.framework/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
- (BOOL)usesCacheKey {
	return NO;
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
	if (self.hudController)
		[self.hudController setVolumeHUDEnabled:NO forCategory:@"Audio/Video"];
}

%new
- (void)sliderDidDisappear:(BOOL)didDisappear {
	if (self.hudController)
		[self.hudController setVolumeHUDEnabled:YES forCategory:@"Audio/Video"];
}

- (void)dealloc {
	if (self.hudController)
		[self.hudController setVolumeHUDEnabled:YES forCategory:@"Audio/Video"];
	%orig;
}

%new
+ (NSString *)sliderIdentifier {
	return @"com.atwiiks.controlcenterx.slider.volume";
}

%new
+ (NSString *)sliderName {
	return @"Volume";
}
%new
+ (UIImage *)sliderImage {
	return [[UIImage imageNamed:@"volume-maximum-value-image" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MediaPlayerUI.framework/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
%end