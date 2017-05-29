#import "headers.h"

%hook CCUIBrightnessContentView
-(CGSize)intrinsicContentSize {
	if (self.layoutStyle == 1) {
		return CGSizeMake(-1, 60);
	} else {
		return CGSizeMake(-1, 30);
	}
}
- (UIEdgeInsets)layoutMargins {
	if (self.layoutStyle == 1) {
		return UIEdgeInsetsMake(0,1,0,1);
	} else {
		return UIEdgeInsetsMake(0,1,1,1);
	}
}

- (void)layoutSubviews {
	%orig;
	CGRect frame = self.frame;
	frame.size.height = [self intrinsicContentSize].height;
	self.frame = frame;

	for (UIView *view in [self subviews]) {
		CGRect frame = view.frame;
		frame.size = self.frame.size;
		view.frame = frame;
	}
}
%end