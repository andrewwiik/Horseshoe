#import "CCXVolumeSectionController.h"

%subclass CCXVolumeSectionController : CCUIControlCenterSectionViewController
%property (nonatomic, retain) CCUIControlCenterSlider *slider;
%property (nonatomic, retain) MPUMediaControlsVolumeView *volumeSectionController;
%property (nonatomic, retain) MPUVolumeHUDController *volumeHUDController;

+ (Class)viewClass {
	return NSClassFromString(@"CCXVolumeSectionView");
}

- (id)init {
	CCXVolumeSectionController *orig = %orig;
	if (orig) {
		self.volumeSectionController = [(MPUMediaControlsVolumeView *)[NSClassFromString(@"MPUMediaControlsVolumeView") alloc] initWithStyle:4];
		self.volumeHUDController = [[NSClassFromString(@"MPUVolumeHUDController") alloc] init];

	}
	return orig;
}

- (void)viewDidLoad {
	%orig;
	self.slider = (CCUIControlCenterSlider *)[self.volumeSectionController valueForKey:@"_slider"];
	[self.view addSubview:self.slider];
	CGRect frame = self.slider.frame;
	frame.size.width = self.view.frame.size.width;
	self.slider.frame = frame;
}

- (void)viewWillLayoutSubviews {
	%orig;
	CGRect frame = self.slider.frame;
	frame.size.width = self.view.frame.size.width;
	self.slider.frame = frame;
	[self.volumeHUDController setVolumeHUDEnabled:NO forCategory:@"Audio/Video"];
}

-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	CGRect frame = self.slider.frame;
	frame.size.width = self.view.frame.size.width;
	self.slider.frame = frame;
}

-(void)controlCenterDidDismiss {
	%orig;
	[self.volumeHUDController setVolumeHUDEnabled:YES forCategory:@"Audio/Video"];
}

%new
+ (NSString *)sectionIdentifier {
	return @"com.atwiiks.controlcenterx.volume-slider";
}
%new
+ (NSString *)sectionName {
	return @"Volume Slider";
}
%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"volume-maximum-value-image" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MediaPlayerUI.framework/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
+ (Class)settingsControllerClass {
	return nil;
}
%end