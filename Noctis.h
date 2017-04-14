#import <ControlCenterUI/CCUIControlCenterSectionViewController.h>
#import <ControlCenterUI/CCUIControlCenterPushButton.h>
#import <ControlCenterUI/CCUINightShiftSectionController.h>

@interface LQDNightSectionController : CCUIControlCenterSectionViewController
@property (nonatomic, retain) CCUINightShiftSectionController *nightShiftController;
@property (nonatomic, retain) CCUIControlCenterPushButton *nightShiftSection;
@property (nonatomic, retain) CCUIControlCenterPushButton *nightModeSection;
@end

@interface CCUISystemControlsPageViewController (LQD)
@property (nonatomic, retain) LQDNightSectionController *lqdNightSectionController;
@end

@interface UIView (Noctis)
- (void)setDarkModeEnabled:(BOOL)arg1;
- (void)setSubstitutedBackgroundColor:(UIColor *)arg1;
- (void)setSubstitutedAlpha:(UIColor *)arg1;
@end

@interface UIImageView (Noctis)
- (void)setSubstitutedTintColor:(UIColor *)arg1;
@end

@interface CALayer (Noctis)
- (void)setDarkModeEnabled:(BOOL)arg1;
- (void)setSubstitutedContentsMultiplyColor:(UIColor *)arg1;
@end

@interface UILabel (Noctis)
@property (nonatomic, retain) UIColor *substitutedTextColor;
- (void)setDarkModeEnabled:(BOOL)enabled;
@end