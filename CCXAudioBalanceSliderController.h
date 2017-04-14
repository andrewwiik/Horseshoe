#import "headers.h"
#import "CCXSliderControllerDelegate-Protocol.h"

@interface CCXAudioBalanceSliderController : NSObject <CCXSliderControllerDelegate>
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