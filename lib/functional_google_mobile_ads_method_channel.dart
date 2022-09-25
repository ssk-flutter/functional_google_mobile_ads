import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'functional_google_mobile_ads_platform_interface.dart';

/// An implementation of [FunctionalGoogleMobileAdsPlatform] that uses method channels.
class MethodChannelFunctionalGoogleMobileAds extends FunctionalGoogleMobileAdsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('functional_google_mobile_ads');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
