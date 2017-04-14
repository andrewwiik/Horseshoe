#import "CCXMultiSliderSectionController.h"
#import "constants.h"

%subclass CCXMultiSliderSectionController : CCUIControlCenterSectionViewController
%property (nonatomic, retain) CCUIControlCenterSlider *slider;
%property (nonatomic, retain) UIView *toggleBackgroundView;
%property (nonatomic, retain) CCUIControlCenterButton *toggleButton;
%property (nonatomic, retain) NSString *enabledKey;
%property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
%property (nonatomic, retain) NSString *disabledKey;
%property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
%property (nonatomic, retain) NSArray *allSwitches;
%property (nonatomic, retain) NSString *settingsFile;
%property (nonatomic, retain) NSString *preferencesApplicationID;
%property (nonatomic, retain) NSString *notificationName;
%property (nonatomic, retain) NSMutableArray *sliders;
%property (nonatomic, retain) NSMutableDictionary *identifiersToSliders;
%property (nonatomic, retain) NSString *currentSliderIdentifier;
%property (nonatomic, retain) NSObject *currentSliderController;
%property (nonatomic, retain) NSTimer *valueUpdateTimer;

+ (Class)viewClass {
	return NSClassFromString(@"CCXMultiSliderSectionView");
}

- (id)init {
	CCXMultiSliderSectionController *orig = %orig;
	if (orig) {
		self.settingsFile = SETTINGS_PLIST;
		self.preferencesApplicationID = SETTINGS_BUNDLE_ID;
		self.notificationName = MULTISLIDER_SETTINGS_NOTIFICATION_NAME;
		self.enabledKey = SETTINGS_SLIDERS_ENABLED_KEY;
		self.disabledKey = SETTINGS_SLIDERS_DISABLED_KEY;

		NSDictionary *settings = nil;

		if (self.settingsFile) {
			if (self.preferencesApplicationID) {
				CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesApplicationID);
				CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
				if (keyList) {
					settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
				}
			} else {
				settings = [NSDictionary dictionaryWithContentsOfFile:self.settingsFile];
			}
		}

		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(reloadSliderSettings)
	                                             	 name:self.notificationName
	                                           	   object:nil];

		NSArray *originalEnabled = [settings objectForKey:self.enabledKey];
		NSArray *originalDisabled = [settings objectForKey:self.disabledKey];

		if (!originalEnabled || [originalEnabled count] == 0) {
			NSMutableArray *originalEnabledDefaults = [NSMutableArray new];
				[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.slider.volume"];
				[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.slider.brightness"];
			//originalEnabled = [originalEnabledDefaults copy];
			//self.enabledIdentifiers = originalEnabledDefaults;
			originalEnabled = [originalEnabledDefaults copy];
		}else {
			// self.enabledIdentifiers = [originalEnabled mutableCopy];
		}


		if (!self.disabledIdentifiers) {
			self.disabledIdentifiers = [NSMutableArray new];
		}
		if (!self.enabledIdentifiers) {
			self.enabledIdentifiers = [NSMutableArray new];
		}

		self.allSwitches = [(CCXSlidersPanel *)[NSClassFromString(@"CCXSlidersPanel") sharedInstance] sortedSliderIdentifiers];
		NSMutableArray *allIdentifiers = [self.allSwitches mutableCopy];
		for  (NSString *identifier in originalEnabled) {
			if ([allIdentifiers containsObject:identifier]) {
				[allIdentifiers removeObject:identifier];
				[self.disabledIdentifiers removeObject:identifier];
				[self.enabledIdentifiers addObject:identifier];
			} else {
				[self.enabledIdentifiers removeObject:identifier];
			}
		}
		for (NSString *identifier in originalDisabled) {
			if ([allIdentifiers containsObject:identifier]) {
				[allIdentifiers removeObject:identifier];
				[self.disabledIdentifiers addObject:identifier];
			} else {
				[self.disabledIdentifiers removeObject:identifier];
			}
		}

		self.sliders = [NSMutableArray new];
		self.identifiersToSliders = [NSMutableDictionary new];

		CCXSlidersPanel *panel = (CCXSlidersPanel *)[NSClassFromString(@"CCXSlidersPanel") sharedInstance];
		for (NSString *identifier in self.enabledIdentifiers) {
			CCXSliderObject *data = [panel sliderObjectForIdentifier:identifier];
			if (data.controllerClass) {
				NSObject *slider = [[data.controllerClass alloc] init];
				[self.sliders addObject:slider];
				[self.identifiersToSliders setObject:slider forKey:identifier];

			}
		}

		if ([self.enabledIdentifiers count] > 0) {
			self.currentSliderIdentifier = [self.enabledIdentifiers objectAtIndex:0];
		}
	}
	return orig;
}

- (void)viewDidLoad {
	%orig;
	//[self.brightnessSectionController viewDidLoad];
	self.slider = [[NSClassFromString(@"CCUIControlCenterSlider") alloc] init];
	[self.slider addTarget:self action:@selector(_sliderDidEndTracking:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
	[self.slider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
	[self.slider addTarget:self action:@selector(_sliderDidBeginTracking:) forControlEvents:UIControlEventTouchDown];

	
	self.toggleButton = [NSClassFromString(@"CCXSliderToggleButton")  smallCircularButtonWithSelectedColor:[UIColor clearColor]];
	//self.nightModeSection.text = [NSString stringWithFormat:@"Mode Théâtre:\nArrêt"];
	//self.nightModeSection.numberOfLines = 2;
	// self.toggleButton.selectedGlyphImage = self.volumeSlider.minimumValueImage;
	// self.toggleButton.glyphImage = self.brightnessSlider.minimumValueImage;
	[self.toggleButton addTarget:self action:@selector(_handleSliderToggle:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.toggleButton];


	// if (CFPreferencesGetAppBooleanValue((CFStringRef)@"HasPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL)) {
	// 	self.isCurrentlyShowingVolume = CFPreferencesGetAppBooleanValue((CFStringRef)@"VolumeIsPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL);
	// 	[self.slider setMaximumValueImage:self.isCurrentlyShowingVolume ? self.volumeSlider.maximumValueImage : self.brightnessSlider.maximumValueImage];
	// 	[self.slider _setValue:self.isCurrentlyShowingVolume ? self.volumeSectionController.volumeController.volumeValue : [self.brightnessSectionController _backlightLevel] andSendAction:NO];
	// }

	// self.toggleButton.selected = self.isCurrentlyShowingVolume ? NO : YES;

	// self.forceTouchGestureRecognizer = [[NSClassFromString(@"SBUIForceTouchGestureRecognizer") alloc] initWithTarget:self action:nil];
	// self.forceTouchGestureRecognizer.delegate = self;
	// self.forceTouchGestureRecognizer.cancelsTouchesInView = YES;
	// [self.toggleButton addGestureRecognizer:self.forceTouchGestureRecognizer];

	// self.iconForceTouchController = [[NSClassFromString(@"SBUIIconForceTouchController") alloc] init];
	// [self.iconForceTouchController setDataSource:self];
	// [self.iconForceTouchController setDelegate:self];
	// [self.iconForceTouchController startHandlingGestureRecognizer:self.forceTouchGestureRecognizer];
	// [NSClassFromString(@"SBUIIconForceTouchController") _addIconForceTouchController:self.iconForceTouchController];
	self.toggleBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	self.toggleBackgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
	[self.view addSubview:self.toggleBackgroundView];
	[self.view sendSubviewToBack:self.toggleBackgroundView];

	[self configureSlider];
	[self.view addSubview:self.slider];

	[self createValueUpdater];


}


%new
- (void)configureSlider {
	if (self.currentSliderIdentifier) {
		id<CCXSliderControllerDelegate> currentSlider = [self.identifiersToSliders objectForKey:self.currentSliderIdentifier];
		self.currentSliderController = (NSObject *)currentSlider;
		if (currentSlider) {
			self.slider.minimumValue = (float)[currentSlider minimumValue];
			self.slider.maximumValue = (float)[currentSlider maximumValue];
			if ([currentSlider usesCacheKey]) {
				[self.slider setMaximumValueImage:[[currentSlider maximumValueImage] ccuiAlphaOnlyImageForMaskImage] cacheKey:NSStringFromClass([self.currentSliderController class])];
			} else {
				[self.slider setMaximumValueImage:[currentSlider maximumValueImage]];
			}
			
			if ([self.enabledIdentifiers count] > 1) {
				NSInteger index = [self.enabledIdentifiers indexOfObject:self.currentSliderIdentifier];
				if (index >= [self.enabledIdentifiers count] - 1) {
					self.toggleButton.forcedGlyphImage = [(id<CCXSliderControllerDelegate>)[self.sliders objectAtIndex:0] minimumValueImage];
				} else {
					self.toggleButton.forcedGlyphImage = [(id<CCXSliderControllerDelegate>)[self.sliders objectAtIndex:index+1] minimumValueImage];
				}
			} else {
				self.toggleButton.forcedGlyphImage = [currentSlider minimumValueImage];
			}

			for (id<CCXSliderControllerDelegate> slider in self.sliders) {
				if ([[[slider class] sliderIdentifier] isEqualToString:self.currentSliderIdentifier]) {
					if ([slider respondsToSelector:@selector(sliderWillAppear:)]) {
						[slider sliderWillAppear:YES];
					}
				} else {
					if ([slider respondsToSelector:@selector(sliderDidDisappear:)]) {
						[slider sliderDidDisappear:YES];
					}
				}
			}

			[self.slider _setValue:[currentSlider currentValue] andSendAction:NO];
		}
	}
}

- (void)viewDidLayoutSubviews {
	CGFloat multiplier = 1;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		multiplier = 1;
	}
	//[self.brightnessSectionController viewDidLayoutSubviews];
	if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
		self.slider.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
		self.toggleButton.frame = CGRectMake(self.slider.frame.size.width-35,self.slider.center.y-self.slider.frame.size.height,35,35);
		self.toggleButton.center = CGPointMake(self.toggleButton.center.x,self.slider.center.y);
		self.slider.frame = CGRectMake(0,self.slider.frame.origin.y,self.slider.frame.size.width-self.toggleButton.frame.size.width-3,self.slider.frame.size.height);
	} else {
		self.slider.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
		self.toggleButton.frame = CGRectMake(0,self.slider.center.y-self.slider.frame.size.height,35,35);
		self.toggleButton.center = CGPointMake(self.toggleButton.center.x,self.slider.center.y);
		self.slider.frame = CGRectMake(self.toggleButton.frame.size.width+3,self.slider.frame.origin.y,self.slider.frame.size.width-self.toggleButton.frame.size.width-3,self.slider.frame.size.height);
	}

	[self updateValue];

}

- (void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate {
	%orig;
	//[self.brightnessSectionController setDelegate:delegate];
}

%new
- (void)_sliderDidBeginTracking:(CCUIControlCenterSlider *)slider {
	if (self.valueUpdateTimer) {
		[self.valueUpdateTimer invalidate];
		self.valueUpdateTimer = nil;
	}
	if (self.currentSliderController) {
		[(id<CCXSliderControllerDelegate>)self.currentSliderController sliderDidBeginTracking:self.slider];
		[(id<CCXSliderControllerDelegate>)self.currentSliderController setTracking:[self.slider isTracking]];
	}

	self.toggleButton.userInteractionEnabled = NO;

	// if (self.isCurrentlyShowingVolume) {
	// 	//[(CCUIControlCend evterSlider *)[self.volumeSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
	// 	[self.volumeSectionController _volumeSliderBeganChanging:slider];
	// } else {
	// 	//[(CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
	// 	[self.brightnessSectionController _sliderDidBeginTracking:slider];
	// }
}
%new
- (void)_sliderDidEndTracking:(CCUIControlCenterSlider *)slider {
	if (self.currentSliderController) {
		[(id<CCXSliderControllerDelegate>)self.currentSliderController sliderDidEndTracking:slider];
		[(id<CCXSliderControllerDelegate>)self.currentSliderController setTracking:[slider isTracking]];
	}

	self.toggleButton.userInteractionEnabled = YES;
	// if (self.isCurrentlyShowingVolume) {
	// 	//[(CCUIControlCenterSlider *)[self.volumeSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
	// 	[self.volumeSectionController _volumeSliderStoppedChanging:slider];
	// } else {
	// 	//[(CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
	// 	[self.brightnessSectionController _sliderDidEndTracking:slider];
	// }
	[self createValueUpdater];
}
%new
- (void)_sliderValueDidChange:(CCUIControlCenterSlider *)slider {
	if (self.currentSliderController) {
		[(id<CCXSliderControllerDelegate>)self.currentSliderController sliderValueDidChange:slider];
		[(id<CCXSliderControllerDelegate>)self.currentSliderController setTracking:[slider isTracking]];
	}
	// if (self.isCurrentlyShowingVolume) {
	// 	//[(CCUIControlCenterSlider *)[self.volumeSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
	// 	[self.volumeSectionController _volumeSliderValueChanged:slider];
	// } else {
	// 	//[(CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
	// 	[self.brightnessSectionController _sliderValueDidChange:slider];
	// }
}
%new
- (void)_handleSliderToggle:(CCXSliderToggleButton *)toggle {
	if (self.enabledIdentifiers) {
		if ([self.enabledIdentifiers count] > 1) {
			NSInteger index = [self.enabledIdentifiers indexOfObject:self.currentSliderIdentifier];
			if (index >= [self.enabledIdentifiers count] - 1) {
				self.currentSliderIdentifier = [self.enabledIdentifiers objectAtIndex:0];
			} else {
				self.currentSliderIdentifier = [self.enabledIdentifiers objectAtIndex:index+1];
			}
		}
	}

	[self configureSlider];
	[self createValueUpdater];
	//if (self.isCurrentlyShowingVolume != toggle.selected) {
		//self.isCurrentlyShowingVolume = toggle.selected;
		// self.isCurrentlyShowingVolume = toggle.selected ? NO : YES;
		// [self.slider setMaximumValueImage:self.isCurrentlyShowingVolume ? self.volumeSlider.maximumValueImage : self.brightnessSlider.maximumValueImage];
		// [self.slider _setValue:toggle.selected ? self.volumeSectionController.volumeController.volumeValue : [self.brightnessSectionController _backlightLevel] andSendAction:NO];
		// //self.isCurrentlyShowingVolume = toggle.selected;
	//}
}


/* 3D Touch Delegation */


// %new
// - (CGRect)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconViewFrameForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
// 	return [self.view convertRect:self.toggleButton.frame toCoordinateSpace:[[UIScreen mainScreen] fixedCoordinateSpace]];
// }

// %new
// - (NSInteger)iconForceTouchController:(SBUIIconForceTouchController *)arg1 layoutStyleForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
// 	return 0;
// }

// %new
// - (UIView *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 newIconViewCopyForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	
// 	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
// 	backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
// 	backgroundView.layer.cornerRadius = self.toggleButton.frame.size.height/2;
// 	backgroundView.clipsToBounds = YES;

// 	UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
// 	iconView.image = [self.isCurrentlyShowingVolume ? self.volumeSlider.minimumValueImage : self.brightnessSlider.minimumValueImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
// 	//iconView.layer.cornerRadius = ((UIImageView *)[self.view.emptyNowPlayingView valueForKey:@"_appIconImageView"]).layer.cornerRadius;
// 	//iconView.clipsToBounds = YES;
// 	iconView.tintColor = [UIColor blackColor];
// 	[backgroundView addSubview:iconView];
// 	iconView.translatesAutoresizingMaskIntoConstraints = NO;
// 	[backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:iconView
// 		                                                      attribute:NSLayoutAttributeCenterX
// 		                                                      relatedBy:NSLayoutRelationEqual
// 		                                                         toItem:backgroundView
// 		                                                      attribute:NSLayoutAttributeCenterX
// 		                                                     multiplier:1
// 		                                                       constant:0]];
// 	[backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:iconView
// 		                                                      attribute:NSLayoutAttributeCenterY
// 		                                                      relatedBy:NSLayoutRelationEqual
// 		                                                         toItem:backgroundView
// 		                                                      attribute:NSLayoutAttributeCenterY
// 		                                                     multiplier:1
// 		                                                       constant:0]];
// 	return backgroundView;

// }

// %new
// -(CGFloat)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconImageCornerRadiusForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
// 	return self.toggleButton.frame.size.height/2;
// }

// %new
// - (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 primaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
// 	NSMutableArray *actions = [NSMutableArray new];

//    // SBUIAction can be thought of as an UIApplicationShortcutItem
// 	NSString *volumeSubtitleText;
// 	NSString *brightnessSubtitleText;
// 	NSString *shouldUseDefaultSubtitleText;
// 	if (CFPreferencesGetAppBooleanValue((CFStringRef)@"HasPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL)) {
// 		if (CFPreferencesGetAppBooleanValue((CFStringRef)@"VolumeIsPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL)) {
// 			volumeSubtitleText = @"Enabled";
// 			brightnessSubtitleText = nil;
// 			shouldUseDefaultSubtitleText = nil;
// 		} else {
// 			volumeSubtitleText = nil;
// 			brightnessSubtitleText =  @"Enabled";
// 			shouldUseDefaultSubtitleText = nil;
// 		}
// 	} else {
// 		volumeSubtitleText = nil;
// 		brightnessSubtitleText =  nil;
// 		shouldUseDefaultSubtitleText = @"Enabled";
// 	}
//    SBUIAction *volumeSlider = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Use Volume Slider" subtitle:volumeSubtitleText image:self.volumeSlider.maximumValueImage handler:^(void) {
//        CFPreferencesSetAppValue((CFStringRef)@"HasPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:YES], CFSTR("com.atwiiks.horseshoe"));
//        CFPreferencesSetAppValue ((CFStringRef)@"VolumeIsPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:YES], CFSTR("com.atwiiks.horseshoe"));
//        [self.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
//    }];
//    SBUIAction *brightnessSlider = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Use Brightness Slider" subtitle:brightnessSubtitleText image:self.brightnessSlider.maximumValueImage handler:^(void) {
//         CFPreferencesSetAppValue((CFStringRef)@"HasPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:YES], CFSTR("com.atwiiks.horseshoe"));
//        CFPreferencesSetAppValue ((CFStringRef)@"VolumeIsPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:NO], CFSTR("com.atwiiks.horseshoe"));
//         [self.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
//        //[[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil]; // this must be called to dismiss the 3D Touch Menu
//    }];
//    SBUIAction *useDefaultSlider = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"No Default Slider" subtitle:shouldUseDefaultSubtitleText image:nil handler:^(void) {
//        CFPreferencesSetAppValue((CFStringRef)@"HasPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:NO], CFSTR("com.atwiiks.horseshoe"));
//         [self.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
//        //[[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil]; // this must be called to dismiss the 3D Touch Menu
//    }];
//    [actions addObject:useDefaultSlider];
//    [actions addObject:brightnessSlider];
//    [actions addObject:volumeSlider];

// 	return [[NSClassFromString(@"SBUIActionPlatterViewController") alloc] initWithActions:[actions copy] gestureRecognizer:arg2];
// }

// %new
// - (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 secondaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
// 	return nil;
// }

// %new
// - (BOOL)iconForceTouchController:(SBUIIconForceTouchController *)arg1 shouldUseSecureWindowForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
// 	return YES;
// }

// - (void)controlCenterWillPresent {
// 	%orig;
// 	self.toggleButton.selected = self.isCurrentlyShowingVolume ? NO : YES;
// 	if (self.slider && self.volumeSectionController && self.brightnessSectionController) {
// 		if (CFPreferencesGetAppBooleanValue((CFStringRef)@"HasPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL)) {
// 			self.isCurrentlyShowingVolume = CFPreferencesGetAppBooleanValue((CFStringRef)@"VolumeIsPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL);
// 			[self.slider setMaximumValueImage:self.isCurrentlyShowingVolume ? self.volumeSlider.maximumValueImage : self.brightnessSlider.maximumValueImage];
// 			[self.slider _setValue:self.isCurrentlyShowingVolume ? self.volumeSectionController.volumeController.volumeValue : [self.brightnessSectionController _backlightLevel] andSendAction:NO];
// 		}
// 	}
// }

%new
+ (NSString *)sectionIdentifier {
	return @"com.atwiiks.controlcenterx.multi-slider";
}
%new
+ (NSString *)sectionName {
	return @"Multi-Slider";
}
%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Sliders_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
+ (Class)settingsControllerClass {
	return NSClassFromString(@"CCXMultiSliderSettingsViewController");
}

-(void)controlCenterDidDismiss {
	%orig;
	if (self.valueUpdateTimer) {
		[self.valueUpdateTimer invalidate];
		self.valueUpdateTimer = nil;
	}

	for (id<CCXSliderControllerDelegate> slider in self.sliders) {
		if ([slider respondsToSelector:@selector(sliderDidDisappear:)]) {
			[slider sliderDidDisappear:YES];
		}
	}
	//[self.volumeHUDController setVolumeHUDEnabled:YES forCategory:@"Audio/Video"];
}

- (void)controlCenterWillPresent {
	%orig;
	if (self.currentSliderIdentifier) {
		for (id<CCXSliderControllerDelegate> slider in self.sliders) {
			if ([[[slider class] sliderIdentifier] isEqualToString:self.currentSliderIdentifier]) {
				if ([slider respondsToSelector:@selector(sliderWillAppear:)]) {
					[slider sliderWillAppear:YES];
				}
			} else {
				if ([slider respondsToSelector:@selector(sliderDidDisappear:)]) {
					[slider sliderDidDisappear:YES];
				}
			}
		}
		[self createValueUpdater];
	}
}

%new
- (void)createValueUpdater {
	if (self.valueUpdateTimer) {
		[self.valueUpdateTimer invalidate];
		self.valueUpdateTimer = nil;
	}

	self.valueUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
    														 target:self
    													   selector:@selector(updateValue)
    													   userInfo:nil
    														repeats:YES];
}

%new
- (void)updateValue {
	if (self.currentSliderController) {
		[self.slider _setValue:[(id<CCXSliderControllerDelegate>)self.currentSliderController currentValue] andSendAction:NO];
	}
}

%new
- (void)reloadSliderSettings {

	if (self.valueUpdateTimer) {
		[self.valueUpdateTimer invalidate];
		self.valueUpdateTimer = nil;
	}

	self.disabledIdentifiers = [NSMutableArray new];
	self.enabledIdentifiers = [NSMutableArray new];
	
	NSDictionary *settings = nil;

	if (self.settingsFile) {
			if (self.preferencesApplicationID) {
				CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesApplicationID);
				CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
				if (keyList) {
					settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
				}
			} else {
				settings = [NSDictionary dictionaryWithContentsOfFile:self.settingsFile];
			}
		}

		NSArray *originalEnabled = [settings objectForKey:self.enabledKey];
		NSArray *originalDisabled = [settings objectForKey:self.disabledKey];

		if (!originalEnabled || [originalEnabled count] == 0) {
			NSMutableArray *originalEnabledDefaults = [NSMutableArray new];
				[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.slider.volume"];
				[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.slider.brightness"];
			//originalEnabled = [originalEnabledDefaults copy];
			//self.enabledIdentifiers = originalEnabledDefaults;
			originalEnabled = [originalEnabledDefaults copy];
		}else {
			// self.enabledIdentifiers = [originalEnabled mutableCopy];
		}


		if (!self.disabledIdentifiers) {
			self.disabledIdentifiers = [NSMutableArray new];
		}
		if (!self.enabledIdentifiers) {
			self.enabledIdentifiers = [NSMutableArray new];
		}

		self.allSwitches = [(CCXSlidersPanel *)[NSClassFromString(@"CCXSlidersPanel") sharedInstance] sortedSliderIdentifiers];
		NSMutableArray *allIdentifiers = [self.allSwitches mutableCopy];
		for  (NSString *identifier in originalEnabled) {
			if ([allIdentifiers containsObject:identifier]) {
				[allIdentifiers removeObject:identifier];
				[self.disabledIdentifiers removeObject:identifier];
				[self.enabledIdentifiers addObject:identifier];
			} else {
				[self.enabledIdentifiers removeObject:identifier];
			}
		}
		for (NSString *identifier in originalDisabled) {
			if ([allIdentifiers containsObject:identifier]) {
				[allIdentifiers removeObject:identifier];
				[self.disabledIdentifiers addObject:identifier];
			} else {
				[self.disabledIdentifiers removeObject:identifier];
			}
		}

		if (!self.sliders) {
			self.sliders = [NSMutableArray new];
		}

		if (!self.identifiersToSliders) {
			self.identifiersToSliders = [NSMutableDictionary new];
		}

		NSMutableArray *newSlidersArray = [NSMutableArray new];
		NSMutableDictionary *newSlidersDictionary = [NSMutableDictionary new];

		CCXSlidersPanel *panel = (CCXSlidersPanel *)[NSClassFromString(@"CCXSlidersPanel") sharedInstance];

		BOOL stillHasCurrentSlider = NO;
		if (self.currentSliderIdentifier) {
			stillHasCurrentSlider = [self.enabledIdentifiers containsObject:self.currentSliderIdentifier];
		}
		for (NSString *identifier in self.enabledIdentifiers) {
			CCXSliderObject *data = [panel sliderObjectForIdentifier:identifier];
			if (data.controllerClass) {
				if (![self.identifiersToSliders objectForKey:identifier]) {
					[newSlidersDictionary setObject:[[data.controllerClass alloc] init] forKey:identifier];
				} else {
					[newSlidersDictionary setObject:[self.identifiersToSliders objectForKey:identifier] forKey:identifier];
				}

				[newSlidersArray addObject:[newSlidersDictionary objectForKey:identifier]];
			}
		}

		self.sliders = newSlidersArray;
		self.identifiersToSliders = newSlidersDictionary;


		if (!stillHasCurrentSlider) {
			if ([self.enabledIdentifiers count] > 0) {
				self.currentSliderIdentifier = [self.enabledIdentifiers objectAtIndex:0];
			}
		}

		[self configureSlider];
		[self createValueUpdater];
}

%end

// 0x8cd675a844024379

