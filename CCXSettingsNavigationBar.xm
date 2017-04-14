#import "CCXSettingsNavigationBar.h"
#import "CCXSharedResources.h"
#import "Noctis.h"

%subclass CCXSettingsNavigationBar : UIView
%property (nonatomic, retain) UILabel *headerLabel;
%property (nonatomic, retain) CCXNoEffectsButton *rightButton;
%property (nonatomic, retain) CCXNoEffectsButton *doneButton;
%property (nonatomic, retain) CCXPunchOutView *separatorView;
%property (nonatomic, retain) UIImageView *iconView;
%property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;

- (id)initWithFrame:(CGRect)frame {
	self = %orig;
	if (self) {

		CCUIControlCenterVisualEffect *effect = [NSClassFromString(@"CCUIControlCenterVisualEffect")  _primaryRegularTextOnPlatterEffect];
    	_UIVisualEffectConfig *effectConfig = [effect effectConfig];
   		self.primaryEffectConfig = effectConfig.contentConfig;

		// Header Label

		self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.iconView.layer.cornerRadius = 2;
		self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.iconView];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView
		                                             attribute:NSLayoutAttributeWidth
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:20]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:20]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView
		                                             attribute:NSLayoutAttributeLeft
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeLeft
		                                             multiplier:1
		                                               constant:8]];

		self.headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.headerLabel.font = [[self class] headerFont];
		self.headerLabel.textColor = [UIColor whiteColor];
		self.headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.headerLabel];
		[self.primaryEffectConfig configureLayerView:self.headerLabel];

		if (NSClassFromString(@"LQDNightSectionController")) {
			//[self.layer setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)];
			//[self setSubstitutedBackgroundColor:[UIColor clearColor]];
			//[self setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)];
			//[self.textLabel setSubstitutedBackgroundColor:[UIColor clearColor]];
			[self.headerLabel setSubstitutedTextColor:[UIColor colorWithWhite:1 alpha:1]];
			[self.headerLabel setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)];
			[self.headerLabel.layer setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)];
		}

		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel
		                                             attribute:NSLayoutAttributeLeft
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.iconView
		                                             attribute:NSLayoutAttributeRight
		                                             multiplier:1
		                                               constant:8]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeHeight
		                                             multiplier:1
		                                               constant:0]];


		// Right Button
		self.rightButton = [NSClassFromString(@"CCXNoEffectsButton") capsuleButtonWithText:@"Back"];
		self.rightButton.font = [[self class] buttonFont];
		self.rightButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.rightButton];
		[self.rightButton removeTarget:nil 
                   action:NULL 
         forControlEvents:UIControlEventAllEvents]; 

		[self.rightButton addTarget:self action:@selector(showPreviousViewController) forControlEvents:UIControlEventTouchUpInside];

		[self.primaryEffectConfig configureLayerView:self.rightButton];

		if (NSClassFromString(@"LQDNightSectionController")) {
			[self.rightButton.layer setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)];
		}

		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton
		                                             attribute:NSLayoutAttributeRight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeRight
		                                             multiplier:1
		                                               constant:-9]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:18]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
		self.rightButton.alpha = 0;

		// Done Button

		self.doneButton = [NSClassFromString(@"CCXNoEffectsButton") capsuleButtonWithText:@"Done"];
		self.doneButton.font = [[self class] buttonFont];
		self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.doneButton];
		[self.doneButton removeTarget:nil 
                   action:NULL 
         forControlEvents:UIControlEventAllEvents]; 

		[self.doneButton addTarget:self action:@selector(closeSettingsPanel) forControlEvents:UIControlEventTouchUpInside];

		[self.primaryEffectConfig configureLayerView:self.doneButton];

		if (NSClassFromString(@"LQDNightSectionController")) {
			[self.doneButton.layer setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)];
		}

		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
		                                             attribute:NSLayoutAttributeRight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeRight
		                                             multiplier:1
		                                               constant:-9]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:18]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
		self.doneButton.alpha = 1;

		// Left Button

		// self.leftButton = [NSClassFromString(@"CCXNoEffectsButton") capsuleButtonWithText:@"Back"];
		// self.leftButton.font = [[self class] buttonFont];
		// self.leftButton.translatesAutoresizingMaskIntoConstraints = NO;
		// [self addSubview:self.leftButton];
		// [self.primaryEffectConfig configureLayerView:self.leftButton];

		// [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton
		//                                              attribute:NSLayoutAttributeLeft
		//                                              relatedBy:NSLayoutRelationEqual
		//                                                 toItem:self
		//                                              attribute:NSLayoutAttributeLeft
		//                                              multiplier:1
		//                                                constant:9]];
		// [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton
		//                                              attribute:NSLayoutAttributeHeight
		//                                              relatedBy:NSLayoutRelationEqual
		//                                                 toItem:nil
		//                                              attribute:NSLayoutAttributeNotAnAttribute
		//                                              multiplier:1
		//                                                constant:18]];
		// [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton
		//                                              attribute:NSLayoutAttributeCenterY
		//                                              relatedBy:NSLayoutRelationEqual
		//                                                 toItem:self
		//                                              attribute:NSLayoutAttributeCenterY
		//                                              multiplier:1
		//                                                constant:0]];

		// Seperator View

		self.separatorView = [[NSClassFromString(@"CCXPunchOutView") alloc] initWithFrame:CGRectZero];
		self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.separatorView];
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
		                                             attribute:NSLayoutAttributeTop
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeBottom
		                                             multiplier:1
		                                               constant:-0.5]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
		                                             attribute:NSLayoutAttributeWidth
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeWidth
		                                             multiplier:1
		                                               constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:0.5]];
	}
	return self;
}

- (void)layoutSubviews {
	%orig;
	if ([self.rightButton valueForKey:@"_backgroundFlatColorView"]) {
		[(UIView *)[self.rightButton valueForKey:@"_backgroundFlatColorView"] layer].cornerRadius = self.rightButton.frame.size.height/2;
	}
	[(UILabel *)[self.rightButton valueForKey:@"_label"] layer].filters = nil;
	[(UILabel *)[self.rightButton valueForKey:@"_alteredStateLabel"] layer].filters = nil;

	// if ([self.leftButton valueForKey:@"_backgroundFlatColorView"]) {
	// 	[(UIView *)[self.leftButton valueForKey:@"_backgroundFlatColorView"] layer].cornerRadius = self.leftButton.frame.size.height/2;
	// }
	// [(UILabel *)[self.leftButton valueForKey:@"_label"] layer].filters = nil;
	// [(UILabel *)[self.leftButton valueForKey:@"_alteredStateLabel"] layer].filters = nil;

}

%new
- (void)setHeaderText:(NSString *)text {
	if (self.headerLabel) {
		self.headerLabel.text = text;
		[self.headerLabel sizeToFit];
		[self setNeedsLayout];
	}
}

%new
- (void)setIconImage:(UIImage *)image {
	if (self.iconView) {
		self.iconView.image = image;
		[self setNeedsLayout];
	}
}

%new
- (void)setShowingBackButton:(BOOL)showingButton {
	if (self.rightButton) {
		if (showingButton) {
			self.rightButton.alpha = 1.0;
			if (self.doneButton) {
				self.doneButton.alpha = 0.0;
			}
		} else {
			self.rightButton.alpha = 0.0;
			if (self.doneButton) {
				self.doneButton.alpha = 1.0;
			}
		}
	}
}

%new
- (void)setIconColor:(UIColor *)color {
	if (self.iconView) {
		if (color) {
			self.iconView.backgroundColor = color;
			self.iconView.layer.cornerRadius = 4;
			self.iconView.clipsToBounds = YES;
			self.iconView.tintColor = [UIColor whiteColor];
		} else {
			self.iconView.backgroundColor = nil;
			self.iconView.layer.cornerRadius = 0;
			self.iconView.clipsToBounds = NO;
		}
	}
}


%new
- (void)showPreviousViewController {
	if (self.rightButton.alpha != 0) {
		[[CCXSharedResources sharedInstance].settingsNavigationController popViewControllerAnimated:YES];
		if ([[CCXSharedResources sharedInstance].settingsNavigationController.visibleViewController isKindOfClass:NSClassFromString(@"CCXSettingsPageTableViewController")]) {
			self.rightButton.alpha = 0;
			if (self.doneButton) {
				self.doneButton.alpha = 1;
			}
		}
	}
}

%new
- (void)closeSettingsPanel {
	if (self.doneButton.alpha != 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"com.horseshoe.activatesettings" object:nil];
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.horseshoe.activatesettings"), nil, nil, true);
	}
}

%new
+ (UIFont *)buttonFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote] fontDescriptorWithFamily:@".SFUIText"];
	descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitCondensed];
	return [UIFont fontWithDescriptor:descriptor size:0];
// 	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1*[UIScreen mainScreen].scale) traits:[font traits]];
}

%new
+ (UIFont *)headerFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline] fontDescriptorWithFamily:@".SFUIText"];
	descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitCondensed];
	return [UIFont fontWithDescriptor:descriptor size:0];
// 	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1*[UIScreen mainScreen].scale) traits:[font traits]];
}
%end