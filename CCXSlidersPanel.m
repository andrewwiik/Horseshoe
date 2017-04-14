#import "CCXSlidersPanel.h"

// static NSInteger DictionaryTextComparator(id a. id b. void *context)
// {
// 	return [[(NSDictionary *)context objectForKey:a] localizedCaseInsensitiveCompare:[(NSDictionary *)context objectForKey:b]];
// }

@implementation CCXSlidersPanel
+ (instancetype)sharedInstance {
	static CCXSlidersPanel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NSClassFromString(@"CCXSlidersPanel") alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NSArray *)sortedSliderIdentifiers {
	if (!self.sliders || !self.sliderIdentifiers) {
		[self loadSliders];
	}
	return [self.sliderIdentifiers copy];
}

- (void)loadSliders {
	NSMutableArray *sliders = [NSMutableArray new];
	[sliders addObject:[[CCXSliderObject alloc] initWithSliderClass:NSClassFromString(@"CCXBrightnessSliderController")]];
	[sliders addObject:[[CCXSliderObject alloc] initWithSliderClass:NSClassFromString(@"CCXAudioBalanceSliderController")]];
	[sliders addObject:[[CCXSliderObject alloc] initWithSliderClass:NSClassFromString(@"CCXVolumeSliderController")]];
	self.sliders = [sliders copy];
	
	if (!self.sliderIdentifiers) {
		self.sliderIdentifiers = [NSMutableArray new];
	}
	
	for (CCXSliderObject *slider in self.sliders) {
		if (slider.sliderIdentifier) {
			[self.sliderIdentifiers addObject:slider.sliderIdentifier];
		}
	}
}

- (CCXSliderObject *)sliderObjectForIdentifier:(NSString *)identifier {
	for (CCXSliderObject *slider in self.sliders) {
		if ([slider.sliderIdentifier isEqualToString:identifier]) {
			return slider;
		}
	}
	return nil;
}

- (UIColor *)primaryColorForSliderIdentifier:(NSString *)identifier {
	return nil;
}

@end