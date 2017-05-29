
// #import <AVFoundation/AVFlashlight.h>

// @interface CCXSharedResources : NSObject
// @property (nonatomic, retain) AVFlashlight *flashlight;
// + (instancetype)sharedInstance;
// @end


// %hook AVFlashlight
// - (void)release {
// 	if (self == [CCXSharedResources sharedInstance].flashlight) return;
// 	else %orig;
// }
// %end