#import "CCXMainControlsPageViewController.h"
#import "constants.h"
#import <dlfcn.h>
#import "CCXSectionViewDelegate-Protocol.h"

%subclass CCXMainControlsPageViewController : CCUISystemControlsPageViewController <UINavigationControllerDelegate, CCUIControlCenterPageContentProviding, CCUIControlCenterSectionViewControllerDelegate>
%property (nonatomic, retain) CCXAirAndNightSectionController *airAndNightController;
%property (nonatomic, retain) CCXMiniMediaPlayerSectionController *miniMediaPlayerController;
%property (nonatomic, retain) CCXMultiSliderSectionController *volumeAndBrightnessController;
%property (nonatomic, retain) CCUIBrightnessSectionController *brightnessController;
%property (nonatomic, retain) LQDNightSectionController *noctisNightModeController;
%property (nonatomic, assign) BOOL isNoctisInstalled;
%property (nonatomic, assign) CGFloat animationProgressValueReal;
%property (nonatomic, assign) NSInteger totalVisibleSections;
%property (nonatomic, retain) NSBundle *templateBundle;
%property (nonatomic, retain) NSString *enabledKey;
%property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
%property (nonatomic, retain) NSString *disabledKey;
%property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
%property (nonatomic, retain) NSMutableArray *allIdentifiers;
%property (nonatomic, retain) NSArray *allSwitches;
%property (nonatomic, retain) NSString *settingsFile;
%property (nonatomic, retain) NSString *preferencesApplicationID;
%property (nonatomic, retain) NSString *notificationName;
%property (nonatomic, retain) UIImageView *backgroundCutoutView;
%property (nonatomic, retain) UIImageView *maskingView;
%property (nonatomic, retain) NSDictionary *settings;

%new
- (CGFloat)animationProgressValue {
	return self.animationProgressValueReal;
}

%new
- (void)setAnimationProgressValue:(CGFloat)value {
	self.animationProgressValueReal = value;
	[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
}
%new
- (BOOL)wantsVisible {
	return YES;
}
%new
- (CGFloat)requestedPageHeightForHeight:(CGFloat)height {
	return height+40;
}
- (void)loadView {
	%orig;

	if (NSClassFromString(@"LQDNightSectionController")) {
		self.isNoctisInstalled = YES;
	}

	self.settingsFile = SETTINGS_PLIST;
	self.preferencesApplicationID = SETTINGS_BUNDLE_ID;
	self.notificationName = SETTINGS_NOTIFICATION_NAME;
	self.enabledKey = SETTINGS_SECTIONS_ENABLED_KEY;
	self.disabledKey = SETTINGS_SECTIONS_DISABLED_KEY;
	if (self.settingsFile) {
		if (self.preferencesApplicationID) {
			CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesApplicationID);
			CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
			if (keyList) {
				self.settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
			}
		} else {
			self.settings = [NSDictionary dictionaryWithContentsOfFile:self.settingsFile];
		}
	}
	self.allSwitches = [(CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance] sortedSectionIdentifiers];
	NSArray *originalEnabled = [self.settings objectForKey:self.enabledKey];
	//NSArray *originalDisabled = [self.settings objectForKey:self.disabledKey];

	if (!originalEnabled || [originalEnabled count] == 0) {
		NSMutableArray *originalEnabledDefaults = [NSMutableArray new];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[originalEnabledDefaults addObject:@"com.apple.controlcenter.settings"];
			[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.multi-slider"];
			[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.air-night"];
			[originalEnabledDefaults addObject:@"com.apple.controlcenter.quick-launch"];
		} else {
			[originalEnabledDefaults addObject:@"com.apple.controlcenter.settings"];
			[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.mini-media-player"];
			[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.multi-slider"];
			[originalEnabledDefaults addObject:@"com.atwiiks.controlcenterx.air-night"];
			[originalEnabledDefaults addObject:@"com.apple.controlcenter.quick-launch"];
		}
		self.enabledIdentifiers = originalEnabledDefaults;
	}else {
		self.enabledIdentifiers = [originalEnabled mutableCopy];
	}

	self.disabledIdentifiers = [NSMutableArray new];


	[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(reloadSectionSettings)
	                                             	 name:self.notificationName
	                                           	   object:nil];

	CCXSectionsPanel *panel = (CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance];

	self.airAndNightController = [[NSClassFromString(@"CCXAirAndNightSectionController") alloc] init];
	self.airAndNightController.delegate = self;
	[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.airAndNightController];

	self.miniMediaPlayerController = [[NSClassFromString(@"CCXMiniMediaPlayerSectionController") alloc] init];
	self.miniMediaPlayerController.delegate = self;
	[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.miniMediaPlayerController];

	self.volumeAndBrightnessController = [[NSClassFromString(@"CCXMultiSliderSectionController") alloc] init];
	self.volumeAndBrightnessController.delegate = self;
	[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.volumeAndBrightnessController];

	if (self.isNoctisInstalled) {
		self.noctisNightModeController = [[NSClassFromString(@"LQDNightSectionController") alloc] init];
		[self.noctisNightModeController setDelegate:self];
		[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.noctisNightModeController];
	}

	self.brightnessController = (CCUIBrightnessSectionController *)[self valueForKey:@"_brightnessSection"];
	self.brightnessController.delegate = self;

	NSMutableArray *switchIdentifiers = [self.allSwitches mutableCopy];
	// for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
	// 	if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
	// 		if ([self.enabledIdentifiers containsObject:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
	// 			[switchIdentifiers removeObject:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]];
	// 		}
	// 	}
	// }


	NSLog(@"SWITCHES: %@", switchIdentifiers);
	for (NSString *identifier in switchIdentifiers) {
		BOOL makeController = YES;
		CCXSectionObject *sectionData = [panel sectionObjectForIdentifier:identifier];
		if (sectionData) {
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([viewController class] == sectionData.controllerClass) {
					makeController = NO;
				}
			}
		}
		if (makeController) {
			id<CCUIControlCenterPageContentProviding> sectionController = [[sectionData.controllerClass alloc] init];
			sectionController.delegate = (id<CCUIControlCenterPageContentViewControllerDelegate>)self;
			[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:sectionController];
			
		}
		// [self.allIdentifiers addObject:identifier];
	}

	//NSMutableArray *switchIdentifiers = [self.allSwitches mutableCopy];
	self.allIdentifiers = [NSMutableArray new];
	for (NSString *identifier in self.enabledIdentifiers) {
		[self.allIdentifiers addObject:identifier];
	}
	for (NSString *identifier in self.disabledIdentifiers) {
		if (![self.allIdentifiers containsObject:identifier]) {
			[self.allIdentifiers addObject:identifier];
		}
	}
	for (NSString *identifier in switchIdentifiers) {
		if (![self.allIdentifiers containsObject:identifier]) {
			[self.allIdentifiers addObject:identifier];
		}
	}


	[self reloadSections];
	[self _updateColumns];
}

%new
- (void)reloadSectionSettings {
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
	self.allSwitches = [(CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance] sortedSectionIdentifiers];
	NSArray *originalEnabled = [settings objectForKey:self.enabledKey];
	self.enabledIdentifiers = [originalEnabled mutableCopy];

	NSMutableArray *switchIdentifiers = [self.allSwitches mutableCopy];
	self.allIdentifiers = [NSMutableArray new];
	for (NSString *identifier in self.enabledIdentifiers) {
		[self.allIdentifiers addObject:identifier];
	}
	for (NSString *identifier in self.disabledIdentifiers) {
		if (![self.allIdentifiers containsObject:identifier]) {
			[self.allIdentifiers addObject:identifier];
		}
	}
	for (NSString *identifier in switchIdentifiers) {
		if (![self.allIdentifiers containsObject:identifier]) {
			[self.allIdentifiers addObject:identifier];
		}
	}

	[self _updateAllSectionVisibilityAnimated:NO];
}

-(void)_updateAllSectionVisibilityAnimated:(BOOL)arg1 {
	%orig;
	[self reloadSections];
	[self updateCutoutView];
}

%new
- (void)updateCutoutView {
	[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
}

-(void)_updateSectionVisibility:(id)arg1 animated:(BOOL)arg2 {
	%orig;
	((UIViewController *)[self valueForKey:@"_auxillaryAirStuffSection"]).view.hidden = YES;
	if (self.isNoctisInstalled)
	self.lqdNightSectionController.view.hidden = YES;
	[self updateCutoutView];


}

- (void)_updateStackViewMarginsAndSpacing {
	%orig;
	CGFloat totalSectionsHeight = 0;
	int numberOfSections = 0;
	NSMutableArray *columnStackViews = [[self valueForKey:@"_columnStackViews"] mutableCopy];
	if ([columnStackViews count] == 1) {
		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
			if (viewController.view.hidden == NO) {
				totalSectionsHeight += [viewController.view intrinsicContentSize].height;
				numberOfSections++;
			}
		}

		if (numberOfSections > 1) {
			CGFloat stackViewHeight = ((UIStackView *)[columnStackViews objectAtIndex:0]).frame.size.height;
			((UIStackView *)[columnStackViews objectAtIndex:0]).spacing = (stackViewHeight - totalSectionsHeight)/(numberOfSections - 1);
		}
	}
}

-(UIEdgeInsets)contentInsets {
	return UIEdgeInsetsMake(0,0,0,0);
}

- (void)setLayoutStyle:(NSInteger)style {
	%orig;
	[self.volumeAndBrightnessController.view setLayoutStyle:style];
	[self.brightnessController.view setLayoutStyle:style];
	[self updateCutoutView];
}

- (void)_updateColumns {
	%orig;
	[self reloadSections];

	//[self _updateAllSectionVisibilityAnimated:NO];
}
- (void)_updateSectionViews {
	%orig;

	[self updateCutoutView];
}


%new
- (void)reloadSections {

	NSMutableArray *columnStackViews = [[self valueForKey:@"_columnStackViews"] mutableCopy];

	NSInteger leftGroup = 0;
	NSInteger centerGroup = 0;
	NSInteger rightGroup = 0;
	NSInteger mediaGroup = 0;
	NSInteger spacingGroup = 0;

	CGFloat totalSectionsHeight = 0;
	NSInteger numberOfSections = 0;

	if ([columnStackViews count] == 1) {
		leftGroup = 0;
		centerGroup = 0;
		rightGroup = 0;
		mediaGroup = 0; 
		spacingGroup = 0;
	} else if ([columnStackViews count] == 2) {
		leftGroup = 0;
		centerGroup = 0;
		rightGroup = 0;
		mediaGroup = 1;
		spacingGroup = 0;
	} else if ([columnStackViews count] == 3) {
		leftGroup = 0;
		centerGroup = 1;
		rightGroup = 2;
		mediaGroup = 1;
		spacingGroup = 1;

	}

	for (int x = 0; x < [self.allIdentifiers count]; x++) {

		NSString *currentSectionIdentifier = self.allIdentifiers[x];

		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {

			BOOL shouldShow = NO;
			BOOL shouldSet = NO;

			NSString *sectionIdentifier = @"";

			if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
				sectionIdentifier = [(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier];
				if ([sectionIdentifier isEqualToString:currentSectionIdentifier]) {
					if ([self.enabledIdentifiers containsObject:currentSectionIdentifier]) {
						shouldShow = YES;
						shouldSet = YES;
						//skipChecks = NO;
					} else {
						shouldSet = YES;
					}
				}
			} else {
				shouldSet = YES;
			}
		
			if (shouldSet) {
				if ([currentSectionIdentifier isEqualToString:@"com.apple.controlcenterx.mini-media-player"]) {
					[(UIStackView *)[columnStackViews objectAtIndex:mediaGroup] addArrangedSubview:viewController.view];
					if (mediaGroup != spacingGroup) {
						numberOfSections--;
						totalSectionsHeight -= [viewController.view intrinsicContentSize].height;
						shouldShow = YES;
					}
				} else if ([currentSectionIdentifier isEqualToString:@"com.apple.controlcenter.settings"]) {
					[(UIStackView *)[columnStackViews objectAtIndex:leftGroup] addArrangedSubview:viewController.view];
					if (leftGroup != spacingGroup) {
						numberOfSections--;
						totalSectionsHeight -= [viewController.view intrinsicContentSize].height;
						shouldShow = YES;
					}
				} else if ([currentSectionIdentifier isEqualToString:@"com.apple.controlcenter.quick-launch"]) {
					[(UIStackView *)[columnStackViews objectAtIndex:rightGroup] addArrangedSubview:viewController.view];
					if (rightGroup != spacingGroup) {
						numberOfSections--;
						totalSectionsHeight -= [viewController.view intrinsicContentSize].height;
						shouldShow = YES;
					}
				} else {
					[(UIStackView *)[columnStackViews objectAtIndex:centerGroup] addArrangedSubview:viewController.view];
				}
			}

			if (viewController.view) {
				if ([viewController.view respondsToSelector:@selector(setAxis:)]) {
					[(id<CCXSectionViewDelegate>)viewController.view setAxis:self.layoutStyle];
				}
				if ([viewController.view respondsToSelector:@selector(setLayoutStyle:)]) {
					[(id<CCXSectionViewDelegate>)viewController.view setLayoutStyle:self.layoutStyle];
				}
			}

			if (shouldShow) {
				totalSectionsHeight += [viewController.view intrinsicContentSize].height;
				numberOfSections++;
				[self addChildViewController:viewController];
				[viewController didMoveToParentViewController:self];
			} else {
				if (shouldSet) {
					[viewController removeFromParentViewController];
				}
			}

			if (shouldSet) {
				viewController.view.hidden = shouldShow ? NO : YES;
			}
		}
	}

	self.totalVisibleSections = numberOfSections;
	if (numberOfSections > 1) {
		CGFloat stackViewHeight = ((UIStackView *)[columnStackViews objectAtIndex:spacingGroup]).frame.size.height;
		((UIStackView *)[columnStackViews objectAtIndex:spacingGroup]).spacing = (stackViewHeight - totalSectionsHeight)/numberOfSections;
	}
}


// 	if ([columnStackViews count] == 1) {
// 		NSMutableArray *processedViewControllers = [NSMutableArray new];
// 		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
// 			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
// 			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
// 					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
// 						[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:viewController.view];
// 						viewController.view.hidden = NO;
// 						[processedViewControllers addObject:viewController];
// 						totalSectionsHeight += [viewController.view intrinsicContentSize].height;
// 						numberOfSections++;
// 						if ([viewController respondsToSelector:@selector(setAxis:)]) {
// 							[(id<CCXSectionControllerDelegate>)viewController setAxis:0];
// 						}
// 					}
// 				}
// 			}
// 		}
// 		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
// 			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
// 			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
// 					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
// 						viewController.view.hidden = YES;
// 						[processedViewControllers addObject:viewController];
// 					}
// 				}
// 			}
// 		}
// 		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 			if (![processedViewControllers containsObject:viewController]) {
// 				viewController.view.hidden = YES;
// 			}
// 		}

// 		if (numberOfSections > 1) {
// 			CGFloat stackViewHeight = ((UIStackView *)[columnStackViews objectAtIndex:0]).frame.size.height;
// 			((UIStackView *)[columnStackViews objectAtIndex:0]).spacing = (stackViewHeight - totalSectionsHeight)/numberOfSections;
// 		}
// 	} else if ([columnStackViews count] == 2) {
// 				NSMutableArray *processedViewControllers = [NSMutableArray new];
// 		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
// 			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
// 			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
// 					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
// 						if (![currentSectionIdentifier isEqualToString:@"com.apple.controlcenterx.mini-media-player"]) {
// 							[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:viewController.view];
// 							viewController.view.hidden = NO;
// 							[processedViewControllers addObject:viewController];
// 							totalSectionsHeight += [viewController.view intrinsicContentSize].height;
// 							numberOfSections++;
// 						}
// 					}
// 				}
// 			}
// 		}
// 		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
// 			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
// 			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
// 					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
// 						if (![currentSectionIdentifier isEqualToString:@"com.apple.controlcenterx.mini-media-player"]) {
// 							[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:viewController.view];
// 							viewController.view.hidden = YES;
// 							[processedViewControllers addObject:viewController];
// 						}
// 					}
// 				}
// 			}
// 		}
// 		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 			if (![processedViewControllers containsObject:viewController]) {
// 				viewController.view.hidden = YES;
// 			}
// 		}

// 		[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.miniMediaPlayerController.view];
// 		((UIStackView *)[columnStackViews objectAtIndex:1]).spacing = 0;
// 		self.miniMediaPlayerController.view.hidden = NO;
// 		if (numberOfSections > 1) {
// 			CGFloat stackViewHeight = ((UIStackView *)[columnStackViews objectAtIndex:0]).frame.size.height;
// 			((UIStackView *)[columnStackViews objectAtIndex:0]).spacing = (stackViewHeight - totalSectionsHeight)/numberOfSections;
// 		}
// 	} else if ([columnStackViews count] == 3) {

// 		NSMutableArray *processedViewControllers = [NSMutableArray new];

// 		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
// 		[(UIStackView *)[columnStackViews objectAtIndex:2] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		
// 		[processedViewControllers addObject:[self valueForKey:@"_settingsSection"]];
// 		[processedViewControllers addObject:[self valueForKey:@"_quickLaunchSection"]];

// 		((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view.hidden = NO;
// 		((CCUISettingsSectionController *)[self valueForKey:@"_quickLaunchSection"]).view.hidden = NO;

// 		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
// 			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
// 			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
// 					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
// 						if (![currentSectionIdentifier isEqualToString:@"com.apple.controlcenter.settings"] && ![currentSectionIdentifier isEqualToString:@"com.apple.controlcenter.quick-launch"]) {
// 							[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:viewController.view];
// 							viewController.view.hidden = NO;
// 							[processedViewControllers addObject:viewController];
// 							if ([viewController respondsToSelector:@selector(setAxis:)]) {
// 								[(id<CCXSectionControllerDelegate>)viewController setAxis:1];
// 							}
// 						}
// 					}
// 				}
// 			}
// 		}
// 		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
// 			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
// 			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
// 					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
// 						if (![currentSectionIdentifier isEqualToString:@"com.apple.controlcenter.settings"] && ![currentSectionIdentifier isEqualToString:@"com.apple.controlcenter.quick-launch"]) {
// 							viewController.view.hidden = YES;
// 							[processedViewControllers addObject:viewController];
// 						}
// 					}
// 				}
// 			}
// 		}
// 		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
// 			if (![processedViewControllers containsObject:viewController]) {
// 				viewController.view.hidden = YES;
// 			}
// 		}
// 	//	self.airStuffController.view.mode = 0;
// 	}

// 	((UIViewController *)[self valueForKey:@"_auxillaryAirStuffSection"]).view.hidden = YES;
// 	if (self.isNoctisInstalled)
// 	self.lqdNightSectionController.view.hidden = YES;
// }

- (void)_dismissButtonActionPlatterWithCompletion:(id)arg1 {
	if ([NSClassFromString(@"SBUIIconForceTouchViewController") _isPeekingOrShowing]) {
		[NSClassFromString(@"SBUIIconForceTouchViewController") _dismissAnimated:YES withCompletionHandler:arg1];
	}
	%orig;
}

%new
- (void)pushingSettingsController {
	//[self presentViewController:self.settingsViewController animated:YES completion:nil];
	// self.view.hidden = YES;
	// [self.navigationController pushViewController:self.settingsViewController animated:YES];
}
%end

%ctor {
	dlopen("/Library/MobileSubstrate/DynamicLibraries/Noctis.dylib", RTLD_NOW);
	%init;
}