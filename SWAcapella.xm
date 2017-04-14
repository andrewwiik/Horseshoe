@interface SWAcapella : NSObject
@property (nonatomic, retain) UIView *cloneContainer;
@end

%hook SWAcapella
- (void)dynamicAnimatorDidPause:(id)object {
	%orig;
	if (self.cloneContainer) {
		if ([self.cloneContainer superview]) {
			if (self.cloneContainer.frame.origin.x == 0) {
				[self.cloneContainer superview].clipsToBounds = NO;
			}
		}
	}
}
%end