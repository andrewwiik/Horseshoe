@interface SWAcapellaCloneContainer : UIView
@end


%hook SWAcapellaCloneContainer
- (BOOL)isUserInteractionEnabled {
	return YES;
}
- (void)setUserInteractionEnabled:(BOOL)enabled {
	%orig(YES);
}

- (BOOL)clipsToBounds {
	return NO;
}

- (void)setClipsToBounds:(BOOL)clips {
	
	%orig(NO);
}

// - (void)addSubview:(id)view {
// 	if ([self superview]) {
// 		if ([[self superview] superview]) {
// 			if ([[[self superview] superview] superview]) {
// 				UIView *superview = [[[self superview] superview] superview];
// 				if ([superview isKindOfClass:NSClassFromString(@"UIStackView")]) {
// 					superview.clipsToBounds = YES;
// 				}
// 			}
// 		}
// 	}
// }

- (NSInteger)tag {
	NSInteger tag = %orig;
	if ([self superview]) {
		if (tag == 1) {
			[self superview].clipsToBounds = YES;
		}
		if ([[self superview] superview]) {
			if ([[[self superview] superview] superview]) {
				UIView *superview = [[[self superview] superview] superview];
				superview.clipsToBounds = (tag == 1) ? YES : YES;

			}
		}
	}
	return tag;
}

- (void)addSubview:(id)view {
	%orig;
	if ([self superview]) {
		[self superview].clipsToBounds = YES;
		if ([[self superview] superview]) {
			if ([[[self superview] superview] superview]) {
				UIView *superview = [[[self superview] superview] superview];
				superview.clipsToBounds = YES;
			}
		}
	}
}

- (void)removeSubview:(id)view {
	%orig;
	if ([self superview]) {
		[self superview].clipsToBounds = NO;
		if ([[self superview] superview]) {
			if ([[[self superview] superview] superview]) {
				UIView *superview = [[[self superview] superview] superview];
				superview.clipsToBounds = NO;
			}
		}
	}
}

- (void)setTag:(NSInteger)tag {
	%orig;
	if ([self superview]) {
		if (tag == 1) {
			[self superview].clipsToBounds = YES;
		}
		if ([[self superview] superview]) {
			if ([[[self superview] superview] superview]) {
				UIView *superview = [[[self superview] superview] superview];
				superview.clipsToBounds = (self.tag == 1) ? YES : YES;
			}
		}
	}
}

// - (void)setVelocity:(CGPoint)velocity {
// 	%orig;
// 	if (velocity.x != 0) {
// 		if ([self superview]) {
// 			[self superview].clipsToBounds = YES;
// 		}
// 	} else {
// 		[self superview].clipsToBounds = NO;
// 	}
// }


// - (void)_constraintsToDeactivate {
// 	%orig;
// 	if ([self superview]) {
// 		[self superview].clipsToBounds = NO;
// 	}
// }

- (void)setFrame:(CGRect)frame {
	%orig;
	if ([self superview]) {
		if (frame.origin.x != 0) {
			[self superview].clipsToBounds = YES;
		} else {
			[self superview].clipsToBounds = NO;
		}
	}
}
%end