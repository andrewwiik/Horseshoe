#import "CCXSliderObject.h"

@implementation CCXSliderObject

- (id)initWithSliderClass:(Class<CCXSliderControllerDelegate>)sliderClass {

	self = [super init];
	if (self) {
		if ([sliderClass respondsToSelector:@selector(sliderIdentifier)]) {
			self.sliderIdentifier = [sliderClass sliderIdentifier];
		}
		if ([sliderClass respondsToSelector:@selector(sliderName)]) {
			self.sliderName = [sliderClass sliderName];
		}
		if ([sliderClass respondsToSelector:@selector(sliderImage)]) {
			self.sliderIcon = [sliderClass sliderImage];
		}
		if ([sliderClass respondsToSelector:@selector(settingsControllerClass)]) {
			self.settingsControllerClass = [sliderClass settingsControllerClass];
		}
		self.controllerClass = sliderClass;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
  	if (self = [super init]) {
	    self.sliderIdentifier = [decoder decodeObjectForKey:@"sliderIdentifier"];
	    self.controllerClass = NSClassFromString([decoder decodeObjectForKey:@"sliderClass"]);
	    if ([self.controllerClass respondsToSelector:@selector(sliderName)]) {
			self.sliderName = [self.controllerClass sliderName];
		}
		if ([self.controllerClass respondsToSelector:@selector(sliderImage)]) {
			self.sliderIcon = [self.controllerClass sliderImage];
		}
  	}
  	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.sliderIdentifier forKey:@"sliderIdentifier"];
	[encoder encodeObject:NSStringFromClass(self.controllerClass) forKey:@"controllerClass"];
}
@end