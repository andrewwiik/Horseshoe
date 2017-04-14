#import "headers.h"
#import "CCXVolumeSectionView.h"

@interface CCXVolumeSectionController : CCUIControlCenterSectionViewController <UIGestureRecognizerDelegate>
@property (nonatomic, retain) CCUIControlCenterSlider *slider;
@property (nonatomic, retain) MPUMediaControlsVolumeView *volumeSectionController;
@property (nonatomic, retain) CCXVolumeSectionView *view;
@property (nonatomic, retain) MPUVolumeHUDController *volumeHUDController;
+ (Class)viewClass;
- (id)init;
- (void)viewDidLoad;
- (void)viewDidLayoutSubviews;
- (void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate;

+ (NSString *)sectionIdentifier;
+ (NSString *)sectionName;
+ (UIImage *)sectionImage;
@end