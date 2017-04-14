#import "CCXMiniMediaPlayerMediaControlsView.h"
#import "CCXMiniMediaPlayerViewController.h"

UIUserInterfaceIdiom currentIdiom;
%subclass CCXMiniMediaPlayerMediaControlsView : MPUControlCenterMediaControlsView
%property (nonatomic, retain) CCXMultiSliderSectionController *volumeController;
%property (nonatomic, assign) BOOL fakeCompactStyle;
%property (nonatomic, retain) UIView *acapellaCloneView;

- (CCXMiniMediaPlayerMediaControlsView *)init {
	// disableFakeIdiom();
	// enableFakeIdiom();
	currentIdiom = UI_USER_INTERFACE_IDIOM();
	enableFakeIdiom();
	CCXMiniMediaPlayerMediaControlsView *orig = %orig;
	if (![self valueForKey:@"_pickedRouteHeaderView"]) {
		MPUAVRouteHeaderView *headerView = [[NSClassFromString(@"MPUAVRouteHeaderView") alloc] init];
		[orig setValue:headerView forKey:@"_pickedRouteHeaderView"];
		CCUIControlCenterVisualEffect *primaryEffect = [NSClassFromString(@"CCUIControlCenterVisualEffect") effectWithControlState:0 inContext:5];
		CCUIControlCenterVisualEffect *secondaryEffect = [NSClassFromString(@"CCUIControlCenterVisualEffect") effectWithControlState:0 inContext:6];
		[headerView setPrimaryVisualEffect:primaryEffect];
		[headerView setSecondaryVisualEffect:secondaryEffect];
		[orig addSubview:headerView];
	}
	[orig setLayoutStyle:0];
	disableFakeIdiom();
	return orig;
}
- (BOOL)useCompactStyle {
	if (self.fakeCompactStyle)
		return NO;
	if (currentIdiom != UIUserInterfaceIdiomPad)
		return YES;
	return %orig;
}
- (void)setUseCompactStyle:(BOOL)arg1 {
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		%orig(YES);
	} else %orig;

}
- (void)setUseCompactStyle:(BOOL)arg1 animated:(BOOL)arg2 {
	// if (self.volumeController) {
	// 	if (arg1) {
	// 		if ([self valueForKey:@"_volumeView"])
	// 			[(UIView*)[self valueForKey:@"_volumeView"] setHidden:YES];
	// 		self.volumeController.view.hidden = YES;
	// 	} else {
	// 		if ([self valueForKey:@"_volumeView"])
	// 			[(UIView*)[self valueForKey:@"_volumeView"] setHidden:NO];
	// 		self.volumeController.view.hidden = NO;
	// 	}
	// }
	enableFakeIdiom();
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		%orig(YES,arg2);
	} else %orig;
	disableFakeIdiom();
}
- (void)setLayoutStyle:(NSUInteger)style {
	if (currentIdiom == UIUserInterfaceIdiomPad) {
		%orig(0);
	} else %orig;
}
- (NSUInteger)layoutStyle {
	if (currentIdiom == UIUserInterfaceIdiomPad) {
		return 0;
	} else return %orig;
}
- (void)_layoutPhoneCompactStyle {
	%orig;
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		if ([self valueForKey:@"_routingContainerView"])
			[(UIView*)[self valueForKey:@"_routingContainerView"] setHidden:YES];
		if ([self valueForKey:@"_routingView"])
			[(UIView*)[self valueForKey:@"_routingView"] setHidden:YES];
		if ([self valueForKey:@"_pickedRouteHeaderView"])
			[(UIView*)[self valueForKey:@"_pickedRouteHeaderView"] setHidden:YES];
	}
	if ([self valueForKey:@"_volumeView"])
		[(UIView*)[self valueForKey:@"_volumeView"] setHidden:YES];
}
- (void)_layoutPhoneLandscape {
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		[self _layoutPhoneCompactStyle];
	} else %orig;
}
- (void)_layoutPhoneRegularStyle {
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		[self _layoutPhoneCompactStyle];
	} else {
		%orig;
		if ([self valueForKey:@"_routingView"]) {
			UIView *routingView = (UIView *)[self valueForKey:@"_routingView"];
			if (routingView.frame.origin.x == 0) {
				CGRect routingViewFrame = routingView.frame;
				routingViewFrame.origin.x = 24.5;
				routingViewFrame.size.width -= 24.5*2;
				routingView.frame = routingViewFrame;
			}
		}

		if ([self valueForKey:@"_pickedRouteHeaderView"]) {
			UIView *routingHeaderView = (UIView *)[self valueForKey:@"_pickedRouteHeaderView"];
			if (routingHeaderView.frame.origin.x == 0) {
				CGRect routingViewHeaderFrame = routingHeaderView.frame;
				routingViewHeaderFrame.origin.x = 24.5;
				routingViewHeaderFrame.size.width -=24.5*2;
				routingHeaderView.frame = routingViewHeaderFrame;
			}
		}

		// if (NSClassFromString(@"SWAcapellaPrefs")) {
		// 	if (self.acapellaCloneView) {
		// 		if (self.acapellaCloneView.frame.origin.x != 0) {
		// 			self.clipsToBounds = YES;
		// 		} else {
		// 			self.clipsToBounds = NO;
		// 		}
		// 	}
		// 	for (UIView *view in [self subviews]) {
		// 		if ([view isKindOfClass:@"SWAcapellaCloneContainer"]) {
		// 			self.acapellaCloneView = view;
		// 			if (view.frame.origin.x != 0) {
		// 				self.clipsToBounds = YES;
		// 			} else {
		// 				self.clipsToBounds = NO;
		// 			}
		// 		}
		// 	}
		// }
	}
}
- (BOOL)_routingViewShouldBeVisible {
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		return NO;
	} else return %orig;
}
- (void)_layoutPad {
	[self _layoutPhoneRegularStyle];
}
- (void)setRoutingView:(UIView *)routingView {
	%orig;
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		if ([self valueForKey:@"_routingContainerView"])
			[(UIView*)[self valueForKey:@"_routingContainerView"] setHidden:YES];
		if ([self valueForKey:@"_routingView"])
			[(UIView*)[self valueForKey:@"_routingView"] setHidden:YES];
		if ([self valueForKey:@"_pickedRouteHeaderView"])
			[(UIView*)[self valueForKey:@"_pickedRouteHeaderView"] setHidden:YES];
	} else {
		if (routingView.frame.origin.x == 0) {
			CGRect routingViewFrame = routingView.frame;
			routingViewFrame.origin.x = 24.5;
			routingViewFrame.size.width -= 24.5*2;
			routingView.frame = routingViewFrame;
		}

		if ([self valueForKey:@"_pickedRouteHeaderView"]) {
			UIView *routingHeaderView = (UIView *)[self valueForKey:@"_pickedRouteHeaderView"];
			if (routingHeaderView.frame.origin.x == 0) {
				CGRect routingViewHeaderFrame = routingHeaderView.frame;
				routingViewHeaderFrame.origin.x = 24.5;
				routingViewHeaderFrame.size.width -=24.5*2;
				routingHeaderView.frame = routingViewHeaderFrame;
			}
		}
	}
	if ([self valueForKey:@"_volumeView"]) {
		[(UIView*)[self valueForKey:@"_volumeView"] setHidden:YES];
	}

	return;
}
- (id)routingView {
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		return nil;
	} else return %orig;
}
- (void)_layoutExpandedRoutingViewUsingBounds:(CGRect)arg1 {
	if (currentIdiom != UIUserInterfaceIdiomPad) {
		return;
	} else {
		%orig(CGRectMake(24.5,arg1.origin.y,arg1.size.width-(24.5*2),arg1.size.height));
	}
}
- (void)_layoutPhoneRegularStyleMediaControlsUsingBounds:(CGRect)bounds {
	%orig;
}

// - (BOOL)clipsToBounds {
// 	if (NSClassFromString(@"SWAcapellaPrefs")) {
// 		if (self.acapellaCloneView) {
// 			return self.acapellaCloneView.frame.origin.x == 0 ? NO : YES;
// 		}
// 	}

// 	return %orig;
// }

// - (void)setClipsToBounds:(BOOL)clips {
// 	if (NSClassFromString(@"SWAcapellaPrefs")) {
// 		if (self.acapellaCloneView) {
// 			if (self.acapellaCloneView.frame.origin.x == 0) {
// 				%orig(NO);
// 				if ([self superview]) {
// 					[self superview].clipsToBounds = NO;
// 				}
// 				return;
// 			} else {
// 				%orig(YES);
// 				if ([self superview]) {
// 					[self superview].clipsToBounds = YES;
// 				}
// 				return;
// 			}
// 		}
// 	}
// 	%orig;
// }
- (void)layoutSubviews {
	enableFakeIdiom();
	%orig;
	//self.clipsToBounds = NO;
	if (currentIdiom != UIUserInterfaceIdiomPad && NSClassFromString(@"SWAcapellaPrefs"))
		self.layer.cornerRadius = 0;

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if ([self valueForKey:@"_routingView"]) {
			UIView *routingView = (UIView *)[self valueForKey:@"_routingView"];
			if (routingView.frame.origin.x == 0) {
				CGRect routingViewFrame = routingView.frame;
				routingViewFrame.origin.x = 24.5;
				routingViewFrame.size.width -= 24.5*2;
				routingView.frame = routingViewFrame;
			}
		}

		if ([self valueForKey:@"_pickedRouteHeaderView"]) {
			UIView *routingHeaderView = (UIView *)[self valueForKey:@"_pickedRouteHeaderView"];
			if (routingHeaderView.frame.origin.x == 0) {
				CGRect routingViewHeaderFrame = routingHeaderView.frame;
				routingViewHeaderFrame.origin.x = 24.5;
				routingViewHeaderFrame.size.width -=24.5*2;
				routingHeaderView.frame = routingViewHeaderFrame;
			}
		}
	}

	if (NSClassFromString(@"SWAcapellaPrefs")) {
		if (self.acapellaCloneView) {
			if (self.acapellaCloneView.frame.origin.x != 0) {
				self.clipsToBounds = YES;
			} else {
				self.clipsToBounds = NO;
			}
		}
		for (UIView *view in [self subviews]) {
			if ([view isKindOfClass:@"SWAcapellaCloneContainer"]) {
				self.acapellaCloneView = view;
				if (view.frame.origin.x != 0) {
					self.clipsToBounds = YES;
				} else {
					self.clipsToBounds = NO;
				}
			}
		}
	}

	disableFakeIdiom();
}

-(void)_reloadDisplayModeOrCompactStyleVisibility {
	enableFakeIdiom();
	%orig;
	disableFakeIdiom();
}
-(id)_createTappableNowPlayingMetadataView {
	enableFakeIdiom();
	id orig = %orig;
	disableFakeIdiom();
	return orig;
}
-(CGSize)_artworkViewSize {

	enableFakeIdiom();
	// if (currentIdiom == UIUserInterfaceIdiomPad) {
	// 	if (!self.useCompactStyle) {
	// 		return CGSizeMake(102,102);
	// 	}
	// }
	CGSize orig = %orig;
	disableFakeIdiom();
	return orig;
}

// - (void)_reloadNowPlayingInfoLabels {
// 	%orig;
// 	MPUControlCenterMetadataView *firstLabel = (MPUControlCenterMetadataView *)[self valueForKey:@"_titleLabel"];
// 	MPUControlCenterMetadataView *middleLabel = (MPUControlCenterMetadataView *)[self valueForKey:@"_artistLabel"];
// 	MPUControlCenterMetadataView *lastLabel = (MPUControlCenterMetadataView *)[self valueForKey:@"_albumLabel"];
// 	MPUControlCenterMetadataView *otherLabel = (MPUControlCenterMetadataView *)[self valueForKey:@"_artistAlbumConcatenatedLabel"];

// 	// First Label
// 	[[firstLabel label].layer setContentsMultiplyColor:nil];
// 	[[firstLabel label] nc_removeAllVibrantStyling];
// 	[firstLabel nc_removeAllVibrantStyling];
// 	//[firstLabel nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:4]];
// 	//[[firstLabel label] nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:4]];
// 	[[firstLabel label].layer setContentsMultiplyColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor];
// 	[firstLabel setBackgroundColor:nil];
// 	[firstLabel label].textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];

// 	// Middle Label
// 	[[middleLabel label].layer setContentsMultiplyColor:nil];
// 	[[middleLabel label] nc_removeAllVibrantStyling];
// 	[middleLabel nc_removeAllVibrantStyling];
// 	//[middleLabel nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:4]];
// 	//[[middleLabel label] nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:4]];
// 	[[middleLabel label].layer setContentsMultiplyColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor];
// 	[middleLabel setBackgroundColor:nil];
// 	[middleLabel label].textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];

// 	// Last Label
// 	[[lastLabel label].layer setContentsMultiplyColor:nil];
// 	[[lastLabel label] nc_removeAllVibrantStyling];
// 	[lastLabel nc_removeAllVibrantStyling];
// 	//[lastLabel nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:4]];
// 	//[[lastLabel label] nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:4]];
// 	[[lastLabel label].layer setContentsMultiplyColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor];
// 	[lastLabel setBackgroundColor:nil];
// 	[lastLabel label].textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];

// 	// That other dumb Label
// 	[[otherLabel label].layer setContentsMultiplyColor:nil];
// 	[[otherLabel label] nc_removeAllVibrantStyling];
// 	[otherLabel nc_removeAllVibrantStyling];
// 	//[otherLabel nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:4]];
// 	//[[otherLabel label] nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:4]];
// 	[[otherLabel label].layer setContentsMultiplyColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor];
// 	[otherLabel setBackgroundColor:nil];
// 	[otherLabel label].textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
// }

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView* subview in self.subviews ) {
        if ( [subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil ) {
            return YES;
        }
    }
    return NO;
}
%end