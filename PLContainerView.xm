#import "headers.h"


@interface PLContainerView (CCX)
@property (nonatomic, assign) NSUInteger currentAxis;
@end 

static BOOL fakeAxis = NO;
%hook PLContainerView
%property (nonatomic, assign) NSUInteger currentAxis;
- (void)setAxis:(NSInteger)axis {
	return %orig;
	///%orig;
	self.currentAxis = axis;
	// if (axis == 1) {
	// 	if ([self superview]) {
	// 		if ([[self superview] isKindOfClass:NSClassFromString(@"UIStackView")]) {
	// 			[(UIStackView *)[[self superview] superview] setDistribution:UIStackViewDistributionFill];
	// 		}
	// 	}
	// }
}

- (NSUInteger)axis {
	return %orig;
	if (fakeAxis) return 0;
	return self.currentAxis;
}

- (CGSize)intrinsicContentSize {
	//return CGSizeMake(47,-1);

	if (fakeAxis || !fakeAxis) {
		if ([self axis] == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				if ([[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
					return CGSizeMake(-1, 44);
				} else {
					return CGSizeMake(-1,76);
				}
			} else if ([[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
				return CGSizeMake(47, -1);
			} else {
				return CGSizeMake(60,-1);
			}
		} else {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				if ([[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
					return CGSizeMake(-1, 44);
				} else {
					return CGSizeMake(-1,76);
				}
			} else if ([[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
				return CGSizeMake(-1, 47);
			} else {
				return CGSizeMake(-1,60);
			}
		}
	}
	if (!NSClassFromString(@"FCCButtonsScrollView") && !NSClassFromString(@"PLAppsController")) {
		if (self.buttons) {
			if ([self.buttons count] > 0) {
				return CGSizeMake(-1,[(CCUIControlCenterButton *)[self.buttons objectAtIndex:0] naturalHeight]);
			}
		}
	}
	

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if ([[self delegate] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
			return CGSizeMake(-1, 44);
		} else {
			return CGSizeMake(-1,60);
		}
	}
	if ([[self delegate] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
		return CGSizeMake(-1, 49);
	} else {
		return CGSizeMake(-1,60);
	}
	// if ([self axis] == 1) {
	// 	if ([self superview]) {
	// 		if ([[[self superview] superview] isKindOfClass:NSClassFromString(@"UIStackView")]) {
	// 			[(UIStackView *)[[self superview] superview] setDistribution:UIStackViewDistributionFillProportionally];
	// 		}
	// 	}
	// }
	// return orig;
	// if ([self axis] == 1) {
	// 	if ([self superview]) {
	// 		if ([[[self superview] superview] isKindOfClass:NSClassFromString(@"UIStackView")]) {
	// 			[(UIStackView *)[[self superview] superview] setDistribution:1];
	// 		}
	// 	}
	// 	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	// 		if ([[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
	// 			return CGSizeMake(-1, 44);
	// 		} else {
	// 			return CGSizeMake(-1,76);
	// 		}
	// 	} else if ([[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
	// 		return CGSizeMake(-1, 47);
	// 	} else {
	// 		return CGSizeMake(-1,47);
	// 	}
	// } else {
	// 	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	// 		if ([[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
	// 			return CGSizeMake(-1, 44);
	// 		} else {
	// 			return CGSizeMake(-1,76);
	// 		}
	// 	} else if ([[self valueForKey:@"_delegate"] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
	// 		return CGSizeMake(-1, 47);
	// 	} else {
	// 		return CGSizeMake(-1,60);
	// 	}
	// }
}

- (void)layoutSubviews {
	fakeAxis = YES;
	%orig;
	// if ([self currentAxis] == 1) {
	// 	if ([self superview]) {
	// 		if ([self superview].frame.size.width != self.frame.size.width) 
	// 			self.superview.frame = CGRectMake(self.superview.frame.origin.x,self.superview.frame.origin.y,self.frame.size.width,self.frame.size.height);
	// 	}
	// }
	fakeAxis = NO;
}
%end

%ctor {
	dlopen("/usr/lib/libPolus.dylib", RTLD_NOW);
	%init;
}