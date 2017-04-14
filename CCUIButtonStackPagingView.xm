#import "headers.h"

%hook CCUIButtonStackPagingView
%new
-(CGSize)intrinsicContentSize {
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
}
%end