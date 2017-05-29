#import "CCXNavigationViewController.h"

@interface CCUIControlCenterViewController (CCP)

@property (nonatomic, assign) CGFloat correctMaxHeight;

@end

%hook CCUIControlCenterViewController

%property (nonatomic, assign) CGFloat correctMaxHeight;

-(CGFloat)_scrollviewContentMaxHeight {
	self.correctMaxHeight = %orig;
	if ([self _selectedContentViewController]) {
		id contentViewController =  [self _selectedContentViewController];
		BOOL isCCPage = [[contentViewController class] isEqual:NSClassFromString(@"CCXNavigationViewController")];
		if (isCCPage) {
			if([(CCXNavigationViewController *)[self _selectedContentViewController] customHeightRequested]) {
				return [(CCXNavigationViewController *)[self _selectedContentViewController] customPageHeight];
			}
		}
	}
	return self.correctMaxHeight;
}

- (CGRect)_frameForChildViewController:(CCUIControlCenterPageContainerViewController *)viewController {
	CGRect originalFrame = %orig;
	if ([viewController contentViewController]) {

		id contentViewController =  [viewController contentViewController];
		id selectedContentViewController = [self _selectedContentViewController];

		BOOL newVCIsCCPage = [[contentViewController class] isEqual:NSClassFromString(@"CCXNavigationViewController")];
		BOOL selectVCIsCCPage = [[selectedContentViewController class] isEqual:NSClassFromString(@"CCXNavigationViewController")];

		if(newVCIsCCPage) {
			CGFloat wantedHeight = [(CCXNavigationViewController *)contentViewController customPageHeight];
			if([(CCXNavigationViewController *)contentViewController customHeightRequested])  {

				if (viewController != [self _selectedViewController]) {
					return CGRectMake(originalFrame.origin.x, self.correctMaxHeight - wantedHeight, originalFrame.size.width, wantedHeight);
				} else {
					return CGRectMake(originalFrame.origin.x, 0, originalFrame.size.width, wantedHeight);
				}
			} else {
				if (selectedContentViewController) {
					if(selectVCIsCCPage) {
						if([(CCXNavigationViewController *)selectedContentViewController customHeightRequested])  {
							CGFloat currentSetHeight = [(CCXNavigationViewController *)selectedContentViewController customPageHeight];
							CGFloat pushDown = (currentSetHeight - self.correctMaxHeight);
							return CGRectMake(originalFrame.origin.x, pushDown, originalFrame.size.width, self.correctMaxHeight);
						}
					}
				}
			}

		} else {

			if (selectedContentViewController) {
				if(selectVCIsCCPage) {
					if([(CCXNavigationViewController *)selectedContentViewController customHeightRequested])  {
						CGFloat currentSetHeight = [(CCXNavigationViewController *)selectedContentViewController customPageHeight];
						CGFloat pushDown = (currentSetHeight - self.correctMaxHeight);
						return CGRectMake(originalFrame.origin.x, pushDown, originalFrame.size.width, self.correctMaxHeight);
					}
				}
			}
		}
	}
	return %orig;
}

-(void)scrollViewDidEndDecelerating:(id)arg1 {
	%orig;
	[self setRevealPercentage:1];
}

%end
