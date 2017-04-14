#import "headers.h"
#import "CCXSliderControllerDelegate-Protocol.h"

@interface CCXVolumeSliderController : NSObject <CCXSliderControllerDelegate>
@property (nonatomic, retain) MPUMediaControlsVolumeView *controller;
@property (nonatomic, retain) MPUVolumeHUDController *hudController;
- (void)sliderDidBeginTracking:(id)sender;
- (void)sliderDidEndTracking:(id)sender;
- (UIImage *)maximumValueImage;
- (UIImage *)minimumValueImage;
- (void)sliderValueDidChange:(id)sender;
- (CGFloat)currentValue;
- (void)sliderWillAppear:(BOOL)willAppear;
- (void)sliderDidDisappear:(BOOL)didDisappear;

+ (NSString *)sliderIdentifier;
+ (UIImage *)sliderImage;
+ (NSString *)sliderName;
@end