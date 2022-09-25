import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'functional_google_mobile_ads_method_channel.dart';

abstract class FunctionalGoogleMobileAdsPlatform extends PlatformInterface {
  /// Constructs a FunctionalGoogleMobileAdsPlatform.
  FunctionalGoogleMobileAdsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FunctionalGoogleMobileAdsPlatform _instance = MethodChannelFunctionalGoogleMobileAds();

  /// The default instance of [FunctionalGoogleMobileAdsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFunctionalGoogleMobileAds].
  static FunctionalGoogleMobileAdsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FunctionalGoogleMobileAdsPlatform] when
  /// they register themselves.
  static set instance(FunctionalGoogleMobileAdsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
