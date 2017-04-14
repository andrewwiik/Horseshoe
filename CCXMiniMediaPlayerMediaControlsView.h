#import "headers.h"
#import "CCXMultiSliderSectionController.h"
#import "idiom.h"
@class CCXMiniMediaPlayerViewController;

@interface CCXMiniMediaPlayerMediaControlsView : MPUControlCenterMediaControlsView
@property (nonatomic, retain) CCXMultiSliderSectionController *volumeController;
@property (nonatomic, assign) BOOL fakeCompactStyle;
@property (nonatomic, retain) UIView *acapellaCloneView;
- (CCXMiniMediaPlayerViewController *)delegate;
- (BOOL)useCompactStyle;
- (void)setUseCompactStyle:(BOOL)arg1;
- (void)setUseCompactStyle:(BOOL)arg1 animated:(BOOL)arg2;
- (void)_layoutPhoneCompactStyle;
- (void)_layoutPhoneLandscape;
- (void)_layoutPhoneRegularStyle;
- (BOOL)_routingViewShouldBeVisible;
- (void)setRoutingView:(id)routingView;
- (id)routingView;
- (void)_layoutExpandedRoutingViewUsingBounds:(CGRect)arg1;
@end