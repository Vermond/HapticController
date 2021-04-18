#import "HapticControllerPlugin.h"
#if __has_include(<haptic_controller/haptic_controller-Swift.h>)
#import <haptic_controller/haptic_controller-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "haptic_controller-Swift.h"
#endif

@implementation HapticControllerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHapticControllerPlugin registerWithRegistrar:registrar];
}
@end
