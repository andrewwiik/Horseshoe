#import "CCXMiniMediaPlayerSectionView.h"
#import "CCXMultiSliderSectionController.h"

%subclass CCXMiniMediaPlayerSectionView : CCUIControlCenterSectionView
%property (nonatomic, retain) CCXMiniMediaPlayerMediaControlsView *mediaControlsView;

- (id)init {
	CCXMiniMediaPlayerSectionView *orig = %orig;
	if (orig) {

	}
	return orig;
}
- (void)layoutSubviews {
	%orig;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (self.frame.size.height == [self superview].frame.size.height) {
			CGRect newFrame = self.frame;
			newFrame.size.height = newFrame.size.height+24;
			newFrame.origin.x = -24.5;
			newFrame.size.width += 24.5*2;
			self.frame = newFrame;
		}
	} else {
		CGRect newFrame = self.frame;
		newFrame.size.height = 50;
		if (self.mediaControlsView) {
			CGFloat artworkHeight = [self.mediaControlsView _artworkViewSize].height;
			if (artworkHeight > newFrame.size.height)
				newFrame.size.height = artworkHeight;
		}
		if (self.frame.size.width == [self superview].frame.size.width) {
			if (NSClassFromString(@"SWAcapellaPrefs")) {
				newFrame.size.width += 16;
			}
		}
		self.frame = newFrame;
	}

	if (self.mediaControlsView) {

		self.mediaControlsView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
	}
}
-(CGSize)intrinsicContentSize {
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		if (self.mediaControlsView) {
			CGFloat artworkHeight = [self.mediaControlsView _artworkViewSize].height;
			if (artworkHeight > self.mediaControlsView.frame.size.height)
				return CGSizeMake(-1,artworkHeight);
		}
		return CGSizeMake(-1,self.mediaControlsView.frame.size.height);
	} else {
		if ([self superview]) {
			return CGSizeMake(-1, [self superview].frame.size.height+24);
		} else return CGSizeMake(-1,279);
	}
}
%end