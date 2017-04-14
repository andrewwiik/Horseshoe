#import "CCXSliderToggleButton.h"

%subclass CCXSliderToggleButton : CCUIControlCenterButton
- (void)_updateEffects {
	%orig;
	((UIImageView *)[self valueForKey:@"_alteredStateGlyphImageView"]).layer.filters = [((UIImageView *)[self valueForKey:@"_glyphImageView"]).layer.filters mutableCopy];
}
-(void)_updateGlyphAndTextForStateChange {
	%orig;
	((UIImageView *)[self valueForKey:@"_alteredStateGlyphImageView"]).layer.filters = [((UIImageView *)[self valueForKey:@"_glyphImageView"]).layer.filters mutableCopy];
}

%new
- (void)setForcedGlyphImage:(UIImage *)image {
	self.glyphImage = image;
	self.selectedGlyphImage = image;
	//[self setGlyphImage:image selectedGlyphImage:image name:nil];
	[self _updateGlyphAndTextForStateChange];
}

- (BOOL)isSelected {
	return NO;
}

- (void)setSelected:(BOOL)selected {
	%orig(NO);
}

%new
- (UIImage *)forcedGlyphImage {
	return nil;
}
// - (NSUInteger)state {
// 	return 0;
// }
// - (NSInteger)_currentState {
// 	return 0;
// }
%end