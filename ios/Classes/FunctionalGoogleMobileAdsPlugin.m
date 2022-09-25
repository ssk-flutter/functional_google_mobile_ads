#import "FunctionalGoogleMobileAdsPlugin.h"
#if __has_include(<functional_google_mobile_ads/functional_google_mobile_ads-Swift.h>)
#import <functional_google_mobile_ads/functional_google_mobile_ads-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "functional_google_mobile_ads-Swift.h"
#endif

@implementation FunctionalGoogleMobileAdsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFunctionalGoogleMobileAdsPlugin registerWithRegistrar:registrar];
}
@end
