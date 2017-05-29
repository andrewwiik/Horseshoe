#import "CCXMultiSliderSectionView.h"
#import "CCXMultiSliderSectionController.h"

%subclass CCXMultiSliderSectionView : CCUIControlCenterSectionView
-(CGSize)intrinsicContentSize {
	if (self.layoutStyle == 1) {
		return CGSizeMake(-1, 60);
	} else {
		return CGSizeMake(-1, 35);
	}
}
- (UIEdgeInsets)layoutMargins {
	if (self.layoutStyle == 1) {
		return UIEdgeInsetsMake(0,1,0,1);
	} else {
		return UIEdgeInsetsMake(-5,1,1,1);
	}
}

 - (void)setHidden:(BOOL)isHidden {
	%orig;
	if (isHidden) {
		[(CCXMultiSliderSectionController *)[self valueForKey:@"_viewDelegate"] controlCenterDidDismiss];
	} else {
		[(CCXMultiSliderSectionController *)[self valueForKey:@"_viewDelegate"] controlCenterWillPresent];
	}
	//[((CCXMultiSliderSectionController *)[self valueForKey:@"_viewDelegate"]).volumeHUDController setVolumeHUDEnabled:isHidden ? YES : NO forCategory:@"Audio/Video"];
}
%end