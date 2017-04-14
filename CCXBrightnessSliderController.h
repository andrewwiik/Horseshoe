#import "headers.h"
#import "CCXSliderControllerDelegate-Protocol.h"

@interface CCXBrightnessSliderController : NSObject <CCXSliderControllerDelegate>
@property (nonatomic, retain) CCUIBrightnessSectionController *controller;
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