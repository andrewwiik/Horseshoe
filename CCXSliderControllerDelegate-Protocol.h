@protocol CCXSliderControllerDelegate
@required
- (void)sliderDidBeginTracking:(id)sender;
- (void)sliderDidEndTracking:(id)sender;
- (UIImage *)maximumValueImage;
- (UIImage *)minimumValueImage;
- (void)sliderValueDidChange:(id)sender;
- (CGFloat)currentValue;
- (void)setTracking:(BOOL)tracking;
- (CGFloat)maximumValue;
- (CGFloat)minimumValue;
- (BOOL)usesCacheKey;
- (Class<CCXSliderControllerDelegate>)class;

+ (NSString *)sliderIdentifier;
+ (UIImage *)sliderImage;
+ (NSString *)sliderName;
@optional
+ (Class)settingsControllerClass;
+ (UIViewController *)configuredSettingsController;
- (void)sliderWillAppear:(BOOL)willAppear;
- (void)sliderDidDisappear:(BOOL)didDisappear;
+ (BOOL)respondsToSelector:(SEL)selector;
+ (id)alloc;
- (id)init;
@end