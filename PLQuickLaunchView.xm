// #import "headers.h"

// %hook PLQuickLaunchView
// - (void)addQuickLaunchButtons {
// 	dispatch_async( dispatch_get_main_queue(), ^{
// 		%orig;
// 	});
// }
// %end

// %ctor {
// 	dlopen("/Library/MobileSubstrate/DynamicLibraries/Polus.dylib", RTLD_NOW);
// 	%init;
// }