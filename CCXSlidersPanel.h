#import "headers.h"
#import "CCXSliderObject.h"

@interface CCXSlidersPanel : NSObject
@property (nonatomic, retain) NSArray *sliders;
@property (nonatomic, retain) NSMutableArray *sliderIdentifiers;
+ (instancetype)sharedInstance;
- (NSArray *)sortedSliderIdentifiers;
- (CCXSliderObject *)sliderObjectForIdentifier:(NSString *)identifier;
- (UIColor *)primaryColorForSliderIdentifier:(NSString *)identifier;
@end