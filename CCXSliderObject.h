#import "headers.h"

#import "CCXSliderControllerDelegate-Protocol.h"

@interface CCXSliderObject : NSObject <NSCoding>
@property (nonatomic, retain) NSString *sliderName;
@property (nonatomic, retain) NSString *sliderIdentifier;
@property (nonatomic, assign) Class<CCXSliderControllerDelegate> controllerClass;
@property (nonatomic, retain) UIImage *sliderIcon;
@property (nonatomic, assign) Class settingsControllerClass;
- (id)initWithSliderClass:(Class<CCXSliderControllerDelegate>)sliderClass;
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end