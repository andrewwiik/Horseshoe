#import "CCXMiniMediaPlayerSectionController.h"

%subclass CCXMiniMediaPlayerSectionController : CCUIControlCenterSectionViewController
%property (nonatomic, retain) CCXMiniMediaPlayerViewController *mediaControlsViewController;

+ (Class)viewClass {
	return NSClassFromString(@"CCXMiniMediaPlayerSectionView");
}

- (id)init {
	CCXMiniMediaPlayerSectionController *orig = %orig;
	if (orig) {
		orig.mediaControlsViewController = [[NSClassFromString(@"CCXMiniMediaPlayerViewController") alloc] init];
	}
	return orig;
}

- (void)viewDidLoad {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (self.view.frame.size.height == [self.view superview].frame.size.height) {
			CGRect newFrame = self.view.frame;
			newFrame.size.height = newFrame.size.height+24;
			self.view.frame = newFrame;
		}
	}

	// MPULayoutInterpolator *_marginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
	// [_marginLayoutInterpolator addValue:0 forReferenceMetric:300];
	// [_marginLayoutInterpolator addValue:0 forReferenceMetric:360];
	// [self.mediaControlsViewController.view setValue:_marginLayoutInterpolator forKey:@"_marginLayoutInterpolator"];
	// MPULayoutInterpolator *_landscapeMarginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
	// [_landscapeMarginLayoutInterpolator addValue:0 forReferenceMetric:552];
	// [_landscapeMarginLayoutInterpolator addValue:0 forReferenceMetric:650];
	// [self.mediaControlsViewController.view setValue:_landscapeMarginLayoutInterpolator forKey:@"_landscapeMarginLayoutInterpolator"];



	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	// 		MPULayoutInterpolator* _artworkNormalContentSizeLayoutInterpolator;
	// MPULayoutInterpolator* _artworkLargeContentSizeLayoutInterpolator;
	// MPULayoutInterpolator* _artworkLandscapePhoneLayoutInterpolator;
		MPULayoutInterpolator *_artworkNormalContentSizeLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_artworkNormalContentSizeLayoutInterpolator addValue:75 forReferenceMetric:300];
		[_artworkNormalContentSizeLayoutInterpolator addValue:95 forReferenceMetric:360];
		[self.mediaControlsViewController.view setValue:_artworkNormalContentSizeLayoutInterpolator forKey:@"_artworkNormalContentSizeLayoutInterpolator"];

		MPULayoutInterpolator *_transportControlsWidthCompactLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_transportControlsWidthCompactLayoutInterpolator addValue:98 forReferenceMetric:360];
		[self.mediaControlsViewController.view setValue:_transportControlsWidthCompactLayoutInterpolator forKey:@"_transportControlsWidthCompactLayoutInterpolator"];
		// MPULayoutInterpolator *_artworkLargeContentSizeLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		// [_artworkLargeContentSizeLayoutInterpolator addValue:50 forReferenceMetric:300];
		// [_artworkLargeContentSizeLayoutInterpolator addValue:50 forReferenceMetric:360];
		// [self.mediaControlsViewController.view setValue:_artworkLargeContentSizeLayoutInterpolator forKey:@"_artworkLargeContentSizeLayoutInterpolator"];

		// MPULayoutInterpolator *_marginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		// [_marginLayoutInterpolator addValue:0 forReferenceMetric:300];
		// [_marginLayoutInterpolator addValue:0 forReferenceMetric:360];
		// [self.mediaControlsViewController.view setValue:_marginLayoutInterpolator forKey:@"_marginLayoutInterpolator"];

		// MPULayoutInterpolator *_contentSizeInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		// [_contentSizeInterpolator addValue:100 forReferenceMetric:320];
		// [_contentSizeInterpolator addValue:150 forReferenceMetric:375];
		// [self.mediaControlsViewController.view setValue:_contentSizeInterpolator forKey:@"_contentSizeInterpolator"];
	} else {

		BOOL setTransportWidth = YES;
		if (NSClassFromString(@"SWAcapellaPrefs")) {
			SWAcapellaPrefs *acapellaPrefs = [[NSClassFromString(@"SWAcapellaPrefs") alloc] initWithKeyPrefix:@"cc"];
			if (acapellaPrefs) {
				if ([acapellaPrefs enabled]) {
					MPULayoutInterpolator *_transportControlsWidthCompactLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
					[_transportControlsWidthCompactLayoutInterpolator addValue:-16 forReferenceMetric:360];
					[_transportControlsWidthCompactLayoutInterpolator addValue:-16 forReferenceMetric:300];
					[self.mediaControlsViewController.view setValue:_transportControlsWidthCompactLayoutInterpolator forKey:@"_transportControlsWidthCompactLayoutInterpolator"];
					
					MPULayoutInterpolator *_transportControlsWidthStandardLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
					[_transportControlsWidthStandardLayoutInterpolator addValue:-16 forReferenceMetric:360];
					[_transportControlsWidthStandardLayoutInterpolator addValue:-16 forReferenceMetric:300];
					[self.mediaControlsViewController.view setValue:_transportControlsWidthStandardLayoutInterpolator forKey:@"_transportControlsWidthStandardLayoutInterpolator"];
		
					setTransportWidth = NO;

					// MPULayoutInterpolator *_contentSizeInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
					// [_contentSizeInterpolator addValue:336 forReferenceMetric:320];
					// [_contentSizeInterpolator addValue:391 forReferenceMetric:375];
					// [self.mediaControlsViewController.view setValue:_contentSizeInterpolator forKey:@"_contentSizeInterpolator"];
				
					// MPULayoutInterpolator *_labelsLeadingHeightPhoneLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
					// [_labelsLeadingHeightPhoneLayoutInterpolator addValue:0 forReferenceMetric:568];
					// [_labelsLeadingHeightPhoneLayoutInterpolator addValue:0 forReferenceMetric:667];
					// [self.mediaControlsViewController.view setValue:_labelsLeadingHeightPhoneLayoutInterpolator forKey:@"_labelsLeadingHeightPhoneLayoutInterpolator"];
				}
			}
		}
		MPULayoutInterpolator *_marginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_marginLayoutInterpolator addValue:0 forReferenceMetric:300];
		[_marginLayoutInterpolator addValue:0 forReferenceMetric:360];
		[self.mediaControlsViewController.view setValue:_marginLayoutInterpolator forKey:@"_marginLayoutInterpolator"];
		
		MPULayoutInterpolator *_landscapeMarginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_landscapeMarginLayoutInterpolator addValue:0 forReferenceMetric:552];
		[_landscapeMarginLayoutInterpolator addValue:0 forReferenceMetric:650];
		[self.mediaControlsViewController.view setValue:_landscapeMarginLayoutInterpolator forKey:@"_landscapeMarginLayoutInterpolator"];
		
		if (setTransportWidth) {
			MPULayoutInterpolator *_transportControlsWidthCompactLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[_transportControlsWidthCompactLayoutInterpolator addValue:98 forReferenceMetric:360];
			[self.mediaControlsViewController.view setValue:_transportControlsWidthCompactLayoutInterpolator forKey:@"_transportControlsWidthCompactLayoutInterpolator"];
		}
	}

	[self.mediaControlsViewController viewDidLoad];

	%orig;

	self.view.mediaControlsView = self.mediaControlsViewController.view;
	[self.view addSubview:self.mediaControlsViewController.view];
	[self addChildViewController:self.mediaControlsViewController];
	[self.mediaControlsViewController.view setDelegate:self.mediaControlsViewController];
}

-(void)viewWillAppear:(BOOL)arg1 {
	[self.mediaControlsViewController viewWillAppear:arg1];
	%orig;
}

-(void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate {
	%orig;
	[self.mediaControlsViewController setDelegate:[delegate delegate]];
}
- (void)controlCenterDidDismiss {
	%orig;
	if (self.mediaControlsViewController) {
		if (self.mediaControlsViewController.iconForceTouchController) {
			if (self.mediaControlsViewController.iconForceTouchController.state) {
				[self.mediaControlsViewController.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
			}
		}
	}
}

%new
- (BOOL)dismissModalFullScreenIfNeeded {
	if (self.mediaControlsViewController) {
		return [self.mediaControlsViewController dismissModalFullScreenIfNeeded];
	} else return NO;
}

%new
+ (NSString *)sectionIdentifier {
	return @"com.atwiiks.controlcenterx.mini-media-player";
}
%new
+ (NSString *)sectionName {
	return @"Music";
}
%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Music_Section" inBundle:[NSBundle bundleWithPath:@"/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
+ (Class)settingsControllerClass {
	return nil;
}
%end