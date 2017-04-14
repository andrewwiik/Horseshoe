#import "headers.h"
#import "CCXSliderToggleButton.h"
#import "CCXMultiSliderSectionView.h"
#import "CCXSliderObject.h"
#import "CCXSlidersPanel.h"
#import "CCXSharedResources.h"
#import "CCXSliderControllerDelegate-Protocol.h"

@interface CCXMultiSliderSectionController : CCUIControlCenterSectionViewController <SBUIIconForceTouchControllerDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, retain) CCUIControlCenterSlider *slider;
@property (nonatomic, retain) UIView *toggleBackgroundView;
@property (nonatomic, retain) CCXSliderToggleButton *toggleButton;
@property (nonatomic, retain) CCXMultiSliderSectionView *view;
@property (nonatomic, retain) NSString *enabledKey;
@property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
@property (nonatomic, retain) NSString *disabledKey;
@property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
@property (nonatomic, retain) NSArray *allSwitches;
@property (nonatomic, retain) NSString *settingsFile;
@property (nonatomic, retain) NSString *preferencesApplicationID;
@property (nonatomic, retain) NSString *notificationName;
@property (nonatomic, retain) NSMutableArray *sliders;
@property (nonatomic, retain) NSMutableDictionary *identifiersToSliders;
@property (nonatomic, retain) NSString *currentSliderIdentifier;
@property (nonatomic, retain) NSObject *currentSliderController;
@property (nonatomic, retain) NSTimer *valueUpdateTimer;
+ (Class)viewClass;
- (id)init;
- (void)viewDidLoad;
- (void)viewDidLayoutSubviews;
- (void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate;
- (void)updateValue;
- (void)createValueUpdater;
- (void)configureSlider;
- (void)reloadSliderSettings;

+ (NSString *)sectionIdentifier;
+ (NSString *)sectionName;
+ (UIImage *)sectionImage;
@end