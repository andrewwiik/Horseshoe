#import "headers.h"
#import "CCXPunchOutView.h"
#import "CCXSliderObject.h"
#import "CCXSlidersPanel.h"
#import "CCXSettingsTableViewCell.h"
#import "ICGTransitionAnimation/ICGNavigationController.h"
#import "ICGTransitionAnimation/AnimationControllers/ICGSlideOverAnimation.h"
#import "CCXSharedResources.h"

@interface CCXMultiSliderSettingsViewController : UITableViewController
@property (nonatomic) CCUIControlCenterPageContainerViewController *delegate;
@property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) NSBundle *templateBundle;
@property (nonatomic, retain) NSString *enabledKey;
@property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
@property (nonatomic, retain) NSString *disabledKey;
@property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
@property (nonatomic, retain) NSArray *allSwitches;
@property (nonatomic, retain) NSString *settingsFile;
@property (nonatomic, retain) NSString *preferencesApplicationID;
@property (nonatomic, retain) NSString *notificationName;
@property (nonatomic, assign) BOOL usingFlipControlCenter;
@property (nonatomic, readonly) NSString *panelName;
- (void)_layoutHeaderView;
@property (nonatomic, retain) NSMutableArray *books;
+ (UIFont *)sliderHeaderFont;
- (NSArray *)arrayForSlider:(NSInteger)slider;
- (void)_flushSettings;

@end